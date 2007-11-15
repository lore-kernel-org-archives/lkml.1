Return-Path: <linux-kernel-owner+w=401wt.eu-S1762944AbXKOGRP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762944AbXKOGRP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 01:17:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759935AbXKOGQI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 01:16:08 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:50973 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752333AbXKOGQG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 01:16:06 -0500
Date: Wed, 14 Nov 2007 22:14:29 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk, bunk@kernel.org,
       Chris Wright <chrisw@sous-sol.org>,
       "David S. Miller" <davem@davemloft.net>
Subject: [patch 02/19] Fix sparc64 MAP_FIXED handling of framebuffer mmaps
Message-ID: <20071115061429.GC7980@kroah.com>
References: <20071115054813.977066477@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="fix-sparc64-map_fixed-handling-of-framebuffer-mmaps.patch"
In-Reply-To: <20071115061415.GA7980@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Chris Wright <chrisw@sous-sol.org>

patch d58aa8c7b1cc0add7b03e26bdb8988d98d2f4cd1 in mainline.

From: Chris Wright <chrisw@sous-sol.org>
Date: Tue, 23 Oct 2007 20:36:14 -0700
Subject: [patch 02/19] [PATCH] [SPARC64]: pass correct addr in get_fb_unmapped_area(MAP_FIXED)

Looks like the MAP_FIXED case is using the wrong address hint.  I'd
expect the comment "don't mess with it" means pass the request
straight on through, not change the address requested to -ENOMEM.

Signed-off-by: Chris Wright <chrisw@sous-sol.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/sparc64/kernel/sys_sparc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/sparc64/kernel/sys_sparc.c
+++ b/arch/sparc64/kernel/sys_sparc.c
@@ -319,7 +319,7 @@ unsigned long get_fb_unmapped_area(struc
 
 	if (flags & MAP_FIXED) {
 		/* Ok, don't mess with it. */
-		return get_unmapped_area(NULL, addr, len, pgoff, flags);
+		return get_unmapped_area(NULL, orig_addr, len, pgoff, flags);
 	}
 	flags &= ~MAP_SHARED;
 

-- 
