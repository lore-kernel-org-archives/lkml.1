Return-Path: <linux-kernel-owner+w=401wt.eu-S1755286AbYIORLx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755286AbYIORLx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2008 13:11:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753821AbYIORLm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Sep 2008 13:11:42 -0400
Received: from ppp-110-205.adsl.restena.lu ([158.64.110.205]:59304 "EHLO
	bonbons.gotdns.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753559AbYIORLk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2008 13:11:40 -0400
X-Greylist: delayed 532 seconds by postgrey-1.27 at vger.kernel.org; Mon, 15 Sep 2008 13:11:40 EDT
Date: Mon, 15 Sep 2008 19:02:42 +0200
From: Bruno =?UTF-8?B?UHLDqW1vbnQ=?= <bonbons@linux-vserver.org>
To: Tejun Heo <tj@kernel.org>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, linux-ide@vger.kernel.org,
       Jeff Garzik <jgarzik@pobox.com>
Subject: Re: XFS shutting down due to IO timeout on SATA disk (pata_via for
 CX700)
Message-ID: <20080915190242.58d21a8f@neptune.home>
In-Reply-To: <48CE22E5.9090403@kernel.org>
References: <20080911193511.7960bc82@neptune.home>
	<48CE22E5.9090403@kernel.org>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Mon, 15 September 2008 Tejun Heo <tj@kernel.org> wrote:
> (please try to wrap paragraphs for 80 column)
I try not to break lines from dmesg, lspci and and other commands'
(formatted) output as those tend to get pretty hard to read when
line-wrapped.
Sorry if I wrapped my text after 80 columns.

> > Kernel error output related to XFS shutdown:
> > [ 9352.420180] ata1.00: exception Emask 0x0 SAct 0x0 SErr 0x0
> > action 0x6 frozen [ 9352.420247] ata1.00: cmd
> > ea/00:00:00:00:00/00:00:00:00:00/a0 tag 0 [ 9352.420261]
> > res 40/00:01:00:4f:c2/00:00:00:00:00/00 Emask 0x4 (timeout)
> 
> Timeout on FLUSH_EXT.  That's a bad sign.  Patch to retry FLUSH is
> pending but at any rate FLUSH failure is often accompanied by loss of
> data and XFS is doing the right thing of giving up on it.
> 
> Can you please post the result of "smartctl -a /dev/sda"?
I checked it though there were no errors logged nor any other information
that would catch attention. The disk/machine is pretty unused (a year old
but low uptime, a few hours those days with uptime)

Anyhow smaprtctl's output is blow.

Bruno



smartctl version 5.38 [i686-pc-linux-gnu] Copyright (C) 2002-8 Bruce Allen
Home page is http://smartmontools.sourceforge.net/

=== START OF INFORMATION SECTION ===
Device Model:     FUJITSU MHY2250BH
Serial Number:    K407T7A25THF
Firmware Version: 0000000B
User Capacity:    250,059,350,016 bytes
Device is:        Not in smartctl database [for details use: -P showall]
ATA Version is:   8
ATA Standard is:  ATA-8-ACS revision 3f
Local Time is:    Mon Sep 15 18:52:53 2008 CEST
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
data collection:                 (1009) seconds.
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
recommended polling time:        ( 143) minutes.
Conveyance self-test routine
recommended polling time:        (   2) minutes.
SCT capabilities:              (0x003d) SCT Status supported.
                                        SCT Feature Control supported.
                                        SCT Data Table supported.

SMART Attributes Data Structure revision number: 16
Vendor Specific SMART Attributes with Thresholds:
ID# ATTRIBUTE_NAME          FLAG     VALUE WORST THRESH TYPE      UPDATED  WHEN_FAILED RAW_VALUE
  1 Raw_Read_Error_Rate     0x000f   100   100   046    Pre-fail  Always       -       189618
  2 Throughput_Performance  0x0005   100   100   030    Pre-fail  Offline      -       53870592
  3 Spin_Up_Time            0x0003   100   100   025    Pre-fail  Always       -       1
  4 Start_Stop_Count        0x0032   100   100   000    Old_age   Always       -       168
  5 Reallocated_Sector_Ct   0x0033   100   100   024    Pre-fail  Always       -       8589934592000
  7 Seek_Error_Rate         0x000f   100   100   047    Pre-fail  Always       -       679
  8 Seek_Time_Performance   0x0005   100   100   019    Pre-fail  Offline      -       0
  9 Power_On_Hours          0x0032   100   100   000    Old_age   Always       -       230
 10 Spin_Retry_Count        0x0013   100   100   020    Pre-fail  Always       -       0
 12 Power_Cycle_Count       0x0032   100   100   000    Old_age   Always       -       149
192 Power-Off_Retract_Count 0x0032   100   100   000    Old_age   Always       -       18
193 Load_Cycle_Count        0x0032   100   100   000    Old_age   Always       -       6674
194 Temperature_Celsius     0x0022   100   100   000    Old_age   Always       -       27 (Lifetime Min/Max 22/36)
195 Hardware_ECC_Recovered  0x001a   100   100   000    Old_age   Always       -       606
196 Reallocated_Event_Count 0x0032   100   100   000    Old_age   Always       -       441778176
197 Current_Pending_Sector  0x0012   100   100   000    Old_age   Always       -       0
198 Offline_Uncorrectable   0x0010   100   100   000    Old_age   Offline      -       0
199 UDMA_CRC_Error_Count    0x003e   200   253   000    Old_age   Always       -       0
200 Multi_Zone_Error_Rate   0x000f   100   100   060    Pre-fail  Always       -       10312
203 Run_Out_Cancel          0x0002   100   100   000    Old_age   Always       -       3728055731610
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

