Return-Path: <linux-kernel-owner+w=401wt.eu-S937516AbZDJACl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937516AbZDJACl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Apr 2009 20:02:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754017AbZDJACa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Apr 2009 20:02:30 -0400
Received: from gate.crashing.org ([63.228.1.57]:33360 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753907AbZDJAC2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Apr 2009 20:02:28 -0400
Cc: oleg@redhat.com, linux-kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Message-Id: <B6C30A35-DBF7-4710-9F03-9E42775CDA21@kernel.crashing.org>
From: Kumar Gala <galak@kernel.crashing.org>
To: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
In-Reply-To: <20090409213910.GB30645@us.ibm.com>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v930.3)
Subject: Re: LTP 20080131 causes defunct processes w/2.6.30-rc1 (possible ptrace issue?)
Date: Thu, 9 Apr 2009 19:01:24 -0500
References: <0CA2FBE3-C50C-4503-9134-6DA1C6965743@kernel.crashing.org> <0D4C1952-792C-4AFF-8969-1EF5386FDAB9@kernel.crashing.org> <20090409194912.GA30645@us.ibm.com> <0D6A6388-C12F-4066-84B8-155381D14504@kernel.crashing.org> <20090409213910.GB30645@us.ibm.com>
X-Mailer: Apple Mail (2.930.3)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Apr 9, 2009, at 4:39 PM, Sukadev Bhattiprolu wrote:

> Kumar Gala [galak@kernel.crashing.org] wrote:
>>
>> On Apr 9, 2009, at 2:49 PM, Sukadev Bhattiprolu wrote:
>>
>>> Kumar Gala [galak@kernel.crashing.org] wrote:
>>>>
>>>> On Apr 9, 2009, at 10:43 AM, Kumar Gala wrote:
>>>>
>>>>> I'm seeing some weird behavior in 2.6.30-rc1 that didn't exist in
>>>>> 2.6.29.
>>>>> We have a slightly older LTP version (20080131) that we run on  
>>>>> some
>>>>> embedded PPC boards.  If I run the syscall tests on 2.6.29  
>>>>> things pass
>>>>> as
>>>
>>> Will try to repro on a normal machine, but can you attach the
>>> /proc/pid/status
>>> (and possibly the stack) of the parent of the 'recv01' ?
>>
>> Name:   recv01
>> State:  Z (zombie)
>> Tgid:   2449
>> Pid:    2449
>> PPid:   1
>
> Ok, but I meant the status of the parent (i.e /proc/1/status in this  
> case).
>
> To get the stack, if CONFIG_MAGIC_SYSRQ=y, you can:
>
> 	$ echo 1 > /proc/sys/kernel/sysrq
> 	$ echo t > /proc/sysrq-trigger
> 	$ dmesg > /tmp/dmesg.out
>
> Look in /tmp/dmesg.out for the process stack
>
> Suka

-bash-3.2# ps
  PID TTY          TIME CMD
2289 ttyS0    00:00:00 bash
2310 ttyS0    00:00:00 runltp
2412 ttyS0    00:00:00 pan
2448 ttyS0    00:00:00 recv01 <defunct>
2450 ttyS0    00:00:00 recvfrom01 <defunct>
2452 ttyS0    00:00:00 recvmsg01 <defunct>
2473 ttyS0    00:00:00 rename14
2474 ttyS0    00:00:01 rename14
2477 ttyS0    00:00:00 rename14
2481 ttyS0    00:00:00 ps
-bash-3.2# cat /proc/1/status
Name:   init
State:  T (stopped)
Tgid:   1
Pid:    1
PPid:   0
TracerPid:      0
Uid:    0       0       0       0
Gid:    0       0       0       0
FDSize: 32
Groups:
VmPeak:     1948 kB
VmSize:     1944 kB
VmLck:         0 kB
VmHWM:       648 kB
VmRSS:       648 kB
VmData:      164 kB
VmStk:        84 kB
VmExe:       288 kB
VmLib:      1124 kB
VmPTE:        20 kB
Threads:        1
SigQ:   8/16384
SigPnd: 0000000000000000
ShdPnd: 0000000000010000
SigBlk: 0000000000000000
SigIgn: fffffffe57f0d8fc
SigCgt: 00000000280b2603
CapInh: 0000000000000000
CapPrm: fffffffffffffeff
CapEff: fffffffffffffeff
CapBnd: fffffffffffffeff
voluntary_ctxt_switches:        87
nonvoluntary_ctxt_switches:     8
-bash-3.2# cat /proc/2448/stat
2448 (recv01) Z 1 2447 2289 1088 2483 4195404 45 0 0 0 0 0 0 0 20 0 1  
0 685 0 0
4294967295 0 0 0 0 0 0 0 0 0 3221418948 0 0 17 0 0 0 0 0 0
-bash-3.2# cat /proc/2448/status
Name:   recv01
State:  Z (zombie)
Tgid:   2448
Pid:    2448
PPid:   1
TracerPid:      0
Uid:    0       0       0       0
Gid:    0       0       0       0
FDSize: 0
Groups: 0 1 2 3 4 6 10
Threads:        1
SigQ:   8/16384
SigPnd: 0000000000000000
ShdPnd: 0000000000004100
SigBlk: 0000000000000000
SigIgn: 0000000000000000
SigCgt: 0000000000000000
CapInh: 0000000000000000
CapPrm: fffffffffffffeff
CapEff: fffffffffffffeff
CapBnd: fffffffffffffeff
voluntary_ctxt_switches:        6
nonvoluntary_ctxt_switches:     0

