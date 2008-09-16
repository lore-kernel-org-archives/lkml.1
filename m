Return-Path: <linux-kernel-owner+w=401wt.eu-S1753663AbYIPIaA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753663AbYIPIaA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2008 04:30:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752125AbYIPI3u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Sep 2008 04:29:50 -0400
Received: from ppp-111-95.adsl.restena.lu ([158.64.111.95]:41083 "EHLO
	bonbons.gotdns.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751836AbYIPI3s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2008 04:29:48 -0400
X-Greylist: delayed 464 seconds by postgrey-1.27 at vger.kernel.org; Tue, 16 Sep 2008 04:29:47 EDT
Date: Tue, 16 Sep 2008 10:21:52 +0200
From: Bruno =?UTF-8?B?UHLDqW1vbnQ=?= <bonbons@linux-vserver.org>
To: Tejun Heo <tj@kernel.org>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, linux-ide@vger.kernel.org,
       Jeff Garzik <jgarzik@pobox.com>, Mark Lord <liml@rtr.ca>
Subject: Re: XFS shutting down due to IO timeout on SATA disk (pata_via for
 CX700)
Message-ID: <20080916102152.3f35439f@pluto.restena.lu>
In-Reply-To: <48CEC8F2.4040904@kernel.org>
References: <20080911193511.7960bc82@neptune.home>
	<48CE22E5.9090403@kernel.org>
	<20080915190242.58d21a8f@neptune.home>
	<48CEC8F2.4040904@kernel.org>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Mon, 15 Sep 2008 Tejun Heo <tj@kernel.org> wrote:
> >> Timeout on FLUSH_EXT.  That's a bad sign.  Patch to retry FLUSH is
> >> pending but at any rate FLUSH failure is often accompanied by loss
> >> of data and XFS is doing the right thing of giving up on it.
> >>
> >> Can you please post the result of "smartctl -a /dev/sda"?
> > I checked it though there were no errors logged nor any other
> > information that would catch attention. The disk/machine is pretty
> > unused (a year old but low uptime, a few hours those days with
> > uptime)
> > 
> > Anyhow smaprtctl's output is blow.
> > 
> 
> >   5 Reallocated_Sector_Ct   0x0033   100   100   024    Pre-fail
> > Always       -       8589934592000
> 
> Whee... That's unusally high realloc count but I'm not sure whether it
> indicates actual problem or it's just the drive's way of saying I'm
> okay.  But this does look quite suspicious.
> 
> > 196 Reallocated_Event_Count 0x0032   100   100   000    Old_age
> > Always       -       441778176
> 
> Hmmm.. Do you happen to have drives of the same model?  If so, can you
> please check what other drives are reporting?
> 
I don't have other drives of the same model, but 3 ones slightly smaller
in size and previous generation, those are just a few months older (but
also have way more uptime), see below for the smartctl output. I've never
seen ATA errors on them.
These other drives are running on AMD based platform, SB600 SATA with AHCI.


Just for the record, on the VIA there were no errors yet with
2.6.27-rc6-git3 though I ran some compiling on it. As such it *could* be
that one of the patches pushed by Jeff helped:
  [libata] LBA28/LBA48 off-by-one bug in ata.h
  sata_inic162x: enable LED blinking
  ata: duplicate variable sparse warning

Bruno


=============== first drive ====================
smartctl version 5.38 [x86_64-pc-linux-gnu] Copyright (C) 2002-8 Bruce Allen
Home page is http://smartmontools.sourceforge.net/

=== START OF INFORMATION SECTION ===
Model Family:     Fujitsu MHW2 BH
Device Model:     FUJITSU MHW2160BH
Serial Number:    K102T7727YER
Firmware Version: 0000001C
User Capacity:    160,041,885,696 bytes
Device is:        In smartctl database [for details use: -P show]
ATA Version is:   8
ATA Standard is:  ATA-8-ACS revision 3b
Local Time is:    Tue Sep 16 09:50:34 2008 CEST
SMART support is: Available - device has SMART capability.
SMART support is: Enabled

=== START OF READ SMART DATA SECTION ===
SMART overall-health self-assessment test result: PASSED

General SMART Values:
Offline data collection status:  (0x00) Offline data collection activity
                                        was never started.
                                        Auto Offline Data Collection: Disabled.
Self-test execution status:      (   0) The previous self-test routine completed
                                        without error or no self-test has ever
                                        been run.
Total time to complete Offline
data collection:                 ( 649) seconds.
Offline data collection
capabilities:                    (0x7b) SMART execute Offline immediate.
                                        Auto Offline data collection on/off support.
                                        Suspend Offline collection upon new
                                        command.
                                        Offline surface scan supported.
                                        Self-test supported.
                                        Conveyance Self-test supported.
                                        Selective Self-test supported.
SMART capabilities:            (0x0003) Saves SMART data before entering
                                        power-saving mode.
                                        Supports SMART auto save timer.
Error logging capability:        (0x01) Error logging supported.
                                        General Purpose Logging supported.
Short self-test routine
recommended polling time:        (   2) minutes.
Extended self-test routine
recommended polling time:        (  92) minutes.
Conveyance self-test routine
recommended polling time:        (   2) minutes.
SCT capabilities:              (0x003d) SCT Status supported.
                                        SCT Feature Control supported.
                                        SCT Data Table supported.

SMART Attributes Data Structure revision number: 16
Vendor Specific SMART Attributes with Thresholds:
ID# ATTRIBUTE_NAME          FLAG     VALUE WORST THRESH TYPE      UPDATED  WHEN_FAILED RAW_VALUE
  1 Raw_Read_Error_Rate     0x000f   100   100   046    Pre-fail  Always       -       117083
  2 Throughput_Performance  0x0005   100   100   030    Pre-fail  Offline      -       38797312
  3 Spin_Up_Time            0x0003   100   100   025    Pre-fail  Always       -       1
  4 Start_Stop_Count        0x0032   099   099   000    Old_age   Always       -       452
  5 Reallocated_Sector_Ct   0x0033   100   100   024    Pre-fail  Always       -       8589934592000
  7 Seek_Error_Rate         0x000f   100   100   047    Pre-fail  Always       -       1461
  8 Seek_Time_Performance   0x0005   100   100   019    Pre-fail  Offline      -       0
  9 Power_On_Hours          0x0032   092   092   000    Old_age   Always       -       4125
 10 Spin_Retry_Count        0x0013   100   100   020    Pre-fail  Always       -       0
 12 Power_Cycle_Count       0x0032   100   100   000    Old_age   Always       -       451
192 Power-Off_Retract_Count 0x0032   100   100   000    Old_age   Always       -       13
193 Load_Cycle_Count        0x0032   098   098   000    Old_age   Always       -       42607
194 Temperature_Celsius     0x0022   100   100   000    Old_age   Always       -       30 (Lifetime Min/Max 20/39)
195 Hardware_ECC_Recovered  0x001a   100   100   000    Old_age   Always       -       31
196 Reallocated_Event_Count 0x0032   100   100   000    Old_age   Always       -       457375744
197 Current_Pending_Sector  0x0012   100   100   000    Old_age   Always       -       0
198 Offline_Uncorrectable   0x0010   100   100   000    Old_age   Offline      -       0
199 UDMA_CRC_Error_Count    0x003e   200   200   000    Old_age   Always       -       0
200 Multi_Zone_Error_Rate   0x000f   100   100   060    Pre-fail  Always       -       1978
203 Run_Out_Cancel          0x0002   100   100   000    Old_age   Always       -       2628559175426
240 Head_Flying_Hours       0x003e   200   200   000    Old_age   Always       -       0

SMART Error Log Version: 1
No Errors Logged

SMART Self-test log structure revision number 1
No self-tests have been logged.  [To run self-tests, use: smartctl -t]


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

=================== second drive ====================
smartctl version 5.38 [x86_64-pc-linux-gnu] Copyright (C) 2002-8 Bruce Allen
Home page is http://smartmontools.sourceforge.net/

=== START OF INFORMATION SECTION ===
Model Family:     Fujitsu MHW2 BH
Device Model:     FUJITSU MHW2160BH
Serial Number:    K102T7727YH5
Firmware Version: 0000001C
User Capacity:    160,041,885,696 bytes
Device is:        In smartctl database [for details use: -P show]
ATA Version is:   8
ATA Standard is:  ATA-8-ACS revision 3b
Local Time is:    Tue Sep 16 10:16:17 2008 CEST
SMART support is: Available - device has SMART capability.
SMART support is: Enabled

=== START OF READ SMART DATA SECTION ===
SMART overall-health self-assessment test result: PASSED

General SMART Values:
Offline data collection status:  (0x00) Offline data collection activity
                                        was never started.
                                        Auto Offline Data Collection: Disabled.
Self-test execution status:      (   0) The previous self-test routine completed
                                        without error or no self-test has ever
                                        been run.
Total time to complete Offline
data collection:                 ( 649) seconds.
Offline data collection
capabilities:                    (0x7b) SMART execute Offline immediate.
                                        Auto Offline data collection on/off support.
                                        Suspend Offline collection upon new
                                        command.
                                        Offline surface scan supported.
                                        Self-test supported.
                                        Conveyance Self-test supported.
                                        Selective Self-test supported.
SMART capabilities:            (0x0003) Saves SMART data before entering
                                        power-saving mode.
                                        Supports SMART auto save timer.
Error logging capability:        (0x01) Error logging supported.
                                        General Purpose Logging supported.
Short self-test routine
recommended polling time:        (   2) minutes.
Extended self-test routine
recommended polling time:        (  92) minutes.
Conveyance self-test routine
recommended polling time:        (   2) minutes.
SCT capabilities:              (0x003d) SCT Status supported.
                                        SCT Feature Control supported.
                                        SCT Data Table supported.

SMART Attributes Data Structure revision number: 16
Vendor Specific SMART Attributes with Thresholds:
ID# ATTRIBUTE_NAME          FLAG     VALUE WORST THRESH TYPE      UPDATED  WHEN_FAILED RAW_VALUE
  1 Raw_Read_Error_Rate     0x000f   100   100   046    Pre-fail  Always       -       107032
  2 Throughput_Performance  0x0005   100   100   030    Pre-fail  Offline      -       39190528
  3 Spin_Up_Time            0x0003   100   100   025    Pre-fail  Always       -       1
  4 Start_Stop_Count        0x0032   099   099   000    Old_age   Always       -       454
  5 Reallocated_Sector_Ct   0x0033   100   100   024    Pre-fail  Always       -       8589934592000
  7 Seek_Error_Rate         0x000f   100   100   047    Pre-fail  Always       -       841
  8 Seek_Time_Performance   0x0005   100   100   019    Pre-fail  Offline      -       0
  9 Power_On_Hours          0x0032   092   092   000    Old_age   Always       -       4158
 10 Spin_Retry_Count        0x0013   100   100   020    Pre-fail  Always       -       0
 12 Power_Cycle_Count       0x0032   100   100   000    Old_age   Always       -       453
192 Power-Off_Retract_Count 0x0032   100   100   000    Old_age   Always       -       10
193 Load_Cycle_Count        0x0032   098   098   000    Old_age   Always       -       56896
194 Temperature_Celsius     0x0022   100   100   000    Old_age   Always       -       29 (Lifetime Min/Max 19/36)
195 Hardware_ECC_Recovered  0x001a   100   100   000    Old_age   Always       -       412
196 Reallocated_Event_Count 0x0032   100   100   000    Old_age   Always       -       412483584
197 Current_Pending_Sector  0x0012   100   100   000    Old_age   Always       -       0
198 Offline_Uncorrectable   0x0010   100   100   000    Old_age   Offline      -       0
199 UDMA_CRC_Error_Count    0x003e   200   200   000    Old_age   Always       -       0
200 Multi_Zone_Error_Rate   0x000f   100   100   060    Pre-fail  Always       -       8190
203 Run_Out_Cancel          0x0002   100   100   000    Old_age   Always       -       3732267335218
240 Head_Flying_Hours       0x003e   200   200   000    Old_age   Always       -       0

SMART Error Log Version: 1
No Errors Logged

SMART Self-test log structure revision number 1
No self-tests have been logged.  [To run self-tests, use: smartctl -t]


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

=========== third drive ========================
smartctl version 5.38 [x86_64-pc-linux-gnu] Copyright (C) 2002-8 Bruce Allen
Home page is http://smartmontools.sourceforge.net/

=== START OF INFORMATION SECTION ===
Model Family:     Fujitsu MHW2 BH
Device Model:     FUJITSU MHW2160BH
Serial Number:    K102T7727YFK
Firmware Version: 0000001C
User Capacity:    160,041,885,696 bytes
Device is:        In smartctl database [for details use: -P show]
ATA Version is:   8
ATA Standard is:  ATA-8-ACS revision 3b
Local Time is:    Tue Sep 16 10:17:49 2008 CEST
SMART support is: Available - device has SMART capability.
SMART support is: Enabled

=== START OF READ SMART DATA SECTION ===
SMART overall-health self-assessment test result: PASSED

General SMART Values:
Offline data collection status:  (0x00) Offline data collection activity
                                        was never started.
                                        Auto Offline Data Collection: Disabled.
Self-test execution status:      (   0) The previous self-test routine completed
                                        without error or no self-test has ever
                                        been run.
Total time to complete Offline
data collection:                 ( 649) seconds.
Offline data collection
capabilities:                    (0x7b) SMART execute Offline immediate.
                                        Auto Offline data collection on/off support.
                                        Suspend Offline collection upon new
                                        command.
                                        Offline surface scan supported.
                                        Self-test supported.
                                        Conveyance Self-test supported.
                                        Selective Self-test supported.
SMART capabilities:            (0x0003) Saves SMART data before entering
                                        power-saving mode.
                                        Supports SMART auto save timer.
Error logging capability:        (0x01) Error logging supported.
                                        General Purpose Logging supported.
Short self-test routine
recommended polling time:        (   2) minutes.
Extended self-test routine
recommended polling time:        (  92) minutes.
Conveyance self-test routine
recommended polling time:        (   2) minutes.
SCT capabilities:              (0x003d) SCT Status supported.
                                        SCT Feature Control supported.
                                        SCT Data Table supported.

SMART Attributes Data Structure revision number: 16
Vendor Specific SMART Attributes with Thresholds:
ID# ATTRIBUTE_NAME          FLAG     VALUE WORST THRESH TYPE      UPDATED  WHEN_FAILED RAW_VALUE
  1 Raw_Read_Error_Rate     0x000f   100   100   046    Pre-fail  Always       -       183032
  2 Throughput_Performance  0x0005   100   100   030    Pre-fail  Offline      -       38862848
  3 Spin_Up_Time            0x0003   100   100   025    Pre-fail  Always       -       1
  4 Start_Stop_Count        0x0032   099   099   000    Old_age   Always       -       452
  5 Reallocated_Sector_Ct   0x0033   100   100   024    Pre-fail  Always       -       8589934592000
  7 Seek_Error_Rate         0x000f   100   100   047    Pre-fail  Always       -       997
  8 Seek_Time_Performance   0x0005   100   100   019    Pre-fail  Offline      -       0
  9 Power_On_Hours          0x0032   092   092   000    Old_age   Always       -       4114
 10 Spin_Retry_Count        0x0013   100   100   020    Pre-fail  Always       -       0
 12 Power_Cycle_Count       0x0032   100   100   000    Old_age   Always       -       451
192 Power-Off_Retract_Count 0x0032   100   100   000    Old_age   Always       -       15
193 Load_Cycle_Count        0x0032   098   098   000    Old_age   Always       -       46692
194 Temperature_Celsius     0x0022   100   100   000    Old_age   Always       -       30 (Lifetime Min/Max 20/39)
195 Hardware_ECC_Recovered  0x001a   100   100   000    Old_age   Always       -       492
196 Reallocated_Event_Count 0x0032   100   100   000    Old_age   Always       -       422903808
197 Current_Pending_Sector  0x0012   100   100   000    Old_age   Always       -       0
198 Offline_Uncorrectable   0x0010   100   100   000    Old_age   Offline      -       0
199 UDMA_CRC_Error_Count    0x003e   200   200   000    Old_age   Always       -       0
200 Multi_Zone_Error_Rate   0x000f   100   100   060    Pre-fail  Always       -       5669
203 Run_Out_Cancel          0x0002   100   100   000    Old_age   Always       -       3732273955621
240 Head_Flying_Hours       0x003e   200   200   000    Old_age   Always       -       0

SMART Error Log Version: 1
No Errors Logged

SMART Self-test log structure revision number 1
No self-tests have been logged.  [To run self-tests, use: smartctl -t]


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
