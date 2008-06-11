Return-Path: <linux-kernel-owner+w=401wt.eu-S1764064AbYFKQhv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764064AbYFKQhv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2008 12:37:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751045AbYFKQhn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jun 2008 12:37:43 -0400
Received: from fg-out-1718.google.com ([72.14.220.156]:7272 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750733AbYFKQhm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2008 12:37:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=PjtkWfG7hvY0H8b3ema1Q0nsdjqvavIu+gqV854TzVSW/4XSk+txu7O6f7cV3kCGKY
         6ocRoGPbiQjTZxgY9eQLYK+Cz5gnvSzn79FSXnWk5tzW0cZhXgyI/Q05s9AP3RjlkyLH
         GsX9cvOPwnd8FYeqdvKxy1vVmmMkWZ4paV+Ho=
Message-ID: <484FFF4E.9020007@gmail.com>
Date: Wed, 11 Jun 2008 19:37:34 +0300
From: Maxim Levitsky <maximlevitsky@gmail.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080505)
MIME-Version: 1.0
To: David Brownell <david-b@pacbell.net>
CC: Andrew Morton <akpm@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [patch 2.6.26-rc5] make HPET_RTC_IRQ track HPET_EMULATE_RTC
References: <200806052241.44713.david-b@pacbell.net> <200806061644.23449.maximlevitsky@gmail.com> <200806101431.21402.david-b@pacbell.net>
In-Reply-To: <200806101431.21402.david-b@pacbell.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Brownell wrote:
> On Friday 06 June 2008, Maxim Levitsky wrote:
> 
>> Remember long ago I had a discussion with you about HPET that
>> steals RTC irq in 'legacy replacement' mode, and rtc driver thus
>> implements rtc on 'top' of hpet.
>>
>> New rtc-cmos driver doesn't do this emulation, thus it isn't compatible
>> with hpet driver.
> 
> That was fixed in 9d8af78b07976d4d84e0df491abd4e9db848d0ad (February)
> by Bernhard Walle <bwalle@suse.de> ... if you look at the bug report
> associated with this patch, you'll see that rtc-cmos was working OK
> with HPET, it's just the legacy RTC driver which got confused after
> the recent updates to clock handling.
> 
> 
>> But there is a solution,  I didn't agree with firstly, but then I did, and
>> I do agree now, and that to put hpet in normal mode.
>>
>> What happened with patches that put hpet in normal independent mode?
> 
> The story from either Ingo or Thomas (I forget who) was that this is
> another case where we have to cope with BIOS braindamage.  Not enough
> BIOS vendors expose the relevant IRQ routing that Linux could default
> to using HPET in what I'd call "sane" mode.
> 
> Now, that still kind of implies there could be an option to use sane
> HPET IRQ configuration (doesn't hijack RTC and other IRQs, and there
> could be a per-CPU HPET) on at least the systems where that IRQ routing
> is available.  Over time I'd hope that systems like that could become
> the common case.  But ... someone else would have to do that work.  :)
> 
> - Dave

Thanks a lot, next time I compile the kernel, I will enable hpet

Best regards,
	Maxim Levitsky

PS:

This is a question to ubuntu devs, I need to ask them, when
they will switch to new rtc driver....

Old driver has some bugs, including no support for suspend/resume, some
troubles with alarm (it sets the alarm when writing to /proc/acpi/alarm, 
but it can be cleared by even just reading the time. New driver 
correctly sets the alarm at actual suspend time)
Even hpet emulation has some bugs, I even wrote some patches to fix this
and add suspend/resume, but I guess that newer driver is way better, so 
no need to fix old one.