--

-bash-3.2# echo t > /proc/sysrq-trigger
SysRq : Show State
Call Trace:
[ef82bc90] [00000900] 0x900 (unreliable)
[ef82bd50] [c0009570] __switch_to+0x8c/0xd4
[ef82bd70] [c0396f34] __schedule+0x2bc/0x7b4
[ef82bdf0] [c0397448] schedule+0x1c/0x3c
[ef82be00] [c003bce4] do_signal_stop+0xa0/0x16c
[ef82be20] [c003c7c0] get_signal_to_deliver+0x14c/0x3a4
[ef82be70] [c0009f0c] do_signal+0x88/0x284
[ef82bf40] [c0013838] do_user_signal+0x74/0xc4
--- Exception: c00 at 0xff39348
    LR = 0x10004cf8
Call Trace:
[ef831e30] [00001032] 0x1032 (unreliable)
[ef831ef0] [c0009570] __switch_to+0x8c/0xd4
[ef831f10] [c0396f34] __schedule+0x2bc/0x7b4
[ef831f90] [c0397448] schedule+0x1c/0x3c
[ef831fa0] [c0044b54] kthreadd+0x17c/0x18c
[ef831ff0] [c0012e5c] kernel_thread+0x4c/0x68
Call Trace:
[ef833eb0] [c0009570] __switch_to+0x8c/0xd4
[ef833ed0] [c0396f34] __schedule+0x2bc/0x7b4
[ef833f50] [c0397448] schedule+0x1c/0x3c
[ef833f60] [c0028278] migration_thread+0x2bc/0x420
[ef833fd0] [c0044bb4] kthread+0x50/0x88
[ef833ff0] [c0012e5c] kernel_thread+0x4c/0x68
Call Trace:
[ef839e30] [c019d110] blk_run_queue+0x28/0x48 (unreliable)
[ef839ef0] [c0009570] __switch_to+0x8c/0xd4
[ef839f10] [c0396f34] __schedule+0x2bc/0x7b4
[ef839f90] [c0397448] schedule+0x1c/0x3c
[ef839fa0] [c00317b0] ksoftirqd+0x108/0x158
[ef839fd0] [c0044bb4] kthread+0x50/0x88
[ef839ff0] [c0012e5c] kernel_thread+0x4c/0x68
Call Trace:
[ef83bf00] [c0009570] __switch_to+0x8c/0xd4
[ef83bf20] [c0396f34] __schedule+0x2bc/0x7b4
[ef83bfa0] [c0397448] schedule+0x1c/0x3c
[ef83bfb0] [c0062eec] watchdog+0x48/0x88
[ef83bfd0] [c0044bb4] kthread+0x50/0x88
[ef83bff0] [c0012e5c] kernel_thread+0x4c/0x68
Call Trace:
[ef841ec0] [c0009570] __switch_to+0x8c/0xd4
[ef841ee0] [c0396f34] __schedule+0x2bc/0x7b4
[ef841f60] [c0397448] schedule+0x1c/0x3c
[ef841f70] [c004048c] worker_thread+0x1b4/0x1b8
[ef841fd0] [c0044bb4] kthread+0x50/0x88
[ef841ff0] [c0012e5c] kernel_thread+0x4c/0x68
Call Trace:
[ef843ec0] [c0009570] __switch_to+0x8c/0xd4
[ef843ee0] [c0396f34] __schedule+0x2bc/0x7b4
[ef843f60] [c0397448] schedule+0x1c/0x3c
[ef843f70] [c004048c] worker_thread+0x1b4/0x1b8
[ef843fd0] [c0044bb4] kthread+0x50/0x88
[ef843ff0] [c0012e5c] kernel_thread+0x4c/0x68
Call Trace:
[ef845e00] [c0022f4c] wake_up_new_task+0xb8/0x124 (unreliable)
[ef845ec0] [c0009570] __switch_to+0x8c/0xd4
[ef845ee0] [c0396f34] __schedule+0x2bc/0x7b4
[ef845f60] [c0397448] schedule+0x1c/0x3c
[ef845f70] [c004048c] worker_thread+0x1b4/0x1b8
[ef845fd0] [c0044bb4] kthread+0x50/0x88
[ef845ff0] [c0012e5c] kernel_thread+0x4c/0x68
Call Trace:
[ef853ed0] [c0009570] __switch_to+0x8c/0xd4
[ef853ef0] [c0396f34] __schedule+0x2bc/0x7b4
[ef853f70] [c0397448] schedule+0x1c/0x3c
[ef853f80] [c004c5b0] async_manager_thread+0xfc/0x12c
[ef853fd0] [c0044bb4] kthread+0x50/0x88
[ef853ff0] [c0012e5c] kernel_thread+0x4c/0x68
Call Trace:
[ef873ec0] [c0009570] __switch_to+0x8c/0xd4
[ef873ee0] [c0396f34] __schedule+0x2bc/0x7b4
[ef873f60] [c0397448] schedule+0x1c/0x3c
[ef873f70] [c004048c] worker_thread+0x1b4/0x1b8
[ef873fd0] [c0044bb4] kthread+0x50/0x88
[ef873ff0] [c0012e5c] kernel_thread+0x4c/0x68
Call Trace:
[ef89de00] [00000001] 0x1 (unreliable)
[ef89dec0] [c0009570] __switch_to+0x8c/0xd4
[ef89dee0] [c0396f34] __schedule+0x2bc/0x7b4
[ef89df60] [c0397448] schedule+0x1c/0x3c
[ef89df70] [c004048c] worker_thread+0x1b4/0x1b8
[ef89dfd0] [c0044bb4] kthread+0x50/0x88
[ef89dff0] [c0012e5c] kernel_thread+0x4c/0x68
Call Trace:
[ef89fec0] [c0009570] __switch_to+0x8c/0xd4
[ef89fee0] [c0396f34] __schedule+0x2bc/0x7b4
[ef89ff60] [c0397448] schedule+0x1c/0x3c
[ef89ff70] [c004048c] worker_thread+0x1b4/0x1b8
[ef89ffd0] [c0044bb4] kthread+0x50/0x88
[ef89fff0] [c0012e5c] kernel_thread+0x4c/0x68
Call Trace:
[ef8a7e80] [c0009570] __switch_to+0x8c/0xd4
[ef8a7ea0] [c0396f34] __schedule+0x2bc/0x7b4
[ef8a7f20] [c0397448] schedule+0x1c/0x3c
[ef8a7f30] [c024d4e8] hub_thread+0xdb0/0xe98
[ef8a7fd0] [c0044bb4] kthread+0x50/0x88
[ef8a7ff0] [c0012e5c] kernel_thread+0x4c/0x68
Call Trace:
[ef8a9eb0] [c0009570] __switch_to+0x8c/0xd4
[ef8a9ed0] [c0396f34] __schedule+0x2bc/0x7b4
[ef8a9f50] [c0397448] schedule+0x1c/0x3c
[ef8a9f60] [c0270574] serio_thread+0x304/0x35c
[ef8a9fd0] [c0044bb4] kthread+0x50/0x88
[ef8a9ff0] [c0012e5c] kernel_thread+0x4c/0x68
Call Trace:
[ef851de0] [c00672dc] call_rcu+0x50/0x68 (unreliable)
[ef851ea0] [c0009570] __switch_to+0x8c/0xd4
[ef851ec0] [c0396f34] __schedule+0x2bc/0x7b4
[ef851f40] [c0397448] schedule+0x1c/0x3c
[ef851f50] [c0397714] schedule_timeout+0x12c/0x1a4
[ef851f90] [c0063224] watchdog+0x60/0x208
[ef851fd0] [c0044bb4] kthread+0x50/0x88
[ef851ff0] [c0012e5c] kernel_thread+0x4c/0x68
Call Trace:
[ef8abdf0] [ef4032b4] 0xef4032b4 (unreliable)
[ef8abeb0] [c0009570] __switch_to+0x8c/0xd4
[ef8abed0] [c0396f34] __schedule+0x2bc/0x7b4
[ef8abf50] [c0397448] schedule+0x1c/0x3c
[ef8abf60] [c0072554] pdflush+0x100/0x254
[ef8abfd0] [c0044bb4] kthread+0x50/0x88
[ef8abff0] [c0012e5c] kernel_thread+0x4c/0x68
Call Trace:
[ef8adeb0] [c0009570] __switch_to+0x8c/0xd4
[ef8aded0] [c0396f34] __schedule+0x2bc/0x7b4
[ef8adf50] [c0397448] schedule+0x1c/0x3c
[ef8adf60] [c0072554] pdflush+0x100/0x254
[ef8adfd0] [c0044bb4] kthread+0x50/0x88
[ef8adff0] [c0012e5c] kernel_thread+0x4c/0x68
Call Trace:
[ef8afe60] [c0009570] __switch_to+0x8c/0xd4
[ef8afe80] [c0396f34] __schedule+0x2bc/0x7b4
[ef8aff00] [c0397448] schedule+0x1c/0x3c
[ef8aff10] [c00778d0] kswapd+0x5c8/0x5d0
[ef8affd0] [c0044bb4] kthread+0x50/0x88
[ef8afff0] [c0012e5c] kernel_thread+0x4c/0x68
Call Trace:
[efab9ec0] [c0009570] __switch_to+0x8c/0xd4
[efab9ee0] [c0396f34] __schedule+0x2bc/0x7b4
[efab9f60] [c0397448] schedule+0x1c/0x3c
[efab9f70] [c004048c] worker_thread+0x1b4/0x1b8
[efab9fd0] [c0044bb4] kthread+0x50/0x88
[efab9ff0] [c0012e5c] kernel_thread+0x4c/0x68
Call Trace:
[efabbec0] [c0009570] __switch_to+0x8c/0xd4
[efabbee0] [c0396f34] __schedule+0x2bc/0x7b4
[efabbf60] [c0397448] schedule+0x1c/0x3c
[efabbf70] [c004048c] worker_thread+0x1b4/0x1b8
[efabbfd0] [c0044bb4] kthread+0x50/0x88
[efabbff0] [c0012e5c] kernel_thread+0x4c/0x68
Call Trace:
[efac7ec0] [c0009570] __switch_to+0x8c/0xd4
[efac7ee0] [c0396f34] __schedule+0x2bc/0x7b4
[efac7f60] [c0397448] schedule+0x1c/0x3c
[efac7f70] [c004048c] worker_thread+0x1b4/0x1b8
[efac7fd0] [c0044bb4] kthread+0x50/0x88
[efac7ff0] [c0012e5c] kernel_thread+0x4c/0x68
Call Trace:
[efb89e00] [72626f20] 0x72626f20 (unreliable)
[efb89ec0] [c0009570] __switch_to+0x8c/0xd4
[efb89ee0] [c0396f34] __schedule+0x2bc/0x7b4
[efb89f60] [c0397448] schedule+0x1c/0x3c
[efb89f70] [c0205a24] scsi_error_handler+0xa4/0x5f8
[efb89fd0] [c0044bb4] kthread+0x50/0x88
[efb89ff0] [c0012e5c] kernel_thread+0x4c/0x68
Call Trace:
[eedd9e00] [eedd9e18] 0xeedd9e18 (unreliable)
[eedd9ec0] [c0009570] __switch_to+0x8c/0xd4
[eedd9ee0] [c0396f34] __schedule+0x2bc/0x7b4
[eedd9f60] [c0397448] schedule+0x1c/0x3c
[eedd9f70] [c0205a24] scsi_error_handler+0xa4/0x5f8
[eedd9fd0] [c0044bb4] kthread+0x50/0x88
[eedd9ff0] [c0012e5c] kernel_thread+0x4c/0x68
Call Trace:
[eee23e00] [c1808880] 0xc1808880 (unreliable)
[eee23ec0] [c0009570] __switch_to+0x8c/0xd4
[eee23ee0] [c0396f34] __schedule+0x2bc/0x7b4
[eee23f60] [c0397448] schedule+0x1c/0x3c
[eee23f70] [c004048c] worker_thread+0x1b4/0x1b8
[eee23fd0] [c0044bb4] kthread+0x50/0x88
[eee23ff0] [c0012e5c] kernel_thread+0x4c/0x68
Call Trace:
[ef2bbe00] [ef2ba000] 0xef2ba000 (unreliable)
[ef2bbec0] [c0009570] __switch_to+0x8c/0xd4
[ef2bbee0] [c0396f34] __schedule+0x2bc/0x7b4
[ef2bbf60] [c0397448] schedule+0x1c/0x3c
[ef2bbf70] [c004048c] worker_thread+0x1b4/0x1b8
[ef2bbfd0] [c0044bb4] kthread+0x50/0x88
[ef2bbff0] [c0012e5c] kernel_thread+0x4c/0x68
Call Trace:
[eee0b980] [c0009570] __switch_to+0x8c/0xd4
[eee0b9a0] [c0396f34] __schedule+0x2bc/0x7b4
[eee0ba20] [c0397448] schedule+0x1c/0x3c
[eee0ba30] [c03986f0] schedule_hrtimeout_range+0x1ac/0x1b8
[eee0bab0] [c00acf88] poll_schedule_timeout+0x3c/0x60
[eee0bac0] [c00adc34] do_select+0x3ec/0x4b0
[eee0bdb0] [c00adf8c] core_sys_select+0x294/0x388
[eee0bf00] [c00ae364] sys_select+0x40/0x138
[eee0bf30] [c00055f0] ppc_select+0x18/0xa0
[eee0bf40] [c0013038] ret_from_syscall+0x0/0x38
--- Exception: c01 at 0x200b6348
    LR = 0x20183c50
