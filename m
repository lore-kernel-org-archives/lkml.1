Return-Path: <linux-kernel-owner+w=401wt.eu-S1751976AbXKSSWp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751976AbXKSSWp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2007 13:22:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750816AbXKSSVj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Nov 2007 13:21:39 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:41897 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751495AbXKSSVh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2007 13:21:37 -0500
Date: Mon, 19 Nov 2007 10:18:25 -0800
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org,
       torvalds@linux-foundation.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk
Subject: [patch 04/26] writeback: dont propagate AOP_WRITEPAGE_ACTIVATE
Message-ID: <20071119181825.GE15425@kroah.com>
References: <20071119181438.617190424@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="writeback-don-t-propagate-aop_writepage_activate.patch"
In-Reply-To: <20071119181746.GA15425@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


2.6.22-stable review patch.  If anyone has any objections, please let us
know.

------------------
From: Andrew Morton <akpm@linux-foundation.org>

patch e423003028183df54f039dfda8b58c49e78c89d7 in mainline.

This is a writeback-internal marker but we're propagating it all the way back
to userspace!.

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>


---
 mm/page-writeback.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/mm/page-writeback.c
+++ b/mm/page-writeback.c
@@ -674,8 +674,10 @@ retry:
 
 			ret = (*writepage)(page, wbc, data);
 
-			if (unlikely(ret == AOP_WRITEPAGE_ACTIVATE))
+			if (unlikely(ret == AOP_WRITEPAGE_ACTIVATE)) {
 				unlock_page(page);
+				ret = 0;
+			}
 			if (ret || (--(wbc->nr_to_write) <= 0))
 				done = 1;
 			if (wbc->nonblocking && bdi_write_congested(bdi)) {

-- 
