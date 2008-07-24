Return-Path: <linux-kernel-owner+w=401wt.eu-S1755664AbYGXTl7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755664AbYGXTl7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2008 15:41:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753223AbYGXTlC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jul 2008 15:41:02 -0400
Received: from mu-out-0910.google.com ([209.85.134.191]:55018 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751820AbYGXTky (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2008 15:40:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type
         :content-transfer-encoding:content-disposition:message-id;
        b=WadGzwwQocPbC6SYiqgPPueDLN7Hh8xoqjCEyjGEh6VVY5AsBIVNQpJOx4794W5d1W
         1U/7e8qaaq5wj0ShaFQoAijReIbIa5jUkYnI2/j4aw+JXZVrHHl3/W7PiyJ/Y1xfx5Cy
         e12E2DyzREhOzz+FDlX7zPmBPqAgfjkdoe8Gs=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Subject: [PATCH 4/4] remove <linux/hdreg.h>
Date: Thu, 24 Jul 2008 21:37:58 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807242137.58606.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It has no in-kernel users now and can be removed.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 include/linux/Kbuild  |    1 
 include/linux/hdreg.h |  454 --------------------------------------------------
 2 files changed, 455 deletions(-)

Index: b/include/linux/Kbuild
===================================================================
--- a/include/linux/Kbuild
+++ b/include/linux/Kbuild
@@ -213,7 +213,6 @@ unifdef-y += hayesesp.h
 unifdef-y += hdio_ioctls.h
 unifdef-y += hdlcdrv.h
 unifdef-y += hdlc.h
-unifdef-y += hdreg.h
 unifdef-y += hid.h
 unifdef-y += hiddev.h
 unifdef-y += hidraw.h
Index: b/include/linux/hdreg.h
===================================================================
--- a/include/linux/hdreg.h
+++ /dev/null
@@ -1,454 +0,0 @@
-#ifndef _LINUX_HDREG_H
-#define _LINUX_HDREG_H
-
-#ifdef __KERNEL__
-#include <linux/ata.h>
-#endif /* __KERNEL__ */
-
-#include <linux/hdio_ioctls.h>
-
-#ifndef __KERNEL__
-/* ATA/ATAPI Commands pre T13 Spec */
-#define WIN_NOP				0x00
-/*
- *	0x01->0x02 Reserved
- */
-#define CFA_REQ_EXT_ERROR_CODE		0x03 /* CFA Request Extended Error Code */
-/*
- *	0x04->0x07 Reserved
- */
-#define WIN_SRST			0x08 /* ATAPI soft reset command */
-#define WIN_DEVICE_RESET		0x08
-/*
- *	0x09->0x0F Reserved
- */
-#define WIN_RECAL			0x10
-#define WIN_RESTORE			WIN_RECAL
-/*
- *	0x10->0x1F Reserved
- */
-#define WIN_READ			0x20 /* 28-Bit */
-#define WIN_READ_ONCE			0x21 /* 28-Bit without retries */
-#define WIN_READ_LONG			0x22 /* 28-Bit */
-#define WIN_READ_LONG_ONCE		0x23 /* 28-Bit without retries */
-#define WIN_READ_EXT			0x24 /* 48-Bit */
-#define WIN_READDMA_EXT			0x25 /* 48-Bit */
-#define WIN_READDMA_QUEUED_EXT		0x26 /* 48-Bit */
-#define WIN_READ_NATIVE_MAX_EXT		0x27 /* 48-Bit */
-/*
- *	0x28
- */
-#define WIN_MULTREAD_EXT		0x29 /* 48-Bit */
-/*
- *	0x2A->0x2F Reserved
- */
-#define WIN_WRITE			0x30 /* 28-Bit */
-#define WIN_WRITE_ONCE			0x31 /* 28-Bit without retries */
-#define WIN_WRITE_LONG			0x32 /* 28-Bit */
-#define WIN_WRITE_LONG_ONCE		0x33 /* 28-Bit without retries */
-#define WIN_WRITE_EXT			0x34 /* 48-Bit */
-#define WIN_WRITEDMA_EXT		0x35 /* 48-Bit */
-#define WIN_WRITEDMA_QUEUED_EXT		0x36 /* 48-Bit */
-#define WIN_SET_MAX_EXT			0x37 /* 48-Bit */
-#define CFA_WRITE_SECT_WO_ERASE		0x38 /* CFA Write Sectors without erase */
-#define WIN_MULTWRITE_EXT		0x39 /* 48-Bit */
-/*
- *	0x3A->0x3B Reserved
- */
-#define WIN_WRITE_VERIFY		0x3C /* 28-Bit */
-/*
- *	0x3D->0x3F Reserved
- */
-#define WIN_VERIFY			0x40 /* 28-Bit - Read Verify Sectors */
-#define WIN_VERIFY_ONCE			0x41 /* 28-Bit - without retries */
-#define WIN_VERIFY_EXT			0x42 /* 48-Bit */
-/*
- *	0x43->0x4F Reserved
- */
-#define WIN_FORMAT			0x50
-/*
- *	0x51->0x5F Reserved
- */
-#define WIN_INIT			0x60
-/*
- *	0x61->0x5F Reserved
- */
-#define WIN_SEEK			0x70 /* 0x70-0x7F Reserved */
-
-#define CFA_TRANSLATE_SECTOR		0x87 /* CFA Translate Sector */
-#define WIN_DIAGNOSE			0x90
-#define WIN_SPECIFY			0x91 /* set drive geometry translation */
-#define WIN_DOWNLOAD_MICROCODE		0x92
-#define WIN_STANDBYNOW2			0x94
-#define WIN_STANDBY2			0x96
-#define WIN_SETIDLE2			0x97
-#define WIN_CHECKPOWERMODE2		0x98
-#define WIN_SLEEPNOW2			0x99
-/*
- *	0x9A VENDOR
- */
-#define WIN_PACKETCMD			0xA0 /* Send a packet command. */
-#define WIN_PIDENTIFY			0xA1 /* identify ATAPI device	*/
-#define WIN_QUEUED_SERVICE		0xA2
-#define WIN_SMART			0xB0 /* self-monitoring and reporting */
-#define CFA_ERASE_SECTORS		0xC0
-#define WIN_MULTREAD			0xC4 /* read sectors using multiple mode*/
-#define WIN_MULTWRITE			0xC5 /* write sectors using multiple mode */
-#define WIN_SETMULT			0xC6 /* enable/disable multiple mode */
-#define WIN_READDMA_QUEUED		0xC7 /* read sectors using Queued DMA transfers */
-#define WIN_READDMA			0xC8 /* read sectors using DMA transfers */
-#define WIN_READDMA_ONCE		0xC9 /* 28-Bit - without retries */
-#define WIN_WRITEDMA			0xCA /* write sectors using DMA transfers */
-#define WIN_WRITEDMA_ONCE		0xCB /* 28-Bit - without retries */
-#define WIN_WRITEDMA_QUEUED		0xCC /* write sectors using Queued DMA transfers */
-#define CFA_WRITE_MULTI_WO_ERASE	0xCD /* CFA Write multiple without erase */
-#define WIN_GETMEDIASTATUS		0xDA
-#define WIN_ACKMEDIACHANGE		0xDB /* ATA-1, ATA-2 vendor */
-#define WIN_POSTBOOT			0xDC
-#define WIN_PREBOOT 			0xDD
-#define WIN_DOORLOCK			0xDE /* lock door on removable drives */
-#define WIN_DOORUNLOCK			0xDF /* unlock door on removable drives */
-#define WIN_STANDBYNOW1			0xE0
-#define WIN_IDLEIMMEDIATE		0xE1 /* force drive to become "ready" */
-#define WIN_STANDBY			0xE2 /* Set device in Standby Mode */
-#define WIN_SETIDLE1			0xE3
-#define WIN_READ_BUFFER			0xE4 /* force read only 1 sector */
-#define WIN_CHECKPOWERMODE1		0xE5
-#define WIN_SLEEPNOW1			0xE6
-#define WIN_FLUSH_CACHE			0xE7
-#define WIN_WRITE_BUFFER		0xE8 /* force write only 1 sector */
-#define WIN_WRITE_SAME			0xE9 /* read ata-2 to use */
-	/* SET_FEATURES 0x22 or 0xDD */
-#define WIN_FLUSH_CACHE_EXT		0xEA /* 48-Bit */
-#define WIN_IDENTIFY			0xEC /* ask drive to identify itself	*/
-#define WIN_MEDIAEJECT			0xED
-#define WIN_IDENTIFY_DMA		0xEE /* same as WIN_IDENTIFY, but DMA */
-#define WIN_SETFEATURES			0xEF /* set special drive features */
-#define EXABYTE_ENABLE_NEST		0xF0
-#define WIN_SECURITY_SET_PASS		0xF1
-#define WIN_SECURITY_UNLOCK		0xF2
-#define WIN_SECURITY_ERASE_PREPARE	0xF3
-#define WIN_SECURITY_ERASE_UNIT		0xF4
-#define WIN_SECURITY_FREEZE_LOCK	0xF5
-#define WIN_SECURITY_DISABLE		0xF6
-#define WIN_READ_NATIVE_MAX		0xF8 /* return the native maximum address */
-#define WIN_SET_MAX			0xF9
-#define DISABLE_SEAGATE			0xFB
-
-/* WIN_SMART sub-commands */
-
-#define SMART_READ_VALUES		0xD0
-#define SMART_READ_THRESHOLDS		0xD1
-#define SMART_AUTOSAVE			0xD2
-#define SMART_SAVE			0xD3
-#define SMART_IMMEDIATE_OFFLINE		0xD4
-#define SMART_READ_LOG_SECTOR		0xD5
-#define SMART_WRITE_LOG_SECTOR		0xD6
-#define SMART_WRITE_THRESHOLDS		0xD7
-#define SMART_ENABLE			0xD8
-#define SMART_DISABLE			0xD9
-#define SMART_STATUS			0xDA
-#define SMART_AUTO_OFFLINE		0xDB
-
-/* Password used in TF4 & TF5 executing SMART commands */
-
-#define SMART_LCYL_PASS			0x4F
-#define SMART_HCYL_PASS			0xC2
-
-/* WIN_SETFEATURES sub-commands */
-#define SETFEATURES_EN_8BIT	0x01	/* Enable 8-Bit Transfers */
-#define SETFEATURES_EN_WCACHE	0x02	/* Enable write cache */
-#define SETFEATURES_DIS_DEFECT	0x04	/* Disable Defect Management */
-#define SETFEATURES_EN_APM	0x05	/* Enable advanced power management */
-#define SETFEATURES_EN_SAME_R	0x22	/* for a region ATA-1 */
-#define SETFEATURES_DIS_MSN	0x31	/* Disable Media Status Notification */
-#define SETFEATURES_DIS_RETRY	0x33	/* Disable Retry */
-#define SETFEATURES_EN_AAM	0x42	/* Enable Automatic Acoustic Management */
-#define SETFEATURES_RW_LONG	0x44	/* Set Length of VS bytes */
-#define SETFEATURES_SET_CACHE	0x54	/* Set Cache segments to SC Reg. Val */
-#define SETFEATURES_DIS_RLA	0x55	/* Disable read look-ahead feature */
-#define SETFEATURES_EN_RI	0x5D	/* Enable release interrupt */
-#define SETFEATURES_EN_SI	0x5E	/* Enable SERVICE interrupt */
-#define SETFEATURES_DIS_RPOD	0x66	/* Disable reverting to power on defaults */
-#define SETFEATURES_DIS_ECC	0x77	/* Disable ECC byte count */
-#define SETFEATURES_DIS_8BIT	0x81	/* Disable 8-Bit Transfers */
-#define SETFEATURES_DIS_WCACHE	0x82	/* Disable write cache */
-#define SETFEATURES_EN_DEFECT	0x84	/* Enable Defect Management */
-#define SETFEATURES_DIS_APM	0x85	/* Disable advanced power management */
-#define SETFEATURES_EN_ECC	0x88	/* Enable ECC byte count */
-#define SETFEATURES_EN_MSN	0x95	/* Enable Media Status Notification */
-#define SETFEATURES_EN_RETRY	0x99	/* Enable Retry */
-#define SETFEATURES_EN_RLA	0xAA	/* Enable read look-ahead feature */
-#define SETFEATURES_PREFETCH	0xAB	/* Sets drive prefetch value */
-#define SETFEATURES_EN_REST	0xAC	/* ATA-1 */
-#define SETFEATURES_4B_RW_LONG	0xBB	/* Set Length of 4 bytes */
-#define SETFEATURES_DIS_AAM	0xC2	/* Disable Automatic Acoustic Management */
-#define SETFEATURES_EN_RPOD	0xCC	/* Enable reverting to power on defaults */
-#define SETFEATURES_DIS_RI	0xDD	/* Disable release interrupt ATAPI */
-#define SETFEATURES_EN_SAME_M	0xDD	/* for a entire device ATA-1 */
-#define SETFEATURES_DIS_SI	0xDE	/* Disable SERVICE interrupt ATAPI */
-
-/* WIN_SECURITY sub-commands */
-
-#define SECURITY_SET_PASSWORD		0xBA
-#define SECURITY_UNLOCK			0xBB
-#define SECURITY_ERASE_PREPARE		0xBC
-#define SECURITY_ERASE_UNIT		0xBD
-#define SECURITY_FREEZE_LOCK		0xBE
-#define SECURITY_DISABLE_PASSWORD	0xBF
-
-/*
- * Structure returned by HDIO_GET_IDENTITY, as per ANSI NCITS ATA6 rev.1b spec.
- *
- * If you change something here, please remember to update fix_driveid() in
- * ide/probe.c.
- */
-struct hd_driveid {
-	unsigned short	config;		/* lots of obsolete bit flags */
-	unsigned short	cyls;		/* Obsolete, "physical" cyls */
-	unsigned short	reserved2;	/* reserved (word 2) */
-	unsigned short	heads;		/* Obsolete, "physical" heads */
-	unsigned short	track_bytes;	/* unformatted bytes per track */
-	unsigned short	sector_bytes;	/* unformatted bytes per sector */
-	unsigned short	sectors;	/* Obsolete, "physical" sectors per track */
-	unsigned short	vendor0;	/* vendor unique */
-	unsigned short	vendor1;	/* vendor unique */
-	unsigned short	vendor2;	/* Retired vendor unique */
-	unsigned char	serial_no[20];	/* 0 = not_specified */
-	unsigned short	buf_type;	/* Retired */
-	unsigned short	buf_size;	/* Retired, 512 byte increments
-					 * 0 = not_specified
-					 */
-	unsigned short	ecc_bytes;	/* for r/w long cmds; 0 = not_specified */
-	unsigned char	fw_rev[8];	/* 0 = not_specified */
-	unsigned char	model[40];	/* 0 = not_specified */
-	unsigned char	max_multsect;	/* 0=not_implemented */
-	unsigned char	vendor3;	/* vendor unique */
-	unsigned short	dword_io;	/* 0=not_implemented; 1=implemented */
-	unsigned char	vendor4;	/* vendor unique */
-	unsigned char	capability;	/* (upper byte of word 49)
-					 *  3:	IORDYsup
-					 *  2:	IORDYsw
-					 *  1:	LBA
-					 *  0:	DMA
-					 */
-	unsigned short	reserved50;	/* reserved (word 50) */
-	unsigned char	vendor5;	/* Obsolete, vendor unique */
-	unsigned char	tPIO;		/* Obsolete, 0=slow, 1=medium, 2=fast */
-	unsigned char	vendor6;	/* Obsolete, vendor unique */
-	unsigned char	tDMA;		/* Obsolete, 0=slow, 1=medium, 2=fast */
-	unsigned short	field_valid;	/* (word 53)
-					 *  2:	ultra_ok	word  88
-					 *  1:	eide_ok		words 64-70
-					 *  0:	cur_ok		words 54-58
-					 */
-	unsigned short	cur_cyls;	/* Obsolete, logical cylinders */
-	unsigned short	cur_heads;	/* Obsolete, l heads */
-	unsigned short	cur_sectors;	/* Obsolete, l sectors per track */
-	unsigned short	cur_capacity0;	/* Obsolete, l total sectors on drive */
-	unsigned short	cur_capacity1;	/* Obsolete, (2 words, misaligned int)     */
-	unsigned char	multsect;	/* current multiple sector count */
-	unsigned char	multsect_valid;	/* when (bit0==1) multsect is ok */
-	unsigned int	lba_capacity;	/* Obsolete, total number of sectors */
-	unsigned short	dma_1word;	/* Obsolete, single-word dma info */
-	unsigned short	dma_mword;	/* multiple-word dma info */
-	unsigned short  eide_pio_modes; /* bits 0:mode3 1:mode4 */
-	unsigned short  eide_dma_min;	/* min mword dma cycle time (ns) */
-	unsigned short  eide_dma_time;	/* recommended mword dma cycle time (ns) */
-	unsigned short  eide_pio;       /* min cycle time (ns), no IORDY  */
-	unsigned short  eide_pio_iordy; /* min cycle time (ns), with IORDY */
-	unsigned short	words69_70[2];	/* reserved words 69-70
-					 * future command overlap and queuing
-					 */
-	/* HDIO_GET_IDENTITY currently returns only words 0 through 70 */
-	unsigned short	words71_74[4];	/* reserved words 71-74
-					 * for IDENTIFY PACKET DEVICE command
-					 */
-	unsigned short  queue_depth;	/* (word 75)
-					 * 15:5	reserved
-					 *  4:0	Maximum queue depth -1
-					 */
-	unsigned short  words76_79[4];	/* reserved words 76-79 */
-	unsigned short  major_rev_num;	/* (word 80) */
-	unsigned short  minor_rev_num;	/* (word 81) */
-	unsigned short  command_set_1;	/* (word 82) supported
-					 * 15:	Obsolete
-					 * 14:	NOP command
-					 * 13:	READ_BUFFER
-					 * 12:	WRITE_BUFFER
-					 * 11:	Obsolete
-					 * 10:	Host Protected Area
-					 *  9:	DEVICE Reset
-					 *  8:	SERVICE Interrupt
-					 *  7:	Release Interrupt
-					 *  6:	look-ahead
-					 *  5:	write cache
-					 *  4:	PACKET Command
-					 *  3:	Power Management Feature Set
-					 *  2:	Removable Feature Set
-					 *  1:	Security Feature Set
-					 *  0:	SMART Feature Set
-					 */
-	unsigned short  command_set_2;	/* (word 83)
-					 * 15:	Shall be ZERO
-					 * 14:	Shall be ONE
-					 * 13:	FLUSH CACHE EXT
-					 * 12:	FLUSH CACHE
-					 * 11:	Device Configuration Overlay
-					 * 10:	48-bit Address Feature Set
-					 *  9:	Automatic Acoustic Management
-					 *  8:	SET MAX security
-					 *  7:	reserved 1407DT PARTIES
-					 *  6:	SetF sub-command Power-Up
-					 *  5:	Power-Up in Standby Feature Set
-					 *  4:	Removable Media Notification
-					 *  3:	APM Feature Set
-					 *  2:	CFA Feature Set
-					 *  1:	READ/WRITE DMA QUEUED
-					 *  0:	Download MicroCode
-					 */
-	unsigned short  cfsse;		/* (word 84)
-					 * cmd set-feature supported extensions
-					 * 15:	Shall be ZERO
-					 * 14:	Shall be ONE
-					 * 13:6	reserved
-					 *  5:	General Purpose Logging
-					 *  4:	Streaming Feature Set
-					 *  3:	Media Card Pass Through
-					 *  2:	Media Serial Number Valid
-					 *  1:	SMART selt-test supported
-					 *  0:	SMART error logging
-					 */
-	unsigned short  cfs_enable_1;	/* (word 85)
-					 * command set-feature enabled
-					 * 15:	Obsolete
-					 * 14:	NOP command
-					 * 13:	READ_BUFFER
-					 * 12:	WRITE_BUFFER
-					 * 11:	Obsolete
-					 * 10:	Host Protected Area
-					 *  9:	DEVICE Reset
-					 *  8:	SERVICE Interrupt
-					 *  7:	Release Interrupt
-					 *  6:	look-ahead
-					 *  5:	write cache
-					 *  4:	PACKET Command
-					 *  3:	Power Management Feature Set
-					 *  2:	Removable Feature Set
-					 *  1:	Security Feature Set
-					 *  0:	SMART Feature Set
-					 */
-	unsigned short  cfs_enable_2;	/* (word 86)
-					 * command set-feature enabled
-					 * 15:	Shall be ZERO
-					 * 14:	Shall be ONE
-					 * 13:	FLUSH CACHE EXT
-					 * 12:	FLUSH CACHE
-					 * 11:	Device Configuration Overlay
-					 * 10:	48-bit Address Feature Set
-					 *  9:	Automatic Acoustic Management
-					 *  8:	SET MAX security
-					 *  7:	reserved 1407DT PARTIES
-					 *  6:	SetF sub-command Power-Up
-					 *  5:	Power-Up in Standby Feature Set
-					 *  4:	Removable Media Notification
-					 *  3:	APM Feature Set
-					 *  2:	CFA Feature Set
-					 *  1:	READ/WRITE DMA QUEUED
-					 *  0:	Download MicroCode
-					 */
-	unsigned short  csf_default;	/* (word 87)
-					 * command set-feature default
-					 * 15:	Shall be ZERO
-					 * 14:	Shall be ONE
-					 * 13:6	reserved
-					 *  5:	General Purpose Logging enabled
-					 *  4:	Valid CONFIGURE STREAM executed
-					 *  3:	Media Card Pass Through enabled
-					 *  2:	Media Serial Number Valid
-					 *  1:	SMART selt-test supported
-					 *  0:	SMART error logging
-					 */
-	unsigned short  dma_ultra;	/* (word 88) */
-	unsigned short	trseuc;		/* time required for security erase */
-	unsigned short	trsEuc;		/* time required for enhanced erase */
-	unsigned short	CurAPMvalues;	/* current APM values */
-	unsigned short	mprc;		/* master password revision code */
-	unsigned short	hw_config;	/* hardware config (word 93)
-					 * 15:	Shall be ZERO
-					 * 14:	Shall be ONE
-					 * 13:
-					 * 12:
-					 * 11:
-					 * 10:
-					 *  9:
-					 *  8:
-					 *  7:
-					 *  6:
-					 *  5:
-					 *  4:
-					 *  3:
-					 *  2:
-					 *  1:
-					 *  0:	Shall be ONE
-					 */
-	unsigned short	acoustic;	/* (word 94)
-					 * 15:8	Vendor's recommended value
-					 *  7:0	current value
-					 */
-	unsigned short	msrqs;		/* min stream request size */
-	unsigned short	sxfert;		/* stream transfer time */
-	unsigned short	sal;		/* stream access latency */
-	unsigned int	spg;		/* stream performance granularity */
-	unsigned long long lba_capacity_2;/* 48-bit total number of sectors */
-	unsigned short	words104_125[22];/* reserved words 104-125 */
-	unsigned short	last_lun;	/* (word 126) */
-	unsigned short	word127;	/* (word 127) Feature Set
-					 * Removable Media Notification
-					 * 15:2	reserved
-					 *  1:0	00 = not supported
-					 *	01 = supported
-					 *	10 = reserved
-					 *	11 = reserved
-					 */
-	unsigned short	dlf;		/* (word 128)
-					 * device lock function
-					 * 15:9	reserved
-					 *  8	security level 1:max 0:high
-					 *  7:6	reserved
-					 *  5	enhanced erase
-					 *  4	expire
-					 *  3	frozen
-					 *  2	locked
-					 *  1	en/disabled
-					 *  0	capability
-					 */
-	unsigned short  csfo;		/*  (word 129)
-					 * current set features options
-					 * 15:4	reserved
-					 *  3:	auto reassign
-					 *  2:	reverting
-					 *  1:	read-look-ahead
-					 *  0:	write cache
-					 */
-	unsigned short	words130_155[26];/* reserved vendor words 130-155 */
-	unsigned short	word156;	/* reserved vendor word 156 */
-	unsigned short	words157_159[3];/* reserved vendor words 157-159 */
-	unsigned short	cfa_power;	/* (word 160) CFA Power Mode
-					 * 15 word 160 supported
-					 * 14 reserved
-					 * 13
-					 * 12
-					 * 11:0
-					 */
-	unsigned short	words161_175[15];/* Reserved for CFA */
-	unsigned short	words176_205[30];/* Current Media Serial Number */
-	unsigned short	words206_254[49];/* reserved words 206-254 */
-	unsigned short	integrity_word;	/* (word 255)
-					 * 15:8 Checksum
-					 *  7:0 Signature
-					 */
-};
-#endif /* __KERNEL__ */
-
-#endif	/* _LINUX_HDREG_H */