Call Trace:
[ee831cf0] [c02c0ecc] sock_alloc_send_pskb+0x208/0x31c (unreliable)
[ee831db0] [c0009570] __switch_to+0x8c/0xd4
[ee831dd0] [c0396f34] __schedule+0x2bc/0x7b4
[ee831e50] [c0397448] schedule+0x1c/0x3c
[ee831e60] [c002cd68] do_syslog+0x444/0x49c
[ee831ec0] [c00eaf08] kmsg_read+0x34/0x68
[ee831ed0] [c00e0fc8] proc_reg_read+0x80/0xb4
[ee831ef0] [c009d16c] vfs_read+0xb4/0x16c
[ee831f10] [c009d32c] sys_read+0x4c/0xa4
[ee831f40] [c0013038] ret_from_syscall+0x0/0x38
--- Exception: c01 at 0x2055b0dc
    LR = 0x2062c178
Call Trace:
[ef2a5980] [c0009570] __switch_to+0x8c/0xd4
[ef2a59a0] [c0396f34] __schedule+0x2bc/0x7b4
[ef2a5a20] [c0397448] schedule+0x1c/0x3c
[ef2a5a30] [c03986f0] schedule_hrtimeout_range+0x1ac/0x1b8
[ef2a5ab0] [c00acf88] poll_schedule_timeout+0x3c/0x60
[ef2a5ac0] [c00adc34] do_select+0x3ec/0x4b0
[ef2a5db0] [c00adf8c] core_sys_select+0x294/0x388
[ef2a5f00] [c00ae364] sys_select+0x40/0x138
[ef2a5f30] [c00055f0] ppc_select+0x18/0xa0
[ef2a5f40] [c0013038] ret_from_syscall+0x0/0x38
--- Exception: c01 at 0x2047c348
    LR = 0x2078456c
