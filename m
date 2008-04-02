Return-Path: <linux-kernel-owner+w=401wt.eu-S1760064AbYDBTMI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760064AbYDBTMI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 15:12:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757978AbYDBTLe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 15:11:34 -0400
Received: from ug-out-1314.google.com ([66.249.92.173]:19837 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757742AbYDBTLc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 15:11:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:date:user-agent:cc:mime-version:content-disposition:message-id:subject:content-type:content-transfer-encoding;
        b=AG4qqVxv4d/HNA5KVN6qh2AP5xHB2waYuibLdSe8MfVT2mZiloehKNzx0yEu4IYGXiEuPZeJIvChN9UPG6U5cXMa5TcvAWZK+GwK/1zvZinEUJRSYfKSW1udob0MepQVTOojIw5lfOkU9M7ir10vEY8rykLD6lfoZmZySyam8kM=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 2 Apr 2008 21:26:08 +0200
User-Agent: KMail/1.9.9
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200804022126.08357.bzolnier@gmail.com>
Subject: [git patches] IDE fixes
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


few obvious things (mainly Adrian's fixes for missing MODULE_LICENSE-s)

Linus, please pull from:

master.kernel.org:/pub/scm/linux/kernel/git/bart/ide-2.6.git/

to receive the following updates:

 drivers/ide/arm/ide_arm.c      |    2 ++
 drivers/ide/cris/ide-cris.c    |    2 ++
 drivers/ide/h8300/ide-h8300.c  |    3 +++
 drivers/ide/ide-iops.c         |    2 +-
 drivers/ide/ide-pnp.c          |    2 ++
 drivers/ide/legacy/buddha.c    |    2 ++
 drivers/ide/legacy/falconide.c |    2 ++
 drivers/ide/legacy/gayle.c     |    2 ++
 drivers/ide/legacy/macide.c    |    2 ++
 drivers/ide/legacy/q40ide.c    |    2 ++
 drivers/ide/pci/cmd640.c       |    2 ++
 drivers/ide/ppc/mpc8xx.c       |    2 ++
 drivers/ide/ppc/pmac.c         |    2 ++
 13 files changed, 26 insertions(+), 1 deletions(-)


Adrian Bunk (12):
      ide-pnp.c: add MODULE_LICENSE
      ide/pci/cmd640.c: add MODULE_LICENSE
      ide/ppc/mpc8xx.c: add MODULE_LICENSE
      ide/ppc/pmac.c: add MODULE_LICENSE
      ide/arm/ide_arm.c: add MODULE_LICENSE
      ide/cris/ide-cris.c: add MODULE_LICENSE
      ide/h8300/ide-h8300.c: add MODULE_LICENSE
      ide/legacy/gayle.c: add MODULE_LICENSE
      ide/legacy/buddha.c: add MODULE_LICENSE
      ide/legacy/falconide.c: add MODULE_LICENSE
      ide/legacy/macide: add MODULE_LICENSE
      ide/legacy/q40ide.c: add MODULE_LICENSE

Bartlomiej Zolnierkiewicz (2):
      ide-h8300: 32-bit I/O is unsupported
      ide: use ->ata_input_data in ide_driveid_update()


diff --git a/drivers/ide/arm/ide_arm.c b/drivers/ide/arm/ide_arm.c
index 43a70e9..be9ff73 100644
--- a/drivers/ide/arm/ide_arm.c
+++ b/drivers/ide/arm/ide_arm.c
@@ -46,3 +46,5 @@ static int __init ide_arm_init(void)
 }
 
 module_init(ide_arm_init);
+
+MODULE_LICENSE("GPL");
diff --git a/drivers/ide/cris/ide-cris.c b/drivers/ide/cris/ide-cris.c
index e79bf8f..c8ffbaf 100644
--- a/drivers/ide/cris/ide-cris.c
+++ b/drivers/ide/cris/ide-cris.c
@@ -1067,3 +1067,5 @@ static void cris_dma_start(ide_drive_t *drive)
 }
 
 module_init(init_e100_ide);
+
+MODULE_LICENSE("GPL");
diff --git a/drivers/ide/h8300/ide-h8300.c b/drivers/ide/h8300/ide-h8300.c
index 520aec0..4108ec4 100644
--- a/drivers/ide/h8300/ide-h8300.c
+++ b/drivers/ide/h8300/ide-h8300.c
@@ -110,6 +110,7 @@ static int __init h8300_ide_init(void)
 	ide_init_port_data(hwif, index);
 	ide_init_port_hw(hwif, &hw);
 	hwif_setup(hwif);
+	hwif->host_flags = IDE_HFLAG_NO_IO_32BIT;
 	printk(KERN_INFO "ide%d: H8/300 generic IDE interface\n", index);
 
 	idx[0] = index;
@@ -125,3 +126,5 @@ out_busy:
 }
 
 module_init(h8300_ide_init);
