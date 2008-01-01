Return-Path: <linux-kernel-owner+w=401wt.eu-S1755537AbYAARcZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755537AbYAARcZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jan 2008 12:32:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754694AbYAARcN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jan 2008 12:32:13 -0500
Received: from ug-out-1314.google.com ([66.249.92.174]:15746 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752056AbYAARcJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jan 2008 12:32:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=nsSPjdqfhFgFAYo/RMbpgxoa2g19oAwMMBQ9Agc+mOUMkZ1jzWAMw1YvcLKUHq1cx72WKbSvxjEZHrmitI+I5bk8N8KBONTPhPmk7Pe3gwKlK/B64w060+qgRvA6btUpbw5OUHjPvPw7wmK49C3VKpawS62HVmTw1DZe3o1KzJU=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Subject: [PATCH 1/3] ide: use MODULE_VERSION()
Date: Tue, 1 Jan 2008 18:40:38 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20071123.740460)
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801011840.38757.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Replace driver versions in comments by DRV_VERSION define.

* Add MODULE_VERSION(DRV_VERSION) to drivers defining DRV_VERSION.

While at it:

* Replace local version defines by DRV_VERSION.

* Bump driver version in ide-floppy to match generic format
  ("0.99.newide" -> "1.00").

* Change printk() level in ide-floppy banner message to KERN_INFO.

* Bump driver version in IDE core module to match generic format
  ("Id: ide.c 7.00a2 20020906" -> "7.00").

* Remove unused REVISION define from ide.c.

* Update (the previously unused) DRV_VERSION define in au1xxx-ide.c.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-cd.c           |    7 ++++---
 drivers/ide/ide-disk.c         |    9 +++++----
 drivers/ide/ide-floppy.c       |   12 +++++++-----
 drivers/ide/ide-tape.c         |    9 +++++----
 drivers/ide/ide.c              |   11 ++++++-----
 drivers/ide/legacy/ali14xx.c   |    5 ++++-
 drivers/ide/legacy/dtc2278.c   |    5 ++++-
 drivers/ide/legacy/ht6560b.c   |    9 ++++++---
 drivers/ide/legacy/ide-cs.c    |    5 ++++-
 drivers/ide/legacy/qd65xx.c    |    5 ++++-
 drivers/ide/legacy/umc8672.c   |    5 ++++-
 drivers/ide/mips/au1xxx-ide.c  |    5 +++--
 drivers/ide/pci/aec62xx.c      |    5 ++++-
 drivers/ide/pci/alim15x3.c     |    5 ++++-
 drivers/ide/pci/amd74xx.c      |    5 +++--
 drivers/ide/pci/atiixp.c       |    5 ++++-
 drivers/ide/pci/cmd640.c       |    5 ++++-
 drivers/ide/pci/cmd64x.c       |    5 ++++-
 drivers/ide/pci/cs5530.c       |    5 ++++-
 drivers/ide/pci/cy82c693.c     |    5 ++++-
 drivers/ide/pci/generic.c      |    5 ++++-
 drivers/ide/pci/hpt34x.c       |    5 ++++-
 drivers/ide/pci/hpt366.c       |    5 ++++-
 drivers/ide/pci/it821x.c       |    5 ++++-
 drivers/ide/pci/ns87415.c      |    5 ++++-
 drivers/ide/pci/opti621.c      |    5 ++++-
 drivers/ide/pci/pdc202xx_old.c |    5 ++++-
 drivers/ide/pci/piix.c         |    5 ++++-
 drivers/ide/pci/rz1000.c       |    6 ++++--
 drivers/ide/pci/sc1200.c       |    5 ++++-
 drivers/ide/pci/serverworks.c  |    5 ++++-
 drivers/ide/pci/siimage.c      |    5 ++++-
 drivers/ide/pci/sis5513.c      |    5 ++++-
 drivers/ide/pci/slc90e66.c     |    5 ++++-
 drivers/ide/pci/tc86c001.c     |    5 ++++-
 drivers/ide/pci/trm290.c       |    5 ++++-
 drivers/ide/pci/via82cxxx.c    |    6 +++---
 drivers/scsi/ide-scsi.c        |    9 +++++----
 38 files changed, 159 insertions(+), 64 deletions(-)

Index: b/drivers/ide/ide-cd.c
===================================================================
--- a/drivers/ide/ide-cd.c
+++ b/drivers/ide/ide-cd.c
@@ -23,8 +23,6 @@
  *	Documentation/ide/ChangeLog.ide-cd.1994-2004
  */
 
-#define IDECD_VERSION "5.00"
-
 #include <linux/module.h>
 #include <linux/types.h>
 #include <linux/kernel.h>
@@ -49,6 +47,8 @@
 
 #include "ide-cd.h"
 
+#define DRV_VERSION	"5.00"
+
 static DEFINE_MUTEX(idecd_ref_mutex);
 
 #define to_ide_cd(obj) container_of(obj, struct cdrom_info, kref) 
@@ -2054,7 +2054,7 @@ static ide_driver_t ide_cdrom_driver = {
 	},
 	.probe			= ide_cd_probe,
 	.remove			= ide_cd_remove,
-	.version		= IDECD_VERSION,
+	.version		= DRV_VERSION,
 	.media			= ide_cdrom,
 	.supports_dsc_overlap	= 1,
 	.do_request		= ide_do_rw_cdrom,
@@ -2275,3 +2275,4 @@ MODULE_ALIAS("ide-cd");
 module_init(ide_cdrom_init);
 module_exit(ide_cdrom_exit);
 MODULE_LICENSE("GPL");
+MODULE_VERSION(DRV_VERSION);
Index: b/drivers/ide/ide-disk.c
===================================================================
--- a/drivers/ide/ide-disk.c
+++ b/drivers/ide/ide-disk.c
@@ -1,5 +1,5 @@
 /*
- *  linux/drivers/ide/ide-disk.c	Version 1.18	Mar 05, 2003
+ *  linux/drivers/ide/ide-disk.c
  *
  *  Copyright (C) 1994-1998  Linus Torvalds & authors (see below)
  *  Copyright (C) 1998-2002  Linux ATA Development
@@ -15,8 +15,6 @@
  * This is the IDE/ATA disk driver, as evolved from hd.c and ide.c.
  */
 
-#define IDEDISK_VERSION	"1.18"
-
 //#define DEBUG
 
 #include <linux/module.h>
@@ -44,6 +42,8 @@
 #include <asm/io.h>
 #include <asm/div64.h>
 
