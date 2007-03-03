Return-Path: <linux-kernel-owner+w=401wt.eu-S1751311AbXCCKKe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751311AbXCCKKe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Mar 2007 05:10:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751314AbXCCKKe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Mar 2007 05:10:34 -0500
Received: from mu-out-0910.google.com ([209.85.134.191]:55534 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751311AbXCCKKc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Mar 2007 05:10:32 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding:from;
        b=EFPe0YBZHgwYDgS+5SJ9kQ36cpLu3yQPdQSaYwgSQPGBt5R1OfJuETCNazIx2Fv6386e5sguoHzqKYDRzNvlKlRTtWXzBH+SYYAME1ua3SBvQ+TCO6mfdfcB8eDRqWVKz6eAM9JocHKzBR3dSEGiJFCY8gmpOT6VKUkJTbdVrbw=
Message-ID: <45E94933.4010206@googlemail.com>
Date: Sat, 03 Mar 2007 11:08:51 +0100
User-Agent: Thunderbird 1.5.0.9 (X11/20070212)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: 2.6.21-rc2-mm1
References: <20070302030026.5eef0c92.akpm@linux-foundation.org>	<6bffcb0e0703021542k4f882531r21807c7efdbd0ebc@mail.gmail.com>	<20070302164009.a2aa6cbc.akpm@linux-foundation.org>	<45E8CDF3.7010406@googlemail.com> <20070302174110.5740b09e.akpm@linux-foundation.org>
In-Reply-To: <20070302174110.5740b09e.akpm@linux-foundation.org>
X-Enigmail-Version: 0.94.1.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
From: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton napisał(a):
> On Sat, 03 Mar 2007 02:22:59 +0100
> Michal Piotrowski <michal.k.k.piotrowski@gmail.com> wrote:
> 
>> Andrew Morton napisa__(a):
>>> On Sat, 3 Mar 2007 00:42:33 +0100
>>> "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com> wrote:
>>>
>>>> On 02/03/07, Andrew Morton <akpm@linux-foundation.org> wrote:
>>>>> Temporarily at
>>>>>
>>>>>   http://userweb.kernel.org/~akpm/2.6.21-rc2-mm1/
>>>>>
>>>> I have noticed some strange system behavior. When i try to build a
>>>> kernel (medium load) - X, keyboard, mouse and sound hangs.
>>>>
>>>> I can ping machine and I can use magic SysRq key, but that's all.
>>>>
>>>> 2.6.20-mm2 was fine, 2.6.21-rc2 works well (over 800 patches since
>>>> 2.6.20-mm2 - great...)
>>>>
>>>> NIL (Nothing Interesting in Logs)
>>>>
>>> Can we see the sysrq-T output please?
>>>
>> http://www.stardust.webpages.pl/files/tbf/bitis-gabonica/2.6.21-rc2-mm1/sys.log
>>
> 
> Well that's all very dull - everything's just sitting there asleep.
> 
> If it was just X then I'd suspect the psmouse changes (are you PS2 or USB?)
> 
> Or I'd suspect that the entire interrupt system has gone bust, but you're
> still able to do sysrq.
> 
> How are you doing sysrq, btw?   Serial console?  alt-F7 into a vgaconsole?

alt + sysrq + key, but alt + fX doesn't work

> Are you able to log in from another machine via ssh?

Yes.

> 
> Are you able to log into it via ssh before it hangs and run things like
> `top' and `watch -n1 cat /proc/interrupts', see what they do when it hangs?

Everything stops.

top - 10:45:55 up 19 min,  2 users,  load average: 2.73, 2.51, 1.61
Tasks: 169 total,   4 running, 165 sleeping,   0 stopped,   0 zombie
Cpu(s): 61.2%us, 21.9%sy,  0.0%ni, 16.0%id,  0.3%wa,  0.0%hi,  0.5%si,  0.0%st
Mem:   1985648k total,  1270908k used,   714740k free,    74424k buffers
Swap:  4192956k total,        0k used,  4192956k free,   849936k cached

  PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  COMMAND
 3656 michal    15   0  293m  91m  27m S   44  4.7   5:53.77 firefox-bin
14683 michal    25   0 22756  18m 3876 R   22  1.0   0:00.66 cc1
 3191 root      16   0  170m  20m 6640 R   21  1.0   2:26.46 Xorg
[..]

> 
> Is the CPU idle when it hangs, or is it busy?  If busy, what does sysrq-P
> say?
> 
> 

Pid: 3716, comm:          firefox-bin
EIP: 0073:[<b23bb9d1>] CPU: 0
EIP is at 0xb23bb9d1
 ESP: 007b:afdfd1d0 EFLAGS: 00000202    Not tainted  (2.6.21-rc2-mm1 #23)
EAX: 00000001 EBX: b25ee12c ECX: 00000018 EDX: 00000018
ESI: 0944e91c EDI: 0944e900 EBP: afdfd398 DS: 007b ES: 007b FS: 0000
CR0: 8005003b CR2: 40954000 CR3: 32bdc000 CR4: 000006d0
 [<c0105256>] show_trace_log_lvl+0x1a/0x2f
 [<c010597b>] show_trace+0x12/0x14
 [<c0102acf>] show_regs+0x181/0x188
 [<c0261010>] sysrq_handle_showregs+0x12/0x14
 [<c0260f47>] __handle_sysrq+0x8c/0x109
 [<c0261122>] handle_sysrq+0x1f/0x21
 [<c025bd6e>] kbd_event+0x2d8/0x4ee
 [<c02bcae2>] input_event+0x420/0x442
 [<c02c01b0>] atkbd_interrupt+0x448/0x514
 [<c02b986e>] serio_interrupt+0x49/0x7f
 [<c02ba6a8>] i8042_interrupt+0x226/0x239
 [<c0155642>] handle_IRQ_event+0x1a/0x46
 [<c015675a>] handle_edge_irq+0x10a/0x14e
 [<c0106c22>] do_IRQ+0xa3/0xbd
 [<c0104c52>] common_interrupt+0x2e/0x34
 =======================

Regards,
Michal

-- 
Michal K. K. Piotrowski
LTG - Linux Testers Group (PL)
(http://www.stardust.webpages.pl/ltg/)
LTG - Linux Testers Group (EN)
(http://www.stardust.webpages.pl/linux_testers_group_en/)
