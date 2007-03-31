Return-Path: <linux-kernel-owner+w=401wt.eu-S1752915AbXCaLUU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752915AbXCaLUU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Mar 2007 07:20:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752921AbXCaLUT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 Mar 2007 07:20:19 -0400
Received: from ug-out-1314.google.com ([66.249.92.168]:24744 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752915AbXCaLUR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Mar 2007 07:20:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding:from;
        b=o6+ZdQf/mpoDAqcCM3aVtrmJpdU9bG4/dOIeOvB166QDX+2fq9VT3jTWE0GhIOjpAvwFljklUB6KSQiWAAeYA/Ym9BJBVXun3Tt+QL5JAONvydAS2WY/0EeI+MVLwEY54s7zuDOlGJdbohiw28m0/b5uYEtj355tL9XLSyEXtJU=
Message-ID: <460E43D2.70504@googlemail.com>
Date: Sat, 31 Mar 2007 13:19:46 +0200
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Andi Kleen <ak@suse.de>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Jan Beulich <jbeulich@novell.com>, Ingo Molnar <mingo@elte.hu>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: Re: Fw: Re: 2.6.21-rc5-mm3
References: <20070330103958.16b738aa.akpm@linux-foundation.org> <200703302131.23469.ak@suse.de>
In-Reply-To: <200703302131.23469.ak@suse.de>
X-Enigmail-Version: 0.94.1.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
From: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen napisał(a):
>> BUG: NMI Watchdog detected LOCKUP on CPU0, eip c014ce9c, registers:
> 
> I suspect it is just because his console is too slow and then unwinding
> took too long and it happened to hit the unwinder. 
> 
> You did use a slow console, right?

console=ttyS0,115200n8

> 
> I suppose it just needs a strategic touch_nmi_watchdog. Will add that.
> 
>> Modules linked in: ide_cd cdrom rtc unix
>> CPU:    0
>> EIP:    0060:[<c014ce9c>]    Not tainted VLI
>> EFLAGS: 00000093   (2.6.21-rc5-mm3 #10)
>> EIP is at read_pointer+0x49/0x2d8
>> eax: c7a8dd04   ebx: 00000000   ecx: 00000000   edx: c043d19c
>> esi: c043d184   edi: c043d19c   ebp: c7a8dbf4   esp: c7a8dbbc
>> ds: 007b   es: 007b   fs: 00d8  gs: 0033  ss: 0068
>> Process udevd (pid: 864, ti=c7a8c000 task=c97cd4d0 task.ti=c7a8c000)
>> Stack: 0000000b c7a8dc70 c7a8dbf4 c014d6d0 c7a8dd04 c043e454 c7a8dbf4 c011fdd1 
>>        c043e404 c043e454 c043d190 0005cd94 c043d184 c7a8dd04 c7a8dd14 c014dd3a 
>>        00000000 00000000 00000000 00000000 c7a8df44 c7a8dd74 c741eefb 00000008 
>> Call Trace:
>>  [<c014dd3a>] unwind+0x414/0xfa2
>>  [<c010510d>] dump_trace_unwind+0xb4/0xe5
>>  [<c014ce4d>] unwind_init_running+0x25/0x2b
>>  [<c01051a1>] dump_trace+0x63/0x1eb
>>  [<c010ad39>] save_stack_trace+0x23/0x42
>>  [<c01393c9>] update_cpu_base_expires_next+0x56/0x5a
>>  [<c013a475>] hrtimer_interrupt+0x17c/0x1b8
>>  [<c0115e8e>] smp_apic_timer_interrupt+0x72/0x85
>>  [<c0104bef>] apic_timer_interrupt+0x33/0x38
>>  [<c014320c>] lock_release+0x1d2/0x1da
>>  [<c013a7ef>] up_read+0x19/0x2e
>>  [<c011b800>] do_page_fault+0x28f/0x55b
>>  [<c034d191>] error_code+0x79/0x80
>>  [<c020c23e>] __put_user_4+0x12/0x18
>> DWARF2 unwinder stuck at __put_user_4+0x12/0x18
>> Leftover inexact backtrace:
>>  [<c01040d6>] ret_from_fork+0x6/0x1c
> 
> Hmpf. I saw it once in child_rip here too. Then I wanted to reproduce it to report
> properly and couldn't again. I had a few other backtraces that were all non stuck
> with child_rip then on essentially the same kernel. Something weird is going on.
> 
>>  [<c013a475>] hrtimer_interrupt+0x17c/0x1b8
>>  [<c0115e8e>] smp_apic_timer_interrupt+0x72/0x85
>>  [<c0104bef>] apic_timer_interrupt+0x33/0x38
>>  [<c020c184>] __get_user_4+0x14/0x17
>> DWARF2 unwinder stuck at __get_user_4+0x14/0x17
>> Leftover inexact backtrace:
> 
> Now that is weird. Never seen before. Jan, any ideas?
> 
> What is your gcc/compiler, Michal?

gcc --version
gcc (GCC) 4.1.1 20070105 (Red Hat 4.1.1-51)

> 
> -Andi
> 
> 
> Were there any strange binutils in use, Michal?

I don't remember when I had problems with this compiler.

> 
>>  [<c018b42f>] do_execve+0xdd/0x210
>>  [<c0102497>] sys_execve+0x3f/0x62
>>  [<c01041c2>] sysenter_past_esp+0x5f/0x99
> 

Regards,
Michal

-- 
Michal K. K. Piotrowski
LTG - Linux Testers Group (PL)
(http://www.stardust.webpages.pl/ltg/)
LTG - Linux Testers Group (EN)
(http://www.stardust.webpages.pl/linux_testers_group_en/)
