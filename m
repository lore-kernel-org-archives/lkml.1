Return-Path: <linux-kernel-owner+w=401wt.eu-S1756776AbZBKT0X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756776AbZBKT0X (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Feb 2009 14:26:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751833AbZBKT0O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Feb 2009 14:26:14 -0500
Received: from cdptpa-omtalb.mail.rr.com ([75.180.132.121]:33259 "EHLO
	cdptpa-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750875AbZBKT0N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Feb 2009 14:26:13 -0500
Message-ID: <49932655.2020702@intertwingly.net>
Date: Wed, 11 Feb 2009 14:26:13 -0500
From: Sam Ruby <rubys@intertwingly.net>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: yakui_zhao <yakui.zhao@intel.com>
CC: Len Brown <lenb@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
       "x86@kernel.org" <x86@kernel.org>,
       "Maciej W. Rozycki" <macro@linux-mips.org>
Subject: Re: [APIC] Kernel panic, rsync corruption, intel q8200, 2.6.28-rc8
References: <4978767D.4060700@intertwingly.net>	 <20090130000758.1dff0113.akpm@linux-foundation.org>	 <498885CC.4060509@intertwingly.net>	 <20090203114849.b661f1ce.akpm@linux-foundation.org>	 <alpine.LFD.2.00.0902032152180.22800@localhost.localdomain>	 <49890B46.8020308@intertwingly.net>	 <alpine.LFD.2.00.0902032336000.5607@localhost.localdomain>	 <4990C14B.7060802@intertwingly.net>	 <1234231805.3706.80.camel@localhost.localdomain>	 <49916927.9080200@intertwingly.net> <1234316533.3706.104.camel@localhost.localdomain>
In-Reply-To: <1234316533.3706.104.camel@localhost.localdomain>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

yakui_zhao wrote:
> On Tue, 2009-02-10 at 19:46 +0800, Sam Ruby wrote:
>> yakui_zhao wrote:
>>> On Tue, 2009-02-10 at 07:50 +0800, Sam Ruby wrote:
>>>> Len Brown wrote:
>>>>>>> Do you have a second computer around with a serial port ? If yes, then
>>>>>>> please add the following to the kernel command line:
>>>>>>>
>>>>>>>        earlyprintk=serial,ttyS0,115200 apic=debug
>>>>>>>
>>>>>>> and connect the serial ports with a null modem cable. Fire up a
>>>>>>> terminal program on the second machine and capture the output.
>>>>>> I do have a second computer, and went out and bought a null modem adapter for
>>>>>> my serial cable and connected the two machines.  I've tried installing minicom
>>>>>> and also connecting it to ttyS0 at 115200 baud on the second machine, but when
>>>>>> I boot the first machine I don't see any output on the terminal.
>>>>> /boot/grub/menu.lst:
>>>>>
>>>>> serial --unit=0 --speed=115200 --word=8 --parity=no --stop=1
>>>>> terminal --timeout=300 serial console
>>> Do you have an opportunity to try the boot option of "acpi=off" as
>>> suggested by Lenb?
>> That also produces the "MP-BIOS bug" message and halts.
> Do you mean that the box still can't be booted with ACPI disabled? If
> so, it should be a BIOS bug. It had better be fixed by bios upgrading.

BIOS information, in case it is helpful to anyone:

http://intertwingly.net/stories/2009/02/11/dmidecode.out

>    From the following test it seems that there exists the MPS table,
> which describes how the timer is connected with I/O APIC. But
> unfortunately it is still incorrect. 
>    And the timer still can't work w/o the timer override.
>    
>    Only when I/O apic is skipped can the box be booted. The timer is
> connected with 8259.  And the timer can work as expected. But there
> still exist other issue.
>     
>>>      From the log it seems that there exists the following warning
>>> message:
>>>     >﻿MP-BIOS bug: 8254 timer not connected to IO-APIC
>>>
>>>     Can you try the following boot options?
>>>     a. acpi_use_timer_override
>> That also produces the "MP-BIOS bug" message and halts.
>>
>>>     b. acpi_skip_timer_override
>> That also produces the "MP-BIOS bug" message and halts.
>>
>>>     c. noapic
>> With that, I can boot, but I get data corruption problems.  Data 
>> corruption problems I don't see when using the same hardware but with 
>> Microsoft Vista.  More details can be found here:
>>
>> http://intertwingly.net/blog/2009/01/20/noAPIC
>> http://intertwingly.net/stories/2009/01/22/
>>
>> I am willing to install new kernels on fresh hard drives, run diagnostic 
>> programs and report the output, including capturing serial output.  Is 
>> there any data I can gather to help diagnose this problem?
>>
>>>     Thanks.
>>>>> is what I use.
>>>>>
>>>>> this will give you a prompt from grub even before the kernel boots
>>>>> so you can select (and edit) your kernel via menu over the serial line
>>>>> if you wish.
>>>> I've got that working now.  I used minicom on the remote machine, 
>>>> capturing the output.  You can see me fumbling around, editing the 
>>>> kernel command and booting here:
>>>>
>>>> http://intertwingly.net/stories/2009/02/09/minicom.out
>>>>
>>>> While it is difficult to make out what I did given line wrapping, etc, 
>>>> what I started with was:
>>>>
>>>> /boot/vmlinuz-2.6.27-11-generic 
>>>> root=UUID=4fce230e-fe72-4685-aab0-294ef1c20efa ro noapic quiet splash
>>>>
>>>> After editing, what I had was
>>>>
>>>> /boot/vmlinuz-2.6.27-11-generic 
>>>> root=UUID=4fce230e-fe72-4685-aab0-294ef1c20efa ro quiet splash 
>>>> earlyprintk=serial,ttyS0,115200 apic=debug
>>>>
>>>> As you can see, the last line I saw was "Starting up ...", after which 
>>>> point the "MP-BIOS bug: 8254 timer not connected to IO-APIC" etc output 
>>>> appeared on the monitor that is directly connected to the machine being 
>>>> booted (i.e., this text did not appear on the minicom session).
>>>>
>>>>> If this doesn't work, then the kernel earlyprintk is unlikely to work 
>>>>> also.
>>>> At the moment, it looks like it works, but earlyprintk does not work for 
>>>> me, at least not on Ubuntu 8.10, kernel 2.6.27-11-generic.
>>>>
>>>>> Note that there may be some BIOS SETUP options related to the serial port 
>>>>> -- worth checking.
>>>>>
>>>>> Also, in minicom, be sure to turn off HW flow control
>>>>>
>>>>> there is a fancy serial console document someplace on this,
>>>>> probably at http://tldp.org/
>>>> As I have managed to get grub to talk to the serial console, I did not 
>>>> explore these options further.  Please let me know if there is something 
>>>> in particular I should explore.
>>>>
>>>>> good luck,
>>>>> -Len
>>>> - Sam Ruby
>>>> --
>>>> To unsubscribe from this list: send the line "unsubscribe linux-acpi" in
>>>> the body of a message to majordomo@vger.kernel.org
>>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> - Sam Ruby
> 

