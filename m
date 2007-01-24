Return-Path: <linux-kernel-owner+w=401wt.eu-S932827AbXAXWfy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932827AbXAXWfy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jan 2007 17:35:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932825AbXAXWfy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jan 2007 17:35:54 -0500
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:3355 "HELO
	mailout.stusta.mhn.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932827AbXAXWfx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jan 2007 17:35:53 -0500
Date: Wed, 24 Jan 2007 23:36:00 +0100
From: Adrian Bunk <bunk@stusta.de>
To: Andrew Morton <akpm@osdl.org>, Ryan Jackson <rjackson@lnxi.com>,
       David Woodhouse <dwmw2@infradead.org>
Cc: linux-kernel@vger.kernel.org, dwmw2@infradead.org
Subject: [-mm patch] MTD_CK804XROM must depend on PCI
Message-ID: <20070124223600.GQ17836@stusta.de>
References: <20070111222627.66bb75ab.akpm@osdl.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070111222627.66bb75ab.akpm@osdl.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 11, 2007 at 10:26:27PM -0800, Andrew Morton wrote:
>...
>  git-mtd.patch
>...
>  git trees

CONFIG_MTD_CK804XROM=y, CONFIG_PCI=n results in the following compile 
error:

<--  snip  -->

...
  CC      drivers/mtd/maps/ck804xrom.o
/home/bunk/linux/kernel-2.6/linux-2.6.20-rc4-mm1/drivers/mtd/maps/ck804xrom.c: In function 'ck804xrom_init_one':
/home/bunk/linux/kernel-2.6/linux-2.6.20-rc4-mm1/drivers/mtd/maps/ck804xrom.c:114: error: implicit declaration of function 'pci_dev_get'
/home/bunk/linux/kernel-2.6/linux-2.6.20-rc4-mm1/drivers/mtd/maps/ck804xrom.c:114: warning: assignment makes pointer from integer without a cast
make[4]: *** [drivers/mtd/maps/ck804xrom.o] Error 1

<--  snip  -->

Considering what hardware this driver is driving, a dependency on PCI 
also seems logical.

Signed-off-by: Adrian Bunk <bunk@stusta.de>

--- linux-2.6.20-rc4-mm1/drivers/mtd/maps/Kconfig.old	2007-01-24 13:53:18.000000000 +0100
+++ linux-2.6.20-rc4-mm1/drivers/mtd/maps/Kconfig	2007-01-24 13:53:39.000000000 +0100
@@ -204,7 +204,7 @@
 
 config MTD_CK804XROM
 	tristate "BIOS flash chip on Nvidia CK804"
-	depends on X86 && MTD_JEDECPROBE
+	depends on X86 && MTD_JEDECPROBE && PCI
 	help
 	  Support for treating the BIOS flash chip on nvidia motherboards
 	  as an MTD device - with this you can reprogram your BIOS.
