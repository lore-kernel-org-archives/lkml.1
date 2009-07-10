Return-Path: <linux-kernel-owner+w=401wt.eu-S1752214AbZGJOE0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752214AbZGJOE0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jul 2009 10:04:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751120AbZGJOES
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Jul 2009 10:04:18 -0400
Received: from mail.gmx.net ([213.165.64.20]:48189 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751039AbZGJOER (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jul 2009 10:04:17 -0400
X-Authenticated: #23875046
X-Provags-ID: V01U2FsdGVkX1+8EdpECoG8IWbZh2xqEJR+ZgHw/HuQkdM5RL+2Qa
	CVTvydQPGCBJiP
Message-ID: <4A574A5C.5060400@fisher-privat.net>
Date: Fri, 10 Jul 2009 16:04:12 +0200
From: Alexey Fisher <bug-track@fisher-privat.net>
User-Agent: Thunderbird 2.0.0.22 (X11/20090616)
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: Ingo Molnar <mingo@elte.hu>, Matthew Garrett <mjg59@srcf.ucam.org>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Arjan van de Ven <arjan@infradead.org>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       Yinghai Lu <yinghai@kernel.org>,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Richard A. Holden III" <aciddeath@gmail.com>
Subject: Re: Intel BIOS - Corrupted low memory at ffff880000004200
References: <4A5210A2.2080301@fisher-privat.net> <4A52254F.8080103@fisher-privat.net> <20090708113949.GA8960@srcf.ucam.org> <20090710115238.GA8812@elte.hu> <4A573131.40601@fisher-privat.net> <alpine.LFD.2.00.0907101504030.2768@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.0907101504030.2768@localhost.localdomain>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.49
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Gleixner schrieb:
> On Fri, 10 Jul 2009, Alexey Fisher wrote:
>> Ingo Molnar schrieb:
>>> * Matthew Garrett <mjg59@srcf.ucam.org> wrote:
>>>
>>>> On Mon, Jul 06, 2009 at 06:24:47PM +0200, Alexey Fisher wrote:
>>>>> Hallo Ingo, Richard.
>>>>>
>>>>> I'm getting "Corrupted low memory" trace with my Intel DG45ID board
>>>>> after resume. This board has different dmi-bios-vendor... so probably it
>>>>> will be nice to have it in your patch.
>>>> I'm beginning to think that we should be doing this on all hardware,
>>>> perhaps with a kernel option to disable it for embedded devices that
>>>> really need that 64K. The low-memory corruption issue seems to be very
>>>> widespread.
>>> The problem is that the BIOS corrupted memory that it also marked as
>>> 'usable' in its E820 map it gave to the kernel. If that memory is not
>>> usable, it should not have been marked as such. Also, some of the reports
>>> showed corruption beyond this range so the workaround is not universal.
>>>
>>> So i'd really like to know what is happening there, instead of just zapping
>>> support for 64K of RAM on the majority of Linux systems.
>>>
>>> We might end up doing the same thing in the end (i.e. disable that 64k of
>>> RAM) - but it should be an informed decision, not a wild stab in the dark.
>>>
>>> 	Ingo
>> If i make memory dump like "dd if=/dev/mem of=memdump.dd bs=64k count=1"
>> before and after suspend. Will it help you find out whats happening.
> 
> The corrupted low memory printks contain the modifications. Can you
> post them please ?
> 
> Thanks,
> 
> 	tglx

[  120.816090] Corrupted low memory at ffff880000004200 (4200 phys) = 
00420301
[  120.816095] ------------[ cut here ]------------
[  120.816102] WARNING: at arch/x86/kernel/check.c:134 
check_for_bios_corruption+0xe4/0xf0()
[  120.816104] Hardware name:
[  120.816106] Memory corruption detected in low memory
[  120.816107] Modules linked in: binfmt_misc kvm_intel kvm 
snd_hda_codec_intelhdmi snd_hda_codec_idt snd_hda_intel snd_hda_codec 
snd_pcm_oss snd_mixer_oss snd_pcm snd_seq_dummy snd_seq_oss snd_seq_midi 
snd_rawmidi snd_seq_midi_event snd_seq snd_timer snd_seq_device psmouse 
snd serio_raw iTCO_wdt iTCO_vendor_support soundcore snd_page_alloc e1000e
[  120.816129] Pid: 9, comm: events/0 Tainted: G        W 
2.6.31-rc1-25446-g1ae8c0a-dirty #2
[  120.816131] Call Trace:
[  120.816136]  [<ffffffff8104a8e8>] warn_slowpath_common+0x78/0xb0
[  120.816139]  [<ffffffff8104a97c>] warn_slowpath_fmt+0x3c/0x40
[  120.816142]  [<ffffffff8102aff4>] check_for_bios_corruption+0xe4/0xf0
[  120.816146]  [<ffffffff8102b000>] ? check_corruption+0x0/0x30
[  120.816148]  [<ffffffff8102b009>] check_corruption+0x9/0x30
[  120.816152]  [<ffffffff8105e4d4>] worker_thread+0x144/0x260
[  120.816155]  [<ffffffff810635c0>] ? autoremove_wake_function+0x0/0x40
[  120.816158]  [<ffffffff8105e390>] ? worker_thread+0x0/0x260
[  120.816161]  [<ffffffff810631e6>] kthread+0x96/0xa0
[  120.816165]  [<ffffffff8100c69a>] child_rip+0xa/0x20
[  120.816168]  [<ffffffff81063150>] ? kthread+0x0/0xa0
[  120.816171]  [<ffffffff8100c690>] ? child_rip+0x0/0x20
[  120.816173] ---[ end trace 11e2979285be7426 ]---


> --
> To unsubscribe from this list: send the line "unsubscribe kernel-testers" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

