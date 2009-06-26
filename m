Return-Path: <linux-kernel-owner+w=401wt.eu-S1760550AbZFZOZa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760550AbZFZOZa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jun 2009 10:25:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751479AbZFZOZU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jun 2009 10:25:20 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:34953 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751308AbZFZOZS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jun 2009 10:25:18 -0400
From: Subrata Modak <subrata@linux.vnet.ibm.com>
To: Scott Wood <scottwood@freescale.com>,
       David Woodhouse <dwmw2@infradead.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Alexander Beregalov <a.beregalov@gmail.com>,
       linux-next <linux-next@vger.kernel.org>,
       Jim Cromie <jim.cromie@gmail.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       Linuxppc-dev <Linuxppc-dev@ozlabs.org>, carolyn.j.smith@exgate.tek.com,
       Sachin P Sant <sachinp@linux.vnet.ibm.com>,
       Subrata Modak <subrata@linux.vnet.ibm.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>, Adrian Bunk <bunk@kernel.org>
Date: Fri, 26 Jun 2009 09:25:13 -0500
Message-Id: <20090626142513.10380.20811.sendpatchset@gekko-lp3.ltc.austin.ibm.com>
Subject: [PATCH] Remove 'SBC8240 Wind River' Device Driver Code
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David/Scott,

Today's next tree(20090626) produced the following build error:

CC [M]  drivers/mtd/maps/sbc8240.o
drivers/mtd/maps/sbc8240.c:31:1: warning: "DEBUG" redefined
In file included from drivers/mtd/maps/sbc8240.c:23:
include/linux/mtd/mtd.h:333:1: warning: this is the location of the previous definition
drivers/mtd/maps/sbc8240.c: In function 'init_sbc8240_mtd':
drivers/mtd/maps/sbc8240.c:172: warning: passing argument 1 of 'simple_map_init' from incompatible pointer type
drivers/mtd/maps/sbc8240.c:177: error: 'struct mtd_info' has no member named 'module'
make[3]: *** [drivers/mtd/maps/sbc8240.o] Error 1
make[2]: *** [drivers/mtd/maps] Error 2
make[1]: *** [drivers/mtd] Error 2
make: *** [drivers] Error 2

I remember reporting this log back in April, when you suggested in removing it:
http://lkml.org/lkml/2009/4/21/476,

>On Tue, 2009-04-21 at 15:00 -0500, Scott Wood wrote:
>Subrata Modak wrote:
> > This is a very old one. Doesn´t seem to go away. Reported this earlier
> > on 14th April:
> > http://lkml.org/lkml/2009/4/14/483,
> > 
> > CC [M]  drivers/mtd/maps/sbc8240.o
> > drivers/mtd/maps/sbc8240.c:31:1: warning: "DEBUG" redefined
> > In file included from drivers/mtd/maps/sbc8240.c:23:
> > include/linux/mtd/mtd.h:339:1: warning: this is the location of the
> > previous definition
> > drivers/mtd/maps/sbc8240.c: In function ‘init_sbc8240_mtd’:
> > drivers/mtd/maps/sbc8240.c:172: error: ‘sbc8240_mtd’ undeclared (first
> > use in this function)
> > drivers/mtd/maps/sbc8240.c:172: error: (Each undeclared identifier is
> > reported only once
> > drivers/mtd/maps/sbc8240.c:172: error: for each function it appears in.)
> > drivers/mtd/maps/sbc8240.c: In function ‘cleanup_sbc8240_mtd’:
> > drivers/mtd/maps/sbc8240.c:233: error: ‘sbc8240_mtd’ undeclared (first
> > use in this function)
> 
> This looks like an arch/ppc orphan.  It's not enabled by any defconfig, 
> and it doesn't look like it does anything that physmap_of can't do.
> 
> I'd just remove it.
> 
> -Scott

I tried to gather some more info about this driver from the link
mentioned in Kconfig:
http://www.windriver.com/products/sbc8240/,
without much success.

If there are no issues, can you please apply this patch to remove it ?

