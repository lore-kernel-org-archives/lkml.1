Return-Path: <linux-kernel-owner+w=401wt.eu-S1754891AbXDZRA7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754891AbXDZRA7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 13:00:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754887AbXDZRA6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 13:00:58 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:39653 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754891AbXDZRAn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 13:00:43 -0400
Date: Thu, 26 Apr 2007 09:56:48 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org,
       torvalds@linux-foundation.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       dhowells@redhat.com, benh@kernel.crashing.org
Subject: [patch 23/33] fix bogon in /dev/mem mmaping on nommu
Message-ID: <20070426165648.GX1898@kroah.com>
References: <20070426165111.393445007@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="fix-bogon-in-dev-mem-mmap-ing-on-nommu.patch"
In-Reply-To: <20070426165445.GA1898@kroah.com>
User-Agent: Mutt/1.5.15 (2007-04-06)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>

While digging through my MAP_FIXED changes, I found that rather obvious
bug in /dev/mem mmap implementation for nommu archs. get_unmapped_area()
is expected to return an address, not a pfn.

Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Acked-By: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/char/mem.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/char/mem.c
+++ b/drivers/char/mem.c
@@ -248,7 +248,7 @@ static unsigned long get_unmapped_area_m
 {
 	if (!valid_mmap_phys_addr_range(pgoff, len))
 		return (unsigned long) -EINVAL;
-	return pgoff;
+	return pgoff << PAGE_SHIFT;
 }
 
 /* can't do an in-place private mapping if there's no MMU */

-- 
