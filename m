Return-Path: <linux-kernel-owner+w=401wt.eu-S932750AbYBNUnV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932750AbYBNUnV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 15:43:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752504AbYBNUmp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 15:42:45 -0500
Received: from hu-out-0506.google.com ([72.14.214.232]:58625 "EHLO
	hu-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751954AbYBNUmm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 15:42:42 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=rbm09v1Z+YLH+fcxK9mbGH7oXgzjq0cEePktl/BTy7FqujzFQAZzyiZVsgwzrdspgbYp5qmspDNAVAe3CCfyCcQVFd9JZImKDVxdufx4yY7DdTRJQZ4Xtqc14xpmjRE4BRIYb7RmqpsC+VVMDW7aVRhnQsc4mpNKkKJRtx3wl78=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Subject: [PATCH 2/2] ide: remove CONFIG_IDE_ARCH_OBSOLETE_INIT
Date: Thu, 14 Feb 2008 21:56:19 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20071204.744707)
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802142156.19997.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Use CONFIG_IDE_ARCH_OBSOLETE_DEFAULTS instead of
  CONFIG_IDE_ARCH_OBSOLETE_INIT in init_ide_data().

* Remove no longer needed CONFIG_IDE_ARCH_OBSOLETE_INIT.

There should be no functional changes caused by this patch.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/Kconfig |    3 ---
 drivers/ide/ide.c   |    4 ++--
 2 files changed, 2 insertions(+), 5 deletions(-)

Index: b/drivers/ide/Kconfig
===================================================================
--- a/drivers/ide/Kconfig
+++ b/drivers/ide/Kconfig
@@ -1096,9 +1096,6 @@ config BLK_DEV_IDEDMA
 	def_bool BLK_DEV_IDEDMA_SFF || BLK_DEV_IDEDMA_PMAC || \
 		 BLK_DEV_IDEDMA_ICS || BLK_DEV_IDE_AU1XXX_MDMA2_DBDMA
 
-config IDE_ARCH_OBSOLETE_INIT
-	def_bool ALPHA || (ARM && !ARCH_L7200) || BLACKFIN || X86 || IA64 || M32R || MIPS || PARISC || PPC || (SUPERH64 && BLK_DEV_IDEPCI) || SPARC
-
 config IDE_ARCH_OBSOLETE_DEFAULTS
 	def_bool ALPHA || X86 || IA64 || M32R || MIPS || PPC32
 
Index: b/drivers/ide/ide.c
===================================================================
--- a/drivers/ide/ide.c
+++ b/drivers/ide/ide.c
@@ -209,16 +209,16 @@ static void __init init_ide_data (void)
 
 		ide_init_port_data(hwif, index);
 
-#ifdef CONFIG_IDE_ARCH_OBSOLETE_INIT
+#ifdef CONFIG_IDE_ARCH_OBSOLETE_DEFAULTS
 		memset(&hw, 0, sizeof(hw));
 		ide_std_init_ports(&hw, io_addr, ctl_addr);
 		memcpy(hwif->io_ports, hw.io_ports, sizeof(hw.io_ports));
-#endif
 		hwif->noprobe = !hwif->io_ports[IDE_DATA_OFFSET];
 #if !defined(CONFIG_PPC32) || defined(CONFIG_PPLUS) || !defined(CONFIG_PCI)
 		hwif->irq =
 			ide_init_default_irq(hwif->io_ports[IDE_DATA_OFFSET]);
 #endif
+#endif
 	}
 }
 