+
+MODULE_LICENSE("GPL");
diff --git a/drivers/ide/ide-iops.c b/drivers/ide/ide-iops.c
index 01b9220..e77cee0 100644
--- a/drivers/ide/ide-iops.c
+++ b/drivers/ide/ide-iops.c
@@ -658,7 +658,7 @@ int ide_driveid_update(ide_drive_t *drive)
 		local_irq_restore(flags);
 		return 0;
 	}
-	ata_input_data(drive, id, SECTOR_WORDS);
+	hwif->ata_input_data(drive, id, SECTOR_WORDS);
 	(void)ide_read_status(drive);	/* clear drive IRQ */
 	local_irq_enable();
 	local_irq_restore(flags);
diff --git a/drivers/ide/ide-pnp.c b/drivers/ide/ide-pnp.c
index b163b2e..c14bb53 100644
--- a/drivers/ide/ide-pnp.c
+++ b/drivers/ide/ide-pnp.c
@@ -86,3 +86,5 @@ static void __exit pnpide_exit(void)
 
 module_init(pnpide_init);
 module_exit(pnpide_exit);
+
+MODULE_LICENSE("GPL");
diff --git a/drivers/ide/legacy/buddha.c b/drivers/ide/legacy/buddha.c
index 50ffa87..fdd3791 100644
--- a/drivers/ide/legacy/buddha.c
+++ b/drivers/ide/legacy/buddha.c
@@ -241,3 +241,5 @@ fail_base2:
 }
 
 module_init(buddha_init);
+
+MODULE_LICENSE("GPL");
diff --git a/drivers/ide/legacy/falconide.c b/drivers/ide/legacy/falconide.c
index 8949ce7..e950afa 100644
--- a/drivers/ide/legacy/falconide.c
+++ b/drivers/ide/legacy/falconide.c
@@ -93,3 +93,5 @@ static int __init falconide_init(void)
 }
 
 module_init(falconide_init);
+
+MODULE_LICENSE("GPL");
diff --git a/drivers/ide/legacy/gayle.c b/drivers/ide/legacy/gayle.c
index b7d8109..e3b4638 100644
--- a/drivers/ide/legacy/gayle.c
+++ b/drivers/ide/legacy/gayle.c
@@ -195,3 +195,5 @@ found:
 }
 
 module_init(gayle_init);
+
+MODULE_LICENSE("GPL");
diff --git a/drivers/ide/legacy/macide.c b/drivers/ide/legacy/macide.c
index 9a79098..eaf5dbe 100644
--- a/drivers/ide/legacy/macide.c
+++ b/drivers/ide/legacy/macide.c
@@ -137,3 +137,5 @@ static int __init macide_init(void)
 }
 
 module_init(macide_init);
+
+MODULE_LICENSE("GPL");
diff --git a/drivers/ide/legacy/q40ide.c b/drivers/ide/legacy/q40ide.c
index 1381b91..2da2875 100644
--- a/drivers/ide/legacy/q40ide.c
+++ b/drivers/ide/legacy/q40ide.c
@@ -153,3 +153,5 @@ static int __init q40ide_init(void)
 }
 
 module_init(q40ide_init);
+
+MODULE_LICENSE("GPL");
diff --git a/drivers/ide/pci/cmd640.c b/drivers/ide/pci/cmd640.c
index ec66798..29fbc5e 100644
--- a/drivers/ide/pci/cmd640.c
+++ b/drivers/ide/pci/cmd640.c
@@ -881,3 +881,5 @@ module_param_named(probe_vlb, cmd640_vlb, bool, 0);
 MODULE_PARM_DESC(probe_vlb, "probe for VLB version of CMD640 chipset");
 
 module_init(cmd640x_init);
+
+MODULE_LICENSE("GPL");
diff --git a/drivers/ide/ppc/mpc8xx.c b/drivers/ide/ppc/mpc8xx.c
index 38fbfb8..ebaba01 100644
--- a/drivers/ide/ppc/mpc8xx.c
+++ b/drivers/ide/ppc/mpc8xx.c
@@ -853,3 +853,5 @@ static int __init mpc8xx_ide_probe(void)
 }
 
 module_init(mpc8xx_ide_probe);
+
+MODULE_LICENSE("GPL");
diff --git a/drivers/ide/ppc/pmac.c b/drivers/ide/ppc/pmac.c
index 78c9eeb..d9ca52e 100644
--- a/drivers/ide/ppc/pmac.c
+++ b/drivers/ide/ppc/pmac.c
@@ -1771,3 +1771,5 @@ static int __devinit pmac_ide_setup_dma(pmac_ide_hwif_t *pmif, ide_hwif_t *hwif)
 #endif /* CONFIG_BLK_DEV_IDEDMA_PMAC */
 
 module_init(pmac_ide_probe);
+
+MODULE_LICENSE("GPL");
