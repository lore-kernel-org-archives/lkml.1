Return-Path: <linux-kernel-owner+w=401wt.eu-S1756463AbYDNT4r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756463AbYDNT4r (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 15:56:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754291AbYDNT43
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 15:56:29 -0400
Received: from smtp6.pp.htv.fi ([213.243.153.40]:38664 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753130AbYDNT41 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 15:56:27 -0400
Date: Mon, 14 Apr 2008 22:55:21 +0300
From: Adrian Bunk <bunk@kernel.org>
To: chris@zankel.net, jgarzik@pobox.com
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [2.6 patch] xtensa: don't offer ATA
Message-ID: <20080414195521.GB26885@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Trying to build libata for xtensa fails with the following error:

<--  snip  -->

...
  CC [M]  drivers/ata/libata-core.o
/home/bunk/linux/kernel-2.6/git/linux-2.6/drivers/ata/libata-core.c: In function 'ata_devchk':
/home/bunk/linux/kernel-2.6/git/linux-2.6/drivers/ata/libata-core.c:1034: error: implicit declaration of function 'iowrite8'
/home/bunk/linux/kernel-2.6/git/linux-2.6/drivers/ata/libata-core.c:1043: error: implicit declaration of function 'ioread8'
/home/bunk/linux/kernel-2.6/git/linux-2.6/drivers/ata/libata-core.c: In function 'ata_data_xfer':
/home/bunk/linux/kernel-2.6/git/linux-2.6/drivers/ata/libata-core.c:5027: error: implicit declaration of function 'ioread16_rep'
/home/bunk/linux/kernel-2.6/git/linux-2.6/drivers/ata/libata-core.c:5029: error: implicit declaration of function 'iowrite16_rep'
/home/bunk/linux/kernel-2.6/git/linux-2.6/drivers/ata/libata-core.c:5037: error: implicit declaration of function 'ioread16'
/home/bunk/linux/kernel-2.6/git/linux-2.6/drivers/ata/libata-core.c:5041: error: implicit declaration of function 'iowrite16'
/home/bunk/linux/kernel-2.6/git/linux-2.6/drivers/ata/libata-core.c: In function 'ata_wait_register':
/home/bunk/linux/kernel-2.6/git/linux-2.6/drivers/ata/libata-core.c:7700: error: implicit declaration of function 'ioread32'
make[3]: *** [drivers/ata/libata-core.o] Error 1

<--  snip  -->

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---
aa579e7ab065e41a9d1e27e1f4b7af6b0508018c diff --git a/drivers/ata/Kconfig b/drivers/ata/Kconfig
index 25aba69..f34e9d1 100644
--- a/drivers/ata/Kconfig
+++ b/drivers/ata/Kconfig
@@ -6,7 +6,7 @@ menuconfig ATA
 	tristate "Serial ATA (prod) and Parallel ATA (experimental) drivers"
 	depends on HAS_IOMEM
 	depends on BLOCK
-	depends on !(M32R || M68K) || BROKEN
+	depends on !(M32R || M68K || XTENSA) || BROKEN
 	depends on !SUN4 || BROKEN
 	select SCSI
 	---help---

