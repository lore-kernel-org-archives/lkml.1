Return-Path: <linux-kernel-owner+w=401wt.eu-S932704AbXHPQGu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932704AbXHPQGu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2007 12:06:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760408AbXHPQGf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Aug 2007 12:06:35 -0400
Received: from boogie.lpds.sztaki.hu ([193.224.70.237]:51223 "EHLO
	boogie.lpds.sztaki.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762801AbXHPQGc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2007 12:06:32 -0400
Date: Thu, 16 Aug 2007 18:06:30 +0200
From: Gabor Gombas <gombasg@sztaki.hu>
To: Tejun Heo <htejun@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: sata_nv + ADMA + Samsung disk problem
Message-ID: <20070816160629.GL8108@boogie.lpds.sztaki.hu>
References: <20070808120804.GB5257@boogie.lpds.sztaki.hu> <46C17634.2040504@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46C17634.2040504@gmail.com>
X-Copyright: Forwarding or publishing without permission is prohibited.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, Aug 14, 2007 at 06:30:28PM +0900, Tejun Heo wrote:

> Hmmm... That's timeout on cache flush, indicative of failing disk.
> Please post the result of 'smartctl -a /dev/sdc'.

Ok, so something is fishy in 2.6.22 wrt. SMART.

First, booting back to 2.6.20.5 I confirmed that SMART works without any
problems for all 4 disks, so all the following is a regression in
2.6.22.

I have 4 disks: two Maxtors (hdparm -I output below): sda/sdb, and two
Samsung (hdparm -I output is in my previous mail): sdc/sdd.

<==================== cut ====================>
/dev/sda:

ATA device, with non-removable media
	Model Number:       Maxtor 6B250S0                          
	Serial Number:      XXXXXXXX            
	Firmware Revision:  BANC1G10
Standards:
	Used: ATA/ATAPI-7 T13 1532D revision 0 
	Supported: 7 6 5 4 
Configuration:
	Logical		max	current
	cylinders	16383	16383
	heads		16	16
	sectors/track	63	63
	--
	CHS current addressable sectors:   16514064
	LBA    user addressable sectors:  268435455
	LBA48  user addressable sectors:  490234752
	device size with M = 1024*1024:      239372 MBytes
	device size with M = 1000*1000:      251000 MBytes (251 GB)
Capabilities:
	LBA, IORDY(can be disabled)
	Queue depth: 32
	Standby timer values: spec'd by Standard, no device specific minimum
	R/W multiple sector transfer: Max = 16	Current = 16
	Advanced power management level: unknown setting (0x0000)
	Recommended acoustic management value: 192, current value: 128
	DMA: mdma0 mdma1 mdma2 udma0 udma1 udma2 udma3 udma4 udma5 *udma6 
	     Cycle time: min=120ns recommended=120ns
	PIO: pio0 pio1 pio2 pio3 pio4 
	     Cycle time: no flow control=120ns  IORDY flow control=120ns
Commands/features:
	Enabled	Supported:
	   *	SMART feature set
	    	Security Mode feature set
	   *	Power Management feature set
	   *	Write cache
	   *	Look-ahead
	   *	Host Protected Area feature set
	   *	WRITE_VERIFY command
	   *	WRITE_BUFFER command
	   *	READ_BUFFER command
	   *	NOP cmd
	   *	DOWNLOAD_MICROCODE
	    	Advanced Power Management feature set
	    	SET_MAX security extension
	   *	Automatic Acoustic Management feature set
	   *	48-bit Address feature set
	   *	Device Configuration Overlay feature set
	   *	Mandatory FLUSH_CACHE
	   *	FLUSH_CACHE_EXT
	   *	SMART error logging
	   *	SMART self-test
	    	Media Card Pass-Through
	   *	General Purpose Logging feature set
	   *	WRITE_{DMA|MULTIPLE}_FUA_EXT
	   *	URG for READ_STREAM[_DMA]_EXT
	   *	URG for WRITE_STREAM[_DMA]_EXT
	   *	SATA-I signaling speed (1.5Gb/s)
	   *	Native Command Queueing (NCQ)
	    	Software settings preservation
	   *	SMART Command Transport (SCT) feature set
	   *	SCT Data Tables (AC5)
Security: 
	Master password revision code = 65534
		supported
	not	enabled
	not	locked
		frozen
	not	expired: security count
	not	supported: enhanced erase
Checksum: correct
<==================== cut ====================>

Under 2.6.22.1, when I try to do "smartctl -d ata -s on /dev/sd[ab]" or
"smartctl -d ata -a /dev/sd[ab]", I get the following error:

<==================== cut ====================>
smartctl version 5.37 [x86_64-unknown-linux-gnu] Copyright (C) 2002-6 Bruce Allen
Home page is http://smartmontools.sourceforge.net/

=== START OF INFORMATION SECTION ===
Model Family:     Maxtor DiamondMax 10 family (ATA/133 and SATA/150)
Device Model:     Maxtor 6B250S0
Serial Number:    XXXXXXXX
Firmware Version: BANC1G10
User Capacity:    251,000,193,024 bytes
Device is:        In smartctl database [for details use: -P show]
ATA Version is:   7
ATA Standard is:  ATA/ATAPI-7 T13 1532D revision 0
Local Time is:    Wed Aug 15 12:01:38 2007 CEST
SMART support is: Available - device has SMART capability.
SMART support is: Enabled

Error SMART Status command failed
Please get assistance from http://smartmontools.sourceforge.net/
Register values returned from SMART Status command are:
CMD=0x50
FR =0x00
NS =0x00
SC =0x00
CL =0xc2
CH =0x00
SEL=0x00
A mandatory SMART command failed: exiting. To continue, add one or more '-T permissive' options.
<==================== cut ====================>

To repeat, this does not happen under 2.6.20.5. Using "-T permissive" works:

<==================== cut ====================>
smartctl version 5.37 [x86_64-unknown-linux-gnu] Copyright (C) 2002-6 Bruce Allen
Home page is http://smartmontools.sourceforge.net/

=== START OF INFORMATION SECTION ===
Model Family:     Maxtor DiamondMax 10 family (ATA/133 and SATA/150)
Device Model:     Maxtor 6B250S0
Serial Number:    XXXXXXXX
Firmware Version: BANC1G10
User Capacity:    251,000,193,024 bytes
Device is:        In smartctl database [for details use: -P show]
ATA Version is:   7
ATA Standard is:  ATA/ATAPI-7 T13 1532D revision 0
Local Time is:    Wed Aug 15 12:01:47 2007 CEST
SMART support is: Available - device has SMART capability.
SMART support is: Enabled

Error SMART Status command failed
Please get assistance from http://smartmontools.sourceforge.net/
Register values returned from SMART Status command are:
CMD=0x50
FR =0x00
NS =0x00
SC =0x00
CL =0xc2
CH =0x00
SEL=0x00
=== START OF READ SMART DATA SECTION ===
SMART overall-health self-assessment test result: PASSED

General SMART Values:
Offline data collection status:  (0x05)	Offline data collection activity
					was aborted by an interrupting command from host.
					Auto Offline Data Collection: Disabled.
Self-test execution status:      (   0)	The previous self-test routine completed
					without error or no self-test has ever 
					been run.
Total time to complete Offline 
data collection: 		 (1922) seconds.
Offline data collection
capabilities: 			 (0x5b) SMART execute Offline immediate.
					Auto Offline data collection on/off support.
					Suspend Offline collection upon new
					command.
					Offline surface scan supported.
					Self-test supported.
					No Conveyance Self-test supported.
					Selective Self-test supported.
SMART capabilities:            (0x0003)	Saves SMART data before entering
					power-saving mode.
					Supports SMART auto save timer.
Error logging capability:        (0x01)	Error logging supported.
					General Purpose Logging supported.
Short self-test routine 
recommended polling time: 	 (   2) minutes.
Extended self-test routine
recommended polling time: 	 (  99) minutes.

SMART Attributes Data Structure revision number: 16
Vendor Specific SMART Attributes with Thresholds:
ID# ATTRIBUTE_NAME          FLAG     VALUE WORST THRESH TYPE      UPDATED  WHEN_FAILED RAW_VALUE
  3 Spin_Up_Time            0x0027   185   183   063    Pre-fail  Always       -       14093
  4 Start_Stop_Count        0x0032   253   253   000    Old_age   Always       -       1050
  5 Reallocated_Sector_Ct   0x0033   253   253   063    Pre-fail  Always       -       0
  6 Read_Channel_Margin     0x0001   253   253   100    Pre-fail  Offline      -       0
  7 Seek_Error_Rate         0x000a   253   252   000    Old_age   Always       -       0
  8 Seek_Time_Performance   0x0027   247   239   187    Pre-fail  Always       -       33104
  9 Power_On_Minutes        0x0032   246   246   000    Old_age   Always       -       440h+23m
 10 Spin_Retry_Count        0x002b   253   252   157    Pre-fail  Always       -       0
 11 Calibration_Retry_Count 0x002b   253   252   223    Pre-fail  Always       -       0
 12 Power_Cycle_Count       0x0032   251   251   000    Old_age   Always       -       1057
192 Power-Off_Retract_Count 0x0032   253   253   000    Old_age   Always       -       0
193 Load_Cycle_Count        0x0032   253   253   000    Old_age   Always       -       0
194 Temperature_Celsius     0x0032   035   253   000    Old_age   Always       -       38
195 Hardware_ECC_Recovered  0x000a   253   252   000    Old_age   Always       -       8387
196 Reallocated_Event_Count 0x0008   253   253   000    Old_age   Offline      -       0
197 Current_Pending_Sector  0x0008   253   253   000    Old_age   Offline      -       0
198 Offline_Uncorrectable   0x0008   253   253   000    Old_age   Offline      -       0
199 UDMA_CRC_Error_Count    0x0008   199   199   000    Old_age   Offline      -       0
200 Multi_Zone_Error_Rate   0x000a   253   252   000    Old_age   Always       -       0
201 Soft_Read_Error_Rate    0x000a   253   252   000    Old_age   Always       -       0
202 TA_Increase_Count       0x000a   253   252   000    Old_age   Always       -       0
203 Run_Out_Cancel          0x000b   253   252   180    Pre-fail  Always       -       0
204 Shock_Count_Write_Opern 0x000a   253   252   000    Old_age   Always       -       0
205 Shock_Rate_Write_Opern  0x000a   253   252   000    Old_age   Always       -       0
207 Spin_High_Current       0x002a   253   252   000    Old_age   Always       -       0
208 Spin_Buzz               0x002a   253   252   000    Old_age   Always       -       0
209 Offline_Seek_Performnce 0x0024   234   234   000    Old_age   Offline      -       230
210 Unknown_Attribute       0x0032   253   252   000    Old_age   Always       -       0
211 Unknown_Attribute       0x0032   253   252   000    Old_age   Always       -       0
212 Unknown_Attribute       0x0032   253   252   000    Old_age   Always       -       0

SMART Error Log Version: 1
No Errors Logged

SMART Self-test log structure revision number 1
Num  Test_Description    Status                  Remaining  LifeTime(hours)  LBA_of_first_error
# 1  Short offline       Completed without error       00%      2618         -
# 2  Short offline       Completed without error       00%      2600         -
# 3  Short offline       Completed without error       00%      2574         -
# 4  Short offline       Self-test routine in progress 80%      2574         -
# 5  Short offline       Completed without error       00%      2565         -
# 6  Short offline       Completed without error       00%      2556         -
# 7  Short offline       Completed without error       00%      2550         -
# 8  Extended offline    Aborted by host               40%      2550         -
# 9  Short offline       Completed without error       00%      2525         -
#10  Short offline       Completed without error       00%      2516         -
#11  Short offline       Completed without error       00%      2516         -
#12  Short offline       Completed without error       00%      2504         -
#13  Short offline       Completed without error       00%      2499         -
#14  Short offline       Completed without error       00%      2494         -
#15  Short offline       Completed without error       00%      2489         -
#16  Short offline       Completed without error       00%      2484         -
#17  Short offline       Completed without error       00%      2469         -
#18  Short offline       Completed without error       00%      2450         -
#19  Short offline       Completed without error       00%      2442         -
#20  Short offline       Completed without error       00%      2435         -
#21  Short offline       Completed without error       00%      2422         -

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
<==================== cut ====================>

Doing "smartctl -d ata -s on /dev/sd[cd]" or "smartctl -d ata -a
/dev/sd[cd]" works _most of the time_, but sometimes I get errors like
this:

<==================== cut ====================>
smartctl version 5.37 [x86_64-unknown-linux-gnu] Copyright (C) 2002-6 Bruce Allen
Home page is http://smartmontools.sourceforge.net/

=== START OF INFORMATION SECTION ===
Model Family:     SAMSUNG SpinPoint P120 series
Device Model:     SAMSUNG SP2504C
Serial Number:    XXXXXXXXXXXXXX
Firmware Version: VT100-33
User Capacity:    250,059,350,016 bytes
Device is:        In smartctl database [for details use: -P show]
ATA Version is:   7
ATA Standard is:  ATA/ATAPI-7 T13 1532D revision 4a
Local Time is:    Wed Aug 15 11:37:35 2007 CEST
SMART support is: Available - device has SMART capability.
SMART support is: Enabled

Error SMART Status command failed
Please get assistance from http://smartmontools.sourceforge.net/
Register values returned from SMART Status command are:
CMD=0x50
FR =0x00
NS =0x00
SC =0x49
CL =0x41
CH =0x16
SEL=0x00
A mandatory SMART command failed: exiting. To continue, add one or more '-T permissive' options.
<==================== cut ====================>

This error is infrequent and not deterministic; I got it 2 times in
about 15-20 tries (I think the second time the SC/CL/CH values were
different but I did not manage to capture that).

When the smart command succeeds, I get the following output:

<==================== cut ====================>
smartctl version 5.37 [x86_64-unknown-linux-gnu] Copyright (C) 2002-6 Bruce Allen
Home page is http://smartmontools.sourceforge.net/

=== START OF INFORMATION SECTION ===
Model Family:     SAMSUNG SpinPoint P120 series
Device Model:     SAMSUNG SP2504C
Serial Number:    XXXXXXXXXXXXXX
Firmware Version: VT100-33
User Capacity:    250,059,350,016 bytes
Device is:        In smartctl database [for details use: -P show]
ATA Version is:   7
ATA Standard is:  ATA/ATAPI-7 T13 1532D revision 4a
Local Time is:    Wed Aug 15 11:47:00 2007 CEST
SMART support is: Available - device has SMART capability.
SMART support is: Enabled

=== START OF READ SMART DATA SECTION ===
SMART overall-health self-assessment test result: PASSED

General SMART Values:
Offline data collection status:  (0x82)	Offline data collection activity
					was completed without error.
					Auto Offline Data Collection: Enabled.
Self-test execution status:      (   0)	The previous self-test routine completed
					without error or no self-test has ever 
					been run.
Total time to complete Offline 
data collection: 		 (4867) seconds.
Offline data collection
capabilities: 			 (0x5b) SMART execute Offline immediate.
					Auto Offline data collection on/off support.
					Suspend Offline collection upon new
					command.
					Offline surface scan supported.
					Self-test supported.
					No Conveyance Self-test supported.
					Selective Self-test supported.
SMART capabilities:            (0x0003)	Saves SMART data before entering
					power-saving mode.
					Supports SMART auto save timer.
Error logging capability:        (0x01)	Error logging supported.
					General Purpose Logging supported.
Short self-test routine 
recommended polling time: 	 (   1) minutes.
Extended self-test routine
recommended polling time: 	 (  81) minutes.

SMART Attributes Data Structure revision number: 16
Vendor Specific SMART Attributes with Thresholds:
ID# ATTRIBUTE_NAME          FLAG     VALUE WORST THRESH TYPE      UPDATED  WHEN_FAILED RAW_VALUE
  1 Raw_Read_Error_Rate     0x000f   100   100   051    Pre-fail  Always       -       0
  3 Spin_Up_Time            0x0007   100   100   025    Pre-fail  Always       -       6080
  4 Start_Stop_Count        0x0032   100   100   000    Old_age   Always       -       817
  5 Reallocated_Sector_Ct   0x0033   253   253   010    Pre-fail  Always       -       0
  7 Seek_Error_Rate         0x000f   253   253   051    Pre-fail  Always       -       0
  8 Seek_Time_Performance   0x0025   253   253   015    Pre-fail  Offline      -       11557
  9 Power_On_Hours          0x0032   100   100   000    Old_age   Always       -       2342
 10 Spin_Retry_Count        0x0033   253   253   051    Pre-fail  Always       -       0
 11 Calibration_Retry_Count 0x0012   253   002   000    Old_age   Always       -       0
 12 Power_Cycle_Count       0x0032   100   100   000    Old_age   Always       -       783
190 Temperature_Celsius     0x0022   148   124   000    Old_age   Always       -       30
194 Temperature_Celsius     0x0022   148   124   000    Old_age   Always       -       30
195 Hardware_ECC_Recovered  0x001a   100   100   000    Old_age   Always       -       2820219
196 Reallocated_Event_Count 0x0032   253   253   000    Old_age   Always       -       0
197 Current_Pending_Sector  0x0012   253   253   000    Old_age   Always       -       0
198 Offline_Uncorrectable   0x0030   253   253   000    Old_age   Offline      -       0
199 UDMA_CRC_Error_Count    0x003e   200   200   000    Old_age   Always       -       0
200 Multi_Zone_Error_Rate   0x000a   100   100   000    Old_age   Always       -       0
201 Soft_Read_Error_Rate    0x000a   253   100   000    Old_age   Always       -       0
202 TA_Increase_Count       0x0032   253   253   000    Old_age   Always       -       0

SMART Error Log Version: 1
No Errors Logged

SMART Self-test log structure revision number 1
Num  Test_Description    Status                  Remaining  LifeTime(hours)  LBA_of_first_error
# 1  Short offline       Completed without error       00%      2336         -
# 2  Short offline       Completed without error       00%      2318         -
# 3  Short offline       Completed without error       00%      2292         -
# 4  Short offline       Interrupted (host reset)      80%      2291         -
# 5  Short offline       Completed without error       00%      2283         -
# 6  Short offline       Completed without error       00%      2273         -
# 7  Short offline       Completed without error       00%      2268         -
# 8  Short offline       Completed without error       00%      2241         -
# 9  Short offline       Completed without error       00%      2233         -
#10  Short offline       Completed without error       00%      2233         -
#11  Short offline       Completed without error       00%      2221         -
#12  Short offline       Completed without error       00%      2216         -
#13  Short offline       Completed without error       00%      2210         -
#14  Short offline       Completed without error       00%      2206         -
#15  Short offline       Completed without error       00%      2200         -
#16  Short offline       Completed without error       00%      2185         -
#17  Extended offline    Completed without error       00%      2181         -
#18  Short offline       Completed without error       00%      2166         -
#19  Short offline       Completed without error       00%      2158         -
#20  Extended offline    Completed without error       00%      2155         -
#21  Short offline       Completed without error       00%      2151         -

SMART Selective Self-Test Log Data Structure Revision Number (0) should be 1
SMART Selective self-test log data structure revision number 0
Warning: ATA Specification requires selective self-test log data structure revision number = 1
 SPAN  MIN_LBA  MAX_LBA  CURRENT_TEST_STATUS
    1        0        0  Not_testing
    2        0        0  Not_testing
    3        0        0  Not_testing
    4        0        0  Not_testing
    5        0        0  Not_testing
Selective self-test flags (0x0):
  After scanning selected spans, do NOT read-scan remainder of disk.
If Selective self-test is pending on power-up, resume after 0 minute delay.
<==================== cut ====================>

The output for the other disk is nearly identical, the differences in
the reported values are insignificant.

SMART shows the same behavior regardless if ADMA is enabled or not, but
when booting with ADMA-enabled I got a SATA exception for sdc in about
10 minutes in single-user mode so basically no I/O load. I never got a
SATA exception with ADMA turned off even during heavy I/O load.

Gabor

-- 
     ---------------------------------------------------------
     MTA SZTAKI Computer and Automation Research Institute
                Hungarian Academy of Sciences
     ---------------------------------------------------------
