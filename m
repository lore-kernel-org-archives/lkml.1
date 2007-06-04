Return-Path: <linux-kernel-owner+w=401wt.eu-S1757539AbXFDPVo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757539AbXFDPVo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2007 11:21:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755569AbXFDPVh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jun 2007 11:21:37 -0400
Received: from gw-e.panasas.com ([65.194.124.178]:47792 "EHLO
	cassoulet.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750795AbXFDPVh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2007 11:21:37 -0400
Message-ID: <46642DE6.4010705@panasas.com>
Date: Mon, 04 Jun 2007 18:21:10 +0300
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Bj=F6rn_Steinbrink?= <B.Steinbrink@gmx.de>,
       Benjamin Pineau <benjamin_pineau@zouh.org>,
       linux-kernel@vger.kernel.org
Subject: Re: 2.6.22-rc3 : "BUG: scheduling while atomic: swapper/0x00000100/0"
References: <20070604135514.GA14426@zouh.org> <20070604143925.GA3363@atjola.homenet> <20070604144101.GB3363@atjola.homenet>
In-Reply-To: <20070604144101.GB3363@atjola.homenet>
Content-Type: multipart/mixed;
 boundary="------------010205090806020707080904"
X-OriginalArrivalTime: 04 Jun 2007 15:21:18.0291 (UTC) FILETIME=[FFBB5230:01C7A6BB]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------010205090806020707080904
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit

Björn Steinbrink wrote:
> On 2007.06.04 16:39:25 +0200, Björn Steinbrink wrote:
>> On 2007.06.04 15:55:14 +0200, Benjamin Pineau wrote:
>>> lspci -vv, lspci -vn, /proc/config.gz, /proc/timer_list, lsmod,
>>> /proc/interrupts, /proc/vmstat, ps auxf, and dmesg (with and 
>>> without the bug's logs) outputs at
>>> http://oshima.zouh.org/~ben/2.6.23-rc3_bug_details.txt
>> To save somebody else from guessing, that's HIRoshima, i.e. the correct
>> URL is http://hiroshima.zouh.org/~ben/2.6.23-rc3_bug_details.txt
> 
> Hmpf, about a second later the original URL also started to work...
> 
> Confused,
> Björn
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

I get something reproducible when using a setup that worked up until 2.6.22-rc2.
I did not report it because the authors of the projects involved do not like that I
use the particular setup that I do.
The setup is using iSCSI Initiator from kernel with iscsi enterprise Target (IET)
which is an out-of-tree kernel module. Both run on the same machine.

(The iet project do not like that I run on the same machine with the Initiator, and
they are probably right, just that it worked perfectly well up to 2.6.21, The first
2.6.22 patches broke the iet over files, and now I have above brakege also when
using iet-over-block-io)

Do I need to bisect this over my setup?

Some dmesg prints:



--------------010205090806020707080904
Content-Type: text/plain;
 name="dmsg-scheduling-while-atomic.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="dmsg-scheduling-while-atomic.txt"

Jun  4 15:41:12 bh-testlin2 kernel: BUG: sleeping function called from invalid context at include2/asm/semaphore.h:105
Jun  4 15:41:12 bh-testlin2 kernel: in_atomic():1, irqs_disabled():0
Jun  4 15:41:12 bh-testlin2 kernel:
Jun  4 15:41:12 bh-testlin2 kernel: Call Trace:
Jun  4 15:41:12 bh-testlin2 kernel:  [<ffffffff802216e1>] __might_sleep+0xb5/0xb7
Jun  4 15:41:12 bh-testlin2 kernel:  [<ffffffff881d3943>] :iscsi_trgt:target_lock+0x4f/0x68
Jun  4 15:41:12 bh-testlin2 kernel:  [<ffffffff881d1333>] :iscsi_trgt:istd+0xa5/0xc3f
Jun  4 15:41:12 bh-testlin2 kernel:  [<ffffffff80223e04>] __wake_up_common+0x42/0x61
Jun  4 15:41:12 bh-testlin2 kernel:  [<ffffffff881d128e>] :iscsi_trgt:istd+0x0/0xc3f
Jun  4 15:41:12 bh-testlin2 kernel:  [<ffffffff80239f4c>] kthread+0x3d/0x63
Jun  4 15:41:12 bh-testlin2 kernel:  [<ffffffff8020a0b8>] child_rip+0xa/0x12
Jun  4 15:41:12 bh-testlin2 kernel:  [<ffffffff80239f0f>] kthread+0x0/0x63
Jun  4 15:41:12 bh-testlin2 kernel:  [<ffffffff8020a0ae>] child_rip+0x0/0x12
Jun  4 15:41:12 bh-testlin2 kernel:
Jun  4 15:41:12 bh-testlin2 kernel: BUG: scheduling while atomic: istd1/0x00000018/3561
Jun  4 15:41:12 bh-testlin2 kernel:
Jun  4 15:41:12 bh-testlin2 kernel: Call Trace:
Jun  4 15:41:13 bh-testlin2 kernel:  [<ffffffff803e34ef>] __sched_text_start+0x5f/0x7ce
Jun  4 15:41:13 bh-testlin2 kernel:  [<ffffffff80223e58>] __wake_up+0x35/0x4b
Jun  4 15:41:13 bh-testlin2 kernel:  [<ffffffff8037aa78>] release_sock+0x10/0xae
Jun  4 15:41:13 bh-testlin2 kernel:  [<ffffffff803e57b0>] _spin_unlock_bh+0x6/0x11
Jun  4 15:41:14 bh-testlin2 kernel:  [<ffffffff803a7187>] tcp_ioctl+0x131/0x13a
Jun  4 15:41:14 bh-testlin2 kernel:  [<ffffffff803a7190>] tcp_sendpage+0x0/0x66b
Jun  4 15:41:14 bh-testlin2 kernel:  [<ffffffff881d12fc>] :iscsi_trgt:istd+0x6e/0xc3f
Jun  4 15:41:14 bh-testlin2 kernel:  [<ffffffff80223e04>] __wake_up_common+0x42/0x61
Jun  4 15:41:14 bh-testlin2 kernel:  [<ffffffff881d128e>] :iscsi_trgt:istd+0x0/0xc3f
Jun  4 15:41:14 bh-testlin2 kernel:  [<ffffffff80239f4c>] kthread+0x3d/0x63
Jun  4 15:41:14 bh-testlin2 kernel:  [<ffffffff8020a0b8>] child_rip+0xa/0x12
Jun  4 15:41:14 bh-testlin2 kernel:  [<ffffffff80239f0f>] kthread+0x0/0x63
Jun  4 15:41:14 bh-testlin2 kernel:  [<ffffffff8020a0ae>] child_rip+0x0/0x12
Jun  4 15:41:14 bh-testlin2 kernel:
Jun  4 15:41:14 bh-testlin2 kernel: >] __sched_text_start+0x5f/0x7ce
Jun  4 15:41:14 bh-testlin2 kernel:  [<ffffffff881ceaae>] :iscsi_trgt:iscsi_cmnd_remove+0x157/0x177
Jun  4 15:41:14 bh-testlin2 kernel:  [<ffffffff803e57b0>] _spin_unlock_bh+0x6/0x11
Jun  4 15:41:14 bh-testlin2 kernel:  [<ffffffff803a7190>] tcp_sendpage+0x0/0x66b
Jun  4 15:41:14 bh-testlin2 kernel:  [<ffffffff881d12fc>] :iscsi_trgt:istd+0x6e/0xc3f
Jun  4 15:41:14 bh-testlin2 kernel:  [<ffffffff80223e04>] __wake_up_common+0x42/0x61
Jun  4 15:41:14 bh-testlin2 kernel:  [<ffffffff881d128e>] :iscsi_trgt:istd+0x0/0xc3f
Jun  4 15:41:14 bh-testlin2 kernel:  [<ffffffff80239f4c>] kthread+0x3d/0x63
Jun  4 15:41:14 bh-testlin2 kernel:  [<ffffffff8020a0b8>] child_rip+0xa/0x12
Jun  4 15:41:14 bh-testlin2 kernel:  [<ffffffff80239f0f>] kthread+0x0/0x63
Jun  4 15:41:14 bh-testlin2 kernel:  [<ffffffff8020a0ae>] child_rip+0x0/0x12
Jun  4 15:41:14 bh-testlin2 kernel: BUG: scheduling while atomic: swapper/0x00000083/0
Jun  4 15:41:14 bh-testlin2 kernel:
Jun  4 15:41:14 bh-testlin2 kernel: Call Trace:
Jun  4 15:41:14 bh-testlin2 kernel:  [<ffffffff803e34ef>] __sched_text_start+0x5f/0x7ce
Jun  4 15:41:14 bh-testlin2 kernel:  [<ffffffff802079ce>] default_idle+0x0/0x3d
Jun  4 15:41:14 bh-testlin2 kernel:  [<ffffffff80207b81>] cpu_idle+0x6e/0x70
Jun  4 15:41:14 bh-testlin2 kernel:  [<ffffffff80500772>] start_kernel+0x29c/0x2a5
Jun  4 15:41:14 bh-testlin2 kernel:  [<ffffffff80500151>] _sinittext+0x151/0x158
Jun  4 15:41:14 bh-testlin2 kernel:
Jun  4 15:41:14 bh-testlin2 kernel: BUG: scheduling while atomic: istd1/0x00000100/3561
Jun  4 15:41:14 bh-testlin2 kernel:
Jun  4 15:41:14 bh-testlin2 kernel: Call Trace:
Jun  4 15:41:14 bh-testlin2 kernel:  [<ffffffff803e34ef>] __sched_text_start+0x5f/0x7ce
Jun  4 15:41:14 bh-testlin2 kernel:  [<ffffffff80223e58>] __wake_up+0x35/0x4b
Jun  4 15:41:14 bh-testlin2 kernel:  [<ffffffff8037aa78>] release_sock+0x10/0xae
Jun  4 15:41:14 bh-testlin2 kernel:  [<ffffffff803e57b0>] _spin_unlock_bh+0x6/0x11
Jun  4 15:41:14 bh-testlin2 kernel:  [<ffffffff803a7187>] tcp_ioctl+0x131/0x13a
Jun  4 15:41:14 bh-testlin2 kernel:  [<ffffffff803a7190>] tcp_sendpage+0x0/0x66b
Jun  4 15:41:14 bh-testlin2 kernel:  [<ffffffff881d12fc>] :iscsi_trgt:istd+0x6e/0xc3f
Jun  4 15:41:14 bh-testlin2 kernel:  [<ffffffff80223e04>] __wake_up_common+0x42/0x61
Jun  4 15:41:14 bh-testlin2 kernel:  [<ffffffff881d128e>] :iscsi_trgt:istd+0x0/0xc3f
Jun  4 15:41:14 bh-testlin2 kernel:  [<ffffffff80239f4c>] kthread+0x3d/0x63
Jun  4 15:41:14 bh-testlin2 kernel:  [<ffffffff8020a0b8>] child_rip+0xa/0x12
Jun  4 15:41:14 bh-testlin2 kernel:  [<ffffffff80239f0f>] kthread+0x0/0x63
Jun  4 15:41:14 bh-testlin2 kernel:  [<ffffffff8020a0ae>] child_rip+0x0/0x12
Jun  4 15:41:14 bh-testlin2 kernel:
Jun  4 15:41:14 bh-testlin2 kernel: BUG: scheduling while atomic: swapper/0x00000083/0
Jun  4 15:41:14 bh-testlin2 kernel:
Jun  4 15:41:14 bh-testlin2 kernel: Call Trace:
Jun  4 15:41:14 bh-testlin2 kernel:  [<ffffffff803e34ef>] __sched_text_start+0x5f/0x7ce
Jun  4 15:41:14 bh-testlin2 kernel:  [<ffffffff802079ce>] default_idle+0x0/0x3d
Jun  4 15:41:14 bh-testlin2 kernel:  [<ffffffff80207b81>] cpu_idle+0x6e/0x70
Jun  4 15:41:14 bh-testlin2 kernel:  [<ffffffff80500772>] start_kernel+0x29c/0x2a5
Jun  4 15:41:14 bh-testlin2 kernel:  [<ffffffff80500151>] _sinittext+0x151/0x158
Jun  4 15:41:14 bh-testlin2 kernel:
Jun  4 15:41:14 bh-testlin2 kernel: BUG: scheduling while atomic: istd1/0x00000100/3561
Jun  4 15:41:14 bh-testlin2 kernel:
Jun  4 15:41:14 bh-testlin2 kernel: Call Trace:
Jun  4 15:41:14 bh-testlin2 kernel:  [<ffffffff803e34ef>] __sched_text_start+0x5f/0x7ce
Jun  4 15:41:14 bh-testlin2 kernel:  [<ffffffff881ceaae>] :iscsi_trgt:iscsi_cmnd_remove+0x157/0x177
Jun  4 15:41:14 bh-testlin2 kernel:  [<ffffffff803e57b0>] _spin_unlock_bh+0x6/0x11
Jun  4 15:41:14 bh-testlin2 kernel:  [<ffffffff803a7190>] tcp_sendpage+0x0/0x66b
Jun  4 15:41:14 bh-testlin2 kernel:  [<ffffffff881d12fc>] :iscsi_trgt:istd+0x6e/0xc3f
Jun  4 15:41:14 bh-testlin2 kernel:  [<ffffffff80223e04>] __wake_up_common+0x42/0x61
Jun  4 15:41:14 bh-testlin2 kernel:  [<ffffffff881d128e>] :iscsi_trgt:istd+0x0/0xc3f
Jun  4 15:41:14 bh-testlin2 kernel:  [<ffffffff80239f4c>] kthread+0x3d/0x63
Jun  4 15:41:14 bh-testlin2 kernel:  [<ffffffff8020a0b8>] child_rip+0xa/0x12
Jun  4 15:41:14 bh-testlin2 kernel:  [<ffffffff80239f0f>] kthread+0x0/0x63
Jun  4 15:41:14 bh-testlin2 kernel:  [<ffffffff8020a0ae>] child_rip+0x0/0x12
Jun  4 15:41:14 bh-testlin2 kernel:
Jun  4 15:41:14 bh-testlin2 kernel: BUG: scheduling while atomic: swapper/0x00000084/0
Jun  4 15:41:14 bh-testlin2 kernel:
Jun  4 15:41:14 bh-testlin2 kernel: Call Trace:
Jun  4 15:41:14 bh-testlin2 kernel:  [<ffffffff803e34ef>] __sched_text_start+0x5f/0x7ce
Jun  4 15:41:14 bh-testlin2 kernel:  [<ffffffff802079ce>] default_idle+0x0/0x3d
Jun  4 15:41:14 bh-testlin2 kernel:  [<ffffffff80207b81>] cpu_idle+0x6e/0x70
Jun  4 15:41:14 bh-testlin2 kernel:  [<ffffffff80500772>] start_kernel+0x29c/0x2a5
Jun  4 15:41:14 bh-testlin2 kernel:  [<ffffffff80500151>] _sinittext+0x151/0x158
Jun  4 15:41:14 bh-testlin2 kernel:
Jun  4 15:41:14 bh-testlin2 kernel: BUG: scheduling while atomic: istd1/0x00000100/3561
Jun  4 15:41:14 bh-testlin2 kernel:
Jun  4 15:41:14 bh-testlin2 kernel: Call Trace:
Jun  4 15:41:14 bh-testlin2 kernel:  [<ffffffff803e34ef>] __sched_text_start+0x5f/0x7ce
Jun  4 15:41:14 bh-testlin2 kernel:  [<ffffffff80223e58>] __wake_up+0x35/0x4b
Jun  4 15:41:14 bh-testlin2 kernel:  [<ffffffff8037aa78>] release_sock+0x10/0xae
Jun  4 15:41:14 bh-testlin2 kernel:  [<ffffffff803e57b0>] _spin_unlock_bh+0x6/0x11
Jun  4 15:41:14 bh-testlin2 kernel:  [<ffffffff803a7187>] tcp_ioctl+0x131/0x13a
Jun  4 15:41:14 bh-testlin2 kernel:  [<ffffffff803a7190>] tcp_sendpage+0x0/0x66b
Jun  4 15:41:15 bh-testlin2 kernel:  [<ffffffff881d12fc>] :iscsi_trgt:istd+0x6e/0xc3f
Jun  4 15:41:15 bh-testlin2 kernel:  [<ffffffff80223e04>] __wake_up_common+0x42/0x61
Jun  4 15:41:15 bh-testlin2 kernel:  [<ffffffff881d128e>] :iscsi_trgt:istd+0x0/0xc3f
Jun  4 15:41:15 bh-testlin2 kernel:  [<ffffffff80239f4c>] kthread+0x3d/0x63
Jun  4 15:41:15 bh-testlin2 kernel:  [<ffffffff8020a0b8>] child_rip+0xa/0x12
Jun  4 15:41:15 bh-testlin2 kernel:  [<ffffffff80239f0f>] kthread+0x0/0x63
Jun  4 15:41:15 bh-testlin2 kernel:  [<ffffffff8020a0ae>] child_rip+0x0/0x12
Jun  4 15:41:15 bh-testlin2 kernel:
Jun  4 15:41:15 bh-testlin2 kernel: BUG: scheduling while atomic: swapper/0x00000084/0
Jun  4 15:41:15 bh-testlin2 kernel:
Jun  4 15:41:15 bh-testlin2 kernel: Call Trace:
Jun  4 15:41:15 bh-testlin2 kernel:  [<ffffffff803e34ef>] __sched_text_start+0x5f/0x7ce
Jun  4 15:41:15 bh-testlin2 kernel:  [<ffffffff802079ce>] default_idle+0x0/0x3d
Jun  4 15:41:15 bh-testlin2 kernel:  [<ffffffff80207b81>] cpu_idle+0x6e/0x70
Jun  4 15:41:15 bh-testlin2 kernel:  [<ffffffff80500772>] start_kernel+0x29c/0x2a5
Jun  4 15:41:15 bh-testlin2 kernel:  [<ffffffff80500151>] _sinittext+0x151/0x158
Jun  4 15:41:15 bh-testlin2 kernel:
Jun  4 15:41:15 bh-testlin2 kernel: BUG: scheduling while atomic: istd1/0x00000100/3561
Jun  4 15:41:15 bh-testlin2 kernel:
Jun  4 15:41:15 bh-testlin2 kernel: Call Trace:
Jun  4 15:41:15 bh-testlin2 kernel:  [<ffffffff803e34ef>] __sched_text_start+0x5f/0x7ce
Jun  4 15:41:15 bh-testlin2 kernel:  [<ffffffff881ceaae>] :iscsi_trgt:iscsi_cmnd_remove+0x157/0x177
Jun  4 15:41:15 bh-testlin2 kernel:  [<ffffffff803e57b0>] _spin_unlock_bh+0x6/0x11
Jun  4 15:41:15 bh-testlin2 kernel: /0x00000100/3561
Jun  4 15:41:15 bh-testlin2 kernel:
Jun  4 15:41:15 bh-testlin2 kernel: Call Trace:
Jun  4 15:41:15 bh-testlin2 kernel:  [<ffffffff803e34ef>] __sched_text_start+0x5f/0x7ce
Jun  4 15:41:15 bh-testlin2 kernel:  [<ffffffff881ceaae>] :iscsi_trgt:iscsi_cmnd_remove+0x157/0x177
Jun  4 15:41:15 bh-testlin2 kernel:  [<ffffffff803e57b0>] _spin_unlock_bh+0x6/0x11
Jun  4 15:41:15 bh-testlin2 kernel:  [<ffffffff881d12fc>] :iscsi_trgt:istd+0x6e/0xc3f
Jun  4 15:41:15 bh-testlin2 kernel:  [<ffffffff80223e04>] __wake_up_common+0x42/0x61
Jun  4 15:41:15 bh-testlin2 kernel:  [<ffffffff881d128e>] :iscsi_trgt:istd+0x0/0xc3f
Jun  4 15:41:15 bh-testlin2 kernel:  [<ffffffff80239f4c>] kthread+0x3d/0x63
Jun  4 15:41:15 bh-testlin2 kernel:  [<ffffffff8020a0b8>] child_rip+0xa/0x12
Jun  4 15:41:15 bh-testlin2 kernel:  [<ffffffff80239f0f>] kthread+0x0/0x63
Jun  4 15:41:15 bh-testlin2 kernel:  [<ffffffff8020a0ae>] child_rip+0x0/0x12
Jun  4 15:41:15 bh-testlin2 kernel:
Jun  4 15:41:15 bh-testlin2 kernel: BUG: scheduling while atomic: swapper/0x000000b5/0
Jun  4 15:41:15 bh-testlin2 kernel:
Jun  4 15:41:15 bh-testlin2 kernel: Call Trace:
Jun  4 15:41:15 bh-testlin2 kernel:  [<ffffffff803e34ef>] __sched_text_start+0x5f/0x7ce
Jun  4 15:41:15 bh-testlin2 kernel:  [<ffffffff802079ce>] default_idle+0x0/0x3d
Jun  4 15:41:15 bh-testlin2 kernel:  [<ffffffff80207b81>] cpu_idle+0x6e/0x70
Jun  4 15:41:15 bh-testlin2 kernel:  [<ffffffff80500772>] start_kernel+0x29c/0x2a5
Jun  4 15:41:15 bh-testlin2 kernel:  [<ffffffff80500151>] _sinittext+0x151/0x158
Jun  4 15:41:15 bh-testlin2 kernel:

--------------010205090806020707080904--
