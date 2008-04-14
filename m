Return-Path: <linux-kernel-owner+w=401wt.eu-S1758019AbYDNOXF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758019AbYDNOXF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 10:23:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761152AbYDNOVF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 10:21:05 -0400
Received: from smtp5.pp.htv.fi ([213.243.153.39]:41367 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761158AbYDNOVD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 10:21:03 -0400
Date: Mon, 14 Apr 2008 17:19:56 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Mark Salyzyn <aacraid@adaptec.com>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       wli@holomorphy.com
Cc: sparclinux@vger.kernel.org, linux-scsi@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [2.6 patch] sparc: export kmap_atomic_to_page
Message-ID: <20080414141956.GN6695@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes the following build error exposed by commit 
3a0086a80ab7c2f1adb0e9b2a6fc82632979cec5:

<--  snip  -->

  MODPOST 1741 modules
ERROR: "kmap_atomic_to_page" [drivers/scsi/aacraid/aacraid.ko] undefined!
...
make[2]: *** [__modpost] Error 1

<--  snip  -->

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

 arch/sparc/mm/highmem.c |    2 ++
 1 file changed, 2 insertions(+)

e0d104bd0a5560ef4c836af8eb1ddd70dfb01db5 diff --git a/arch/sparc/mm/highmem.c b/arch/sparc/mm/highmem.c
index 01fc6c2..145ac7f 100644
--- a/arch/sparc/mm/highmem.c
+++ b/arch/sparc/mm/highmem.c
@@ -24,6 +24,7 @@
  */
 #include <linux/mm.h>
 #include <linux/highmem.h>
+#include <linux/module.h>
 #include <asm/pgalloc.h>
 #include <asm/cacheflush.h>
 #include <asm/tlbflush.h>
@@ -116,3 +117,4 @@ struct page *kmap_atomic_to_page(void *ptr)
 	pte = kmap_pte - (idx - FIX_KMAP_BEGIN);
 	return pte_page(*pte);
 }
+EXPORT_SYMBOL_GPL(kmap_atomic_to_page);

