Return-Path: <linux-kernel-owner+w=401wt.eu-S1753434AbYHLLop@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753434AbYHLLop (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2008 07:44:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752172AbYHLLog
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Aug 2008 07:44:36 -0400
Received: from mx1.redhat.com ([66.187.233.31]:58919 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752119AbYHLLof (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2008 07:44:35 -0400
Message-ID: <48A1779B.5020303@redhat.com>
Date: Tue, 12 Aug 2008 13:44:27 +0200
From: Milan Broz <mbroz@redhat.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Pavel Machek <pavel@suse.cz>
CC: Andi Kleen <andi@firstfloor.org>,
       kernel list <linux-kernel@vger.kernel.org>,
       ACPI mailing list <linux-acpi@vger.kernel.org>
Subject: Re: 2.6.27-rc1: critical thermal shutdown on thinkpad x60
References: <20080806090246.GA1572@elf.ucw.cz> <87bq046cht.fsf@basil.nowhere.org> <20080812094135.GA1565@elf.ucw.cz> <20080812105409.GA1366@one.firstfloor.org> <48A16EFC.1050401@redhat.com> <20080812112602.GA2948@elf.ucw.cz>
In-Reply-To: <20080812112602.GA2948@elf.ucw.cz>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Machek wrote:
> Hi!
>>> On Tue, Aug 12, 2008 at 11:41:35AM +0200, Pavel Machek wrote:
>>>>>> Aug  6 11:00:10 amd kernel: ACPI: Critical trip point
>>>>>> Aug  6 11:00:10 amd kernel: Critical temperature reached (128 C),
>>>>>> shutting down.
>>>>>> Aug  6 11:00:10 amd shutdown[24414]: shutting down for system halt
>>>>>>
>>>>>> ...and machine went down at that point :-(.
>>>>> I hope you can easily reproduce it?
>>>>>
>>>>> So it's new in 2.6.27rc1 and wasn't in 2.6.26? Can you please
>>>> Yes, I'm very sure. It makes machine basically unusable.
>>> Does this mean you can easily reproduce it?  
>>> Please do a bisect then. 
>>>
>>>> Not that one :-(. Thinkpad does not even have fan device: it is
>>>> controlled by hardware.
>> Hi,
>> I see exactly the same on my x60s, but during upgrade to 2.6.26.2.
> 
> Are you sure?

yes. maybe some userspace tool controlling frequency is involved, no idea yet.
But it is 2.6.26 tree for sure.

> 
>> I found that (at least in my case) the problem is, that in
>> 2.6.25 the core frequency drop to 1GHz (instead of 1.67GHz) when
>> the temperature is above some limit.
> 
> Can you verify that 2.6.26 is okay?

No, it is not ok.
I'll run bisect again, but I hit it at least one in some 2.6.26-rc too.

> 
>> Now, the CPU cores remains on 1.67GHz and fan is unable to cool them properly
>> under heavy load (even if I set "level disengaged" through thinkpad fan control,
>> temperature sensor shows after a while 128 C (probably not real temp,
>> I expect some critical flag => and it properly switch off the
>> system...)
> 
> How do you control fans? I could not get anything but -EINVAL from IBM
> ACPI driver :-(.

you need add fan_control=1 to thinkpad_acpi module

http://www.thinkwiki.org/wiki/How_to_control_fan_speed
http://www.thinkwiki.org/wiki/ACPI_fan_control_script


>> (I had bad reproducer script in bisect and bisect failed, so I'll try it again,
>> but anyway, for me the bug is even in 2.6.26 tree. It never happened in 2.6.25.)
> 
> Hmmm... that's seriously strange. I definitely don't see it in
> 2.6.26. Maybe it is config dependend?! (Attaching my 2.6.27-rc2
> failing config.)

hm. strange, I'll try this config too...

Milan
