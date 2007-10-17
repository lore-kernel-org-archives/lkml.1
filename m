Return-Path: <linux-kernel-owner+w=401wt.eu-S1761593AbXJQMVN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761593AbXJQMVN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2007 08:21:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753062AbXJQMU6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Oct 2007 08:20:58 -0400
Received: from smtp4-g19.free.fr ([212.27.42.30]:41659 "EHLO smtp4-g19.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752942AbXJQMU5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2007 08:20:57 -0400
Message-ID: <4715FE27.2000802@free.fr>
Date: Wed, 17 Oct 2007 14:20:55 +0200
From: John Sigler <linux.kernel@free.fr>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061108 SeaMonkey/1.0.6
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
       linux-rt-users@vger.kernel.org
Subject: Re: NMI watchdog
References: <470F3BE0.4050807@free.fr> <Pine.LNX.4.58.0710120625380.8208@gandalf.stny.rr.com> <470F7620.6040705@free.fr> <Pine.LNX.4.58.0710121210210.12663@gandalf.stny.rr.com>
In-Reply-To: <Pine.LNX.4.58.0710121210210.12663@gandalf.stny.rr.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Steven Rostedt wrote:
> --

(Strange characters.)

> John Sigler wrote:
> 
>> APIC timer registered as dummy, due to nmi_watchdog=1!
>> Clockevents: could not switch to one-shot mode: lapic is not functional.
>> Could not switch to high resolution mode on CPU 0
>>
>> Do you know why nmi_watchdog=1 disables high-resolution timers?
>>
>> And why nmi_watchdog=1 implies APIC timer registered as dummy?
> 
> Crap, I forgot about that. Thomas explained why to me once, and I forgot.

Thomas,

Could you explain again why using the IO-APIC watchdog disables hrt?

> Does it still crash? If not, does it crash if you turn off highres?

It's not that simple. My app depends on hrt. I'd have to tweak it to 
make it work when hrt are not available.

BTW, it's not a crash, it's a complete system lock-up. Nothing works, 
and I really do mean nothing: ping is ignored, I can't open an ssh 
connection, the serial console won't budge, even if I send SysRq combos...

> Or better yet, try turning off dynamic-ticks. We had a bug once before
> that had a problem with the new RCU code and dynamic ticks.

I didn't enable dynamic-ticks kernel support.

CONFIG_TICK_ONESHOT=y
# CONFIG_NO_HZ is not set
CONFIG_HIGH_RES_TIMERS=y
CONFIG_GENERIC_CLOCKEVENTS_BUILD=y
# CONFIG_SMP is not set
CONFIG_X86_PC=y
...
# CONFIG_HPET_TIMER is not set
# CONFIG_PREEMPT_NONE is not set
# CONFIG_PREEMPT_VOLUNTARY is not set
# CONFIG_PREEMPT_DESKTOP is not set
CONFIG_PREEMPT_RT=y
CONFIG_PREEMPT=y
CONFIG_PREEMPT_SOFTIRQS=y
CONFIG_PREEMPT_HARDIRQS=y
CONFIG_PREEMPT_BKL=y
# CONFIG_CLASSIC_RCU is not set
CONFIG_PREEMPT_RCU=y
# CONFIG_RCU_TRACE is not set
CONFIG_X86_UP_APIC=y
CONFIG_X86_UP_IOAPIC=y
CONFIG_X86_LOCAL_APIC=y
CONFIG_X86_IO_APIC=y
# CONFIG_X86_MCE is not set
# CONFIG_VM86 is not set
# CONFIG_TOSHIBA is not set
# CONFIG_I8K is not set
# CONFIG_X86_REBOOTFIXUPS is not set
# CONFIG_MICROCODE is not set
# CONFIG_X86_MSR is not set

Regards.
