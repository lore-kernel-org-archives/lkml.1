Return-Path: <linux-kernel-owner+w=401wt.eu-S1751856AbYC3APV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751856AbYC3APV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Mar 2008 20:15:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750918AbYC3API
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Mar 2008 20:15:08 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:61639 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750854AbYC3APF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Mar 2008 20:15:05 -0400
From: Hans-Peter Jansen <hpj@urpla.net>
To: Tejun Heo <htejun@gmail.com>
Subject: Re: 2.6.24.3: regular sata drive resets - worrisome?
Date: Sun, 30 Mar 2008 01:14:39 +0100
User-Agent: KMail/1.9.9
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org
References: <200803201518.32109.hpj@urpla.net> <20080320214830.6d39876d.akpm@linux-foundation.org> <47EE3CFA.2000707@gmail.com>
In-Reply-To: <47EE3CFA.2000707@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200803300114.40096.hpj@urpla.net>
X-Provags-ID: V01U2FsdGVkX19T+pA8GVb7xxRlYxEhA3+/j4BhSnk8ZWJz9DJ
 5YbgMa9p6RW+pY/cnJkf+R2dluhvyiMsqhEplB5dbVhE98MiOH
 s8lvg3v/3fsK56I9zWuQw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tejun,

thanks for picking this issue up.

Am Samstag, 29. März 2008 schrieb Tejun Heo:
> Hello, Hans.
>
> Andrew Morton wrote:
> >> since I upgraded to 2.6.24.3 on one of my production systems, I see
> >> regular device resets like these:
> >>
> >> Mar 20 14:33:03 lisa5 kernel: ata2.00: exception Emask 0x0 SAct 0x0
> >> SErr 0x0 action 0x2 frozen Mar 20 14:33:03 lisa5 kernel: ata2.00: cmd
> >> ea/00:00:00:00:00/00:00:00:00:00/a0 tag 0 Mar 20 14:33:03 lisa5
> >> kernel:          res 40/00:00:01:4f:c2/00:00:00:00:00/00 Emask 0x4
> >> (timeout)
>
> Ouch, timeout on FLUSH_EXT.  Are all errors on cmd ea?
>
> >> Should I be worried? smartd doesn't show anything suspicious on those.
>
> Can you please post the result of "smartctl -a /dev/sdX"?

Here's the last smart report from two of the offending drives. As noted 
before, I did the hardware reorganization, replaced the dog slow 3ware 
9500S-8 and the SiI 3124 with a single Areca 1130 and retired the drives 
for now, but a nephew already showed interest. What do you think, can I 
cede those drives with a clear conscience? The Hardware_ECC_Recovered
values are really worrisome, aren't they?

sdc:
smartctl version 5.38 [i686-suse-linux-gnu] Copyright (C) 2002-7 Bruce Allen
Home page is http://smartmontools.sourceforge.net/

=== START OF INFORMATION SECTION ===
Model Family:     SAMSUNG SpinPoint P120 series
Device Model:     SAMSUNG SP2504C
Serial Number:    S09QJ1GYA03006
Firmware Version: VT100-33
User Capacity:    250.059.350.016 bytes
Device is:        In smartctl database [for details use: -P show]
ATA Version is:   7
ATA Standard is:  ATA/ATAPI-7 T13 1532D revision 4a
Local Time is:    Sun Mar 23 01:13:37 2008 CET

==> WARNING: May need -F samsung3 enabled; see manual for details.

SMART support is: Available - device has SMART capability.
SMART support is: Enabled

=== START OF READ SMART DATA SECTION ===
SMART overall-health self-assessment test result: PASSED

General SMART Values:
Offline data collection status:  (0x82) Offline data collection activity
                                        was completed without error.
                                        Auto Offline Data Collection: Enabled.
Self-test execution status:      (   0) The previous self-test routine completed
                                        without error or no self-test has ever 
                                        been run.
Total time to complete Offline 
data collection:                 (4866) seconds.
Offline data collection
capabilities:                    (0x5b) SMART execute Offline immediate.
                                        Auto Offline data collection on/off support.
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
recommended polling time:        (   1) minutes.
Extended self-test routine
recommended polling time:        (  81) minutes.

