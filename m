Return-Path: <linux-kernel-owner+w=401wt.eu-S1757480AbXEMBwR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757480AbXEMBwR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 May 2007 21:52:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756843AbXEMBwF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 May 2007 21:52:05 -0400
Received: from app2.redhotpenguin.com ([64.151.90.21]:35995 "EHLO
	redhotpenguin.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756499AbXEMBwE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 May 2007 21:52:04 -0400
X-Spam-Check-By: app2.redhotpenguin.com
Message-ID: <46466F47.6050800@redhotpenguin.com>
Date: Sat, 12 May 2007 18:52:07 -0700
From: Fred Moyer <fred@redhotpenguin.com>
User-Agent: Thunderbird 2.0.0.0 (Macintosh/20070326)
MIME-Version: 1.0
To: Robert Hancock <hancockr@shaw.ca>
CC: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: [2.6.21.1] SATA freeze
References: <fa.zU1kuoSgByTYCYqY+iCQ5rMJy34@ifi.uio.no> <46460C1B.6000609@shaw.ca> <464610F7.6030202@redhotpenguin.com> <464663AE.6040409@shaw.ca>
In-Reply-To: <464663AE.6040409@shaw.ca>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Robert Hancock wrote:
> Fred Moyer wrote:
>>> This appears to be a different problem. Something is issuing 
>>> SMART-related commands (smartd or smartctl perhaps) which the drive 
>>> seems to be reacting strangely to. It apparently completed the 
>>> command but never raised DRQ to request any data being transferred 
>>> even though we expected it to. Maybe SMART is disabled on the drive 
>>> and that's causing it to just toss these commands? CCing linux-ide in 
>>> case anyone knows what would cause this.
>>
>> Here's smartctl -a for this drive - same output for both sda and sdb. 
>> Smartd is currently running.  Any advice appreciated.
>>
> Sounds like SMART is likely disabled on that drive. You can try doing 
> "smartctl -s on /dev/sda" and see if that will turn it on.
> 

Sorry - that last post of mine was brain dead.  Here's the one with 
(hopefully) useful data.

app2 ~ # smartctl  -d ata -a /dev/sda
smartctl version 5.36 [x86_64-pc-linux-gnu] Copyright (C) 2002-6 Bruce Allen
Home page is http://smartmontools.sourceforge.net/

=== START OF INFORMATION SECTION ===
Device Model:     ST3808110AS
Serial Number:    5LR8895K
Firmware Version: 3.AJJ
User Capacity:    80,026,361,856 bytes
Device is:        Not in smartctl database [for details use: -P showall]
ATA Version is:   7
ATA Standard is:  Exact ATA specification draft version not indicated
Local Time is:    Sat May 12 18:49:06 2007 PDT
SMART support is: Available - device has SMART capability.
SMART support is: Enabled

=== START OF READ SMART DATA SECTION ===
SMART overall-health self-assessment test result: PASSED

General SMART Values:
Offline data collection status:  (0x82) Offline data collection activity
                                         was completed without error.
                                         Auto Offline Data Collection: 
Enabled.
Self-test execution status:      (   0) The previous self-test routine 
completed
                                         without error or no self-test 
has ever
                                         been run.
Total time to complete Offline
data collection:                 ( 431) seconds.
Offline data collection
capabilities:                    (0x5b) SMART execute Offline immediate.
                                         Auto Offline data collection 
on/off support.
                                         Suspend Offline collection upon new
                                         command.
                                         Offline surface scan supported.
                                         Self-test supported.
                                         No Conveyance Self-test supported.
                                         Selective Self-test supported.
SMART capabilities:            (0x0003) Saves SMART data before entering
                                         power-saving mode.
                                         Supports SMART auto save timer.
Error logging capability:        (0x01) Error logging supported.
                                         General Purpose Logging supported.
Short self-test routine
recommended polling time:        (   2) minutes.
Extended self-test routine
recommended polling time:        (  27) minutes.

SMART Attributes Data Structure revision number: 10
Vendor Specific SMART Attributes with Thresholds:
ID# ATTRIBUTE_NAME          FLAG     VALUE WORST THRESH TYPE 
UPDATED  WHEN_FAILED RAW_VALUE
   1 Raw_Read_Error_Rate     0x000f   100   253   006    Pre-fail 
Always       -       0
   3 Spin_Up_Time            0x0002   097   094   000    Old_age 
Always       -       0
   4 Start_Stop_Count        0x0033   100   100   020    Pre-fail 
Always       -       41
   5 Reallocated_Sector_Ct   0x0033   098   098   036    Pre-fail 
Always       -       80
   7 Seek_Error_Rate         0x000f   073   060   030    Pre-fail 
Always       -       23194052
   9 Power_On_Hours          0x0032   096   096   000    Old_age 
Always       -       3899
  10 Spin_Retry_Count        0x0013   100   100   097    Pre-fail 
Always       -       0
  12 Power_Cycle_Count       0x0033   100   100   020    Pre-fail 
Always       -       108
187 Unknown_Attribute       0x0032   001   001   000    Old_age   Always 
       -       17863
189 Unknown_Attribute       0x003a   100   100   000    Old_age   Always 
       -       0
190 Unknown_Attribute       0x0022   070   057   045    Old_age   Always 
       -       2689188364318
194 Temperature_Celsius     0x0022   030   043   000    Old_age   Always 
       -       30 (Lifetime Min/Max 0/22)
195 Hardware_ECC_Recovered  0x001a   048   045   000    Old_age   Always 
       -       2474070
197 Current_Pending_Sector  0x0012   100   100   000    Old_age   Always 
       -       0
198 Offline_Uncorrectable   0x0010   100   100   000    Old_age 
Offline      -       0
199 UDMA_CRC_Error_Count    0x003e   200   200   000    Old_age   Always 
       -       7
200 Multi_Zone_Error_Rate   0x0000   100   253   000    Old_age 
Offline      -       0
202 TA_Increase_Count       0x0032   100   253   000    Old_age   Always 
       -       0

SMART Error Log Version: 1
ATA Error Count: 8 (device log contains only the most recent five errors)
         CR = Command Register [HEX]
         FR = Features Register [HEX]
         SC = Sector Count Register [HEX]
         SN = Sector Number Register [HEX]
         CL = Cylinder Low Register [HEX]
         CH = Cylinder High Register [HEX]
         DH = Device/Head Register [HEX]
         DC = Device Command Register [HEX]
         ER = Error register [HEX]
         ST = Status register [HEX]
Powered_Up_Time is measured from power on, and printed as
DDd+hh:mm:SS.sss where DD=days, hh=hours, mm=minutes,
SS=sec, and sss=millisec. It "wraps" after 49.710 days.

Error 8 occurred at disk power-on lifetime: 3753 hours (156 days + 9 hours)
   When the command that caused the error occurred, the device was 
active or idle.

   After command completion occurred, registers were:
   ER ST SC SN CL CH DH
   -- -- -- -- -- -- --
   84 51 00 78 7a 06 e0  Error: ICRC, ABRT at LBA = 0x00067a78 = 424568

   Commands leading to the command that caused the error were:
   CR FR SC SN CL CH DH DC   Powered_Up_Time  Command/Feature_Name
   -- -- -- -- -- -- -- --  ----------------  --------------------
   25 00 40 39 7a 06 e0 00      02:55:54.633  READ DMA EXT
   b0 d0 01 00 4f c2 00 02      02:55:52.076  SMART READ DATA
   b0 da 00 00 4f c2 00 00      02:55:51.992  SMART RETURN STATUS
   35 00 08 10 52 04 e0 00      02:55:51.903  WRITE DMA EXT
   35 00 a0 70 51 04 e0 00      02:55:51.892  WRITE DMA EXT

Error 7 occurred at disk power-on lifetime: 3751 hours (156 days + 7 hours)
   When the command that caused the error occurred, the device was 
active or idle.

   After command completion occurred, registers were:
   ER ST SC SN CL CH DH
   -- -- -- -- -- -- --
   84 51 00 bf ec 43 e0  Error: ICRC, ABRT at LBA = 0x0043ecbf = 4451519

   Commands leading to the command that caused the error were:
   CR FR SC SN CL CH DH DC   Powered_Up_Time  Command/Feature_Name
   -- -- -- -- -- -- -- --  ----------------  --------------------
   25 00 08 b8 ec 43 e0 00      02:25:46.836  READ DMA EXT
   b0 d0 01 00 4f c2 00 02      02:25:46.818  SMART READ DATA
   b0 da 00 00 4f c2 00 00      02:25:44.880  SMART RETURN STATUS
   35 00 08 f8 bc 04 e0 00      02:25:44.866  WRITE DMA EXT
   35 00 20 d8 bc 04 e0 00      02:25:44.858  WRITE DMA EXT

Error 6 occurred at disk power-on lifetime: 3751 hours (156 days + 7 hours)
   When the command that caused the error occurred, the device was 
active or idle.

   After command completion occurred, registers were:
   ER ST SC SN CL CH DH
   -- -- -- -- -- -- --
   84 51 00 88 7a 17 e0  Error: ICRC, ABRT at LBA = 0x00177a88 = 1538696

   Commands leading to the command that caused the error were:
   CR FR SC SN CL CH DH DC   Powered_Up_Time  Command/Feature_Name
   -- -- -- -- -- -- -- --  ----------------  --------------------
   25 00 08 81 7a 17 e0 00      01:55:42.014  READ DMA EXT
   b0 d0 01 00 4f c2 00 02      01:55:41.990  SMART READ DATA
   b0 da 00 00 4f c2 00 00      02:01:18.894  SMART RETURN STATUS
   35 00 08 a0 21 04 e0 00      01:55:48.306  WRITE DMA EXT
   35 00 98 08 21 04 e0 00      01:55:48.098  WRITE DMA EXT

Error 5 occurred at disk power-on lifetime: 3750 hours (156 days + 6 hours)
   When the command that caused the error occurred, the device was 
active or idle.

   After command completion occurred, registers were:
   ER ST SC SN CL CH DH
   -- -- -- -- -- -- --
   84 51 00 b5 c9 73 e0  Error: ICRC, ABRT at LBA = 0x0073c9b5 = 7588277

   Commands leading to the command that caused the error were:
   CR FR SC SN CL CH DH DC   Powered_Up_Time  Command/Feature_Name
   -- -- -- -- -- -- -- --  ----------------  --------------------
   25 00 20 96 c9 73 e0 00      01:25:42.886  READ DMA EXT
   b0 d0 01 00 4f c2 00 02      01:25:42.868  SMART READ DATA
   35 00 08 ae b6 42 e0 00      01:25:42.456  WRITE DMA EXT
   b0 da 00 00 4f c2 00 00      01:25:42.430  SMART RETURN STATUS
   35 00 08 60 81 04 e0 00      01:25:42.376  WRITE DMA EXT

Error 4 occurred at disk power-on lifetime: 3749 hours (156 days + 5 hours)
   When the command that caused the error occurred, the device was 
active or idle.

   After command completion occurred, registers were:
   ER ST SC SN CL CH DH
   -- -- -- -- -- -- --
   84 51 00 4d 94 3e e0  Error: ICRC, ABRT at LBA = 0x003e944d = 4101197

   Commands leading to the command that caused the error were:
   CR FR SC SN CL CH DH DC   Powered_Up_Time  Command/Feature_Name
   -- -- -- -- -- -- -- --  ----------------  --------------------
   25 00 08 46 94 3e e0 00      00:55:35.846  READ DMA EXT
   b0 d0 01 00 4f c2 00 02      00:55:35.774  SMART READ DATA
   b0 da 00 00 4f c2 00 00      00:55:35.732  SMART RETURN STATUS
   35 00 08 20 b3 04 e0 00      00:55:35.649  WRITE DMA EXT
   35 00 90 90 b2 04 e0 00      00:55:35.337  WRITE DMA EXT

SMART Self-test log structure revision number 1

SMART Selective self-test log data structure revision number 1
  SPAN  MIN_LBA  MAX_LBA  CURRENT_TEST_STATUS
     1        0        0  Not_testing
     2        0        0  Not_testing
     3        0        0  Not_testing
     4        0        0  Not_testing
     5        0        0  Not_testing
Selective self-test flags (0x0):
   After scanning selected spans, do NOT read-scan remainder of disk.
If Selective self-test is pending on power-up, resume after 0 minute delay.
