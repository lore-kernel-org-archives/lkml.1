Return-Path: <linux-kernel-owner+w=401wt.eu-S1758308AbZF2Mx3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758308AbZF2Mx3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jun 2009 08:53:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751928AbZF2MxW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jun 2009 08:53:22 -0400
Received: from mail-bw0-f213.google.com ([209.85.218.213]:44978 "EHLO
	mail-bw0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751486AbZF2MxW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jun 2009 08:53:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=rfj9AjVcBKsbNIn388kSFh8MwAY2Vc3t2xfvfNBl0FY/1T+zaVDEAQtJ+lzSQrJa80
         oc1EWKIOEdHMJeJpVXTDLqplOoJNT9U0OSdP54ojgunUzf9NqQ8AfMxC5eui4NvnJcVi
         imiytPApOiX4h9tRQ+pZZuS6a/RM9CO0xD3Bs=
MIME-Version: 1.0
Date: Mon, 29 Jun 2009 14:45:03 +0200
Message-ID: <b6373cd60906290545w2f9a660ci7c7c51794ecf5f56@mail.gmail.com>
Subject: hdd errors with libata drivers
From: Marcin Niskiewicz <mniskiewicz@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello!
I have 2 identical machines - both with 3 disks (WDC WD3000HLFS) -
root filesystem is under raid1, data partitions are in raid5 (using
mdadm)
gentoo, kernel version - 2.6.25-hardened-r8, ahci driver for disks...
reiserfs as filesystem...
00:1f.2 SATA controller: Intel Corporation 82801IR/IO/IH (ICH9R/DO/DH)
6 port SATA AHCI Controller (rev 02)
Intel(R) Xeon(R) CPU X3360

About 4 months ago both machines died in the same way - due to problem
with disks - both raid5-s were down, data filesystem was
unreachable... (the root filesystem survived)

I thought that it was sth linked with power supply or sth similar - so
I made some changes to avoid the problem ...

But few days ago it happened again - at the SAME time - BOTH machines
had problems with disks! (again root filesystem survived, data
partition was corrupted and raid5 was unreachable)

In dmesg I noticed something like this:

ata1.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
ata1.00: irq_stat 0x40000001
ata1.00: cmd ea/00:00:00:00:00/00:00:00:00:00/a0 tag 0
         res 51/04:00:34:cf:f3/00:00:00:f3:40/a3 Emask 0x1 (device error)
ata1.00: status: { DRDY ERR }
ata1.00: error: { ABRT }
ata1.00: configured for UDMA/133
ata1: EH complete
sd 0:0:0:0: [sda] 586072368 512-byte hardware sectors (300069 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't
support DPO or FUA
ata1.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
ata1.00: irq_stat 0x40000001
ata1.00: cmd ea/00:00:00:00:00/00:00:00:00:00/a0 tag 0
         res 51/04:00:34:cf:f3/00:00:00:f3:40/a3 Emask 0x1 (device error)
ata1.00: status: { DRDY ERR }
ata1.00: error: { ABRT }
ata1.00: configured for UDMA/133
ata1: EH complete
sd 0:0:0:0: [sda] 586072368 512-byte hardware sectors (300069 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't
support DPO or FUA
ata1.00: exception Emask 0x0 SAct 0x7 SErr 0x0 action 0x0
ata1.00: irq_stat 0x40000008
ata1.00: cmd 60/08:08:f7:23:8a/00:00:0b:00:00/40 tag 1 ncq 4096 in
         res 41/40:00:f7:23:8a/21:00:0b:00:00/4b Emask 0x409 (media error) <F>
ata1.00: status: { DRDY ERR }
ata1.00: error: { UNC }
ata1.00: configured for UDMA/133
ata1: EH complete

On both machines dmesg errors were about ata1.00 ...

Due to http://ata.wiki.kernel.org/index.php/Libata_error_messages it
looks like hardware problem - but 6 disks in two machines - at the
same time again?
I checked all of disks with WD tools before going to production and
everything was OK... It's really strange ....

I found opinions that it could be kernel bug on ata acpi - and that I
should add noacpi or noapic option - is it true? wouldn't it have any
affects (performance etc.) to Intel CPU?

I'm thinking about changing kernel version - maybe not hardened ...

One more thing - it's the smart report from one of disks:

smartctl -a /dev/sda

smartctl version 5.38 [x86_64-pc-linux-gnu] Copyright (C) 2002-8 Bruce Allen
Home page is http://smartmontools.sourceforge.net/

=== START OF INFORMATION SECTION ===
Device Model:     WDC WD3000HLFS-01G6U0
Serial Number:    WD-WXL808032081
Firmware Version: 04.04V01
User Capacity:    300,069,052,416 bytes
Device is:        Not in smartctl database [for details use: -P showall]
ATA Version is:   8
ATA Standard is:  Exact ATA specification draft version not indicated
Local Time is:    Fri Jun 26 10:38:42 2009 CEST
SMART support is: Available - device has SMART capability.
SMART support is: Enabled

=== START OF READ SMART DATA SECTION ===
SMART overall-health self-assessment test result: PASSED

(...)

SMART Attributes Data Structure revision number: 16
Vendor Specific SMART Attributes with Thresholds:
ID# ATTRIBUTE_NAME          FLAG     VALUE WORST THRESH TYPE
UPDATED  WHEN_FAILED RAW_VALUE
  1 Raw_Read_Error_Rate     0x000f   200   200   051    Pre-fail
Always       -       0
  3 Spin_Up_Time            0x0003   195   195   021    Pre-fail
Always       -       3216
  4 Start_Stop_Count        0x0032   100   100   000    Old_age
Always       -       26
  5 Reallocated_Sector_Ct   0x0033   200   200   140    Pre-fail
Always       -       0
  7 Seek_Error_Rate         0x000e   200   200   000    Old_age
Always       -       0
  9 Power_On_Hours          0x0032   097   097   000    Old_age
Always       -       2480
 10 Spin_Retry_Count        0x0012   100   253   000    Old_age
Always       -       0
 11 Calibration_Retry_Count 0x0012   100   253   000    Old_age
Always       -       0
 12 Power_Cycle_Count       0x0032   100   100   000    Old_age
Always       -       23
192 Power-Off_Retract_Count 0x0032   200   200   000    Old_age
Always       -       17
193 Load_Cycle_Count        0x0032   200   200   000    Old_age
Always       -       26
194 Temperature_Celsius     0x0022   119   107   000    Old_age
Always       -       28
196 Reallocated_Event_Count 0x0032   200   200   000    Old_age
Always       -       0
197 Current_Pending_Sector  0x0012   200   200   000    Old_age
Always       -       0
198 Offline_Uncorrectable   0x0010   200   200   000    Old_age
Offline      -       0
199 UDMA_CRC_Error_Count    0x003e   200   200   000    Old_age
Always       -       0
200 Multi_Zone_Error_Rate   0x0008   200   200   000    Old_age
Offline      -       0

SMART Error Log Version: 1
ATA Error Count: 68 (device log contains only the most recent five errors)
(...)
Powered_Up_Time is measured from power on, and printed as
DDd+hh:mm:SS.sss where DD=days, hh=hours, mm=minutes,
SS=sec, and sss=millisec. It "wraps" after 49.710 days.

Error 68 occurred at disk power-on lifetime: 2453 hours (102 days + 5 hours)
  When the command that caused the error occurred, the device was
active or idle.

  After command completion occurred, registers were:
  ER ST SC SN CL CH DH
  -- -- -- -- -- -- --
  40 51 00 49 b8 f0 40

  Commands leading to the command that caused the error were:
  CR FR SC SN CL CH DH DC   Powered_Up_Time  Command/Feature_Name
  -- -- -- -- -- -- -- --  ----------------  --------------------
  60 40 00 49 b8 f0 1f 08      00:00:26.823  READ FPDMA QUEUED
  27 00 00 00 00 00 00 08  49d+17:02:43.547  READ NATIVE MAX ADDRESS EXT
  ec 00 00 00 00 00 00 08  49d+17:02:43.540  IDENTIFY DEVICE
  ef 03 46 00 00 00 00 08  49d+17:02:43.540  SET FEATURES [Set transfer mode]
  27 00 00 00 00 00 00 08  49d+17:02:43.540  READ NATIVE MAX ADDRESS EXT

Error 67 occurred at disk power-on lifetime: 2453 hours (102 days + 5 hours)
  When the command that caused the error occurred, the device was
active or idle.

  After command completion occurred, registers were:
  ER ST SC SN CL CH DH
  -- -- -- -- -- -- --
  40 51 00 17 57 00 40

  Commands leading to the command that caused the error were:
  CR FR SC SN CL CH DH DC   Powered_Up_Time  Command/Feature_Name
  -- -- -- -- -- -- -- --  ----------------  --------------------
  60 28 00 17 57 00 00 08  49d+17:02:43.467  READ FPDMA QUEUED
  27 00 00 00 00 00 00 08  49d+17:02:43.467  READ NATIVE MAX ADDRESS EXT
  ec 00 00 00 00 00 00 08  49d+17:02:43.460  IDENTIFY DEVICE
  ef 03 46 00 00 00 00 08  49d+17:02:43.460  SET FEATURES [Set transfer mode]
  27 00 00 00 00 00 00 08  49d+17:02:43.460  READ NATIVE MAX ADDRESS EXT

Error 66 occurred at disk power-on lifetime: 2453 hours (102 days + 5 hours)
  When the command that caused the error occurred, the device was
active or idle.

  After command completion occurred, registers were:
  ER ST SC SN CL CH DH
  -- -- -- -- -- -- --
  40 51 00 17 57 00 40

  Commands leading to the command that caused the error were:
  CR FR SC SN CL CH DH DC   Powered_Up_Time  Command/Feature_Name
  -- -- -- -- -- -- -- --  ----------------  --------------------
  60 28 00 17 57 00 00 08  49d+17:02:43.428  READ FPDMA QUEUED
  27 00 00 00 00 00 00 08  49d+17:02:43.428  READ NATIVE MAX ADDRESS EXT
  ec 00 00 00 00 00 00 08  49d+17:02:43.421  IDENTIFY DEVICE
  ef 03 46 00 00 00 00 08  49d+17:02:43.421  SET FEATURES [Set transfer mode]
  27 00 00 00 00 00 00 08  49d+17:02:43.421  READ NATIVE MAX ADDRESS EXT

Error 65 occurred at disk power-on lifetime: 2453 hours (102 days + 5 hours)
  When the command that caused the error occurred, the device was
active or idle.

  After command completion occurred, registers were:
  ER ST SC SN CL CH DH
  -- -- -- -- -- -- --
  40 51 00 17 57 00 40

  Commands leading to the command that caused the error were:
  CR FR SC SN CL CH DH DC   Powered_Up_Time  Command/Feature_Name
  -- -- -- -- -- -- -- --  ----------------  --------------------
  60 28 00 17 57 00 00 08  49d+17:02:43.388  READ FPDMA QUEUED
  27 00 00 00 00 00 00 08  49d+17:02:43.388  READ NATIVE MAX ADDRESS EXT
  ec 00 00 00 00 00 00 08  49d+17:02:43.381  IDENTIFY DEVICE
  ef 03 46 00 00 00 00 08  49d+17:02:43.381  SET FEATURES [Set transfer mode]
  27 00 00 00 00 00 00 08  49d+17:02:43.381  READ NATIVE MAX ADDRESS EXT

Error 64 occurred at disk power-on lifetime: 2453 hours (102 days + 5 hours)
  When the command that caused the error occurred, the device was
active or idle.

  After command completion occurred, registers were:
  ER ST SC SN CL CH DH
  -- -- -- -- -- -- --
  40 51 00 17 57 00 40

  Commands leading to the command that caused the error were:
  CR FR SC SN CL CH DH DC   Powered_Up_Time  Command/Feature_Name
  -- -- -- -- -- -- -- --  ----------------  --------------------
  60 28 00 17 57 00 00 08  49d+17:02:43.349  READ FPDMA QUEUED
  27 00 00 00 00 00 00 08  49d+17:02:43.349  READ NATIVE MAX ADDRESS EXT
  ec 00 00 00 00 00 00 08  49d+17:02:43.342  IDENTIFY DEVICE
  ef 03 46 00 00 00 00 08  49d+17:02:43.342  SET FEATURES [Set transfer mode]
  27 00 00 00 00 00 00 08  49d+17:02:43.342  READ NATIVE MAX ADDRESS EXT

SMART Self-test log structure revision number 1
Num  Test_Description    Status                  Remaining
LifeTime(hours)  LBA_of_first_error
# 1  Conveyance offline  Completed without error       00%         0         -
(...)

Any ideas?

Thanks for any help!

regards
nichu