To: David Woodhouse <dwmw2@infradead.org>,
To: Scott Wood <scottwood@freescale.com>,
Cc: Jim Cromie <jim.cromie@gmail.com>,
Cc: carolyn.j.smith@exgate.tek.com,
Cc: Adrian Bunk <bunk@kernel.org>,
Cc: Sachin P Sant <sachinp@linux.vnet.ibm.com>,
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>,
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
Cc: Linuxppc-dev <Linuxppc-dev@ozlabs.org>,
Cc: linux-next <linux-next@vger.kernel.org>,
Cc: Alexander Beregalov <a.beregalov@gmail.com>


Signed-off-by: Subrata Modak <subrata@linux.vnet.ibm.com>
Tested-on-PPC64-by: Subrata Modak <subrata@linux.vnet.ibm.com>
---

diff -uprN a/drivers/mtd/maps/Kconfig b/drivers/mtd/maps/Kconfig
--- a/drivers/mtd/maps/Kconfig	2009-06-26 07:36:23.000000000 -0500
+++ b/drivers/mtd/maps/Kconfig	2009-06-26 07:39:34.000000000 -0500
@@ -284,13 +284,6 @@ config MTD_L440GX
 
 	  BE VERY CAREFUL.
 
-config MTD_SBC8240
-	tristate "Flash device on SBC8240"
-	depends on MTD_JEDECPROBE && 8260
-	help
-          Flash access on the SBC8240 board from Wind River.  See
-          <http://www.windriver.com/products/sbc8240/>
-
 config MTD_TQM8XXL
 	tristate "CFI Flash device mapped on TQM8XXL"
 	depends on MTD_CFI && TQM8xxL
diff -uprN a/drivers/mtd/maps/Makefile b/drivers/mtd/maps/Makefile
--- a/drivers/mtd/maps/Makefile	2009-06-26 07:36:23.000000000 -0500
+++ b/drivers/mtd/maps/Makefile	2009-06-26 07:40:03.000000000 -0500
@@ -50,7 +50,6 @@ obj-$(CONFIG_MTD_UCLINUX)	+= uclinux.o
 obj-$(CONFIG_MTD_NETtel)	+= nettel.o
 obj-$(CONFIG_MTD_SCB2_FLASH)	+= scb2_flash.o
 obj-$(CONFIG_MTD_H720X)		+= h720x-flash.o
-obj-$(CONFIG_MTD_SBC8240)	+= sbc8240.o
 obj-$(CONFIG_MTD_IXP4XX)	+= ixp4xx.o
 obj-$(CONFIG_MTD_IXP2000)	+= ixp2000.o
 obj-$(CONFIG_MTD_WRSBC8260)	+= wr_sbc82xx_flash.o
