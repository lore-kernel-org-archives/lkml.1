Return-Path: <linux-kernel-owner+w=401wt.eu-S1752782AbYLCNXp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752782AbYLCNXp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 08:23:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750918AbYLCNXf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 08:23:35 -0500
Received: from mail-qy0-f11.google.com ([209.85.221.11]:36822 "EHLO
	mail-qy0-f11.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750811AbYLCNXe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 08:23:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=S/V8rFxCFkeCoA+lp7tc2bsXvEcSUMbhW2YMwgrNiczvisAxGqFExPF86MsEqjIYkE
         Vf9zz3Gzf98OsHDmmWFuT7iEtaET9QaCyD6LA+VzguregM2ZaCz+PLslhyOc52Mb282Y
         Zc+huDZwXbvDf3+LnB7dPLRIV2lXnb4BlOsd4=
Message-ID: <c62985530812030523w3e5130cfg6db9d146c67e2d27@mail.gmail.com>
Date: Wed, 3 Dec 2008 14:23:33 +0100
From: "=?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?=" <fweisbec@gmail.com>
To: "Steven Rostedt" <rostedt@goodmis.org>
Subject: Re: [PATCH 4/5] ftrace: function graph return for function entry
Cc: "Ingo Molnar" <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Steven Rostedt" <srostedt@redhat.com>
In-Reply-To: <alpine.DEB.1.10.0812030655360.29045@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081203045001.367443457@goodmis.org>
	 <20081203045044.002248353@goodmis.org>
	 <20081203081301.GF21006@elte.hu> <20081203100526.GA13096@elte.hu>
	 <alpine.DEB.1.10.0812030655360.29045@gandalf.stny.rr.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/12/3 Steven Rostedt <rostedt@goodmis.org>:
>
> On Wed, 3 Dec 2008, Ingo Molnar wrote:
>
>>
>> Steve,
>>
>> after your stream of ftrace patches i'm now getting easy crashes in the
>> function-graph tracer - these crashes didnt occur before. See below an
>> example. Config attached, kernel is tip/master.
>
> Hmm, I've actually had it the other way :-(  I hit this same crash without
> the patches, and it went away after adding my patches.
>
> This is probably some nasty race that depends on a set of timings :-(
>
>
>>
>>       Ingo
>>
>> ------------->
>> EXT3-fs: mounted filesystem with ordered data mode.
>> Adding 8193140k swap on /dev/sda2.  Priority:-1 extents:1 across:8193140k
>> 0000:04:00.0: eth0: Link is Up 1000 Mbps Full Duplex, Flow Control: RX/TX
>>
>> Fedora Core release 6 (Zod)
>> Kernel 2.6.28-rc7-tip on an x86_64
>>
>> titan login: BUG: unable to handle kernel NULL pointer dereference at 0000000000000009
>> IP: [<ffffffff80572c57>] do_page_fault+0x414/0x8cd
>> PGD 38519067 PUD 38518067 PMD 0
>> Oops: 0000 [#1] SMP
>> last sysfs file: /sys/devices/pci0000:00/0000:00:1c.5/0000:04:00.0/irq
>> CPU 0
>> Modules linked in:
>> Pid: 1617, comm: gnome-settings- Not tainted 2.6.28-rc7-tip #54
>> RIP: 0010:[<ffffffff80572c57>]  [<ffffffff80572c57>] do_page_fault+0x414/0x8cd
>> RSP: 0000:ffff880038407b58  EFLAGS: 00010002
>> RAX: 0000000000000001 RBX: 0000000000000001 RCX: 0000000000000000
>> RDX: fffffffffffffffd RSI: 0000000000000000 RDI: ffff880000012698
>> RBP: ffff880038407c28 R08: ffffffffffffffff R09: 0000000000000001
>> R10: 0000000000000020 R11: dead000000100100 R12: 000000000000001f
>> R13: ffff880000011e80 R14: 0000000000000000 R15: 0000000000000002
>> FS:  00007f7f49376710(0000) GS:ffffffff80930a00(0000) knlGS:0000000000000000
>> CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
>> CR2: 0000000000000009 CR3: 0000000039804000 CR4: 00000000000006e0
>> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
>> DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
>> Process gnome-settings- (pid: 1617, threadinfo ffff880038406000, task ffff88003c312080)
>> Stack:
>>  ffff880038407ba8 0000000000000292 ffffffff809b37c0 0000000000000000
>>  0000000000000002 0000000300000044 ffff880000014a00 000000008028abed
>>  0000000000000000 001200d200c96070 ffff880000014a08 0000000180221e63
>> Call Trace:
>>  [<ffffffff8020c0fd>] return_to_handler+0x0/0x73
>>  [<ffffffff8020ee9b>] dump_trace+0x26e/0x27f
>>  [<ffffffff8020c132>] ? return_to_handler+0x35/0x73
>>  [<ffffffff8020c0fd>] return_to_handler+0x0/0x73
>>  [<ffffffff8020f899>] show_trace_log_lvl+0x51/0x5d
>>  [<ffffffff8020c0fd>] return_to_handler+0x0/0x73
>>  [<ffffffff8020e9f2>] show_stack_log_lvl+0x100/0x10f
>>  [<ffffffff8020c0fd>] return_to_handler+0x0/0x73
>>  [<ffffffff8020eab6>] show_registers+0xb5/0x22c
>>  [<ffffffff8020c0fd>] return_to_handler+0x0/0x73
>
> Cool! The output of the stack worked! My backtraces looked more like this,
> because it happened without the patches:
>
>  [<ffffffff8020c0fd>] return_to_handler+0x0/0x73
>  [<ffffffff8020c132>] ? return_to_handler+0x35/0x73
>  [<ffffffff8020c0fd>] return_to_handler+0x0/0x73
>  [<ffffffff8020c0fd>] return_to_handler+0x0/0x73
>  [<ffffffff8020c0fd>] return_to_handler+0x0/0x73
>  [<ffffffff8020c0fd>] return_to_handler+0x0/0x73
>
> I'll look into it.
>
> -- Steve
>
>>  [<ffffffff805714bf>] __die+0x99/0xe7
>>  [<ffffffff8027c4c4>] ? tracing_generic_entry_update+0x7f/0xab
>>  [<ffffffff8020a6b2>] ? sys_clone+0x23/0x25
>>  [<ffffffff80221f27>] ? ftrace_return_to_handler+0xa2/0xd2
>>  [<ffffffff8023df2d>] ? do_fork+0x11/0x2a6
>>  [<ffffffff8020c132>] ? return_to_handler+0x35/0x73
>>  [<ffffffff80570479>] ? trace_hardirqs_off_thunk+0x3a/0x6c
>>  [<ffffffff80570adf>] page_fault+0x1f/0x30
>> Code: 02 01 00 00 48 8b bd b0 fe ff ff e8 c5 cc ff ff 48 8b bd b8 fe ff ff 4c 89 e6 e8 47 6a d2 ff 48 85 c0 48 89 c3 0f 84 c3 00 00 00 <4c> 39 60 08 76 38 f6 40 29 01 0f 84 b3 00 00 00 41 f6 c5 04 74
>> RIP  [<ffffffff80572c57>] do_page_fault+0x414/0x8cd
>>  RSP <ffff880038407b58>
>> CR2: 0000000000000009
>> <<4>paging request at ffffffff80afe223
>> IP: [<ffffffff8028a7e1>] get_page_from_freelist+0x324/0x64a
>> PGD 203067 PUD 207063 PMD a001e3
>> Oops: 0020 [#2] SMP
>> last sysfs file: /sys/devices/pci0000:00/0000:00:1c.5/0000:04:00.0/irq
>> CPU 1
>> Modules linked in:
>> Pid: 1625, comm: gnome-settings- Tainted: G      D    2.6.28-rc7-tip #54
>> RIP: 0010:[<ffffffff8028a7e1>]  [<ffffffff8028a7e1>] get_page_from_freelist+0x324/0x64a
>> Process +  (pid: 612141896, threadinfo 4820247c8b482824, task ffffffff8020c0d6)
>> Stack:
>> BUG: unable to handle kernel NULL pointer dereference at 0000000000000003
>> IP: [<ffffffff8020e9a7>] show_stack_log_lvl+0xb5/0x10f
>> PGD 38457067 PUD 38452067 PMD 0
>> Oops: 0000 [#3] SMP
>> last sysfs file: /sys/devices/pci0000:00/0000:00:1c.5/0000:04:00.0/irq
>> CPU 1
>> Modules linked in:
>> Pid: 1625, comm: gnome-settings- Tainted: G      D    2.6.28-rc7-tip #54
>> RIP: 0010:[<ffffffff8020e9a7>]  [<ffffffff8020e9a7>] show_stack_log_lvl+0xb5/0x10f
>> RSP: 0018:ffff8800384d5ba8  EFLAGS: 00010046
>> RAX: ffff88003e63ffc0 RBX: 0000000000000003 RCX: ffff8800384d5eb8
>> RDX: ffff880001009b80 RSI: ffff8800384d5df8 RDI: 0000000000000000
>> RBP: ffff8800384d5bf8 R08: ffffffff806a8871 R09: 0000000000000000
>> R10: ffffffff80afe620 R11: 0000000000000010 R12: 0000000000000000
>> R13: 0000000000000000 R14: ffff88003e643fc0 R15: ffffffff806a8871
>> FS:  00007f7f49376710(0000) GS:ffff88003e60dac0(0000) knlGS:0000000000000000
>> CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
>> CR2: 0000000000000003 CR3: 0000000038456000 CR4: 00000000000006e0
>> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
>> DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
>> Process gnome-settings- (pid: 1625, threadinfo ffff8800384d4000, task ffff88003e6cc7f0)
>> Stack:
>>  ffff880000000008 ffff8800384d5eb8 ffff8800384d5df8 ffff88003e63ffc0
>>  0000000000000003 ffffffff8020c0d6 0000000000000003 0000000000000ac0
>>  ffff8800384d5df8 0000000000000040 ffff8800384d5c48 ffffffff8020c0fd
>> Call Trace:
>>  [<ffffffff8020c0d6>] ? ftrace_graph_caller+0x46/0x6d
>>  [<ffffffff8020c0fd>] return_to_handler+0x0/0x73
>>  [<ffffffff8020ee9b>] dump_trace+0x26e/0x27f
>>  [<ffffffff8057318d>] ? atomic_notifier_call_chain+0x13/0x15
>>  [<ffffffff8020c0fd>] return_to_handler+0x0/0x73
>>  [<ffffffff8020f899>] show_trace_log_lvl+0x51/0x5d
>>  [<ffffffff80572ff2>] do_page_fault+0x7af/0x8cd
>>  [<ffffffff8027c00f>] ? rb_reserve_next_event+0x19b/0x2f2
>>  [<ffffffff8027c4c4>] ? tracing_generic_entry_update+0x7f/0xab
>>  [<ffffffff80570479>] ? trace_hardirqs_off_thunk+0x3a/0x6c
>>  [<ffffffff80570adf>] page_fault+0x1f/0x30
>>  [<ffffffff8028a7e1>] ? get_page_from_freelist+0x324/0x64a
>>  [<ffffffff8028a7df>] ? get_page_from_freelist+0x322/0x64a
>>  [<ffffffff8020c0fd>] return_to_handler+0x0/0x73
>>  [<ffffffff8020e9f2>] show_stack_log_lvl+0x100/0x10f
>>  [<ffffffff8020c0fd>] return_to_handler+0x0/0x73
>>  [<ffffffff8020eab6>] show_registers+0xb5/0x22c
>>  [<ffffffff8020c0fd>] return_to_handler+0x0/0x73
>>  [<ffffffff805714bf>] __die+0x99/0xe7
>>  [<ffffffff8020c0fd>] return_to_handler+0x0/0x73
>>  [<ffffffff8020eab6>] show_registers+0xb5/0x22c
>>  [<ffffffff8020c0fd>] return_to_handler+0x0/0x73
>>  [<ffffffff805714bf>] __die+0x99/0xe7
>> Code: e8 4a fa 35 00 eb 08 f7 c3 ff 1f 00 00 74 42 45 85 e4 74 17 41 f6 c4 03 75 11 4c 89 fe 48 c7 c7 24 88 6a 80 31 c0 e8 24 fa 35 00 <48> 8b 33 48 c7 c7 28 88 6a 80 31 c0 48 83 c3 08 41 ff c4 e8 0c
>> RIP  [<ffffffff8020e9a7>] show_stack_log_lvl+0xb5/0x10f
>>  RSP <ffff8800384d5ba8>
>> CR2: 0000000000000003
>> ---[ end trace 68aa414552b98440 ]---


I've never had such a thing (didn't tested yet with the last Steven's
patches). But I had a strange
warn_on_slowpath at the middle of a reboot which seems to rely on the
function-graph-tracer, or perhaps ring-buffer,
both where cited in the trace. But my stacktraces were dirty. It
should be more understandable with the Steven latest patches
which fix the nasty stacktraces....

I will test all of that this evening.
