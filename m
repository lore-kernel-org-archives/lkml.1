Return-Path: <linux-kernel-owner+w=401wt.eu-S1757412AbYDNNOT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757412AbYDNNOT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 09:14:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753320AbYDNNOI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 09:14:08 -0400
Received: from e28smtp05.in.ibm.com ([59.145.155.5]:40723 "EHLO
	e28smtp05.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752894AbYDNNOH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 09:14:07 -0400
Message-ID: <4803589B.30304@linux.vnet.ibm.com>
Date: Mon, 14 Apr 2008 18:44:03 +0530
From: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
User-Agent: Thunderbird 1.5.0.14ubu (X11/20080306)
MIME-Version: 1.0
To: Suresh Siddha <suresh.b.siddha@intel.com>
CC: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Andy Whitcroft <apw@shadowen.org>, akpm@linux-foundation.org
Subject: Re: [BUG] linux-next:  April 10 -  kernel oops at kmem_cache_alloc
 () regression from April 9 kernel
References: <20080410181404.b76939a6.sfr@canb.auug.org.au> <47FE5765.2030401@linux.vnet.ibm.com> <20080411175623.GC6542@linux-os.sc.intel.com>
In-Reply-To: <20080411175623.GC6542@linux-os.sc.intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Suresh Siddha wrote:
> On Thu, Apr 10, 2008 at 11:37:33PM +0530, Kamalesh Babulal wrote:
>> Hi Stephen,
>>
>> When booting the x86_64 boxes with the next-20080409 and 20080410 kernels
>> the kernel bug is hit. The same bug was reported for the April 9  kernel
>> at http://lkml.org/lkml/2008/4/10/63 (this kernel was compiled with 
>> CONFIG_CC_STACKPROTECTOR is not set)
>>
>>
>> BUG: unable to handle kernel NULL pointer dereference at 0000000000000000
>> IP: [<ffffffff802869b1>] kmem_cache_alloc+0x41/0x130
>> PGD 32dc2e067 PUD 32dd6a067 PMD 0 
>> Oops: 0000 [1] SMP 
>> last sysfs file: /sys/kernel/uevent_seqnum
>> CPU 0 
>> Modules linked in: sg
>> Pid: 1, comm: init Not tainted 2.6.25-rc8-next-20080410-autotest #1
>> RIP: 0010:[<ffffffff802869b1>]  [<ffffffff802869b1>] kmem_cache_alloc+0x41/0x130
>> RSP: 0000:ffff810bfe4abef8  EFLAGS: 00010046
>> RAX: 0000000000000000 RBX: ffff81090e4aa050 RCX: 0000000000405017
>> RDX: 00007ffffb4c05b8 RSI: 00000000000000d0 RDI: 0000000000000000
>> RBP: 0000000000000292 R08: 0000000000586f00 R09: 0000000000586f20
>> R10: 0000000000586f08 R11: 0000000000000246 R12: 00000000000000d0
>> R13: 0000000000000000 R14: 0000000000405150 R15: 0000000000000000
>> FS:  000000000058b850(0063) GS:ffffffff8067f000(0000) knlGS:0000000000000000
>> CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
>> CR2: 0000000000000000 CR3: 000000090d0e6000 CR4: 00000000000006e0
>> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
>> DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
>> Process init (pid: 1, threadinfo ffff810bfe4aa000, task ffff81090e4aa050)
>> Stack:  0000000000000000 ffff81090e4aa050 ffff81090e4aa050 0000000000000001
>>  0000000000405110 ffffffff80212f96 0000000000000292 ffff81090e4aa050
>>  00007ffffb4c05a8 ffffffff8020cb79 0000000000000000 ffffffff804da339
>> Call Trace:
>>  [<ffffffff80212f96>] init_fpu+0x96/0xf0
>>  [<ffffffff8020cb79>] math_state_restore+0x19/0x60
>>  [<ffffffff804da339>] error_exit+0x0/0x51
> 
> I noticed in another thread, that you are using gcc 4.1.1. I think
> both 4.1.0 and 4.1.1 has some issues with weak symbols. Can you please
> try gcc 4.1.2 and see if that fixes your issue.
> 
> When I go back to 4.1.0, I am bitten by smilar oops. But not with 4.1.2.
> 
> thanks,
> suresh
Hi,

When I tried reproducing the problem on another machine with gcc 4.1.2, the goes into a loop with 
the following call trace. Will try and reproduce on the same machine, which was causing the panic.

[    0.000000] Initializing cgroup subsys cpuset