diff -uprN a/drivers/mtd/maps/sbc8240.c b/drivers/mtd/maps/sbc8240.c
--- a/drivers/mtd/maps/sbc8240.c	2009-06-26 07:36:23.000000000 -0500
+++ b/drivers/mtd/maps/sbc8240.c	1969-12-31 18:00:00.000000000 -0600
@@ -1,250 +0,0 @@
-/*
- * Handle mapping of the flash memory access routines on the SBC8240 board.
- *
- * Carolyn Smith, Tektronix, Inc.
- *
- * This code is GPLed
- */
-
-/*
- * The SBC8240 has 2 flash banks.
- * Bank 0 is a 512 KiB AMD AM29F040B; 8 x 64 KiB sectors.
- * It contains the U-Boot code (7 sectors) and the environment (1 sector).
- * Bank 1 is 4 x 1 MiB AMD AM29LV800BT; 15 x 64 KiB sectors, 1 x 32 KiB sector,
- * 2 x 8 KiB sectors, 1 x 16 KiB sectors.
- * Both parts are JEDEC compatible.
- */
-
-#include <linux/module.h>
-#include <linux/types.h>
-#include <linux/kernel.h>
-#include <asm/io.h>
-
-#include <linux/mtd/mtd.h>
-#include <linux/mtd/map.h>
-#include <linux/mtd/cfi.h>
-
-#ifdef CONFIG_MTD_PARTITIONS
-#include <linux/mtd/partitions.h>
-#endif
-
-#define	DEBUG
-
-#ifdef	DEBUG
-# define debugk(fmt,args...)	printk(fmt ,##args)
-#else
-# define debugk(fmt,args...)
-#endif
-
-
-#define WINDOW_ADDR0	0xFFF00000		/* 512 KiB */
-#define WINDOW_SIZE0	0x00080000
-#define BUSWIDTH0	1
-
-#define WINDOW_ADDR1	0xFF000000		/* 4 MiB */
-#define WINDOW_SIZE1	0x00400000
-#define BUSWIDTH1	8
-
-#define MSG_PREFIX "sbc8240:"	/* prefix for our printk()'s */
-#define MTDID	   "sbc8240-%d"	/* for mtdparts= partitioning */
-
-
-static struct map_info sbc8240_map[2] = {
-	{
-		.name           = "sbc8240 Flash Bank #0",
-		.size           = WINDOW_SIZE0,
-		.bankwidth       = BUSWIDTH0,
-	},
-	{
-		.name           = "sbc8240 Flash Bank #1",
-		.size           = WINDOW_SIZE1,
-		.bankwidth       = BUSWIDTH1,
-	}
-};
-
-#define NUM_FLASH_BANKS	ARRAY_SIZE(sbc8240_map)
-
-/*
- * The following defines the partition layout of SBC8240 boards.
- *
- * See include/linux/mtd/partitions.h for definition of the
- * mtd_partition structure.
- *
- * The *_max_flash_size is the maximum possible mapped flash size
- * which is not necessarily the actual flash size. It must correspond
- * to the value specified in the mapping definition defined by the
- * "struct map_desc *_io_desc" for the corresponding machine.
- */
-
-#ifdef CONFIG_MTD_PARTITIONS
-
-static struct mtd_partition sbc8240_uboot_partitions [] = {
-	/* Bank 0 */
-	{
-		.name =	"U-boot",			/* U-Boot Firmware	*/
-		.offset =	0,
-		.size =	0x00070000,			/*  7 x 64 KiB sectors 	*/
-		.mask_flags = MTD_WRITEABLE,		/*  force read-only	*/
-	},
-	{
-		.name =	"environment",			/* U-Boot environment	*/
-		.offset =	0x00070000,
-		.size =	0x00010000,			/*  1 x 64 KiB sector	*/
-	},
-};
-
-static struct mtd_partition sbc8240_fs_partitions [] = {
-	{
-		.name =	"jffs",				/* JFFS  filesystem	*/
-		.offset =	0,
-		.size =	0x003C0000,			/*  4 * 15 * 64KiB	*/
-	},
-	{
-		.name =	"tmp32",
-		.offset =	0x003C0000,
-		.size =	0x00020000,			/*  4 * 32KiB		*/
-	},
-	{
-		.name =	"tmp8a",
-		.offset =	0x003E0000,
-		.size =	0x00008000,			/*  4 * 8KiB		*/
-	},
-	{
-		.name =	"tmp8b",
-		.offset =	0x003E8000,
-		.size =	0x00008000,			/*  4 * 8KiB		*/
-	},
-	{
-		.name =	"tmp16",
-		.offset =	0x003F0000,
-		.size =	0x00010000,			/*  4 * 16KiB		*/
-	}
-};
-
-/* trivial struct to describe partition information */
-struct mtd_part_def
-{
-	int nums;
-	unsigned char *type;
-	struct mtd_partition* mtd_part;
-};
-
-static struct mtd_info *sbc8240_mtd[NUM_FLASH_BANKS];
-static struct mtd_part_def sbc8240_part_banks[NUM_FLASH_BANKS];
-
-
-#endif	/* CONFIG_MTD_PARTITIONS */
-
-
-static int __init init_sbc8240_mtd (void)
-{
-	static struct _cjs {
-		u_long addr;
-		u_long size;
-	} pt[NUM_FLASH_BANKS] = {
-		{
-			.addr = WINDOW_ADDR0,
-			.size = WINDOW_SIZE0
-		},
-		{
-			.addr = WINDOW_ADDR1,
-			.size = WINDOW_SIZE1
-		},
-	};
-
-	int devicesfound = 0;
-	int i,j;
-
-	for (i = 0; i < NUM_FLASH_BANKS; i++) {
-		printk (KERN_NOTICE MSG_PREFIX
-			"Probing 0x%08lx at 0x%08lx\n", pt[i].size, pt[i].addr);
-
-		sbc8240_map[i].map_priv_1 =
-			(unsigned long) ioremap (pt[i].addr, pt[i].size);
-		if (!sbc8240_map[i].map_priv_1) {
-			printk (MSG_PREFIX "failed to ioremap\n");
-			for (j = 0; j < i; j++) {
-				iounmap((void *) sbc8240_map[j].map_priv_1);
-				sbc8240_map[j].map_priv_1 = 0;
-			}
-			return -EIO;
-		}
-		simple_map_init(&sbc8240_mtd[i]);
-
-		sbc8240_mtd[i] = do_map_probe("jedec_probe", &sbc8240_map[i]);
-
-		if (sbc8240_mtd[i]) {
-			sbc8240_mtd[i]->module = THIS_MODULE;
-			devicesfound++;
-		} else {
-			if (sbc8240_map[i].map_priv_1) {
-				iounmap((void *) sbc8240_map[i].map_priv_1);
-				sbc8240_map[i].map_priv_1 = 0;
-			}
-		}
-	}
-
-	if (!devicesfound) {
-		printk(KERN_NOTICE MSG_PREFIX
-		       "No suppported flash chips found!\n");
-		return -ENXIO;
-	}
-
-#ifdef CONFIG_MTD_PARTITIONS
-	sbc8240_part_banks[0].mtd_part   = sbc8240_uboot_partitions;
-	sbc8240_part_banks[0].type       = "static image";
-	sbc8240_part_banks[0].nums       = ARRAY_SIZE(sbc8240_uboot_partitions);
-	sbc8240_part_banks[1].mtd_part   = sbc8240_fs_partitions;
-	sbc8240_part_banks[1].type       = "static file system";
-	sbc8240_part_banks[1].nums       = ARRAY_SIZE(sbc8240_fs_partitions);
-
-	for (i = 0; i < NUM_FLASH_BANKS; i++) {
-
-		if (!sbc8240_mtd[i]) continue;
-		if (sbc8240_part_banks[i].nums == 0) {
-			printk (KERN_NOTICE MSG_PREFIX
-				"No partition info available, registering whole device\n");
-			add_mtd_device(sbc8240_mtd[i]);
-		} else {
-			printk (KERN_NOTICE MSG_PREFIX
-				"Using %s partition definition\n", sbc8240_part_banks[i].mtd_part->name);
-			add_mtd_partitions (sbc8240_mtd[i],
-					    sbc8240_part_banks[i].mtd_part,
-					    sbc8240_part_banks[i].nums);
-		}
-	}
-#else
-	printk(KERN_NOTICE MSG_PREFIX
-	       "Registering %d flash banks at once\n", devicesfound);
-
-	for (i = 0; i < devicesfound; i++) {
-		add_mtd_device(sbc8240_mtd[i]);
-	}
-#endif	/* CONFIG_MTD_PARTITIONS */
-
-	return devicesfound == 0 ? -ENXIO : 0;
-}
-
-static void __exit cleanup_sbc8240_mtd (void)
-{
-	int i;
-
-	for (i = 0; i < NUM_FLASH_BANKS; i++) {
-		if (sbc8240_mtd[i]) {
-			del_mtd_device (sbc8240_mtd[i]);
-			map_destroy (sbc8240_mtd[i]);
-		}
-		if (sbc8240_map[i].map_priv_1) {
-			iounmap ((void *) sbc8240_map[i].map_priv_1);
-			sbc8240_map[i].map_priv_1 = 0;
-		}
-	}
-}
-
-module_init (init_sbc8240_mtd);
-module_exit (cleanup_sbc8240_mtd);
-
-MODULE_LICENSE ("GPL");
-MODULE_AUTHOR ("Carolyn Smith <carolyn.smith@tektronix.com>");
-MODULE_DESCRIPTION ("MTD map driver for SBC8240 boards");
-

---
Regards--
Subrata