Call Trace:
[efac9d30] [c006be0c] mempool_free+0xb8/0xcc (unreliable)
[efac9df0] [c0009570] __switch_to+0x8c/0xd4
[efac9e10] [c0396f34] __schedule+0x2bc/0x7b4
[efac9e90] [c0397448] schedule+0x1c/0x3c
[efac9ea0] [c002ec3c] do_wait+0x210/0x3c4
[efac9f20] [c002ee6c] sys_wait4+0x7c/0xc4
[efac9f40] [c0013038] ret_from_syscall+0x0/0x38
--- Exception: c01 at 0xfde21e8
    LR = 0xfec28a8
Call Trace:
[ee827e20] [c0008c34] show_stack+0x48/0x15c (unreliable)
[ee827e50] [c0026e10] sched_show_task+0xbc/0xf8
[ee827e60] [c0026ec4] show_state_filter+0x78/0xdc
[ee827e80] [c01e883c] sysrq_handle_showstate+0x14/0x24
[ee827e90] [c01e8684] __handle_sysrq+0xd0/0x1c0
[ee827ec0] [c01e87d0] write_sysrq_trigger+0x5c/0x68
[ee827ed0] [c00e0f14] proc_reg_write+0x80/0xb4
[ee827ef0] [c009cea0] vfs_write+0xb4/0x16c
[ee827f10] [c009d060] sys_write+0x4c/0xa4
[ee827f40] [c0013038] ret_from_syscall+0x0/0x38
--- Exception: c01 at 0xfe89160
    LR = 0xfe373b4
