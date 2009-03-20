Return-Path: <linux-kernel-owner+w=401wt.eu-S1753242AbZCTIJ3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753242AbZCTIJ3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Mar 2009 04:09:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751300AbZCTIJP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Mar 2009 04:09:15 -0400
Received: from mga02.intel.com ([134.134.136.20]:47317 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750979AbZCTIJK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Mar 2009 04:09:10 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.38,394,1233561600"; 
   d="scan'208";a="499370260"
From: "Metzger, Markus T" <markus.t.metzger@intel.com>
To: Ingo Molnar <mingo@elte.hu>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "tglx@linutronix.de" <tglx@linutronix.de>,
       "hpa@zytor.com" <hpa@zytor.com>,
       "markus.t.metzger@gmail.com" <markus.t.metzger@gmail.com>,
       "roland@redhat.com" <roland@redhat.com>,
       "eranian@googlemail.com" <eranian@googlemail.com>,
       "oleg@redhat.com" <oleg@redhat.com>,
       "Villacis, Juan" <juan.villacis@intel.com>,
       "ak@linux.jf.intel.com" <ak@linux.jf.intel.com>
Date: Fri, 20 Mar 2009 08:07:53 +0000
Subject: RE: [patch] x86, bts: use atomic memory allocation
Thread-Topic: [patch] x86, bts: use atomic memory allocation
Thread-Index: AcmorYajgr4TY41IQQmaIE9N0yHZTQAgkIfw
Message-ID: <928CFBE8E7CB0040959E56B4EA41A77E923FFCA4@irsmsx504.ger.corp.intel.com>
References: <20090318192700.A6038@sedona.ch.intel.com>
 <20090319161141.GA12144@elte.hu>
In-Reply-To: <20090319161141.GA12144@elte.hu>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-cr-hashedpuzzle: CQnB JX9h OZry T877 b354 dAOa figb m8KP yPI2 1WaD 2C4D
 5Zoh AB9x0Q== ADNr4w== AFTmIg==
 AHaJ6A==;9;YQBrAEAAbABpAG4AdQB4AC4AagBmAC4AaQBuAHQAZQBsAC4AYwBvAG0AOwBlAHIAYQBuAGkAYQBuAEAAZwBvAG8AZwBsAGUAbQBhAGkAbAAuAGMAbwBtADsAaABwAGEAQAB6AHkAdABvAHIALgBjAG8AbQA7AGwAaQBuAHUAeAAtAGsAZQByAG4AZQBsAEAAdgBnAGUAcgAuAGsAZQByAG4AZQBsAC4AbwByAGcAOwBtAGEAcgBrAHUAcwAuAHQALgBtAGUAdAB6AGcAZQByAEAAZwBtAGEAaQBsAC4AYwBvAG0AOwBtAGkAbgBnAG8AQABlAGwAdABlAC4AaAB1ADsAbwBsAGUAZwBAAHIAZQBkAGgAYQB0AC4AYwBvAG0AOwByAG8AbABhAG4AZABAAHIAZQBkAGgAYQB0AC4AYwBvAG0AOwB0AGcAbAB4AEAAbABpAG4AdQB0AHIAbwBuAGkAeAAuAGQAZQA=;Sosha1_v1;7;{4E2A1C9E-372D-40DC-BFB4-22901E2A9EC5};bQBhAHIAawB1AHMALgB0AC4AbQBlAHQAegBnAGUAcgBAAGkAbgB0AGUAbAAuAGMAbwBtAA==;Fri,
 20 Mar 2009 08:07:53
 GMT;UgBFADoAIABbAHAAYQB0AGMAaABdACAAeAA4ADYALAAgAGIAdABzADoAIAB1AHMAZQAgAGEAdABvAG0AaQBjACAAbQBlAG0AbwByAHkAIABhAGwAbABvAGMAYQB0AGkAbwBuAA==
x-cr-puzzleid: {4E2A1C9E-372D-40DC-BFB4-22901E2A9EC5}
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>-----Original Message-----
>From: Ingo Molnar [mailto:mingo@elte.hu]
>Sent: Thursday, March 19, 2009 5:12 PM
>To: Metzger, Markus T


>> Ds_request_bts() needs to allocate memory. It uses GFP_KERNEL.
>>
>> Hw-branch-tracer calls ds_request_bts() within on_each_cpu().
>>
>> Use atomic memory allocation to allow it to be used in that context.
>
>the hw-branch-tracer still crashes during bootup. Have you tried the
>config i sent to you, and have you tried to reproduce it? I've
>attached another config that crashes.

The first config boots OK.
The second config boots OK with the additional changes to keep the GFP_KERNEL
and move the ds_request_bts() calls out of the on_each_cpu() in the hw-branch-tracer.

I don't know yet what exactly causes the crash and if there is a simpler fix.

I'm not sure I did it right, though. None of the configs worked as-is. I had to
answer a few additional questions for each one.
Here's what I did:
$ cp config.bad .config
$ make oldconfig
<press return a few times>
$ make

What's strange in the log you sent is that I do not see any
"[ds] using <whatever> configuration" messages.
I don't see any error message, either. It simply stops when it starts testing
the hw-branch-tracer.

When I boot that configuration (without the additional patches), I get some
error dumps on the screen including a call trace. Unfortunately, the interesting
part scrolls out of the top of my screen and the boot stops.
Are those logs stored somewhere? I looked in /var/log/messages but I only
found messages from successful boots; /var/log/dmesg also seems to contain only
the last successful boot.
If I can't get the logs, is there a way to restrict the depth of the call trace?


I then bootet a defconfig kernel with some debugging enabled and I get the following
message:
[    1.731080] inconsistent {HARDIRQ-ON-W} -> {IN-HARDIRQ-W} usage.
[    1.731180] swapper/0 [HC1[1]:SC0[0]:HE0:SE1] takes:
[    1.731180]  (ds_lock){?.+...}, at: [<ffffffff8101560f>] ds_put_context+0x21/0xf3

How would I read this error message?
It's pretty clear that something is wrong with ds_lock, but what exactly is the
error condition that was detected?

Here's the full error log:
[    1.730182] =================================
[    1.730538] [ INFO: inconsistent lock state ]
[    1.730719] 2.6.29-rc8 #1 SMP Thu Mar 19 20:39:13 CET 2009
[    1.730900] ---------------------------------
[    1.731080] inconsistent {HARDIRQ-ON-W} -> {IN-HARDIRQ-W} usage.
[    1.731180] swapper/0 [HC1[1]:SC0[0]:HE0:SE1] takes:
[    1.731180]  (ds_lock){?.+...}, at: [<ffffffff8101560f>] ds_put_context+0x21/0xf3
[    1.731180] {HARDIRQ-ON-W} state was registered at:
[    1.731180]   [<ffffffff8105f4f0>] __lock_acquire+0x29c/0xb61
[    1.731180]   [<ffffffff8106077c>] lock_acquire+0xbc/0xe0
[    1.731180]   [<ffffffff814bb19c>] _spin_lock+0x2c/0x38
[    1.731180]   [<ffffffff81015ab1>] ds_request+0xee/0x214
[    1.731180]   [<ffffffff81015e41>] ds_request_bts+0xab/0x18d
[    1.731180]   [<ffffffff81015f44>] ds_request_bts_cpu+0x21/0x23
[    1.731180]   [<ffffffff81016583>] ds_selftest_bts+0x74/0x161
[    1.731180]   [<ffffffff817dd553>] ds_selftest+0x12/0x6e
[    1.731180]   [<ffffffff8100905c>] do_one_initcall+0x56/0x130
[    1.731180]   [<ffffffff817d78dd>] kernel_init+0x139/0x191
[    1.731180]   [<ffffffff8100cc3a>] child_rip+0xa/0x20
[    1.731180]   [<ffffffffffffffff>] 0xffffffffffffffff
[    1.731180] irq event stamp: 48158
[    1.731180] hardirqs last  enabled at (48157): [<ffffffff8100c63c>] restore_args+0x0/0x30
[    1.731180] hardirqs last disabled at (48158): [<ffffffff8100b967>] save_args+0x67/0x70
[    1.731180] softirqs last  enabled at (48084): [<ffffffff81042964>] __do_softirq+0x197/0x1a6
[    1.731180] softirqs last disabled at (48067): [<ffffffff8100cd3c>] call_softirq+0x1c/0x34
[    1.731180] 
[    1.731180] other info that might help us debug this:
[    1.731180] no locks held by swapper/0.
[    1.731180] 
[    1.731180] stack backtrace:
[    1.731180] Pid: 0, comm: swapper Not tainted 2.6.29-rc8 #1 SMP Thu Mar 19 20:39:13 CET 2009
[    1.731180] Call Trace:
[    1.731180]  <IRQ>  [<ffffffff8105e8f5>] valid_state+0x179/0x18c
[    1.731180]  [<ffffffff8105e727>] ? check_usage_forwards+0x0/0x55
[    1.731180]  [<ffffffff8105e9e3>] mark_lock+0xdb/0x1ff
[    1.731180]  [<ffffffff8105f482>] __lock_acquire+0x22e/0xb61
[    1.731180]  [<ffffffff8105e92a>] ? mark_lock+0x22/0x1ff
[    1.731180]  [<ffffffff8106077c>] lock_acquire+0xbc/0xe0
[    1.731180]  [<ffffffff8101560f>] ? ds_put_context+0x21/0xf3
[    1.731180]  [<ffffffff814bb19c>] _spin_lock+0x2c/0x38
[    1.731180]  [<ffffffff8101560f>] ? ds_put_context+0x21/0xf3
[    1.731180]  [<ffffffff8101560f>] ds_put_context+0x21/0xf3
[    1.731180]  [<ffffffff810157d3>] ds_free_bts+0x73/0x7f
[    1.731180]  [<ffffffff81015822>] ds_release_bts_noirq+0x43/0x4b
[    1.731180]  [<ffffffff81016278>] ds_release_bts_noirq_wrap+0x9/0xb
[    1.731180]  [<ffffffff81065308>] generic_smp_call_function_single_interrupt+0x97/0xe3
[    1.731180]  [<ffffffff8101e18a>] smp_call_function_single_interrupt+0x13/0x23
[    1.731180]  [<ffffffff8100c8d3>] call_function_single_interrupt+0x13/0x20
[    1.731180]  <EOI>  [<ffffffff814bd7db>] ? __atomic_notifier_call_chain+0x0/0x87
[    1.731180]  [<ffffffff81012827>] ? mwait_idle+0x7c/0x99
[    1.731180]  [<ffffffff8101281e>] ? mwait_idle+0x73/0x99
[    1.731180]  [<ffffffff814bd871>] ? atomic_notifier_call_chain+0xf/0x11
[    1.731180]  [<ffffffff8100a89b>] ? enter_idle+0x20/0x22
[    1.731180]  [<ffffffff8100abb9>] ? cpu_idle+0x57/0x86
[    1.731180]  [<ffffffff814b53d4>] ? start_secondary+0x18e/0x192
[    1.742370] failed.
[    1.742550] ------------[ cut here ]------------


thanks,
markus.
---------------------------------------------------------------------
Intel GmbH
Dornacher Strasse 1
85622 Feldkirchen/Muenchen Germany
Sitz der Gesellschaft: Feldkirchen bei Muenchen
Geschaeftsfuehrer: Douglas Lusk, Peter Gleissner, Hannes Schwaderer
Registergericht: Muenchen HRB 47456 Ust.-IdNr.
VAT Registration No.: DE129385895
Citibank Frankfurt (BLZ 502 109 00) 600119052

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.

