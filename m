Return-Path: <linux-kernel-owner+w=401wt.eu-S1760083AbYEANUj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760083AbYEANUj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2008 09:20:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754055AbYEANUb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 May 2008 09:20:31 -0400
Received: from smtp-out03.alice-dsl.net ([88.44.63.5]:20272 "EHLO
	smtp-out03.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752728AbYEANUb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2008 09:20:31 -0400
Message-ID: <4819C35D.6000300@googlemail.com>
Date: Thu, 01 May 2008 15:19:25 +0200
From: Gabriel C <nix.or.die@googlemail.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080227)
MIME-Version: 1.0
To: Len Brown <lenb@kernel.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-pm@lists.linux-foundation.org, pavel@suse.cz,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: Some sort corruption of my Thermal Subsystem after suspend to
 ram
References: <4818D9AB.3040402@googlemail.com> <200805010157.58607.lenb@kernel.org>
In-Reply-To: <200805010157.58607.lenb@kernel.org>
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 01 May 2008 13:12:42.0946 (UTC) FILETIME=[0A2C1A20:01C8AB8D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Len Brown wrote:
> The ICH9 apparently provides a pair of memory mapped on-die thermal sensors.
> 
> The sensors basically shut off your hardware if it gets too hot.
> 
> ICH9 exports the base address for the sensors via a PCI device -- D31:F6, aka Linux 00:1f.6
> 
> I'm not aware of a native Linux device driver that talks to this device
> (nor can I think of a useful purpose for such a driver)
> So it seems what is in play here is any BIOS code that talks to this device,
> and Linux's standard PCI config space restore.
> 
> My guess is that the BIOS is enabling the device on cold boot,
> but not enabling it after resume from S3.
> Is there a BIOS SETUP option that controls if the ICH9 thermal device is enabled or not?

I have some options for the ASUS HW monitoring things where I can set fan profile and see the speed of the fans
but I cannot find something where I can enable/disable the whole thermal devices.

There is a option to ignore some fans but that is.

> 
> -Len
> 
> 
> 
> 
> On Wednesday 30 April 2008, Gabriel C wrote:
>> Hi all,
>>
>> I thought I've found all issue with that new box but I was wrong ;)
>>
>> On an ASUS P5E-VM DO , 4G RAM , Q9300 CPU after suspend to ram Thermal 
>> Subsystem gets corrupted in some way.
>>
>> I got some reboot , halt problems and was hunting the issue and noticed these problems only
>> occurred when I've suspend the box to ram , at least once.
>>
>> I've tested 2.6.{24*,25,linus-git(before ACPI merge),x86-latest-git} and all got that problem.
>>
>> Also on x86-latest-git I've tested with MTRR_SANITIZER on/off. It does not make any difference.
>>
>>
>> lspci output before s2r is :
>>
>> ..
>>
>>
>> 00:1f.6 Signal processing controller [1180]: Intel Corporation 82801I (ICH9 Family) Thermal Subsystem [8086:2932] (rev 02)
>>         Subsystem: ASUSTeK Computer Inc. Device [1043:8277]
>>         Flags: fast devsel
>>         Memory at fed08000 (64-bit, non-prefetchable) [size=4K]
>>         Capabilities: [50] Power Management version 3                                                                                                       
>>
>> ...
>>
>>
>> and after :
>>
>> ...
>>
>> 00:1f.6 Signal processing controller [1180]: Intel Corporation 82801I (ICH9 Family) Thermal Subsystem [8086:2932] (rev ff) (prog-if ff)
>>         !!! Unknown header type 7f
>>
>> ...
>>
>> dmesg | grep 00:1f.6
>> [21520.103062] PM: Writing back config space on device 0000:00:1f.6 at offset f (was ffffffff, writing 300)
>> [21520.103066] PM: Writing back config space on device 0000:00:1f.6 at offset e (was ffffffff, writing 0)
>> [21520.103070] PM: Writing back config space on device 0000:00:1f.6 at offset d (was ffffffff, writing 50)
>> [21520.103074] PM: Writing back config space on device 0000:00:1f.6 at offset c (was ffffffff, writing 0)
>> [21520.103078] PM: Writing back config space on device 0000:00:1f.6 at offset b (was ffffffff, writing 82771043)
>> [21520.103083] PM: Writing back config space on device 0000:00:1f.6 at offset a (was ffffffff, writing 0)
>> [21520.103087] PM: Writing back config space on device 0000:00:1f.6 at offset 9 (was ffffffff, writing 0)
>> [21520.103091] PM: Writing back config space on device 0000:00:1f.6 at offset 8 (was ffffffff, writing 0)
>> [21520.103095] PM: Writing back config space on device 0000:00:1f.6 at offset 7 (was ffffffff, writing 0)
>> [21520.103099] PM: Writing back config space on device 0000:00:1f.6 at offset 6 (was ffffffff, writing 0)
>> [21520.103103] PM: Writing back config space on device 0000:00:1f.6 at offset 5 (was ffffffff, writing 0)
>> [21520.103107] PM: Writing back config space on device 0000:00:1f.6 at offset 4 (was ffffffff, writing fed08004)
>> [21520.103111] PM: Writing back config space on device 0000:00:1f.6 at offset 3 (was ffffffff, writing 0)
>> [21520.103115] PM: Writing back config space on device 0000:00:1f.6 at offset 2 (was ffffffff, writing 11800002)
>> [21520.103119] PM: Writing back config space on device 0000:00:1f.6 at offset 1 (was ffffffff, writing 100002)
>> [21520.103123] PM: Writing back config space on device 0000:00:1f.6 at offset 0 (was ffffffff, writing 29328086)
>>
>> ..
>>
>>
>> Please let me know if you need my config , dmesg or any other informations.
>>
>>
>> Best Regards,
>>
>> Gabriel C
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/
>>
> 
> 
> 
