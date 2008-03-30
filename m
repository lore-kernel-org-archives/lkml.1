Return-Path: <linux-kernel-owner+w=401wt.eu-S1752002AbYC3Ayj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752002AbYC3Ayj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Mar 2008 20:54:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750983AbYC3Ay3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Mar 2008 20:54:29 -0400
Received: from rv-out-0910.google.com ([209.85.198.186]:55024 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750962AbYC3Ay2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Mar 2008 20:54:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=QeYASX4WiGMF1Wh4HHPksRBW+HQ4Zpa2SU4D7pchvIkNXExLY8yuQUl9RDI0r49/8MUOxh47Ol5biTSJQOObgyeyPqLszfkRlBzHYLme1yGnm/TTfWfcXiJv1QJ1X/PRAXcxT779DoTPnJVqS/bfVVZxp6K8i8h9LEUeOvmw9NI=
Message-ID: <47EEE4BF.5080609@gmail.com>
Date: Sun, 30 Mar 2008 09:54:23 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Hans-Peter Jansen <hpj@urpla.net>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org
Subject: Re: 2.6.24.3: regular sata drive resets - worrisome?
References: <200803201518.32109.hpj@urpla.net> <20080320214830.6d39876d.akpm@linux-foundation.org> <47EE3CFA.2000707@gmail.com> <200803300114.40096.hpj@urpla.net>
In-Reply-To: <200803300114.40096.hpj@urpla.net>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Hans-Peter Jansen wrote:
>>>> Should I be worried? smartd doesn't show anything suspicious on those.
>> Can you please post the result of "smartctl -a /dev/sdX"?
> 
> Here's the last smart report from two of the offending drives. As noted 
> before, I did the hardware reorganization, replaced the dog slow 3ware 
> 9500S-8 and the SiI 3124 with a single Areca 1130 and retired the drives 
> for now, but a nephew already showed interest. What do you think, can I 
> cede those drives with a clear conscience? The Hardware_ECC_Recovered
> values are really worrisome, aren't they?

Different vendors use different scales for the raw values.  The value is 
still pegged at the highest so it could be those raw values are okay or 
that the vendor just doesn't update value field accordingly.  My P120 
says 0 for the raw value and 904635 for hardware ECC recovered so there 
is some difference.  What do other non-failing drives say about those 
values?

> SMART Attributes Data Structure revision number: 16
> Vendor Specific SMART Attributes with Thresholds:
> ID# ATTRIBUTE_NAME          FLAG     VALUE WORST THRESH TYPE      UPDATED  WHEN_FAILED RAW_VALUE
>   1 Raw_Read_Error_Rate     0x000f   100   100   051    Pre-fail  Always       -       82
>   3 Spin_Up_Time            0x0007   100   100   025    Pre-fail  Always       -       5952
>   4 Start_Stop_Count        0x0032   100   100   000    Old_age   Always       -       23
>   5 Reallocated_Sector_Ct   0x0033   253   253   010    Pre-fail  Always       -       0
>   7 Seek_Error_Rate         0x000f   253   253   051    Pre-fail  Always       -       0
>   8 Seek_Time_Performance   0x0025   253   253   015    Pre-fail  Offline      -       0
>   9 Power_On_Hours          0x0032   100   100   000    Old_age   Always       -       17647
>  10 Spin_Retry_Count        0x0033   253   253   051    Pre-fail  Always       -       0
>  11 Calibration_Retry_Count 0x0012   253   002   000    Old_age   Always       -       0
>  12 Power_Cycle_Count       0x0032   100   100   000    Old_age   Always       -       19
> 190 Airflow_Temperature_Cel 0x0022   124   124   000    Old_age   Always       -       38
> 194 Temperature_Celsius     0x0022   124   124   000    Old_age   Always       -       38
> 195 Hardware_ECC_Recovered  0x001a   100   100   000    Old_age   Always       -       162956700
> 196 Reallocated_Event_Count 0x0032   253   253   000    Old_age   Always       -       0
> 197 Current_Pending_Sector  0x0012   253   253   000    Old_age   Always       -       0
> 198 Offline_Uncorrectable   0x0030   253   253   000    Old_age   Offline      -       0
> 199 UDMA_CRC_Error_Count    0x003e   200   200   000    Old_age   Always       -       0
> 200 Multi_Zone_Error_Rate   0x000a   253   100   000    Old_age   Always       -       0
> 201 Soft_Read_Error_Rate    0x000a   100   100   000    Old_age   Always       -       0
> 202 TA_Increase_Count       0x0032   253   253   000    Old_age   Always       -       0

Hmmm... If the drive is failing FLUSHs, I would expect to see elevated 
reallocation counters and maybe some pending counts.  Aieee.. weird.

>>>> It's been 4 samsung drives at all hanging on a sata sil 3124:
>> FLUSH_EXT timing out usually indicates that the drive is having problem
>> writing out what it has in its cache to the media.  There was one case
>> where FLUSH_EXT timeout was caused by the driver failing to switch
>> controller back from NCQ mode before issuing FLUSH_EXT but that was on
>> sata_nv.  There hasn't been any similar problem on sata_sil24.
> 
> Hmm, I didn't noticed any data distortions, and if there where, they live
> on as copies in their new home.. 

It should have appeared as read errors.  Maybe the drive successfully 
wrote those sectors after 30+ secs timeout.

-- 
tejun