Call Trace:
[eeca7c90] [c052b9e8] __per_cpu_offset+0x0/0x8 (unreliable)
[eeca7d50] [c0009570] __switch_to+0x8c/0xd4
[eeca7d70] [c0396f34] __schedule+0x2bc/0x7b4
[eeca7df0] [c0397448] schedule+0x1c/0x3c
[eeca7e00] [c003bce4] do_signal_stop+0xa0/0x16c
[eeca7e20] [c003c7c0] get_signal_to_deliver+0x14c/0x3a4
[eeca7e70] [c0009f0c] do_signal+0x88/0x284
[eeca7f40] [c0013838] do_user_signal+0x74/0xc4
--- Exception: c00 at 0xfe64288
    LR = 0x10036560
Call Trace:
[ee821c90] [00000140] 0x140 (unreliable)
[ee821d50] [c0009570] __switch_to+0x8c/0xd4
[ee821d70] [c0396f34] __schedule+0x2bc/0x7b4
[ee821df0] [c0397448] schedule+0x1c/0x3c
[ee821e00] [c003bce4] do_signal_stop+0xa0/0x16c
[ee821e20] [c003c7c0] get_signal_to_deliver+0x14c/0x3a4
[ee821e70] [c0009f0c] do_signal+0x88/0x284
[ee821f40] [c0013838] do_user_signal+0x74/0xc4
--- Exception: c00 at 0xfe191e8
    LR = 0xfef98a8
