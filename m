Return-Path: <linux-kernel-owner+w=401wt.eu-S1751596AbZIWKMb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751596AbZIWKMb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Sep 2009 06:12:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751335AbZIWKMa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Sep 2009 06:12:30 -0400
Received: from fg-out-1718.google.com ([72.14.220.159]:38200 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751194AbZIWKM3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Sep 2009 06:12:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Uo4iDZ+7IPFRUI8R1Tz7wkBOL6pb7Dc6fFTfqdb5Efm5feHuugkLZ0znKViqoXcaFr
         66oZ3ejspOjr4TODwrTzUb2RySAV2mVwP5MBkC1If0t+dVjMd+HZeMfUx+WD3FozrhkT
         4QC9R1tHU3U3F+EwD/xhNujF95V6SI0ujTkB4=
MIME-Version: 1.0
In-Reply-To: <7863dc4c0909230306x3bc60775rc503919df83087ed@mail.gmail.com>
References: <7863dc4c0909221409v7893bfd3o4b590d5951a233ba@mail.gmail.com>
	 <1253686585.7695.84.camel@twins> <20090923073253.GA18022@elte.hu>
	 <20090923074028.GA3078@elte.hu>
	 <aa79d98a0909230044q3548cf0bjda62e05e0400edd6@mail.gmail.com>
	 <aa79d98a0909230148j47232382oe28c6d88eef181c4@mail.gmail.com>
	 <7863dc4c0909230215u2fed3edciec84f93f24d3ae1@mail.gmail.com>
	 <20090923092024.GA29323@elte.hu>
	 <aa79d98a0909230248j22f05047n34e0ee97382f573f@mail.gmail.com>
	 <7863dc4c0909230306x3bc60775rc503919df83087ed@mail.gmail.com>
Date: Wed, 23 Sep 2009 14:12:31 +0400
Message-ID: <aa79d98a0909230312g24fa080fub14d9deb48377006@mail.gmail.com>
Subject: Re: perf sched record hangs machine
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Chris Malley <mail@chrismalley.co.uk>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org,
       Steven Rostedt <rostedt@goodmis.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, September 23, 2009, Chris Malley <mail@chrismalley.co.uk> wrote:
> 2009/9/23 Cyrill Gorcunov <gorcunov@gmail.com>:
>> On 9/23/09, Ingo Molnar <mingo@elte.hu> wrote:
>>>
>>> Would still be important to fix the crash - there are boxes where lapics
>>> are disabled permanently and cannot be re-enabled. (plus most people
>>> dont touch their defaults and dont add funky boot options - so crashing
>>> is not an option)
>>>
>>
>> Ingo, Chris, could you try Peter's patch? It seems like what we need.
>>
>> (Peter, self-ipi shouldn't be separated from others ipi, yes it  may
>> not issue any cycle on fsb, but iirc it uses the same logic as other
>> ipi use)
>>
>
> Applied Peter's patch, doesn't seem to have fixed the problem:
>

thanks Chris! I'll take a look on this today evening (if someone
wouldn't beat me ;)

> [  246.408893] BUG: unable to handle kernel paging request at ffffb300
> [  246.408939] IP: [<c011b0bd>] default_send_IPI_self+0x1d/0x50
> [  246.408961] *pde = 0073f067 *pte = 00000000
> [  246.408985] Oops: 0000 [#1] SMP
> [  246.408996] last sysfs file:
> /sys/devices/system/cpu/cpu0/cpufreq/scaling_cur_freq
> [  246.409007] Modules linked in: netconsole configfs binfmt_misc
> snd_intel8x0 snd_ac97_codec ac97_bus snd_pcm_oss snd_mixer_oss snd_pcm
> snd_seq_dummy snd_seq_oss snd_seq_midi snd_rawmidi snd_seq_midi_event
> snd_seq snd_timer snd_seq_device ipw2200 libipw snd dcdbas cfg80211
> intel_agp video soundcore sr_mod lib80211 output joydev pcspkr
> snd_page_alloc agpgart usb_storage usbhid ohci1394 tg3 ieee1394
> [  246.409112]
> [  246.409121] Pid: 4188, comm: firefox Not tainted
> (2.6.31-cjm-07092-g819307a #4) Latitude D400
> [  246.409126] EIP: 0060:[<c011b0bd>] EFLAGS: 00010046 CPU: 0
> [  246.409131] EIP is at default_send_IPI_self+0x1d/0x50
> [  246.409135] EAX: fffff000 EBX: 000000ec ECX: 00000800 EDX: ffffb300
> [  246.409140] ESI: f16cdc64 EDI: 00000000 EBP: f16cdc00 ESP: f16cdbfc
> [  246.409144]  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
> [  246.409150] Process firefox (pid: 4188, ti=f16cc000 task=f1465aa0
> task.ti=f16cc000)
> [  246.409154] Stack:
> [  246.409158]  f16c3e14 f16cdc08 c010e3b4 f16cdc28 c01b9751 f1602024
> f1602020 00115838
> [  246.409179] <0> 00000000 f1602000 f16c2c00 f16cdc38 c01b981a
> f16cdc64 f16cdc84 f16cdc98
> [  246.409199] <0> c01ba690 f16c2c00 00000001 c030963e ffffffff
> ffffffff 00000000 00000001
> [  246.409223] Call Trace:
> [  246.409234]  [<c010e3b4>] ? set_perf_event_pending+0x14/0x20
> [  246.409244]  [<c01b9751>] ? perf_output_unlock+0x121/0x1a0
> [  246.409249]  [<c01b981a>] ? perf_output_end+0x4a/0x70
> [  246.409255]  [<c01ba690>] ? __perf_event_overflow+0x240/0x2f0
> [  246.409264]  [<c030963e>] ? atomic64_cmpxchg+0x1e/0x30
> [  246.409270]  [<c01ba8f4>] ? perf_swevent_ctx_event+0x1b4/0x1c0
> [  246.409276]  [<c01ba773>] ? perf_swevent_ctx_event+0x33/0x1c0
> [  246.409281]  [<c01ba9a7>] ? do_perf_sw_event+0xa7/0x160
> [  246.409286]  [<c01baae2>] ? perf_tp_event+0x82/0xa0
> [  246.409296]  [<c012e9c6>] ? ftrace_profile_sched_stat_runtime+0xe6/0x120
> [  246.409301]  [<c012e8e0>] ? ftrace_profile_sched_stat_runtime+0x0/0x120
> [  246.409307]  [<c013c85a>] ? update_curr+0x18a/0x230
> [  246.409313]  [<c013e965>] ? enqueue_entity+0x15/0x460
> [  246.409319]  [<c0132447>] ? task_rq_lock+0x47/0x80
> [  246.409324]  [<c013f2d1>] ? enqueue_task_fair+0x31/0x70
> [  246.409331]  [<c012acad>] ? enqueue_task+0x6d/0x90
> [  246.409336]  [<c012ae50>] ? activate_task+0x20/0x30
> [  246.409343]  [<c013beeb>] ? try_to_wake_up+0x1fb/0x2f0
> [  246.409351]  [<c015ef50>] ? hrtimer_wakeup+0x0/0x20
> [  246.409357]  [<c013c00f>] ? wake_up_process+0xf/0x20
> [  246.409365]  [<c015ef68>] ? hrtimer_wakeup+0x18/0x20
> [  246.409370]  [<c015efdc>] ? __run_hrtimer+0x6c/0xc0
> [  246.409379]  [<c04e748a>] ? _spin_lock+0x3a/0x40
> [  246.409384]  [<c015f2f5>] ? hrtimer_interrupt+0x185/0x230
> [  246.409391]  [<c010564c>] ? timer_interrupt+0x3c/0x50
> [  246.409402]  [<c0199bd0>] ? handle_IRQ_event+0x50/0x140
> [  246.409407]  [<c04e7335>] ? _spin_unlock_irqrestore+0x55/0x60
> [  246.409413]  [<c019bfa4>] ? handle_level_irq+0x64/0xf0
> [  246.409418]  [<c019bfae>] ? handle_level_irq+0x6e/0xf0
> [  246.409423]  [<c01050da>] ? handle_irq+0x1a/0x30
> [  246.409428]  [<c0104896>] ? do_IRQ+0x46/0xc0
> [  246.409437]  [<c016f3cc>] ? trace_hardirqs_on_caller+0x12c/0x170
> [  246.409442]  [<c010372e>] ? common_interrupt+0x2e/0x34
> [  246.409448] Code: 0f 44 c1 89 02 5b 5d c3 8d b6 00 00 00 00 55 89
> e5 53 89 c3 a1 5c de 68 c0 8b 48 20 eb 02 f3 90 a1 c8 10 69 c0 8d 90
> 00 c3 ff ff <8b> 80 00 c3 ff ff f6 c4 10 75 e8 89 c8 81 c9 00 04 04 00
> 0d 00
> [  246.409591] EIP: [<c011b0bd>] default_send_IPI_self+0x1d/0x50
> SS:ESP 0068:f16cdbfc
> [  246.409601] CR2: 00000000ffffb300
> [  246.409609] ---[ end trace 237505c339f73345 ]---
> [  246.409616] Kernel panic - not syncing: Fatal exception in interrupt
> [  246.409623] Pid: 4188, comm: firefox Tainted: G      D
> 2.6.31-cjm-07092-g819307a #4
> [  246.409627] Call Trace:
> [  246.409633]  [<c04e3eb5>] ? printk+0x18/0x1b
> [  246.409638]  [<c04e3de0>] panic+0x43/0x100
> [  246.409643]  [<c04e8569>] oops_end+0xb9/0xc0
> [  246.409648]  [<c0124d66>] no_context+0xb6/0x150
> [  246.409653]  [<c0124e63>] __bad_area_nosemaphore+0x63/0x180
> [  246.409659]  [<c016fb13>] ? __lock_acquire+0x193/0x1240
> [  246.409664]  [<c016fb13>] ? __lock_acquire+0x193/0x1240
> [  246.409670]  [<c016fb13>] ? __lock_acquire+0x193/0x1240
> [  246.409675]  [<c016fb13>] ? __lock_acquire+0x193/0x1240
> [  246.409680]  [<c0124f92>] bad_area_nosemaphore+0x12/0x20
> [  246.409687]  [<c04e9b4c>] do_page_fault+0x31c/0x3c0
> [  246.409692]  [<c04e9830>] ? do_page_fault+0x0/0x3c0
> [  246.409697]  [<c04e79d3>] error_code+0x6b/0x70
> [  246.409703]  [<c016007b>] ? down_write_trylock+0x1b/0x50
> [  246.409708]  [<c04e9830>] ? do_page_fault+0x0/0x3c0
> [  246.409714]  [<c011b0bd>] ? default_send_IPI_self+0x1d/0x50
> [  246.409720]  [<c010e3b4>] set_perf_event_pending+0x14/0x20
> [  246.409725]  [<c01b9751>] perf_output_unlock+0x121/0x1a0
> [  246.409732]  [<c01b981a>] perf_output_end+0x4a/0x70
>
