Return-Path: <linux-kernel-owner+w=401wt.eu-S1753405AbYLNCqQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753405AbYLNCqQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Dec 2008 21:46:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751660AbYLNCqF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Dec 2008 21:46:05 -0500
Received: from sh.osrg.net ([192.16.179.4]:57746 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751087AbYLNCqD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Dec 2008 21:46:03 -0500
Date: Sun, 14 Dec 2008 11:44:37 +0900
To: kyle@mcmartin.ca
Cc: linux-parisc@vger.kernel.org, matthew@wil.cx, grundler@parisc-linux.org,
       jens.axboe@oracle.com, linux-kernel@vger.kernel.org
Subject: [RESEND] [PATCH] parisc: remove dead BIO_VMERGE_BOUNDARY and
 BIO_VMERGE_MAX_SIZE definitions
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20081214114450M.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a resend of:

http://marc.info/?l=linux-parisc&m=122482703716617&w=2

I added Grant's ACK:

http://marc.info/?l=linux-parisc&m=122555878602851&w=2

=
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH] parisc: remove dead BIO_VMERGE_BOUNDARY and BIO_VMERGE_MAX_SIZE definitions

The block layer dropped the virtual merge feature
(b8b3e16cfe6435d961f6aaebcfd52a1ff2a988c5). BIO_VMERGE_BOUNDARY and
BIO_VMERGE_MAX_SIZE definitions are meaningless now.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Acked-by: Grant Grundler <grundler@parisc-linux.org>
---
 arch/parisc/include/asm/io.h |    6 ------
 arch/parisc/kernel/setup.c   |    5 -----
 drivers/parisc/ccio-dma.c    |    2 --
 drivers/parisc/sba_iommu.c   |    2 --
 4 files changed, 0 insertions(+), 15 deletions(-)

diff --git a/arch/parisc/include/asm/io.h b/arch/parisc/include/asm/io.h
index 55ddb18..b92efb3 100644
--- a/arch/parisc/include/asm/io.h
+++ b/arch/parisc/include/asm/io.h
@@ -4,12 +4,6 @@
 #include <linux/types.h>
 #include <asm/pgtable.h>
 
-extern unsigned long parisc_vmerge_boundary;
-extern unsigned long parisc_vmerge_max_size;
-
-#define BIO_VMERGE_BOUNDARY	parisc_vmerge_boundary
-#define BIO_VMERGE_MAX_SIZE	parisc_vmerge_max_size
-
 #define virt_to_phys(a) ((unsigned long)__pa(a))
 #define phys_to_virt(a) __va(a)
 #define virt_to_bus virt_to_phys
diff --git a/arch/parisc/kernel/setup.c b/arch/parisc/kernel/setup.c
index 7d27853..8d8b024 100644
--- a/arch/parisc/kernel/setup.c
+++ b/arch/parisc/kernel/setup.c
@@ -58,11 +58,6 @@ int parisc_bus_is_phys __read_mostly = 1;	/* Assume no IOMMU is present */
 EXPORT_SYMBOL(parisc_bus_is_phys);
 #endif
 
-/* This sets the vmerge boundary and size, it's here because it has to
- * be available on all platforms (zero means no-virtual merging) */
-unsigned long parisc_vmerge_boundary = 0;
-unsigned long parisc_vmerge_max_size = 0;
-
 void __init setup_cmdline(char **cmdline_p)
 {
 	extern unsigned int boot_args[];
diff --git a/drivers/parisc/ccio-dma.c b/drivers/parisc/ccio-dma.c
index dcc1e99..62cc21d 100644
--- a/drivers/parisc/ccio-dma.c
+++ b/drivers/parisc/ccio-dma.c
@@ -1578,8 +1578,6 @@ static int __init ccio_probe(struct parisc_device *dev)
 
 	ioc_count++;
 
-	parisc_vmerge_boundary = IOVP_SIZE;
-	parisc_vmerge_max_size = BITS_PER_LONG * IOVP_SIZE;
 	parisc_has_iommu();
 	return 0;
 }
diff --git a/drivers/parisc/sba_iommu.c b/drivers/parisc/sba_iommu.c
index bc73b96..bdc9a0a 100644
--- a/drivers/parisc/sba_iommu.c
+++ b/drivers/parisc/sba_iommu.c
@@ -1979,8 +1979,6 @@ sba_driver_callback(struct parisc_device *dev)
 	proc_create("sba_iommu-bitmap", 0, root, &sba_proc_bitmap_fops);
 #endif
 
-	parisc_vmerge_boundary = IOVP_SIZE;
-	parisc_vmerge_max_size = IOVP_SIZE * BITS_PER_LONG;
 	parisc_has_iommu();
 	return 0;
 }
-- 
1.5.5.GIT