Call Trace:
[efba1c40] [ee9ee000] 0xee9ee000 (unreliable)
[efba1d00] [c0009570] __switch_to+0x8c/0xd4
[efba1d20] [c0396f34] __schedule+0x2bc/0x7b4
[efba1da0] [c0397448] schedule+0x1c/0x3c
[efba1db0] [c002f3c4] do_exit+0x440/0x61c
[efba1e00] [c002f5e8] do_group_exit+0x48/0xb4
[efba1e20] [c003c824] get_signal_to_deliver+0x1b0/0x3a4
[efba1e70] [c0009f0c] do_signal+0x88/0x284
[efba1f40] [c0013838] do_user_signal+0x74/0xc4
--- Exception: c00 at 0xff39348
    LR = 0x10001b00
Call Trace:
[ee9e5c40] [ee9ee160] 0xee9ee160 (unreliable)
[ee9e5d00] [c0009570] __switch_to+0x8c/0xd4
[ee9e5d20] [c0396f34] __schedule+0x2bc/0x7b4
[ee9e5da0] [c0397448] schedule+0x1c/0x3c
[ee9e5db0] [c002f3c4] do_exit+0x440/0x61c
[ee9e5e00] [c002f5e8] do_group_exit+0x48/0xb4
[ee9e5e20] [c003c824] get_signal_to_deliver+0x1b0/0x3a4
[ee9e5e70] [c0009f0c] do_signal+0x88/0x284
[ee9e5f40] [c0013838] do_user_signal+0x74/0xc4
--- Exception: c00 at 0xff39348
    LR = 0x10001b94