+#define DRV_VERSION	"1.18"
+
 struct ide_disk_obj {
 	ide_drive_t	*drive;
 	ide_driver_t	*driver;
@@ -959,7 +959,7 @@ static ide_driver_t idedisk_driver = {
 	.remove			= ide_disk_remove,
 	.resume			= ide_disk_resume,
 	.shutdown		= ide_device_shutdown,
-	.version		= IDEDISK_VERSION,
+	.version		= DRV_VERSION,
 	.media			= ide_disk,
 	.supports_dsc_overlap	= 0,
 	.do_request		= ide_do_rw_disk,
@@ -1193,3 +1193,4 @@ MODULE_ALIAS("ide:*m-disk*");
 module_init(idedisk_init);
 module_exit(idedisk_exit);
 MODULE_LICENSE("GPL");
+MODULE_VERSION(DRV_VERSION);
Index: b/drivers/ide/ide-floppy.c
===================================================================
--- a/drivers/ide/ide-floppy.c
+++ b/drivers/ide/ide-floppy.c
@@ -1,5 +1,5 @@
 /*
- * linux/drivers/ide/ide-floppy.c	Version 0.99	Feb 24 2002
+ * linux/drivers/ide/ide-floppy.c
  *
  * Copyright (C) 1996 - 1999 Gadi Oxman <gadio@netvision.net.il>
  * Copyright (C) 2000 - 2002 Paul Bristow <paul@paulbristow.net>
@@ -80,8 +80,6 @@
  *                        to support new PocketZip drives 
  */
 
-#define IDEFLOPPY_VERSION "0.99.newide"
-
 #include <linux/module.h>
 #include <linux/types.h>
 #include <linux/string.h>
@@ -107,6 +105,8 @@
 #include <asm/io.h>
 #include <asm/unaligned.h>
 
+#define DRV_VERSION	"1.00"
+
 /*
  *	The following are used to debug the driver.
  */
@@ -1834,7 +1834,7 @@ static ide_driver_t idefloppy_driver = {
 	},
 	.probe			= ide_floppy_probe,
 	.remove			= ide_floppy_remove,
-	.version		= IDEFLOPPY_VERSION,
+	.version		= DRV_VERSION,
 	.media			= ide_floppy,
 	.supports_dsc_overlap	= 0,
 	.do_request		= idefloppy_do_request,
@@ -2120,7 +2120,8 @@ static void __exit idefloppy_exit (void)
 
 static int __init idefloppy_init(void)
 {
-	printk("ide-floppy driver " IDEFLOPPY_VERSION "\n");
+	printk(KERN_INFO "ide-floppy driver " DRV_VERSION "\n");
+
 	return driver_register(&idefloppy_driver.gen_driver);
 }
 
@@ -2128,3 +2129,4 @@ MODULE_ALIAS("ide:*m-floppy*");
 module_init(idefloppy_init);
 module_exit(idefloppy_exit);
 MODULE_LICENSE("GPL");
+MODULE_VERSION(DRV_VERSION);
Index: b/drivers/ide/ide-tape.c
===================================================================
--- a/drivers/ide/ide-tape.c
+++ b/drivers/ide/ide-tape.c
@@ -1,5 +1,5 @@
 /*
- * linux/drivers/ide/ide-tape.c		Version 1.19	Nov, 2003
+ * linux/drivers/ide/ide-tape.c
  *
  * Copyright (C) 1995 - 1999 Gadi Oxman <gadio@netvision.net.il>
  *
@@ -422,8 +422,6 @@
  *		sharing a (fast) ATA-2 disk with any (slow) new ATAPI device.
  */
 
-#define IDETAPE_VERSION "1.19"
-
 #include <linux/module.h>
 #include <linux/types.h>
 #include <linux/string.h>
@@ -450,6 +448,8 @@
 #include <asm/io.h>
 #include <asm/unaligned.h>
 
+#define DRV_VERSION	"1.19"
+
 /*
  * partition
  */
@@ -4678,7 +4678,7 @@ static ide_driver_t idetape_driver = {
 	},
 	.probe			= ide_tape_probe,
 	.remove			= ide_tape_remove,
-	.version		= IDETAPE_VERSION,
+	.version		= DRV_VERSION,
 	.media			= ide_tape,
 	.supports_dsc_overlap 	= 1,
 	.do_request		= idetape_do_request,
@@ -4859,3 +4859,4 @@ MODULE_ALIAS("ide:*m-tape*");
 module_init(idetape_init);
 module_exit(idetape_exit);
 MODULE_ALIAS_CHARDEV_MAJOR(IDETAPE_MAJOR);
+MODULE_VERSION(DRV_VERSION);
Index: b/drivers/ide/ide.c
===================================================================
--- a/drivers/ide/ide.c
+++ b/drivers/ide/ide.c
@@ -1,5 +1,5 @@
 /*
- *  linux/drivers/ide/ide.c		Version 7.00beta2	Mar 05 2003
+ *  linux/drivers/ide/ide.c
  *
  *  Copyright (C) 1994-1998  Linus Torvalds & authors (see below)
  */
@@ -45,9 +45,6 @@
  *  inspiration from lots of linux users, esp.  hamish@zot.apana.org.au
  */
 
-#define	REVISION	"Revision: 7.00alpha2"
-#define	VERSION		"Id: ide.c 7.00a2 20020906"
-
 #define _IDE_C			/* Tell ide.h it's really us */
 
 #include <linux/module.h>
@@ -78,6 +75,7 @@
 #include <asm/uaccess.h>
 #include <asm/io.h>
 
+#define DRV_VERSION	"7.00"
 
 /* default maximum number of failures */
 #define IDE_DEFAULT_MAX_FAILURES 	1
@@ -1666,7 +1664,9 @@ static int __init ide_init(void)
 {
 	int ret;
 
-	printk(KERN_INFO "Uniform Multi-Platform E-IDE driver " REVISION "\n");
+	printk(KERN_INFO "Uniform Multi-Platform E-IDE driver version "
+			 DRV_VERSION "\n");
+
 	system_bus_speed = ide_system_bus_speed();
 
 	ret = bus_register(&ide_bus_type);
@@ -1686,6 +1686,7 @@ static int __init ide_init(void)
 static char *options = NULL;
 module_param(options, charp, 0);
 MODULE_LICENSE("GPL");
+MODULE_VERSION(DRV_VERSION);
 
 static void __init parse_options (char *line)
 {
Index: b/drivers/ide/legacy/ali14xx.c
===================================================================
--- a/drivers/ide/legacy/ali14xx.c
+++ b/drivers/ide/legacy/ali14xx.c
@@ -1,5 +1,5 @@
 /*
- *  linux/drivers/ide/legacy/ali14xx.c		Version 0.03	Feb 09, 1996
+ *  linux/drivers/ide/legacy/ali14xx.c
  *
  *  Copyright (C) 1996  Linus Torvalds & author (see below)
  */
@@ -51,6 +51,8 @@
 
 #include <asm/io.h>
 
+#define DRV_VERSION	"0.03"
+
 /* port addresses for auto-detection */
 #define ALI_NUM_PORTS 4
 static const int ports[ALI_NUM_PORTS] __initdata =
@@ -252,3 +254,4 @@ module_init(ali14xx_init);
 MODULE_AUTHOR("see local file");
 MODULE_DESCRIPTION("support of ALI 14XX IDE chipsets");
 MODULE_LICENSE("GPL");
+MODULE_VERSION(DRV_VERSION);
Index: b/drivers/ide/legacy/dtc2278.c
===================================================================
--- a/drivers/ide/legacy/dtc2278.c
+++ b/drivers/ide/legacy/dtc2278.c
@@ -1,5 +1,5 @@
 /*
- *  linux/drivers/ide/legacy/dtc2278.c		Version 0.02	Feb 10, 1996
+ *  linux/drivers/ide/legacy/dtc2278.c
  *
  *  Copyright (C) 1996  Linus Torvalds & author (see below)
  */
@@ -18,6 +18,8 @@
 
 #include <asm/io.h>
 
+#define DRV_VERSION	"0.02"
+
 /*
  * Changing this #undef to #define may solve start up problems in some systems.
  */
@@ -167,3 +169,4 @@ module_init(dtc2278_init);
 MODULE_AUTHOR("See Local File");
 MODULE_DESCRIPTION("support of DTC-2278 VLB IDE chipsets");
 MODULE_LICENSE("GPL");
+MODULE_VERSION(DRV_VERSION);
Index: b/drivers/ide/legacy/ht6560b.c
===================================================================
--- a/drivers/ide/legacy/ht6560b.c
+++ b/drivers/ide/legacy/ht6560b.c
@@ -1,5 +1,5 @@
 /*
- *  linux/drivers/ide/legacy/ht6560b.c		Version 0.07	Feb  1, 2000
+ *  linux/drivers/ide/legacy/ht6560b.c
  *
  *  Copyright (C) 1995-2000  Linus Torvalds & author (see below)
  */
@@ -50,6 +50,8 @@
 
 #include <asm/io.h>
 
+#define DRV_VERSION	"0.07"
+
 /* #define DEBUG */  /* remove comments for DEBUG messages */
 
 /*
@@ -189,8 +191,8 @@ static int __init try_to_init_ht6560b(vo
 	outb(HT_CONFIG_DEFAULT, HT_CONFIG_PORT);
 	outb(HT_TIMING_DEFAULT, 0x1f6);  /* IDE_SELECT_REG */
 	(void) inb(0x1f7);               /* IDE_STATUS_REG */
-	
-	printk("\nht6560b " HT6560B_VERSION
+
+	printk(KERN_CONT "\nht6560b v" DRV_VERSION
 	       ": chipset detected and initialized"
 #ifdef DEBUG
 	       " with debug enabled"
@@ -373,3 +375,4 @@ module_init(ht6560b_init);
 MODULE_AUTHOR("See Local File");
 MODULE_DESCRIPTION("HT-6560B EIDE-controller support");
 MODULE_LICENSE("GPL");
+MODULE_VERSION(DRV_VERSION);
Index: b/drivers/ide/legacy/ide-cs.c
===================================================================
--- a/drivers/ide/legacy/ide-cs.c
+++ b/drivers/ide/legacy/ide-cs.c
@@ -2,7 +2,7 @@
 
     A driver for PCMCIA IDE/ATA disk cards
 
-    ide-cs.c 1.3 2002/10/26 05:45:31
+    ide-cs.c
 
     The contents of this file are subject to the Mozilla Public
     License Version 1.1 (the "License"); you may not use this file
@@ -53,6 +53,8 @@
 #include <pcmcia/cisreg.h>
 #include <pcmcia/ciscode.h>
 
+#define DRV_VERSION	"1.3"
+
 /*====================================================================*/
 
 /* Module parameters */
@@ -60,6 +62,7 @@
 MODULE_AUTHOR("David Hinds <dahinds@users.sourceforge.net>");
 MODULE_DESCRIPTION("PCMCIA ATA/IDE card driver");
 MODULE_LICENSE("Dual MPL/GPL");
+MODULE_VERSION(DRV_VERSION);
 
 #define INT_MODULE_PARM(n, v) static int n = v; module_param(n, int, 0)
 
Index: b/drivers/ide/legacy/qd65xx.c
===================================================================
--- a/drivers/ide/legacy/qd65xx.c
+++ b/drivers/ide/legacy/qd65xx.c
@@ -1,5 +1,5 @@
 /*
- *  linux/drivers/ide/legacy/qd65xx.c		Version 0.07	Sep 30, 2001
+ *  linux/drivers/ide/legacy/qd65xx.c
  *
  *  Copyright (C) 1996-2001  Linus Torvalds & author (see below)
  */
@@ -41,6 +41,8 @@
 
 #include "qd65xx.h"
 
+#define DRV_VERSION	"0.07"
+
 /*
  * I/O ports are 0x30-0x31 (and 0x32-0x33 for qd6580)
  *            or 0xb0-0xb1 (and 0xb2-0xb3 for qd6580)
@@ -496,3 +498,4 @@ module_init(qd65xx_init);
 MODULE_AUTHOR("Samuel Thibault");
 MODULE_DESCRIPTION("support of qd65xx vlb ide chipset");
 MODULE_LICENSE("GPL");
+MODULE_VERSION(DRV_VERSION);
Index: b/drivers/ide/legacy/umc8672.c
===================================================================
--- a/drivers/ide/legacy/umc8672.c
+++ b/drivers/ide/legacy/umc8672.c
@@ -1,5 +1,5 @@
 /*
- *  linux/drivers/ide/legacy/umc8672.c		Version 0.05	Jul 31, 1996
+ *  linux/drivers/ide/legacy/umc8672.c
  *
  *  Copyright (C) 1995-1996  Linus Torvalds & author (see below)
  */
@@ -53,6 +53,8 @@
 
 #include <asm/io.h>
 
+#define DRV_VERSION	"0.05"
+
 /*
  * Default speeds.  These can be changed with "auto-tune" and/or hdparm.
  */
@@ -185,3 +187,4 @@ module_init(umc8672_init);
 MODULE_AUTHOR("Wolfram Podien");
 MODULE_DESCRIPTION("Support for UMC 8672 IDE chipset");
 MODULE_LICENSE("GPL");
+MODULE_VERSION(DRV_VERSION);
Index: b/drivers/ide/mips/au1xxx-ide.c
===================================================================
--- a/drivers/ide/mips/au1xxx-ide.c
+++ b/drivers/ide/mips/au1xxx-ide.c
@@ -1,5 +1,5 @@
 /*
- * linux/drivers/ide/mips/au1xxx-ide.c  version 01.30.00        Aug. 02 2005
+ * linux/drivers/ide/mips/au1xxx-ide.c
  *
  * BRIEF MODULE DESCRIPTION
  * AMD Alchemy Au1xxx IDE interface routines over the Static Bus
@@ -50,7 +50,7 @@
 #include <asm/mach-au1x00/au1xxx_ide.h>
 
 #define DRV_NAME	"au1200-ide"
-#define DRV_VERSION	"1.0"
+#define DRV_VERSION	"1.30"
 #define DRV_AUTHOR	"Enrico Walther <enrico.walther@amd.com> / Pete Popov <ppopov@embeddedalley.com>"
 
 /* enable the burstmode in the dbdma */
@@ -720,6 +720,7 @@ static void __exit au_ide_exit(void)
 
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("AU1200 IDE driver");
+MODULE_VERSION(DRV_VERSION);
 
 module_init(au_ide_init);
 module_exit(au_ide_exit);
Index: b/drivers/ide/pci/aec62xx.c
===================================================================
--- a/drivers/ide/pci/aec62xx.c
+++ b/drivers/ide/pci/aec62xx.c
@@ -1,5 +1,5 @@
 /*
- * linux/drivers/ide/pci/aec62xx.c		Version 0.27	Sep 16, 2007
+ * linux/drivers/ide/pci/aec62xx.c
  *
  * Copyright (C) 1999-2002	Andre Hedrick <andre@linux-ide.org>
  * Copyright (C) 2007		MontaVista Software, Inc. <source@mvista.com>
@@ -16,6 +16,8 @@
 
 #include <asm/io.h>
 
+#define DRV_VERSION	"0.27"
+
 struct chipset_bus_clock_list_entry {
 	u8 xfer_speed;
 	u8 chipset_settings;
@@ -318,3 +320,4 @@ module_init(aec62xx_ide_init);
 MODULE_AUTHOR("Andre Hedrick");
 MODULE_DESCRIPTION("PCI driver module for ARTOP AEC62xx IDE");
 MODULE_LICENSE("GPL");
+MODULE_VERSION(DRV_VERSION);
Index: b/drivers/ide/pci/alim15x3.c
===================================================================
--- a/drivers/ide/pci/alim15x3.c
+++ b/drivers/ide/pci/alim15x3.c
@@ -1,5 +1,5 @@
 /*
- * linux/drivers/ide/pci/alim15x3.c		Version 0.29	Sep 16 2007
+ * linux/drivers/ide/pci/alim15x3.c
  *
  *  Copyright (C) 1998-2000 Michel Aubry, Maintainer
  *  Copyright (C) 1998-2000 Andrzej Krzysztofowicz, Maintainer
@@ -41,6 +41,8 @@
 
 #include <asm/io.h>
 
+#define DRV_VERSION	"0.29"
+
 #define DISPLAY_ALI_TIMINGS
 
 /*
@@ -832,3 +834,4 @@ module_init(ali15x3_ide_init);
 MODULE_AUTHOR("Michael Aubry, Andrzej Krzysztofowicz, CJ, Andre Hedrick, Alan Cox");
 MODULE_DESCRIPTION("PCI driver module for ALi 15x3 IDE");
 MODULE_LICENSE("GPL");
+MODULE_VERSION(DRV_VERSION);
Index: b/drivers/ide/pci/amd74xx.c
===================================================================
--- a/drivers/ide/pci/amd74xx.c
+++ b/drivers/ide/pci/amd74xx.c
@@ -1,6 +1,4 @@
 /*
- * Version 2.25
- *
  * AMD 755/756/766/8111 and nVidia nForce/2/2s/3/3s/CK804/MCP04
  * IDE driver for Linux.
  *
@@ -28,6 +26,8 @@
 
 #include "ide-timing.h"
 
+#define DRV_VERSION	"2.25"
+
 enum {
 	AMD_IDE_CONFIG		= 0x41,
 	AMD_CABLE_DETECT	= 0x42,
@@ -360,3 +360,4 @@ module_init(amd74xx_ide_init);
 MODULE_AUTHOR("Vojtech Pavlik");
 MODULE_DESCRIPTION("AMD PCI IDE driver");
 MODULE_LICENSE("GPL");
+MODULE_VERSION(DRV_VERSION);
Index: b/drivers/ide/pci/atiixp.c
===================================================================
--- a/drivers/ide/pci/atiixp.c
+++ b/drivers/ide/pci/atiixp.c
@@ -1,5 +1,5 @@
 /*
- *  linux/drivers/ide/pci/atiixp.c	Version 0.05	Nov 9 2007
+ *  linux/drivers/ide/pci/atiixp.c
  *
  *  Copyright (C) 2003 ATI Inc. <hyu@ati.com>
  *  Copyright (C) 2004,2007 Bartlomiej Zolnierkiewicz
@@ -17,6 +17,8 @@
 
 #include <asm/io.h>
 
+#define DRV_VERSION	"0.05"
+
 #define ATIIXP_IDE_PIO_TIMING		0x40
 #define ATIIXP_IDE_MDMA_TIMING		0x44
 #define ATIIXP_IDE_PIO_CONTROL		0x48
@@ -211,3 +213,4 @@ module_init(atiixp_ide_init);
 MODULE_AUTHOR("HUI YU");
 MODULE_DESCRIPTION("PCI driver module for ATI IXP IDE");
 MODULE_LICENSE("GPL");
+MODULE_VERSION(DRV_VERSION);
Index: b/drivers/ide/pci/cmd640.c
===================================================================
--- a/drivers/ide/pci/cmd640.c
+++ b/drivers/ide/pci/cmd640.c
@@ -1,5 +1,5 @@
 /*
- *  linux/drivers/ide/pci/cmd640.c		Version 1.02  Sep 01, 1996
+ *  linux/drivers/ide/pci/cmd640.c
  *
  *  Copyright (C) 1995-1996  Linus Torvalds & authors (see below)
  */
@@ -115,6 +115,8 @@
 
 #include <asm/io.h>
 
+#define DRV_VERSION	"1.02"
+
 /*
  * This flag is set in ide.c by the parameter:  ide0=cmd640_vlb
  */
@@ -885,5 +887,6 @@ static int __init cmd640x_init(void)
 
 module_param_named(probe_vlb, cmd640_vlb, bool, 0);
 MODULE_PARM_DESC(probe, "probe for VLB version of CMD640 chipset");
+MODULE_VERSION(DRV_VERSION);
 
 module_init(cmd640x_init);
Index: b/drivers/ide/pci/cmd64x.c
===================================================================
--- a/drivers/ide/pci/cmd64x.c
+++ b/drivers/ide/pci/cmd64x.c
@@ -1,5 +1,5 @@
 /*
- * linux/drivers/ide/pci/cmd64x.c		Version 1.53	Dec 24, 2007
+ * linux/drivers/ide/pci/cmd64x.c
  *
  * cmd64x.c: Enable interrupts at initialization time on Ultra/PCI machines.
  *           Due to massive hardware bugs, UltraDMA is only supported
@@ -22,6 +22,8 @@
 
 #include <asm/io.h>
 
+#define DRV_VERSION	"1.53"
+
 #define CMD_DEBUG 0
 
 #if CMD_DEBUG
@@ -522,3 +524,4 @@ module_init(cmd64x_ide_init);
 MODULE_AUTHOR("Eddie Dost, David Miller, Andre Hedrick");
 MODULE_DESCRIPTION("PCI driver module for CMD64x IDE");
 MODULE_LICENSE("GPL");
+MODULE_VERSION(DRV_VERSION);
Index: b/drivers/ide/pci/cs5530.c
===================================================================
--- a/drivers/ide/pci/cs5530.c
+++ b/drivers/ide/pci/cs5530.c
@@ -1,5 +1,5 @@
 /*
- * linux/drivers/ide/pci/cs5530.c		Version 0.77	Sep 24 2007
+ * linux/drivers/ide/pci/cs5530.c
  *
  * Copyright (C) 2000			Andre Hedrick <andre@linux-ide.org>
  * Copyright (C) 2000			Mark Lord <mlord@pobox.com>
@@ -30,6 +30,8 @@
 #include <asm/io.h>
 #include <asm/irq.h>
 
+#define DRV_VERSION	"0.77"
+
 /*
  * Here are the standard PIO mode 0-4 timings for each "format".
  * Format-0 uses fast data reg timings, with slower command reg timings.
@@ -291,3 +293,4 @@ module_init(cs5530_ide_init);
 MODULE_AUTHOR("Mark Lord");
 MODULE_DESCRIPTION("PCI driver module for Cyrix/NS 5530 IDE");
 MODULE_LICENSE("GPL");
+MODULE_VERSION(DRV_VERSION);
Index: b/drivers/ide/pci/cy82c693.c
===================================================================
--- a/drivers/ide/pci/cy82c693.c
+++ b/drivers/ide/pci/cy82c693.c
@@ -1,5 +1,5 @@
 /*
- * linux/drivers/ide/pci/cy82c693.c		Version 0.44	Nov 8, 2007
+ * linux/drivers/ide/pci/cy82c693.c
  *
  *  Copyright (C) 1998-2000 Andreas S. Krebs (akrebs@altavista.net), Maintainer
  *  Copyright (C) 1998-2002 Andre Hedrick <andre@linux-ide.org>, Integrator
@@ -53,6 +53,8 @@
 
 #include <asm/io.h>
 
+#define DRV_VERSION	"0.44"
+
 /* the current version */
 #define CY82_VERSION	"CY82C693U driver v0.34 99-13-12 Andreas S. Krebs (akrebs@altavista.net)"
 
@@ -458,3 +460,4 @@ module_init(cy82c693_ide_init);
 MODULE_AUTHOR("Andreas Krebs, Andre Hedrick");
 MODULE_DESCRIPTION("PCI driver module for the Cypress CY82C693 IDE");
 MODULE_LICENSE("GPL");
+MODULE_VERSION(DRV_VERSION);
Index: b/drivers/ide/pci/generic.c
===================================================================
--- a/drivers/ide/pci/generic.c
+++ b/drivers/ide/pci/generic.c
@@ -1,5 +1,5 @@
 /*
- *  linux/drivers/ide/pci/generic.c	Version 0.11	December 30, 2002
+ *  linux/drivers/ide/pci/generic.c
  *
  *  Copyright (C) 2001-2002	Andre Hedrick <andre@linux-ide.org>
  *  Portions (C) Copyright 2002  Red Hat Inc <alan@redhat.com>
@@ -36,6 +36,8 @@
 
 #include <asm/io.h>
 
+#define DRV_VERSION	"0.11"
+
 static int ide_generic_all;		/* Set to claim all devices */
 
 /*
@@ -210,3 +212,4 @@ module_init(generic_ide_init);
 MODULE_AUTHOR("Andre Hedrick");
 MODULE_DESCRIPTION("PCI driver module for generic PCI IDE");
 MODULE_LICENSE("GPL");
+MODULE_VERSION(DRV_VERSION);
Index: b/drivers/ide/pci/hpt34x.c
===================================================================
--- a/drivers/ide/pci/hpt34x.c
+++ b/drivers/ide/pci/hpt34x.c
@@ -1,5 +1,5 @@
 /*
- * linux/drivers/ide/pci/hpt34x.c		Version 0.40	Sept 10, 2002
+ * linux/drivers/ide/pci/hpt34x.c
  *
  * Copyright (C) 1998-2000	Andre Hedrick <andre@linux-ide.org>
  * May be copied or modified under the terms of the GNU General Public License
@@ -41,6 +41,8 @@
 #include <asm/io.h>
 #include <asm/irq.h>
 
+#define DRV_VERSION	"0.40"
+
 #define HPT343_DEBUG_DRIVE_INFO		0
 
 static void hpt34x_set_mode(ide_drive_t *drive, const u8 speed)
@@ -193,3 +195,4 @@ module_init(hpt34x_ide_init);
 MODULE_AUTHOR("Andre Hedrick");
 MODULE_DESCRIPTION("PCI driver module for Highpoint 34x IDE");
 MODULE_LICENSE("GPL");
+MODULE_VERSION(DRV_VERSION);
Index: b/drivers/ide/pci/hpt366.c
===================================================================
--- a/drivers/ide/pci/hpt366.c
+++ b/drivers/ide/pci/hpt366.c
@@ -1,5 +1,5 @@
 /*
- * linux/drivers/ide/pci/hpt366.c		Version 1.30	Dec 12, 2007
+ * linux/drivers/ide/pci/hpt366.c
  *
  * Copyright (C) 1999-2003		Andre Hedrick <andre@linux-ide.org>
  * Portions Copyright (C) 2001	        Sun Microsystems, Inc.
@@ -138,6 +138,8 @@
 #include <asm/io.h>
 #include <asm/irq.h>
 
+#define DRV_VERSION	"1.30"
+
 /* various tuning parameters */
 #define HPT_RESET_STATE_ENGINE
 #undef	HPT_DELAY_INTERRUPT
@@ -1652,3 +1654,4 @@ module_init(hpt366_ide_init);
 MODULE_AUTHOR("Andre Hedrick");
 MODULE_DESCRIPTION("PCI driver module for Highpoint HPT366 IDE");
 MODULE_LICENSE("GPL");
+MODULE_VERSION(DRV_VERSION);
Index: b/drivers/ide/pci/it821x.c
===================================================================
--- a/drivers/ide/pci/it821x.c
+++ b/drivers/ide/pci/it821x.c
@@ -1,6 +1,6 @@
 
 /*
- * linux/drivers/ide/pci/it821x.c		Version 0.16	Jul 3 2007
+ * linux/drivers/ide/pci/it821x.c
  *
  * Copyright (C) 2004		Red Hat <alan@redhat.com>
  * Copyright (C) 2007		Bartlomiej Zolnierkiewicz
@@ -73,6 +73,8 @@
 
 #include <asm/io.h>
 
+#define DRV_VERSION	"0.16"
+
 struct it821x_dev
 {
 	unsigned int smart:1,		/* Are we in smart raid mode */
@@ -679,3 +681,4 @@ MODULE_PARM_DESC(it8212_noraid, "Force c
 MODULE_AUTHOR("Alan Cox");
 MODULE_DESCRIPTION("PCI driver module for the ITE 821x");
 MODULE_LICENSE("GPL");
+MODULE_VERSION(DRV_VERSION);
Index: b/drivers/ide/pci/ns87415.c
===================================================================
--- a/drivers/ide/pci/ns87415.c
+++ b/drivers/ide/pci/ns87415.c
@@ -1,5 +1,5 @@
 /*
- * linux/drivers/ide/pci/ns87415.c		Version 2.00  Sep. 10, 2002
+ * linux/drivers/ide/pci/ns87415.c
  *
  * Copyright (C) 1997-1998	Mark Lord <mlord@pobox.com>
  * Copyright (C) 1998		Eddie C. Dost <ecd@skynet.be>
@@ -25,6 +25,8 @@
 
 #include <asm/io.h>
 
+#define DRV_VERSION	"2.00"
+
 #ifdef CONFIG_SUPERIO
 /* SUPERIO 87560 is a PoS chip that NatSem denies exists.
  * Unfortunately, it's built-in on all Astro-based PA-RISC workstations
@@ -298,3 +300,4 @@ module_init(ns87415_ide_init);
 MODULE_AUTHOR("Mark Lord, Eddie Dost, Andre Hedrick");
 MODULE_DESCRIPTION("PCI driver module for NS87415 IDE");
 MODULE_LICENSE("GPL");
+MODULE_VERSION(DRV_VERSION);
Index: b/drivers/ide/pci/opti621.c
===================================================================
--- a/drivers/ide/pci/opti621.c
+++ b/drivers/ide/pci/opti621.c
@@ -1,5 +1,5 @@
 /*
- *  linux/drivers/ide/pci/opti621.c		Version 0.9	Sep 24, 2007
+ *  linux/drivers/ide/pci/opti621.c
  *
  *  Copyright (C) 1996-1998  Linus Torvalds & authors (see below)
  */
@@ -100,6 +100,8 @@
 
 #include <asm/io.h>
 
+#define DRV_VERSION	"0.9"
+
 //#define OPTI621_MAX_PIO 3
 /* In fact, I do not have any PIO 4 drive
  * (address: 25 ns, data: 70 ns, recovery: 35 ns),
@@ -383,3 +385,4 @@ module_init(opti621_ide_init);
 MODULE_AUTHOR("Jaromir Koutek, Jan Harkes, Mark Lord");
 MODULE_DESCRIPTION("PCI driver module for Opti621 IDE");
 MODULE_LICENSE("GPL");
+MODULE_VERSION(DRV_VERSION);
Index: b/drivers/ide/pci/pdc202xx_old.c
===================================================================
--- a/drivers/ide/pci/pdc202xx_old.c
+++ b/drivers/ide/pci/pdc202xx_old.c
@@ -1,5 +1,5 @@
 /*
- *  linux/drivers/ide/pci/pdc202xx_old.c	Version 0.52	Aug 27, 2007
+ *  linux/drivers/ide/pci/pdc202xx_old.c
  *
  *  Copyright (C) 1998-2002		Andre Hedrick <andre@linux-ide.org>
  *  Copyright (C) 2006-2007		MontaVista Software, Inc.
@@ -47,6 +47,8 @@
 #include <asm/io.h>
 #include <asm/irq.h>
 
+#define DRV_VERSION	"0.52"
+
 #define PDC202XX_DEBUG_DRIVE_INFO	0
 
 static const char *pdc_quirk_drives[] = {
@@ -479,3 +481,4 @@ module_init(pdc202xx_ide_init);
 MODULE_AUTHOR("Andre Hedrick, Frank Tiernan");
 MODULE_DESCRIPTION("PCI driver module for older Promise IDE");
 MODULE_LICENSE("GPL");
+MODULE_VERSION(DRV_VERSION);
Index: b/drivers/ide/pci/piix.c
===================================================================
--- a/drivers/ide/pci/piix.c
+++ b/drivers/ide/pci/piix.c
@@ -1,5 +1,5 @@
 /*
- *  linux/drivers/ide/pci/piix.c	Version 0.54	Sep 5, 2007
+ *  linux/drivers/ide/pci/piix.c
  *
  *  Copyright (C) 1998-1999 Andrzej Krzysztofowicz, Author and Maintainer
  *  Copyright (C) 1998-2000 Andre Hedrick <andre@linux-ide.org>
@@ -58,6 +58,8 @@
 
 #include <asm/io.h>
 
+#define DRV_VERSION	"0.54"
+
 static int no_piix_dma;
 
 /**
@@ -478,3 +480,4 @@ module_init(piix_ide_init);
 MODULE_AUTHOR("Andre Hedrick, Andrzej Krzysztofowicz");
 MODULE_DESCRIPTION("PCI driver module for Intel PIIX IDE");
 MODULE_LICENSE("GPL");
+MODULE_VERSION(DRV_VERSION);
Index: b/drivers/ide/pci/rz1000.c
===================================================================
--- a/drivers/ide/pci/rz1000.c
+++ b/drivers/ide/pci/rz1000.c
@@ -1,5 +1,5 @@
 /*
- *  linux/drivers/ide/pci/rz1000.c	Version 0.06	January 12, 2003
+ *  linux/drivers/ide/pci/rz1000.c
  *
  *  Copyright (C) 1995-1998  Linus Torvalds & author (see below)
  */
@@ -30,6 +30,8 @@
 
 #include <asm/io.h>
 
+#define DRV_VERSION	"0.06"
+
 static void __devinit init_hwif_rz1000 (ide_hwif_t *hwif)
 {
 	struct pci_dev *dev = to_pci_dev(hwif->dev);
@@ -84,4 +86,4 @@ module_init(rz1000_ide_init);
 MODULE_AUTHOR("Andre Hedrick");
 MODULE_DESCRIPTION("PCI driver module for RZ1000 IDE");
 MODULE_LICENSE("GPL");
-
+MODULE_VERSION(DRV_VERSION);
Index: b/drivers/ide/pci/sc1200.c
===================================================================
--- a/drivers/ide/pci/sc1200.c
+++ b/drivers/ide/pci/sc1200.c
@@ -1,5 +1,5 @@
 /*
- * linux/drivers/ide/pci/sc1200.c		Version 0.97	Aug 3 2007
+ * linux/drivers/ide/pci/sc1200.c
  *
  * Copyright (C) 2000-2002		Mark Lord <mlord@pobox.com>
  * Copyright (C)      2007		Bartlomiej Zolnierkiewicz
@@ -30,6 +30,8 @@
 #include <asm/io.h>
 #include <asm/irq.h>
 
+#define DRV_VERSION	"0.97"
+
 #define SC1200_REV_A	0x00
 #define SC1200_REV_B1	0x01
 #define SC1200_REV_B3	0x02
@@ -353,3 +355,4 @@ module_init(sc1200_ide_init);
 MODULE_AUTHOR("Mark Lord");
 MODULE_DESCRIPTION("PCI driver module for NS SC1200 IDE");
 MODULE_LICENSE("GPL");
+MODULE_VERSION(DRV_VERSION);
Index: b/drivers/ide/pci/serverworks.c
===================================================================
--- a/drivers/ide/pci/serverworks.c
+++ b/drivers/ide/pci/serverworks.c
@@ -1,5 +1,5 @@
 /*
- * linux/drivers/ide/pci/serverworks.c		Version 0.22	Jun 27 2007
+ * linux/drivers/ide/pci/serverworks.c
  *
  * Copyright (C) 1998-2000 Michel Aubry
  * Copyright (C) 1998-2000 Andrzej Krzysztofowicz
@@ -42,6 +42,8 @@
 
 #include <asm/io.h>
 
+#define DRV_VERSION	"0.22"
+
 #define SVWKS_CSB5_REVISION_NEW	0x92 /* min PCI_REVISION_ID for UDMA5 (A2.0) */
 #define SVWKS_CSB6_REVISION	0xa0 /* min PCI_REVISION_ID for UDMA4 (A1.0) */
 
@@ -462,3 +464,4 @@ module_init(svwks_ide_init);
 MODULE_AUTHOR("Michael Aubry. Andrzej Krzysztofowicz, Andre Hedrick");
 MODULE_DESCRIPTION("PCI driver module for Serverworks OSB4/CSB5/CSB6 IDE");
 MODULE_LICENSE("GPL");
+MODULE_VERSION(DRV_VERSION);
Index: b/drivers/ide/pci/siimage.c
===================================================================
--- a/drivers/ide/pci/siimage.c
+++ b/drivers/ide/pci/siimage.c
@@ -1,5 +1,5 @@
 /*
- * linux/drivers/ide/pci/siimage.c		Version 1.19	Nov 16 2007
+ * linux/drivers/ide/pci/siimage.c
  *
  * Copyright (C) 2001-2002	Andre Hedrick <andre@linux-ide.org>
  * Copyright (C) 2003		Red Hat <alan@redhat.com>
@@ -48,6 +48,8 @@
 
 #include <asm/io.h>
 
+#define DRV_VERSION	"1.19"
+
 /**
  *	pdev_is_sata		-	check if device is SATA
  *	@pdev:	PCI device to check
@@ -903,3 +905,4 @@ module_init(siimage_ide_init);
 MODULE_AUTHOR("Andre Hedrick, Alan Cox");
 MODULE_DESCRIPTION("PCI driver module for SiI IDE");
 MODULE_LICENSE("GPL");
+MODULE_VERSION(DRV_VERSION);
Index: b/drivers/ide/pci/sis5513.c
===================================================================
--- a/drivers/ide/pci/sis5513.c
+++ b/drivers/ide/pci/sis5513.c
@@ -1,5 +1,5 @@
 /*
- * linux/drivers/ide/pci/sis5513.c	Version 0.31	Aug 9, 2007
+ * linux/drivers/ide/pci/sis5513.c
  *
  * Copyright (C) 1999-2000	Andre Hedrick <andre@linux-ide.org>
  * Copyright (C) 2002		Lionel Bouton <Lionel.Bouton@inet6.fr>, Maintainer
@@ -65,6 +65,8 @@
 
 #include "ide-timing.h"
 
+#define DRV_VERSION	"0.31"
+
 /* registers layout and init values are chipset family dependant */
 
 #define ATA_16		0x01
@@ -616,6 +618,7 @@ module_init(sis5513_ide_init);
 MODULE_AUTHOR("Lionel Bouton, L C Chang, Andre Hedrick, Vojtech Pavlik");
 MODULE_DESCRIPTION("PCI driver module for SIS IDE");
 MODULE_LICENSE("GPL");
+MODULE_VERSION(DRV_VERSION);
 
 /*
  * TODO:
Index: b/drivers/ide/pci/slc90e66.c
===================================================================
--- a/drivers/ide/pci/slc90e66.c
+++ b/drivers/ide/pci/slc90e66.c
@@ -1,5 +1,5 @@
 /*
- *  linux/drivers/ide/pci/slc90e66.c	Version 0.19	Sep 24, 2007
+ *  linux/drivers/ide/pci/slc90e66.c
  *
  *  Copyright (C) 2000-2002 Andre Hedrick <andre@linux-ide.org>
  *  Copyright (C) 2006-2007 MontaVista Software, Inc. <source@mvista.com>
@@ -21,6 +21,8 @@
 
 #include <asm/io.h>
 
+#define DRV_VERSION	"0.19"
+
 static DEFINE_SPINLOCK(slc90e66_lock);
 
 static void slc90e66_set_pio_mode(ide_drive_t *drive, const u8 pio)
@@ -177,3 +179,4 @@ module_init(slc90e66_ide_init);
 MODULE_AUTHOR("Andre Hedrick");
 MODULE_DESCRIPTION("PCI driver module for SLC90E66 IDE");
 MODULE_LICENSE("GPL");
+MODULE_VERSION(DRV_VERSION);
Index: b/drivers/ide/pci/tc86c001.c
===================================================================
--- a/drivers/ide/pci/tc86c001.c
+++ b/drivers/ide/pci/tc86c001.c
@@ -1,5 +1,5 @@
 /*
- * drivers/ide/pci/tc86c001.c	Version 1.01	Sep 5, 2007
+ * drivers/ide/pci/tc86c001.c
  *
  * Copyright (C) 2002 Toshiba Corporation
  * Copyright (C) 2005-2006 MontaVista Software, Inc. <source@mvista.com>
@@ -13,6 +13,8 @@
 #include <linux/pci.h>
 #include <linux/ide.h>
 
+#define DRV_VERSION	"1.01"
+
 static void tc86c001_set_mode(ide_drive_t *drive, const u8 speed)
 {
 	ide_hwif_t *hwif	= HWIF(drive);
@@ -257,3 +259,4 @@ module_init(tc86c001_ide_init);
 MODULE_AUTHOR("MontaVista Software, Inc. <source@mvista.com>");
 MODULE_DESCRIPTION("PCI driver module for TC86C001 IDE");
 MODULE_LICENSE("GPL");
+MODULE_VERSION(DRV_VERSION);
Index: b/drivers/ide/pci/trm290.c
===================================================================
--- a/drivers/ide/pci/trm290.c
+++ b/drivers/ide/pci/trm290.c
@@ -1,5 +1,5 @@
 /*
- *  linux/drivers/ide/pci/trm290.c		Version 1.05	Dec. 30, 2007
+ *  linux/drivers/ide/pci/trm290.c
  *
  *  Copyright (c) 1997-1998  Mark Lord
  *  Copyright (c) 2007       MontaVista Software, Inc. <source@mvista.com>
@@ -144,6 +144,8 @@
 
 #include <asm/io.h>
 
+#define DRV_VERSION	"1.05"
+
 static void trm290_prepare_drive (ide_drive_t *drive, unsigned int use_dma)
 {
 	ide_hwif_t *hwif = HWIF(drive);
@@ -374,3 +376,4 @@ module_init(trm290_ide_init);
 MODULE_AUTHOR("Mark Lord");
 MODULE_DESCRIPTION("PCI driver module for Tekram TRM290 IDE");
 MODULE_LICENSE("GPL");
+MODULE_VERSION(DRV_VERSION);
Index: b/drivers/ide/pci/via82cxxx.c
===================================================================
--- a/drivers/ide/pci/via82cxxx.c
+++ b/drivers/ide/pci/via82cxxx.c
@@ -1,7 +1,4 @@
 /*
- *
- * Version 3.50
- *
  * VIA IDE driver for Linux. Supported southbridges:
  *
  *   vt82c576, vt82c586, vt82c586a, vt82c586b, vt82c596a, vt82c596b,
@@ -44,6 +41,8 @@
 
 #include "ide-timing.h"
 
+#define DRV_VERSION	"3.50"
+
 #define VIA_IDE_ENABLE		0x40
 #define VIA_IDE_CONFIG		0x41
 #define VIA_FIFO_CONFIG		0x43
@@ -512,3 +511,4 @@ module_init(via_ide_init);
 MODULE_AUTHOR("Vojtech Pavlik, Michel Aubry, Jeff Garzik, Andre Hedrick");
 MODULE_DESCRIPTION("PCI driver module for VIA IDE");
 MODULE_LICENSE("GPL");
+MODULE_VERSION(DRV_VERSION);
Index: b/drivers/scsi/ide-scsi.c
===================================================================
--- a/drivers/scsi/ide-scsi.c
+++ b/drivers/scsi/ide-scsi.c
@@ -1,5 +1,5 @@
 /*
- * linux/drivers/scsi/ide-scsi.c	Version 0.9		Jul   4, 1999
+ * linux/drivers/scsi/ide-scsi.c
  *
  * Copyright (C) 1996 - 1999 Gadi Oxman <gadio@netvision.net.il>
  */
@@ -31,8 +31,6 @@
  * Ver 0.92  Dec 31 02   Implement new SCSI mid level API
  */
 
-#define IDESCSI_VERSION "0.92"
-
 #include <linux/module.h>
 #include <linux/types.h>
 #include <linux/string.h>
@@ -59,6 +57,8 @@
 #include <scsi/scsi_tcq.h>
 #include <scsi/sg.h>
 
+#define DRV_VERSION	"0.92"
+
 #define IDESCSI_DEBUG_LOG		0
 
 typedef struct idescsi_pc_s {
@@ -695,7 +695,7 @@ static ide_driver_t idescsi_driver = {
 	},
 	.probe			= ide_scsi_probe,
 	.remove			= ide_scsi_remove,
-	.version		= IDESCSI_VERSION,
+	.version		= DRV_VERSION,
 	.media			= ide_scsi,
 	.supports_dsc_overlap	= 0,
 	.do_request		= idescsi_do_request,
@@ -1074,3 +1074,4 @@ MODULE_PARM_DESC(idescsi_nocd, "Disable 
 module_init(init_idescsi_module);
 module_exit(exit_idescsi_module);
 MODULE_LICENSE("GPL");
+MODULE_VERSION(DRV_VERSION);