[    0.000000] Linux version 2.6.25-rc8-next-20080411-autokern1 (root@elm3b63.beaverton.ibm.com) (gcc version 4.1.2 20071124 (Red Hat 4.1.2-41)) #1 SMP PREEMPT Mon Apr 14 08:31:54 EDT 2008
.
.
.
<snip>
.
.
[    3.059347] request_module: runaway loop modprobe binfmt-464c
[    3.065238] request_module: runaway loop modprobe binfmt-464c
[    3.071106] request_module: runaway loop modprobe binfmt-464c
[    3.077242] request_module: runaway loop modprobe binfmt-464c
[    3.085556] request_module: runaway loop modprobe binfmt-464c
[    3.169430] khelper used greatest stack depth: 2884 bytes left
[    3.224149] khelper used greatest stack depth: 2864 bytes left
[    3.358136] khelper used greatest stack depth: 2844 bytes left
[    3.384146] khelper used greatest stack depth: 2780 bytes left
[    3.692012] khelper used greatest stack depth: 2744 bytes left
[    4.470665] khelper used greatest stack depth: 2716 bytes left
[    4.714540] khelper used greatest stack depth: 2700 bytes left
[    5.632645] khelper used greatest stack depth: 2616 bytes left
[   37.306789] khelper used greatest stack depth: 2596 bytes left
[  279.173966] INFO: task swapper:1 blocked for more than 240 seconds.
[  279.180375] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[  279.188421] swapper       D 00000001  2376     1      0
[  279.196385]        f7844cc0 00000046 f7844c78 00000001 c06ed24c f7880000 f7846000 f7846190 
[  279.205829]        c4ab1700 00000007 00000000 fffeddc1 c0511054 373dd61a 000000ab ffffffff 
[  279.215036]        ffffffff ffffffff ffffffff 00000000 00000000 00000000 7fffffff 7fffffff 
[  279.224236] Call Trace:
[  279.227087]  [<c03c2c36>] schedule_timeout+0x16/0x8b
[  279.233650]  [<c023f674>] trace_hardirqs_on+0xb/0xd
[  279.240270]  [<c023f648>] trace_hardirqs_on_caller+0xe1/0x102
[  279.246470]  [<c023f674>] trace_hardirqs_on+0xb/0xd
[  279.254471]  [<c03c2423>] wait_for_common+0xda/0x139
[  279.259650]  [<c021ba97>] default_wake_function+0x0/0xd
[  279.266715]  [<c03c2504>] wait_for_completion+0x12/0x14
[  279.273332]  [<c0230e90>] call_usermodehelper_exec+0x7f/0xbf
[  279.279212]  [<c023119e>] request_module+0xce/0xe0
[  279.285587]  [<c023da76>] put_lock_stats+0xd/0x21
[  279.292211]  [<c023dada>] lock_release_holdtime+0x50/0x56
[  279.298064]  [<c028250f>] search_binary_handler+0x189/0x1c2
[  279.306064]  [<c02a5388>] load_script+0x0/0x188
[  279.311048]  [<c02a54fd>] load_script+0x175/0x188
[  279.315960]  [<c0208268>] __cycles_2_ns+0x14/0x35
[  279.322499]  [<c023da76>] put_lock_stats+0xd/0x21
[  279.329116]  [<c023dada>] lock_release_holdtime+0x50/0x56
[  279.334967]  [<c02823fc>] search_binary_handler+0x76/0x1c2
[  279.342968]  [<c0282404>] search_binary_handler+0x7e/0x1c2
[  279.348668]  [<c02a5388>] load_script+0x0/0x188
[  279.355034]  [<c02835ff>] do_execve+0x125/0x17b
[  279.359763]  [<c020273b>] sys_execve+0x29/0x4d
[  279.366382]  [<c0203c36>] syscall_call+0x7/0xb
[  279.371027]  [<c028007b>] set_anon_super+0x2d/0xa0
[  279.376268]  [<c0206b83>] kernel_execve+0x17/0x1c
[  279.382811]  [<c0201147>] run_init_process+0x17/0x19
[  279.389438]  [<c02011a8>] init_post+0x5f/0xc3
[  279.394243]  [<c0203c8e>] restore_nocheck_notrace+0x0/0xe
[  279.401485]  [<c0204833>] kernel_thread_helper+0x7/0x10
[  279.408103]  =======================



-- 
Thanks & Regards,
Kamalesh Babulal,
Linux Technology Center,
IBM, ISTL.