SMART Attributes Data Structure revision number: 16
Vendor Specific SMART Attributes with Thresholds:
ID# ATTRIBUTE_NAME          FLAG     VALUE WORST THRESH TYPE      UPDATED  WHEN_FAILED RAW_VALUE
  1 Raw_Read_Error_Rate     0x000f   100   100   051    Pre-fail  Always       -       82
  3 Spin_Up_Time            0x0007   100   100   025    Pre-fail  Always       -       5952
  4 Start_Stop_Count        0x0032   100   100   000    Old_age   Always       -       23
  5 Reallocated_Sector_Ct   0x0033   253   253   010    Pre-fail  Always       -       0
  7 Seek_Error_Rate         0x000f   253   253   051    Pre-fail  Always       -       0
  8 Seek_Time_Performance   0x0025   253   253   015    Pre-fail  Offline      -       0
  9 Power_On_Hours          0x0032   100   100   000    Old_age   Always       -       17647
 10 Spin_Retry_Count        0x0033   253   253   051    Pre-fail  Always       -       0
 11 Calibration_Retry_Count 0x0012   253   002   000    Old_age   Always       -       0
 12 Power_Cycle_Count       0x0032   100   100   000    Old_age   Always       -       19
190 Airflow_Temperature_Cel 0x0022   124   124   000    Old_age   Always       -       38
194 Temperature_Celsius     0x0022   124   124   000    Old_age   Always       -       38
195 Hardware_ECC_Recovered  0x001a   100   100   000    Old_age   Always       -       162956700
196 Reallocated_Event_Count 0x0032   253   253   000    Old_age   Always       -       0
197 Current_Pending_Sector  0x0012   253   253   000    Old_age   Always       -       0
198 Offline_Uncorrectable   0x0030   253   253   000    Old_age   Offline      -       0
199 UDMA_CRC_Error_Count    0x003e   200   200   000    Old_age   Always       -       0
200 Multi_Zone_Error_Rate   0x000a   253   100   000    Old_age   Always       -       0
201 Soft_Read_Error_Rate    0x000a   100   100   000    Old_age   Always       -       0
202 TA_Increase_Count       0x0032   253   253   000    Old_age   Always       -       0

SMART Error Log Version: 1
No Errors Logged

SMART Self-test log structure revision number 1
Num  Test_Description    Status                  Remaining  LifeTime(hours)  LBA_of_first_error
# 1  Short offline       Completed without error       00%     17624         -
# 2  Short offline       Completed without error       00%     17601         -
# 3  Short offline       Completed without error       00%     17577         -
# 4  Short offline       Completed without error       00%     17553         -
# 5  Short offline       Completed without error       00%     17528         -
# 6  Short offline       Completed without error       00%     17504         -
# 7  Extended offline    Completed without error       00%     17489         -
# 8  Short offline       Completed without error       00%     17480         -
# 9  Short offline       Completed without error       00%     17456         -
#10  Short offline       Completed without error       00%     17432         -
#11  Short offline       Completed without error       00%     17408         -
#12  Short offline       Completed without error       00%     17384         -
#13  Short offline       Completed without error       00%     17360         -
#14  Short offline       Completed without error       00%     17336         -
#15  Extended offline    Completed without error       00%     17320         -
#16  Short offline       Completed without error       00%     17311         -
#17  Short offline       Completed without error       00%     17287         -
#18  Short offline       Completed without error       00%     17263         -
#19  Short offline       Completed without error       00%     17239         -

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

sdd:

smartctl version 5.38 [i686-suse-linux-gnu] Copyright (C) 2002-7 Bruce Allen
Home page is http://smartmontools.sourceforge.net/

=== START OF INFORMATION SECTION ===
Model Family:     SAMSUNG SpinPoint P120 series
Device Model:     SAMSUNG SP2504C
Serial Number:    S09QJ1GYA03003
Firmware Version: VT100-33
User Capacity:    250.059.350.016 bytes
Device is:        In smartctl database [for details use: -P show]
ATA Version is:   7
ATA Standard is:  ATA/ATAPI-7 T13 1532D revision 4a
Local Time is:    Sun Mar 23 01:13:38 2008 CET

==> WARNING: May need -F samsung3 enabled; see manual for details.

SMART support is: Available - device has SMART capability.
SMART support is: Enabled

=== START OF READ SMART DATA SECTION ===
SMART overall-health self-assessment test result: PASSED

General SMART Values:
Offline data collection status:  (0x82) Offline data collection activity
                                        was completed without error.
                                        Auto Offline Data Collection: Enabled.
