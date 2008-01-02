Return-Path: <linux-kernel-owner+w=401wt.eu-S1756962AbYABDZu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756962AbYABDZu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jan 2008 22:25:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754255AbYABDZl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jan 2008 22:25:41 -0500
Received: from rv-out-0910.google.com ([209.85.198.189]:10527 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753760AbYABDZi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jan 2008 22:25:38 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=pogtL6pc+Zmo/Az4QBT3FAeqa/L9h3lMh0lxI2yHN+2mgRwPvzRYELLvNUgATW3ZSUqBh142c5EgvXyDhLtRq89pHYl5hP/9w2Ir1CP0msfsa+9gz1KBn/Cxj+/eBSGdZ/Hcw5BGr5R0K4NvV8gi4gL5SGBn/9x3Rg4wW3L4GzQ=
Message-ID: <477B0429.7040909@gmail.com>
Date: Wed, 02 Jan 2008 12:25:29 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Gabor Gombas <gombasg@sztaki.hu>
CC: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       Robert Hancock <hancockr@shaw.ca>, kluo@nvidia.com, AMartin@nvidia.com,
       pchen@nvidia.com
Subject: Re: sata_nv + ADMA + Samsung disk problem
References: <20070808120804.GB5257@boogie.lpds.sztaki.hu> <20080101164416.GA29574@boogie.lpds.sztaki.hu>
In-Reply-To: <20080101164416.GA29574@boogie.lpds.sztaki.hu>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[cc'ing Robert Hancock and NVidia people]

Whole thread can be read from the following URL.

  http://thread.gmane.org/gmane.linux.ide/21710

In a nutshell, with ADMA enabled, FLUSH_EXT occasionally times out.  I
first suspected faulty disk (reallocation failure on flush) but SMART
reports nothing suspicious and w/ ADMA disabled, the drive works just fine.

On a side note, on 2.6.22.1, SMART fails from time to time but the
problem went away on 2.6.24-rc6.  This was apparently fixed during that
period.  I guess we can ignore this for now.

Thanks.

Gabor Gombas wrote:
> Hi,
> 
> Just FYI I've tried to enable ADMA again (now running 2.6.24-rc6) but
> the bug is still present:
> 
> Jan  1 16:11:21 host kernel: ata7: EH in ADMA mode, notifier 0x0 notifier_error 0x0 gen_ctl 0x1501000 status 0x400 next cpb count 0x0 next cpb idx 0x0
> Jan  1 16:11:21 host kernel: ata7: CPB 0: ctl_flags 0x9, resp_flags 0x0
> Jan  1 16:11:21 host kernel: ata7: timeout waiting for ADMA IDLE, stat=0x400
> Jan  1 16:11:21 host kernel: ata7: timeout waiting for ADMA LEGACY, stat=0x400
> Jan  1 16:11:21 host kernel: ata7.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2 frozen
> Jan  1 16:11:21 host kernel: ata7.00: cmd ea/00:00:00:00:00/00:00:00:00:00/a0 tag 0
> Jan  1 16:11:21 host kernel:          res 40/00:00:00:4f:c2/00:00:00:00:00/00 Emask 0x4 (timeout)
> Jan  1 16:11:21 host kernel: ata7.00: status: { DRDY }
> Jan  1 16:11:21 host kernel: ata7: soft resetting link
> Jan  1 16:11:22 host kernel: ata7: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
> Jan  1 16:11:22 host kernel: ata7.00: configured for UDMA/133
> Jan  1 16:11:22 host kernel: ata7: EH complete
> Jan  1 16:11:22 host kernel: sd 6:0:0:0: [sdc] 488397168 512-byte hardware sectors (250059 MB)
> Jan  1 16:11:22 host kernel: sd 6:0:0:0: [sdc] Write Protect is off
> Jan  1 16:11:22 host kernel: sd 6:0:0:0: [sdc] Mode Sense: 00 3a 00 00
> Jan  1 16:11:22 host kernel: sd 6:0:0:0: [sdc] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
> 
> Although this time the above happened more than 3 hours after boot
> which is much better than 2.6.22 was. In the past ~4 months ADMA was
> disabled and I never had any libata-related error messages.
> 
> SMART does not show anything interesting:
> 
> smartctl version 5.37 [x86_64-unknown-linux-gnu] Copyright (C) 2002-6 Bruce Allen
> Home page is http://smartmontools.sourceforge.net/
> 
> === START OF INFORMATION SECTION ===
> Model Family:     SAMSUNG SpinPoint P120 series
> Device Model:     SAMSUNG SP2504C
> Serial Number:    XXXXXXXXXXXXXX
> Firmware Version: VT100-33
> User Capacity:    250,059,350,016 bytes
> Device is:        In smartctl database [for details use: -P show]
> ATA Version is:   7
> ATA Standard is:  ATA/ATAPI-7 T13 1532D revision 4a
> Local Time is:    Tue Jan  1 17:38:21 2008 CET
> SMART support is: Available - device has SMART capability.
> SMART support is: Enabled
> 
> === START OF READ SMART DATA SECTION ===
> SMART overall-health self-assessment test result: PASSED
> 
> General SMART Values:
> Offline data collection status:  (0x82)	Offline data collection activity
> 					was completed without error.
> 					Auto Offline Data Collection: Enabled.
> Self-test execution status:      (   0)	The previous self-test routine completed
> 					without error or no self-test has ever 
> 					been run.
> Total time to complete Offline 
> data collection: 		 (4867) seconds.
> Offline data collection
> capabilities: 			 (0x5b) SMART execute Offline immediate.
> 					Auto Offline data collection on/off support.
> 					Suspend Offline collection upon new
> 					command.
> 					Offline surface scan supported.
> 					Self-test supported.
> 					No Conveyance Self-test supported.
> 					Selective Self-test supported.
> SMART capabilities:            (0x0003)	Saves SMART data before entering
> 					power-saving mode.
> 					Supports SMART auto save timer.
> Error logging capability:        (0x01)	Error logging supported.
> 					General Purpose Logging supported.
> Short self-test routine 
> recommended polling time: 	 (   1) minutes.
> Extended self-test routine
> recommended polling time: 	 (  81) minutes.
> 
> SMART Attributes Data Structure revision number: 16
> Vendor Specific SMART Attributes with Thresholds:
> ID# ATTRIBUTE_NAME          FLAG     VALUE WORST THRESH TYPE      UPDATED  WHEN_FAILED RAW_VALUE
>   1 Raw_Read_Error_Rate     0x000f   100   100   051    Pre-fail  Always       -       0
>   3 Spin_Up_Time            0x0007   100   100   025    Pre-fail  Always       -       6144
>   4 Start_Stop_Count        0x0032   099   099   000    Old_age   Always       -       1218
>   5 Reallocated_Sector_Ct   0x0033   253   253   010    Pre-fail  Always       -       0
>   7 Seek_Error_Rate         0x000f   253   253   051    Pre-fail  Always       -       0
>   8 Seek_Time_Performance   0x0025   253   253   015    Pre-fail  Offline      -       11363
>   9 Power_On_Hours          0x0032   100   100   000    Old_age   Always       -       3325
>  10 Spin_Retry_Count        0x0033   253   253   051    Pre-fail  Always       -       0
>  11 Calibration_Retry_Count 0x0012   253   002   000    Old_age   Always       -       0
>  12 Power_Cycle_Count       0x0032   100   100   000    Old_age   Always       -       985
> 190 Temperature_Celsius     0x0022   160   124   000    Old_age   Always       -       26
> 194 Temperature_Celsius     0x0022   160   124   000    Old_age   Always       -       26
> 195 Hardware_ECC_Recovered  0x001a   100   100   000    Old_age   Always       -       4346055
> 196 Reallocated_Event_Count 0x0032   253   253   000    Old_age   Always       -       0
> 197 Current_Pending_Sector  0x0012   253   253   000    Old_age   Always       -       0
> 198 Offline_Uncorrectable   0x0030   253   253   000    Old_age   Offline      -       0
> 199 UDMA_CRC_Error_Count    0x003e   200   200   000    Old_age   Always       -       0
> 200 Multi_Zone_Error_Rate   0x000a   100   100   000    Old_age   Always       -       0
> 201 Soft_Read_Error_Rate    0x000a   253   100   000    Old_age   Always       -       0
> 202 TA_Increase_Count       0x0032   253   253   000    Old_age   Always       -       0
> 
> SMART Error Log Version: 1
> No Errors Logged
> 
> SMART Self-test log structure revision number 1
> Num  Test_Description    Status                  Remaining  LifeTime(hours)  LBA_of_first_error
> # 1  Short offline       Completed without error       00%      3315         -
> # 2  Short offline       Completed without error       00%      3298         -
> # 3  Short offline       Completed without error       00%      3268         -
> # 4  Extended offline    Completed without error       00%      3262         -
> # 5  Short offline       Completed without error       00%      3243         -
> # 6  Short offline       Completed without error       00%      3236         -
> # 7  Short offline       Completed without error       00%      3228         -
> # 8  Extended offline    Completed without error       00%      3218         -
> # 9  Short offline       Completed without error       00%      3186         -
> #10  Short offline       Completed without error       00%      3178         -
> #11  Short offline       Completed without error       00%      3175         -
> #12  Short offline       Completed without error       00%      3165         -
> #13  Short offline       Completed without error       00%      3155         -
> #14  Short offline       Completed without error       00%      3146         -
> #15  Short offline       Completed without error       00%      3139         -
> #16  Extended offline    Completed without error       00%      3135         -
> #17  Short offline       Completed without error       00%      3125         -
> #18  Extended offline    Completed without error       00%      3082         -
> #19  Short offline       Completed without error       00%      3068         -
> #20  Short offline       Completed without error       00%      3066         -
> #21  Short offline       Completed without error       00%      3052         -
> 
> SMART Selective Self-Test Log Data Structure Revision Number (0) should be 1
> SMART Selective self-test log data structure revision number 0
> Warning: ATA Specification requires selective self-test log data structure revision number = 1
>  SPAN  MIN_LBA  MAX_LBA  CURRENT_TEST_STATUS
>     1        0        0  Not_testing
>     2        0        0  Not_testing
>     3        0        0  Not_testing
>     4        0        0  Not_testing
>     5        0        0  Not_testing
> Selective self-test flags (0x0):
>   After scanning selected spans, do NOT read-scan remainder of disk.
> If Selective self-test is pending on power-up, resume after 0 minute delay.
> 
> Gabor
> 

-- 
tejun
