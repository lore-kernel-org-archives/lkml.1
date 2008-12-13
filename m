Return-Path: <linux-kernel-owner+w=401wt.eu-S1755499AbYLMCIN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755499AbYLMCIN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2008 21:08:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753544AbYLMCH4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Dec 2008 21:07:56 -0500
Received: from wf-out-1314.google.com ([209.85.200.170]:59068 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753417AbYLMCHz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2008 21:07:55 -0500
Message-ID: <494318F5.4060007@gawab.com>
Date: Fri, 12 Dec 2008 18:07:49 -0800
User-Agent: Thunderbird 2.0.0.18 (X11/20081205)
MIME-Version: 1.0
To: lkml <linux-kernel@vger.kernel.org>
Subject: [2.6.28-rc] Sata soft reset filling log
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
From: Justin Madru <bevicm@dslextreme.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I've been testing .28 (currently -rc8) and I've noticed in the logs a 
massive amount of the following.
I can confirm that the messages doesn't appear when booting into a .27 
kernel.

ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6 frozen
ata2.00: ST_FIRST: !(DRQ|ERR|DF)
ata2.00: cmd a0/00:00:00:00:00/00:00:00:00:00/a0 tag 0
         cdb 1e 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00
         res 50/00:01:00:00:00/00:00:00:00:00/a0 Emask 0x2 (HSM violation)
ata2.00: status: { DRDY }
ata2: soft resetting link
ata2.00: configured for UDMA/33
ata2: EH complete

I get this block of messages about every 20 seconds for as long as I'm 
booted into a .28 kernel.
It seems that the sata link is being soft reseted about every _20_ secs.
My drive is a sata drive that should be using UDMA/133 (right?),
but the "error" message says configuring for UDMA/33.
Does this mean that my drive is running at a slower speed?
Should I be worried about the .28 kernel corrupting my hardware? Is this 
a known issue?
How can I stop it from filling my logs!

Some information about my computer:

$ lspci
00:00.0 Host bridge: Intel Corporation Mobile 945GM/PM/GMS, 943/940GML 
and 945GT Express Memory Controller Hub (rev 03)
00:02.0 VGA compatible controller: Intel Corporation Mobile 945GM/GMS, 
943/940GML Express Integrated Graphics Controller (rev 03)
00:02.1 Display controller: Intel Corporation Mobile 945GM/GMS/GME, 
943/940GML Express Integrated Graphics Controller (rev 03)
00:1b.0 Audio device: Intel Corporation 82801G (ICH7 Family) High 
Definition Audio Controller (rev 01)
00:1c.0 PCI bridge: Intel Corporation 82801G (ICH7 Family) PCI Express 
Port 1 (rev 01)
00:1c.3 PCI bridge: Intel Corporation 82801G (ICH7 Family) PCI Express 
Port 4 (rev 01)
00:1d.0 USB Controller: Intel Corporation 82801G (ICH7 Family) USB UHCI 
Controller #1 (rev 01)
00:1d.1 USB Controller: Intel Corporation 82801G (ICH7 Family) USB UHCI 
Controller #2 (rev 01)
00:1d.2 USB Controller: Intel Corporation 82801G (ICH7 Family) USB UHCI 
Controller #3 (rev 01)
00:1d.3 USB Controller: Intel Corporation 82801G (ICH7 Family) USB UHCI 
Controller #4 (rev 01)
00:1d.7 USB Controller: Intel Corporation 82801G (ICH7 Family) USB2 EHCI 
Controller (rev 01)
00:1e.0 PCI bridge: Intel Corporation 82801 Mobile PCI Bridge (rev e1)
00:1f.0 ISA bridge: Intel Corporation 82801GBM (ICH7-M) LPC Interface 
Bridge (rev 01)
00:1f.2 IDE interface: Intel Corporation 82801GBM/GHM (ICH7 Family) SATA 
IDE Controller (rev 01)
00:1f.3 SMBus: Intel Corporation 82801G (ICH7 Family) SMBus Controller 
(rev 01)
03:00.0 Ethernet controller: Broadcom Corporation BCM4401-B0 100Base-TX 
(rev 02)
03:01.0 FireWire (IEEE 1394): Ricoh Co Ltd R5C832 IEEE 1394 Controller
03:01.1 SD Host controller: Ricoh Co Ltd R5C822 SD/SDIO/MMC/MS/MSPro 
Host Adapter (rev 19)
03:01.2 System peripheral: Ricoh Co Ltd R5C843 MMC Host Controller (rev 0a)
03:01.3 System peripheral: Ricoh Co Ltd R5C592 Memory Stick Bus Host 
Adapter (rev 05)
03:01.4 System peripheral: Ricoh Co Ltd xD-Picture Card Controller (rev ff)
0b:00.0 Network controller: Intel Corporation PRO/Wireless 3945ABG 
[Golan] Network Connection (rev 02)

$ hdparm -I /dev/sda
/dev/sda:
ATA device, with non-removable media
        Model Number:       ST980811AS
        Serial Number:      5LY6J1M0
        Firmware Revision:  3.CDD
Standards:
        Supported: 7 6 5 4
        Likely used: 8
Configuration:
        Logical         max     current
        cylinders       16383   16383
        heads           16      16
        sectors/track   63      63
        --
        CHS current addressable sectors:   16514064
        LBA    user addressable sectors:  156301488
        LBA48  user addressable sectors:  156301488
        device size with M = 1024*1024:       76319 MBytes
        device size with M = 1000*1000:       80026 MBytes (80 GB)
Capabilities:
        LBA, IORDY(can be disabled)
        Queue depth: 32
        Standby timer values: spec'd by Standard, no device specific minimum
        R/W multiple sector transfer: Max = 16  Current = 8
        Advanced power management level: 128
        Recommended acoustic management value: 128, current value: 0
        DMA: mdma0 mdma1 mdma2 udma0 udma1 udma2 udma3 udma4 udma5 *udma6
             Cycle time: min=120ns recommended=120ns
        PIO: pio0 pio1 pio2 pio3 pio4
             Cycle time: no flow control=240ns  IORDY flow control=120ns
Commands/features:
        Enabled Supported:
           *    SMART feature set
                Security Mode feature set
           *    Power Management feature set
           *    Write cache
           *    Look-ahead
           *    Host Protected Area feature set
           *    WRITE_BUFFER command
           *    READ_BUFFER command
           *    DOWNLOAD_MICROCODE
           *    Advanced Power Management feature set
                SET_MAX security extension
                Automatic Acoustic Management feature set
           *    48-bit Address feature set
           *    Mandatory FLUSH_CACHE
           *    FLUSH_CACHE_EXT
           *    SMART error logging
           *    SMART self-test
           *    IDLE_IMMEDIATE with UNLOAD
           *    SATA-I signaling speed (1.5Gb/s)
           *    Native Command Queueing (NCQ)
           *    Phy event counters
                Device-initiated interface power management
           *    Software settings preservation
           *    SMART Command Transport (SCT) feature set
Security:
        Master password revision code = 65534
                supported
        not     enabled
        not     locked
                frozen
        not     expired: security count
        not     supported: enhanced erase
Checksum: correct

$ hdparm -fF /dev/sda; hdparm -tT /dev/sda
/dev/sda:
 Timing cached reads:   1650 MB in  2.00 seconds = 825.06 MB/sec
 Timing buffered disk reads:  130 MB in  3.04 seconds =  42.79 MB/sec

$ smartctl -a /dev/sda
smartctl version 5.38 [i686-pc-linux-gnu] Copyright (C) 2002-8 Bruce Allen
Home page is http://smartmontools.sourceforge.net/

=== START OF INFORMATION SECTION ===
Model Family:     Seagate Momentus 5400.3
Device Model:     ST980811AS
Serial Number:    5LY6J1M0
Firmware Version: 3.CDD
User Capacity:    80,026,361,856 bytes
Device is:        In smartctl database [for details use: -P show]
ATA Version is:   7
ATA Standard is:  Exact ATA specification draft version not indicated
Local Time is:    Fri Dec 12 17:05:06 2008 PST
SMART support is: Available - device has SMART capability.
SMART support is: Enabled

=== START OF READ SMART DATA SECTION ===
SMART overall-health self-assessment test result: PASSED
See vendor-specific Attribute list for marginal Attributes.

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
data collection:                 ( 426) seconds.
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
                                        No General Purpose Logging support.
Short self-test routine
recommended polling time:        (   2) minutes.
Extended self-test routine
recommended polling time:        (  84) minutes.
SCT capabilities:              (0x0001) SCT Status supported.

SMART Attributes Data Structure revision number: 10
Vendor Specific SMART Attributes with Thresholds:
ID# ATTRIBUTE_NAME          FLAG     VALUE WORST THRESH TYPE      
UPDATED  WHEN_FAILED RAW_VALUE
  1 Raw_Read_Error_Rate     0x000f   100   253   006    Pre-fail  
Always       -       0
  3 Spin_Up_Time            0x0003   099   099   085    Pre-fail  
Always       -       0
  4 Start_Stop_Count        0x0032   099   099   020    Old_age   
Always       -       1142
  5 Reallocated_Sector_Ct   0x0033   100   100   036    Pre-fail  
Always       -       0
  7 Seek_Error_Rate         0x000f   079   060   030    Pre-fail  
Always       -       88807308
  9 Power_On_Hours          0x0032   097   097   000    Old_age   
Always       -       3420
 10 Spin_Retry_Count        0x0013   100   100   034    Pre-fail  
Always       -       0
 12 Power_Cycle_Count       0x0032   099   099   020    Old_age   
Always       -       1180
187 Reported_Uncorrect      0x0032   100   100   000    Old_age   
Always       -       0
189 High_Fly_Writes         0x003a   100   100   000    Old_age   
Always       -       0
190 Airflow_Temperature_Cel 0x0022   050   042   045    Old_age   
Always   In_the_past 50 (0 102 52 25)
192 Power-Off_Retract_Count 0x0032   100   100   000    Old_age   
Always       -       1076
193 Load_Cycle_Count        0x0032   001   001   000    Old_age   
Always       -       241664
194 Temperature_Celsius     0x0022   050   058   000    Old_age   
Always       -       50 (0 19 0 0)
195 Hardware_ECC_Recovered  0x001a   061   060   000    Old_age   
Always       -       195105625
197 Current_Pending_Sector  0x0012   100   100   000    Old_age   
Always       -       0
198 Offline_Uncorrectable   0x0010   100   100   000    Old_age   
Offline      -       0
199 UDMA_CRC_Error_Count    0x003e   200   200   000    Old_age   
Always       -       0
200 Multi_Zone_Error_Rate   0x0000   100   253   000    Old_age   
Offline      -       0
202 TA_Increase_Count       0x0032   100   253   000    Old_age   
Always       -       0

SMART Error Log Version: 1
No Errors Logged

SMART Self-test log structure revision number 1
Num  Test_Description    Status                  Remaining  
LifeTime(hours)  LBA_of_first_error
# 1  Extended offline    Completed without error       00%      
3257         -
# 2  Short offline       Completed without error       00%      
3256         -
# 3  Short offline       Completed without error       00%      
2659         -
# 4  Short offline       Completed without error       00%      
2659         -
# 5  Short offline       Completed without error       00%      
1657         -
# 6  Short offline       Completed without error       00%      
1621         -
# 7  Short offline       Completed without error       00%         
2         -
# 8  Short offline       Completed without error       00%         
2         -
# 9  Short offline       Completed without error       00%         
1         -
#10  Short offline       Completed without error       00%         
0         -

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

Justin Madru
