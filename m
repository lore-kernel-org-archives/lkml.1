Return-Path: <linux-kernel-owner+w=401wt.eu-S1753783AbXLFMvA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753783AbXLFMvA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2007 07:51:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754840AbXLFMnq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Dec 2007 07:43:46 -0500
Received: from miranda.se.axis.com ([193.13.178.8]:53752 "EHLO
	miranda.se.axis.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754824AbXLFMnp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2007 07:43:45 -0500
From: Jesper Nilsson <jesper.nilsson@axis.com>
Message-Id: <1706d1abad9d44334f933a7959add1fcceb5b4fc.1196848533.git.jesper.nilsson@axis.com>
In-Reply-To: <ca13018bb45763422de40e6109171637091a312e.1196848533.git.jesper.nilsson@axis.com>
References: <ca13018bb45763422de40e6109171637091a312e.1196848533.git.jesper.nilsson@axis.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       Mikael Starvik <mikael.starvik@axis.com>,
       Jesper Nilsson <jesper.nilsson@axis.com>, linux-kernel@vger.kernel.org
Date: Fri, 30 Nov 2007 16:17:21 +0100
Subject: [PATCH 28/47] Update and improve CRISv10 axisflashmap.c
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

- Add config to use mtd0 as whole flash device.
- Fix whitespace errors.
- Remove braces around single statement ifs.
- Break long lines.
- Remove unnecessary CVS log.

Signed-off-by: Jesper Nilsson <jesper.nilsson@axis.com>
---
 arch/cris/arch-v10/drivers/axisflashmap.c |  181 ++++++-----------------------
 1 files changed, 37 insertions(+), 144 deletions(-)

diff --git a/arch/cris/arch-v10/drivers/axisflashmap.c b/arch/cris/arch-v10/drivers/axisflashmap.c
index ea3cf2e..b3bdda9 100644
--- a/arch/cris/arch-v10/drivers/axisflashmap.c
+++ b/arch/cris/arch-v10/drivers/axisflashmap.c
@@ -10,129 +10,6 @@
  * tells us what other partitions to define. If there isn't, we use a default
  * partition split defined below.
  *
- * $Log: axisflashmap.c,v $
- * Revision 1.11  2004/11/15 10:27:14  starvik
- * Corrected typo (Thanks to Milton Miller <miltonm@bga.com>).
- *
- * Revision 1.10  2004/08/16 12:37:22  starvik
- * Merge of Linux 2.6.8
- *
- * Revision 1.8  2004/05/14 07:58:03  starvik
- * Merge of changes from 2.4
- *
- * Revision 1.6  2003/07/04 08:27:37  starvik
- * Merge of Linux 2.5.74
- *
- * Revision 1.5  2002/12/11 13:13:57  starvik
- * Added arch/ to v10 specific includes
- * Added fix from Linux 2.4 in serial.c (flush_to_flip_buffer)
- *
- * Revision 1.4  2002/11/20 11:56:10  starvik
- * Merge of Linux 2.5.48
- *
- * Revision 1.3  2002/11/13 14:54:13  starvik
- * Copied from linux 2.4
- *
- * Revision 1.28  2002/10/01 08:08:43  jonashg
- * The first partition ends at the start of the partition table.
- *
- * Revision 1.27  2002/08/21 09:23:13  jonashg
- * Speling.
- *
- * Revision 1.26  2002/08/21 08:35:20  jonashg
- * Cosmetic change to printouts.
- *
- * Revision 1.25  2002/08/21 08:15:42  jonashg
- * Made it compile even without CONFIG_MTD_CONCAT defined.
- *
- * Revision 1.24  2002/08/20 13:12:35  jonashg
- * * New approach to probing. Probe cse0 and cse1 separately and (mtd)concat
- *   the results.
- * * Removed compile time tests concerning how the mtdram driver has been
- *   configured. The user will know about the misconfiguration at runtime
- *   instead. (The old approach made it impossible to use mtdram for anything
- *   else than RAM boot).
- *
- * Revision 1.23  2002/05/13 12:12:28  johana
- * Allow compile without CONFIG_MTD_MTDRAM but warn at compiletime and
- * be informative at runtime.
- *
- * Revision 1.22  2002/05/13 10:24:44  johana
- * Added #if checks on MTDRAM CONFIG
- *
- * Revision 1.21  2002/05/06 16:05:20  johana
- * Removed debug printout.
- *
- * Revision 1.20  2002/05/06 16:03:00  johana
- * No more cramfs as root hack in generic code.
- * It's handled by axisflashmap using mtdram.
- *
- * Revision 1.19  2002/03/15 17:10:28  bjornw
- * Changed comment about cached access since we changed this before
- *
- * Revision 1.18  2002/03/05 17:06:15  jonashg
- * Try amd_flash probe before cfi_probe since amd_flash driver can handle two
- * (or more) flash chips of different model and the cfi driver cannot.
- *
- * Revision 1.17  2001/11/12 19:42:38  pkj
- * Fixed compiler warnings.
- *
- * Revision 1.16  2001/11/08 11:18:58  jonashg
- * Always read from uncached address to avoid problems with flushing
- * cachelines after write and MTD-erase. No performance loss have been
- * seen yet.
- *
- * Revision 1.15  2001/10/19 12:41:04  jonashg
- * Name of probe has changed in MTD.
- *
- * Revision 1.14  2001/09/21 07:14:10  jonashg
- * Made root filesystem (cramfs) use mtdblock driver when booting from flash.
- *
- * Revision 1.13  2001/08/15 13:57:35  jonashg
- * Entire MTD updated to the linux 2.4.7 version.
- *
- * Revision 1.12  2001/06/11 09:50:30  jonashg
- * Oops, 2MB is 0x200000 bytes.
- *
- * Revision 1.11  2001/06/08 11:39:44  jonashg
- * Changed sizes and offsets in axis_default_partitions to use
- * CONFIG_ETRAX_PTABLE_SECTOR.
- *
- * Revision 1.10  2001/05/29 09:42:03  jonashg
- * Use macro for end marker length instead of sizeof.
- *
- * Revision 1.9  2001/05/29 08:52:52  jonashg
- * Gave names to the magic fours (size of the ptable end marker).
- *
- * Revision 1.8  2001/05/28 15:36:20  jonashg
- * * Removed old comment about ptable location in flash (it's a CONFIG_ option).
- * * Variable ptable was initialized twice to the same value.
- *
- * Revision 1.7  2001/04/05 13:41:46  markusl
- * Updated according to review remarks
- *
- * Revision 1.6  2001/03/07 09:21:21  bjornw
- * No need to waste .data
- *
- * Revision 1.5  2001/03/06 16:27:01  jonashg
- * Probe the entire flash area for flash devices.
- *
- * Revision 1.4  2001/02/23 12:47:15  bjornw
- * Uncached flash in LOW_MAP moved from 0xe to 0x8
- *
- * Revision 1.3  2001/02/16 12:11:45  jonashg
- * MTD driver amd_flash is now included in MTD CVS repository.
- * (It's now in drivers/mtd).
- *
- * Revision 1.2  2001/02/09 11:12:22  jonashg
- * Support for AMD compatible non-CFI flash chips.
- * Only tested with Toshiba TC58FVT160 so far.
- *
- * Revision 1.1  2001/01/12 17:01:18  bjornw
- * * Added axisflashmap.c, a physical mapping for MTD that reads and understands
- *   Axis partition-table format.
- *
- *
  */
 
 #include <linux/module.h>
@@ -235,7 +112,7 @@ static struct map_info map_cse1 = {
 };
 
 /* If no partition-table was found, we use this default-set. */
-#define MAX_PARTITIONS         7  
+#define MAX_PARTITIONS         7
 #define NUM_DEFAULT_PARTITIONS 3
 
 /*
@@ -300,6 +177,15 @@ static struct mtd_partition axis_partitions[MAX_PARTITIONS] = {
 	},
 };
 
+#ifdef CONFIG_ETRAX_AXISFLASHMAP_MTD0WHOLE
+/* Main flash device */
+static struct mtd_partition main_partition = {
+	.name = "main",
+	.size = 0,
+	.offset = 0
+};
+#endif
+
 /*
  * Probe a chip select for AMD-compatible (JEDEC) or CFI-compatible flash
  * chips in that order (because the amd_flash-driver is faster).
@@ -316,15 +202,14 @@ static struct mtd_info *probe_cs(struct map_info *map_cs)
 	mtd_cs = do_map_probe("cfi_probe", map_cs);
 #endif
 #ifdef CONFIG_MTD_JEDECPROBE
-	if (!mtd_cs) {
+	if (!mtd_cs)
 		mtd_cs = do_map_probe("jedec_probe", map_cs);
-	}
 #endif
 
 	return mtd_cs;
 }
 
-/* 
+/*
  * Probe each chip select individually for flash chips. If there are chips on
  * both cse0 and cse1, the mtd_info structs will be concatenated to one struct
  * so that MTD partitions can cross chip boundries.
@@ -351,7 +236,7 @@ static struct mtd_info *flash_probe(void)
 	if (mtd_cse0 && mtd_cse1) {
 #ifdef CONFIG_MTD_CONCAT
 		struct mtd_info *mtds[] = { mtd_cse0, mtd_cse1 };
-		
+
 		/* Since the concatenation layer adds a small overhead we
 		 * could try to figure out if the chips in cse0 and cse1 are
 		 * identical and reprobe the whole cse0+cse1 window. But since
@@ -372,7 +257,7 @@ static struct mtd_info *flash_probe(void)
 
 			/* The best we can do now is to only use what we found
 			 * at cse0.
-			 */ 
+			 */
 			mtd_cse = mtd_cse0;
 			map_destroy(mtd_cse1);
 		}
@@ -395,7 +280,7 @@ static int __init init_axis_flash(void)
 	struct partitiontable_head *ptable_head = NULL;
 	struct partitiontable_entry *ptable;
 	int use_default_ptable = 1; /* Until proven otherwise. */
-	const char *pmsg = "  /dev/flash%d at 0x%08x, size 0x%08x\n";
+	const char pmsg[] = "  /dev/flash%d at 0x%08x, size 0x%08x\n";
 
 	if (!(mymtd = flash_probe())) {
 		/* There's no reason to use this module if no flash chip can
@@ -435,7 +320,7 @@ static int __init init_axis_flash(void)
 		unsigned long offset = CONFIG_ETRAX_PTABLE_SECTOR;
 		unsigned char *p;
 		unsigned long csum = 0;
-		
+
 		ptable = (struct partitiontable_entry *)
 			((unsigned long)ptable_head + sizeof(*ptable_head));
 
@@ -490,6 +375,16 @@ static int __init init_axis_flash(void)
 		pidx++;
 	}
 
+#ifdef CONFIG_ETRAX_AXISFLASHMAP_MTD0WHOLE
+	if (mymtd) {
+		main_partition.size = mymtd->size;
+		err = add_mtd_partitions(mymtd, &main_partition, 1);
+		if (err)
+			panic("axisflashmap: Could not initialize "
+			      "partition for whole main mtd device!\n");
+	}
+#endif
+
         if (mymtd) {
 		if (use_default_ptable) {
 			printk(KERN_INFO " Using default partition table.\n");
@@ -499,9 +394,8 @@ static int __init init_axis_flash(void)
 			err = add_mtd_partitions(mymtd, axis_partitions, pidx);
 		}
 
-		if (err) {
+		if (err)
 			panic("axisflashmap could not add MTD partitions!\n");
-		}
 	}
 
 	if (!romfs_in_flash) {
@@ -515,25 +409,24 @@ static int __init init_axis_flash(void)
 #else
 		struct mtd_info *mtd_ram;
 
-		mtd_ram = kmalloc(sizeof(struct mtd_info),
-						     GFP_KERNEL);
-		if (!mtd_ram) {
+		mtd_ram = kmalloc(sizeof(struct mtd_info), GFP_KERNEL);
+		if (!mtd_ram)
 			panic("axisflashmap couldn't allocate memory for "
 			      "mtd_info!\n");
-		}
 
 		printk(KERN_INFO " Adding RAM partition for romfs image:\n");
-		printk(pmsg, pidx, romfs_start, romfs_length);
-
-		err = mtdram_init_device(mtd_ram, (void*)romfs_start, 
-		                         romfs_length, "romfs");
-		if (err) {
+		printk(pmsg, pidx, (unsigned)romfs_start,
+			(unsigned)romfs_length);
+
+		err = mtdram_init_device(mtd_ram,
+			(void *)romfs_start,
+			romfs_length,
+			"romfs");
+		if (err)
 			panic("axisflashmap could not initialize MTD RAM "
 			      "device!\n");
-		}
 #endif
 	}
-
 	return err;
 }
 
-- 
1.5.3.6.970.gd25430

