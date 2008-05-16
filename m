Return-Path: <linux-kernel-owner+w=401wt.eu-S1753180AbYEPOi5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753180AbYEPOi5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2008 10:38:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750752AbYEPOit
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 May 2008 10:38:49 -0400
Received: from ozlabs.org ([203.10.76.45]:57372 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750751AbYEPOit (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2008 10:38:49 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH] lguest: use ioremap_cache, not ioremap
Date: Sat, 17 May 2008 00:38:35 +1000
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, lguest <lguest@ozlabs.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805170038.35282.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks to Jon Corbet & LWN.  Only took me a day to join the dots.

Host->Guest netcat before (with unnecessily large receive buffers):
1073741824 bytes (1.1 GB) copied, 24.7528 seconds, 43.4 MB/s

After:
1073741824 bytes (1.1 GB) copied, 17.6369 seconds, 60.9 MB/s

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
---
 drivers/lguest/lguest_device.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -r f0417cb4869e drivers/lguest/lguest_device.c
--- a/drivers/lguest/lguest_device.c	Fri May 16 15:51:08 2008 +1000
+++ b/drivers/lguest/lguest_device.c	Fri May 16 20:43:36 2008 +1000
@@ -27,7 +27,7 @@ static unsigned int dev_index;
  * __iomem to quieten sparse. */
 static inline void *lguest_map(unsigned long phys_addr, unsigned long pages)
 {
-	return (__force void *)ioremap(phys_addr, PAGE_SIZE*pages);
+	return (__force void *)ioremap_cache(phys_addr, PAGE_SIZE*pages);
 }
 
 static inline void lguest_unmap(void *addr)