Self-test execution status:      (   0) The previous self-test routine completed
                                        without error or no self-test has ever 
                                        been run.
Total time to complete Offline 
data collection:                 (4836) seconds.
Offline data collection
capabilities:                    (0x5b) SMART execute Offline immediate.
                                        Auto Offline data collection on/off support.
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
recommended polling time:        (   1) minutes.
Extended self-test routine
recommended polling time:        (  80) minutes.

SMART Attributes Data Structure revision number: 16
Vendor Specific SMART Attributes with Thresholds:
ID# ATTRIBUTE_NAME          FLAG     VALUE WORST THRESH TYPE      UPDATED  WHEN_FAILED RAW_VALUE
  1 Raw_Read_Error_Rate     0x000f   100   100   051    Pre-fail  Always       -       79
  3 Spin_Up_Time            0x0007   100   100   025    Pre-fail  Always       -       5952
  4 Start_Stop_Count        0x0032   100   100   000    Old_age   Always       -       23
  5 Reallocated_Sector_Ct   0x0033   253   253   010    Pre-fail  Always       -       0
  7 Seek_Error_Rate         0x000f   253   253   051    Pre-fail  Always       -       0
  8 Seek_Time_Performance   0x0025   253   253   015    Pre-fail  Offline      -       0
  9 Power_On_Hours          0x0032   100   100   000    Old_age   Always       -       17648
 10 Spin_Retry_Count        0x0033   253   253   051    Pre-fail  Always       -       0
 11 Calibration_Retry_Count 0x0012   253   002   000    Old_age   Always       -       0
 12 Power_Cycle_Count       0x0032   100   100   000    Old_age   Always       -       19
190 Airflow_Temperature_Cel 0x0022   118   118   000    Old_age   Always       -       40
194 Temperature_Celsius     0x0022   118   118   000    Old_age   Always       -       40
195 Hardware_ECC_Recovered  0x001a   100   100   000    Old_age   Always       -       162520674
196 Reallocated_Event_Count 0x0032   253   253   000    Old_age   Always       -       0
197 Current_Pending_Sector  0x0012   253   253   000    Old_age   Always       -       0
198 Offline_Uncorrectable   0x0030   253   253   000    Old_age   Offline      -       0
199 UDMA_CRC_Error_Count    0x003e   200   200   000    Old_age   Always       -       0
200 Multi_Zone_Error_Rate   0x000a   253   100   000    Old_age   Always       -       0
201 Soft_Read_Error_Rate    0x000a   100   100   000    Old_age   Always       -       0
202 TA_Increase_Count       0x0032   253   253   000    Old_age   Always       -       0

SMART Error Log Version: 1
No Errors Logged

SMART Self-test log structure revision number 1
Num  Test_Description    Status                  Remaining  LifeTime(hours)  LBA_of_first_error
# 1  Short offline       Completed without error       00%     17626         -
# 2  Short offline       Completed without error       00%     17602         -
# 3  Short offline       Completed without error       00%     17578         -
# 4  Short offline       Completed without error       00%     17554         -
# 5  Short offline       Completed without error       00%     17530         -
# 6  Short offline       Completed without error       00%     17506         -
# 7  Extended offline    Completed without error       00%     17490         -
# 8  Short offline       Completed without error       00%     17482         -
# 9  Short offline       Completed without error       00%     17457         -
#10  Short offline       Completed without error       00%     17433         -
#11  Short offline       Completed without error       00%     17409         -
#12  Short offline       Completed without error       00%     17385         -
#13  Short offline       Completed without error       00%     17361         -
#14  Short offline       Completed without error       00%     17337         -
#15  Extended offline    Completed without error       00%     17321         -
#16  Short offline       Completed without error       00%     17313         -
#17  Short offline       Completed without error       00%     17289         -
#18  Short offline       Completed without error       00%     17264         -
#19  Short offline       Completed without error       00%     17240         -

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

> >> It's been 4 samsung drives at all hanging on a sata sil 3124:
>
> FLUSH_EXT timing out usually indicates that the drive is having problem
> writing out what it has in its cache to the media.  There was one case
> where FLUSH_EXT timeout was caused by the driver failing to switch
> controller back from NCQ mode before issuing FLUSH_EXT but that was on
> sata_nv.  There hasn't been any similar problem on sata_sil24.

Hmm, I didn't noticed any data distortions, and if there where, they live
on as copies in their new home.. 

Thanks,
Pete
