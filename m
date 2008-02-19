Return-Path: <linux-kernel-owner+w=401wt.eu-S1756492AbYBSTaI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756492AbYBSTaI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 14:30:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757703AbYBST3n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 14:29:43 -0500
Received: from smtp5.pp.htv.fi ([213.243.153.39]:55840 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754608AbYBST3l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 14:29:41 -0500
Date: Tue, 19 Feb 2008 21:29:05 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: "Robert P. J. Day" <rpjday@crashcourse.ca>, linux-kernel@vger.kernel.org
Subject: [2.6 patch] remove include/linux/hdsmart.h
Message-ID: <20080219192905.GE31955@cs181133002.pp.htv.fi>
References: <200802171807.57983.bzolnier@gmail.com> <200802171840.32180.bzolnier@gmail.com> <20080217173642.GC1403@cs181133002.pp.htv.fi> <200802171904.52188.bzolnier@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <200802171904.52188.bzolnier@gmail.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 17, 2008 at 07:04:51PM +0100, Bartlomiej Zolnierkiewicz wrote:
> On Sunday 17 February 2008, Adrian Bunk wrote:
> 
> > Why can't we simply remove it?
> 
> If it is safe w.r.t. userspace then please do it.
> 
> [ I don't know and I couldn't get an answer on LKML so... ]

The purpose of the kernel userapce headers is to contain the interfaces 
between the kernel and userspace.

If nothing in the kernel uses it there's not much value in keeping it.

Removal patch below.

> Thanks,
> Bart

cu
Adrian


<--  snip  -->


include/linux/hdsmart.h is not used by the kernel and should therefore 
be removed.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

 include/linux/Kbuild    |    1 
 include/linux/hdsmart.h |  126 ----------------------------------------
 2 files changed, 127 deletions(-)

a93fe7221c62dbe655e646321a0f1f276f4d05f2 diff --git a/include/linux/Kbuild b/include/linux/Kbuild
index aada32f..0743c5e 100644
--- a/include/linux/Kbuild
+++ b/include/linux/Kbuild
@@ -210,7 +210,6 @@ unifdef-y += hayesesp.h
 unifdef-y += hdlcdrv.h
 unifdef-y += hdlc.h
 unifdef-y += hdreg.h
-unifdef-y += hdsmart.h
 unifdef-y += hiddev.h
 unifdef-y += hpet.h
 unifdef-y += i2c.h
diff --git a/include/linux/hdsmart.h b/include/linux/hdsmart.h
deleted file mode 100644
index 4f4faf9..0000000
--- a/include/linux/hdsmart.h
+++ /dev/null
@@ -1,126 +0,0 @@
-/*
- * linux/include/linux/hdsmart.h
- *
- * Copyright (C) 1999-2000	Michael Cornwell <cornwell@acm.org>
- * Copyright (C) 2000		Andre Hedrick <andre@linux-ide.org>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2, or (at your option)
- * any later version.
- *
- * You should have received a copy of the GNU General Public License
- * (for example /usr/src/linux/COPYING); if not, write to the Free
- * Software Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
- */
-
-#ifndef _LINUX_HDSMART_H
-#define _LINUX_HDSMART_H
-
-#ifndef __KERNEL__
-#define OFFLINE_FULL_SCAN		0
-#define SHORT_SELF_TEST			1
-#define EXTEND_SELF_TEST		2
-#define SHORT_CAPTIVE_SELF_TEST		129
-#define EXTEND_CAPTIVE_SELF_TEST	130
-
-/* smart_attribute is the vendor specific in SFF-8035 spec */
-typedef struct ata_smart_attribute_s {
-	unsigned char			id;
-	unsigned short			status_flag;
-	unsigned char			normalized;
-	unsigned char			worse_normal;
-	unsigned char			raw[6];
-	unsigned char			reserv;
-} __attribute__ ((packed)) ata_smart_attribute_t;
-
-/* smart_values is format of the read drive Atrribute command */
-typedef struct ata_smart_values_s {
-	unsigned short			revnumber;
-	ata_smart_attribute_t		vendor_attributes [30];
-        unsigned char			offline_data_collection_status;
-        unsigned char			self_test_exec_status;
-	unsigned short			total_time_to_complete_off_line;
-	unsigned char			vendor_specific_366;
-	unsigned char			offline_data_collection_capability;
-	unsigned short			smart_capability;
-	unsigned char			errorlog_capability;
-	unsigned char			vendor_specific_371;
-	unsigned char			short_test_completion_time;
-	unsigned char			extend_test_completion_time;
-	unsigned char			reserved_374_385 [12];
-	unsigned char			vendor_specific_386_509 [125];
-	unsigned char			chksum;
-} __attribute__ ((packed)) ata_smart_values_t;
-
-/* Smart Threshold data structures */
-/* Vendor attribute of SMART Threshold */
-typedef struct ata_smart_threshold_entry_s {
-	unsigned char			id;
-	unsigned char			normalized_threshold;
-	unsigned char			reserved[10];
-} __attribute__ ((packed)) ata_smart_threshold_entry_t;
-
-/* Format of Read SMART THreshold Command */
-typedef struct ata_smart_thresholds_s {
-	unsigned short			revnumber;
-	ata_smart_threshold_entry_t	thres_entries[30];
-	unsigned char			reserved[149];
-	unsigned char			chksum;
-} __attribute__ ((packed)) ata_smart_thresholds_t;
-
-typedef struct ata_smart_errorlog_command_struct_s {
-	unsigned char			devicecontrolreg;
-	unsigned char			featuresreg;
-	unsigned char			sector_count;
-	unsigned char			sector_number;
-	unsigned char			cylinder_low;
-	unsigned char			cylinder_high;
-	unsigned char			drive_head;
-	unsigned char			commandreg;
-	unsigned int			timestamp;
-} __attribute__ ((packed)) ata_smart_errorlog_command_struct_t;
-
-typedef struct ata_smart_errorlog_error_struct_s {
-	unsigned char			error_condition;
-	unsigned char			extended_error[14];
-	unsigned char			state;
-	unsigned short			timestamp;
-} __attribute__ ((packed)) ata_smart_errorlog_error_struct_t;
-
-typedef struct ata_smart_errorlog_struct_s {
-	ata_smart_errorlog_command_struct_t	commands[6];
-	ata_smart_errorlog_error_struct_t	error_struct;
-} __attribute__ ((packed)) ata_smart_errorlog_struct_t;
-
-typedef struct ata_smart_errorlog_s {
-	unsigned char			revnumber;
-	unsigned char			error_log_pointer;
-	ata_smart_errorlog_struct_t	errorlog_struct[5];
-	unsigned short			ata_error_count;
-	unsigned short			non_fatal_count;
-	unsigned short			drive_timeout_count;
-	unsigned char			reserved[53];
-	unsigned char			chksum;
-} __attribute__ ((packed)) ata_smart_errorlog_t;
-
-typedef struct ata_smart_selftestlog_struct_s {
-	unsigned char			selftestnumber;
-	unsigned char			selfteststatus;
-	unsigned short			timestamp;
-	unsigned char			selftestfailurecheckpoint;
-	unsigned int			lbafirstfailure;
-	unsigned char			vendorspecific[15];
-} __attribute__ ((packed)) ata_smart_selftestlog_struct_t;
-
-typedef struct ata_smart_selftestlog_s {
-	unsigned short			revnumber;
-	ata_smart_selftestlog_struct_t	selftest_struct[21];
-	unsigned char			vendorspecific[2];
-	unsigned char			mostrecenttest;
-	unsigned char			resevered[2];
-	unsigned char			chksum;
-} __attribute__ ((packed)) ata_smart_selftestlog_t;
-#endif /* __KERNEL__ */
-
-#endif	/* _LINUX_HDSMART_H */