Call Trace:
[eeddbc40] [c02ca018] __scm_destroy+0xdc/0x104 (unreliable)
[eeddbd00] [c0009570] __switch_to+0x8c/0xd4
[eeddbd20] [c0396f34] __schedule+0x2bc/0x7b4
[eeddbda0] [c0397448] schedule+0x1c/0x3c
[eeddbdb0] [c002f3c4] do_exit+0x440/0x61c
[eeddbe00] [c002f5e8] do_group_exit+0x48/0xb4
[eeddbe20] [c003c824] get_signal_to_deliver+0x1b0/0x3a4
[eeddbe70] [c0009f0c] do_signal+0x88/0x284
[eeddbf40] [c0013838] do_user_signal+0x74/0xc4
--- Exception: c00 at 0xff39348
    LR = 0x100024e4
Call Trace:
[efb95dc0] [eea50030] 0xeea50030 (unreliable)
[efb95e80] [c0009570] __switch_to+0x8c/0xd4
[efb95ea0] [c0396f34] __schedule+0x2bc/0x7b4
[efb95f20] [c0397448] schedule+0x1c/0x3c
[efb95f30] [c0038eac] sys_pause+0x18/0x2c
[efb95f40] [c0013038] ret_from_syscall+0x0/0x38
--- Exception: c01 at 0xff0c9a8
    LR = 0x10000f3c
Call Trace:
[eee03dd0] [00000001] 0x1 (unreliable)
[eee03e90] [c0009570] __switch_to+0x8c/0xd4
[eee03eb0] [c0396f34] __schedule+0x2bc/0x7b4
[eee03f30] [c0397448] schedule+0x1c/0x3c
[eee03f40] [c00137a4] recheck+0x0/0x20
--- Exception: c01 at 0xff31068
    LR = 0x100011a0
Call Trace:
[eedd7dd0] [ef824000] 0xef824000 (unreliable)
[eedd7e90] [c0009570] __switch_to+0x8c/0xd4
[eedd7eb0] [c0396f34] __schedule+0x2bc/0x7b4
[eedd7f30] [c0397448] schedule+0x1c/0x3c
[eedd7f40] [c00137a4] recheck+0x0/0x20
--- Exception: c01 at 0xfecfcbc
    LR = 0x100011cc
Sched Debug Version: v0.09, 2.6.30-rc1 #17
now at 11328.667077 msecs
  .jiffies                                 : 4294678606
  .sysctl_sched_latency                    : 20.000000
  .sysctl_sched_min_granularity            : 4.000000
  .sysctl_sched_wakeup_granularity         : 5.000000
  .sysctl_sched_child_runs_first           : 0.000001
  .sysctl_sched_features                   : 113917

cpu#0
  .nr_running                    : 3
  .load                          : 3072
  .nr_switches                   : 11083
  .nr_load_updates               : 6686
  .nr_uninterruptible            : 0
  .next_balance                  : 4294.674587
  .curr->pid                     : 2289
  .clock                         : 11311.326992
  .cpu_load[0]                   : 2048
  .cpu_load[1]                   : 2048
  .cpu_load[2]                   : 2048
  .cpu_load[3]                   : 2048
  .cpu_load[4]                   : 2048

cfs_rq[0]:
  .exec_clock                    : 0.000000
  .MIN_vruntime                  : 6826.174825
  .min_vruntime                  : 6826.172137
  .max_vruntime                  : 6826.606277
  .spread                        : 0.431452
  .spread0                       : 0.000000
  .nr_running                    : 3
  .load                          : 3072
  .nr_spread_over                : 0

rt_rq[0]:
  .rt_nr_running                 : 0
  .rt_throttled                  : 0
  .rt_time                       : 0.000000
  .rt_runtime                    : 950.000000

runnable tasks:
            task   PID         tree-key  switches  prio     exec-runtime
sum-exec        sum-sleep
--------------------------------------------------------------------------------
--------------------------
R           bash  2289      6806.177849       350   120               0
      0               0.000000               0.000000                
0.000000
        rename14  2474      6826.174825       265   120               0
      0               0.000000               0.000000                
0.000000
        rename14  2477      6826.606277       322   120               0
      0               0.000000               0.000000                
0.000000

