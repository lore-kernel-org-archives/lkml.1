Return-Path: <linux-kernel-owner+w=401wt.eu-S1753894AbYCVQBT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753894AbYCVQBT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Mar 2008 12:01:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752284AbYCVQBA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Mar 2008 12:01:00 -0400
Received: from fg-out-1718.google.com ([72.14.220.152]:16735 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752138AbYCVQA6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Mar 2008 12:00:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=g4xYHTNo5mEKHpn7nfk3ySDRf0EbZ4rqsMgUGY2hrTiNuejwJeAdGQRG0OwcPssfaHDV2/MLhZfNe2RrTpnMUL4Kn/X4p3j7W15F29/u48kWF4sVM9E4GUOzrIfe2FMw6333fcbZ0lXzx5MvOHiauVD5nuKkpxqmka/CLPvZMC8=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [git patches] IDE fixes
Date: Sat, 22 Mar 2008 17:14:14 +0100
User-Agent: KMail/1.9.9
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803221714.14203.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Some final polishing for 2.6.25.

Linus, Please pull from:

master.kernel.org:/pub/scm/linux/kernel/git/bart/ide-2.6.git/

to receive the following updates:

 Documentation/feature-removal-schedule.txt |   10 ----------
 Documentation/ide/ide.txt                  |   21 +++------------------
 drivers/ide/ide-lib.c                      |   10 ----------
 drivers/ide/ide-tape.c                     |    5 -----
 drivers/ide/ide.c                          |   20 ++++++++++----------
 5 files changed, 13 insertions(+), 53 deletions(-)


Bartlomiej Zolnierkiewicz (6):
      ide: remove commented out entries from ide_pio_blacklist[]
      ide: mark special "ide0=" kernel parameters as obsoleted
      ide: Documentation/ide/ide.txt fixes
      ide: mark "hdx=[driver_name]" and "hdx=scsi" kernel parameters as obsoleted
      ide: mark "hdx=remap" and "hdx=remap63" kernel parameters as obsoleted
      Revert "ide-tape: schedule driver for removal after 6 months"


diff --git a/Documentation/feature-removal-schedule.txt b/Documentation/feature-removal-schedule.txt
index c1d1fd0..bf0e3df 100644
--- a/Documentation/feature-removal-schedule.txt
+++ b/Documentation/feature-removal-schedule.txt
@@ -172,16 +172,6 @@ Who:	Len Brown <len.brown@intel.com>
 
 ---------------------------
 
-What:	ide-tape driver
-When:	July 2008
-Files:	drivers/ide/ide-tape.c
-Why:	This driver might not have any users anymore and maintaining it for no
-	reason is an effort no one wants to make.
-Who:	Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>, Borislav Petkov
-	<petkovbb@googlemail.com>
-
----------------------------
-
 What: libata spindown skipping and warning
 When: Dec 2008
 Why:  Some halt(8) implementations synchronize caches for and spin
diff --git a/Documentation/ide/ide.txt b/Documentation/ide/ide.txt
index e3b3425..818676a 100644
--- a/Documentation/ide/ide.txt
+++ b/Documentation/ide/ide.txt
@@ -105,7 +105,7 @@ Drives are normally found by auto-probing and/or examining the CMOS/BIOS data.
 For really weird situations, the apparent (fdisk) geometry can also be specified
 on the kernel "command line" using LILO.  The format of such lines is:
 
-	hdx=cyls,heads,sects,wpcom,irq
+	hdx=cyls,heads,sects
 or	hdx=cdrom
 
 where hdx can be any of hda through hdh, Three values are required
@@ -214,9 +214,9 @@ driver using the "options=" keyword to insmod, while replacing any ',' with
 Summary of ide driver parameters for kernel command line
 --------------------------------------------------------
 
- "hdx="  is recognized for all "x" from "a" to "h", such as "hdc".
+ "hdx="  is recognized for all "x" from "a" to "u", such as "hdc".
 
- "idex=" is recognized for all "x" from "0" to "3", such as "ide1".
+ "idex=" is recognized for all "x" from "0" to "9", such as "ide1".
 
  "hdx=noprobe"		: drive may be present, but do not probe for it
 
@@ -228,13 +228,6 @@ Summary of ide driver parameters for kernel command line
 
  "hdx=cyl,head,sect"	: disk drive is present, with specified geometry
 
- "hdx=remap"		: remap access of sector 0 to sector 1 (for EZDrive)
-
- "hdx=remap63"		: remap the drive: add 63 to all sector numbers
-			  (for DM OnTrack)
-
- "idex=noautotune"	: driver will NOT attempt to tune interface speed
-
  "hdx=autotune"		: driver will attempt to tune interface speed
 			  to the fastest PIO mode supported,
 			  if possible for this drive only.
@@ -244,10 +237,6 @@ Summary of ide driver parameters for kernel command line
 
  "hdx=nodma"		: disallow DMA
 
- "hdx=scsi"		: the return of the ide-scsi flag, this is useful for
- 			  allowing ide-floppy, ide-tape, and ide-cdrom|writers
- 			  to use ide-scsi emulation on a device specific option.
-
  "idebus=xx"		: inform IDE driver of VESA/PCI bus speed in MHz,
 			  where "xx" is between 20 and 66 inclusive,
 			  used when tuning chipset PIO modes.
@@ -282,10 +271,6 @@ Summary of ide driver parameters for kernel command line
 
  "ide=reverse"		: formerly called to pci sub-system, but now local.
 
-The following are valid ONLY on ide0, which usually corresponds
-to the first ATA interface found on the particular host, and the defaults for
-the base,ctl ports must not be altered.
-
  "ide=doubler"		: probe/support IDE doublers on Amiga
 
 There may be more options than shown -- use the source, Luke!
diff --git a/drivers/ide/ide-lib.c b/drivers/ide/ide-lib.c
index 29e2c97..7031a8d 100644
--- a/drivers/ide/ide-lib.c
+++ b/drivers/ide/ide-lib.c
@@ -122,7 +122,6 @@ static struct ide_pio_info {
 	const char	*name;
 	int		pio;
 } ide_pio_blacklist [] = {
-/*	{ "Conner Peripherals 1275MB - CFS1275A", 4 }, */
 	{ "Conner Peripherals 540MB - CFS540A", 3 },
 
 	{ "WDC AC2700",  3 },
@@ -138,10 +137,8 @@ static struct ide_pio_info {
 	{ "WDC AC1170",  1 },
 	{ "WDC AC1210",  1 },
 	{ "WDC AC280",   0 },
-/*	{ "WDC AC21000", 4 }, */
 	{ "WDC AC31000", 3 },
 	{ "WDC AC31200", 3 },
-/*	{ "WDC AC31600", 4 }, */
 
 	{ "Maxtor 7131 AT", 1 },
 	{ "Maxtor 7171 AT", 1 },
@@ -155,13 +152,6 @@ static struct ide_pio_info {
 	{ "SAMSUNG SHD-3122A", 1 },
 	{ "SAMSUNG SHD-3172A", 1 },
 
-/*	{ "ST51080A", 4 },
- *	{ "ST51270A", 4 },
- *	{ "ST31220A", 4 },
- *	{ "ST31640A", 4 },
- *	{ "ST32140A", 4 },
- *	{ "ST3780A",  4 },
- */
 	{ "ST5660A",  3 },
 	{ "ST3660A",  3 },
 	{ "ST3630A",  3 },
diff --git a/drivers/ide/ide-tape.c b/drivers/ide/ide-tape.c
index 43e0e05..0598ecf 100644
--- a/drivers/ide/ide-tape.c
+++ b/drivers/ide/ide-tape.c
@@ -3765,11 +3765,6 @@ static int ide_tape_probe(ide_drive_t *drive)
 	g->fops = &idetape_block_ops;
 	ide_register_region(g);
 
-	printk(KERN_WARNING "It is possible that this driver does not have any"
-		" users anymore and, as a result, it will be REMOVED soon."
-		" Please notify Bart <bzolnier@gmail.com> or Boris"
-		" <petkovbb@gmail.com> in case you still need it.\n");
-
 	return 0;
 
 out_free_tape:
diff --git a/drivers/ide/ide.c b/drivers/ide/ide.c
index 9976f9d..fc69fe2 100644
--- a/drivers/ide/ide.c
+++ b/drivers/ide/ide.c
@@ -1258,7 +1258,7 @@ static int __init ide_setup(char *s)
 		drive = &hwif->drives[unit];
 		if (strncmp(s + 4, "ide-", 4) == 0) {
 			strlcpy(drive->driver_req, s + 4, sizeof(drive->driver_req));
-			goto done;
+			goto obsolete_option;
 		}
 		switch (match_parm(&s[3], hd_words, vals, 3)) {
 			case -1: /* "none" */
@@ -1290,13 +1290,13 @@ static int __init ide_setup(char *s)
 				goto done;
 			case -12: /* "remap" */
 				drive->remap_0_to_1 = 1;
-				goto done;
+				goto obsolete_option;
 			case -13: /* "remap63" */
 				drive->sect0 = 63;
-				goto done;
+				goto obsolete_option;
 			case -14: /* "scsi" */
 				drive->scsi = 1;
-				goto done;
+				goto obsolete_option;
 			case 3: /* cyl,head,sect */
 				drive->media	= ide_disk;
 				drive->ready_stat = READY_STAT;
@@ -1370,32 +1370,32 @@ static int __init ide_setup(char *s)
 #ifdef CONFIG_BLK_DEV_ALI14XX
 			case -17: /* "ali14xx" */
 				probe_ali14xx = 1;
-				goto done;
+				goto obsolete_option;
 #endif
 #ifdef CONFIG_BLK_DEV_UMC8672
 			case -16: /* "umc8672" */
 				probe_umc8672 = 1;
-				goto done;
+				goto obsolete_option;
 #endif
 #ifdef CONFIG_BLK_DEV_DTC2278
 			case -15: /* "dtc2278" */
 				probe_dtc2278 = 1;
-				goto done;
+				goto obsolete_option;
 #endif
 #ifdef CONFIG_BLK_DEV_CMD640
 			case -14: /* "cmd640_vlb" */
 				cmd640_vlb = 1;
-				goto done;
+				goto obsolete_option;
 #endif
 #ifdef CONFIG_BLK_DEV_HT6560B
 			case -13: /* "ht6560b" */
 				probe_ht6560b = 1;
-				goto done;
+				goto obsolete_option;
 #endif
 #ifdef CONFIG_BLK_DEV_QD65XX
 			case -12: /* "qd65xx" */
 				probe_qd65xx = 1;
-				goto done;
+				goto obsolete_option;
 #endif
 #ifdef CONFIG_BLK_DEV_4DRIVES
 			case -11: /* "four" drives on one set of ports */
