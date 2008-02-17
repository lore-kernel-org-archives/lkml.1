Return-Path: <linux-kernel-owner+w=401wt.eu-S1754786AbYBQUKE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754786AbYBQUKE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2008 15:10:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752262AbYBQUJy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Feb 2008 15:09:54 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:39143 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751471AbYBQUJy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2008 15:09:54 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
Subject: Re: [BUG] Linux 2.6.25-rc2 - Regression from 2.6.24-rc1-git1 softlockup while bootup on powerpc
Date: Sun, 17 Feb 2008 21:08:18 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linuxppc-dev@ozlabs.org, Ingo Molnar <mingo@elte.hu>,
       Jens Axboe <jens.axboe@oracle.com>,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Andy Whitcroft <apw@shadowen.org>,
       Balbir Singh <balbir@linux.vnet.ibm.com>
References: <alpine.LFD.1.00.0802151302210.9496@woody.linux-foundation.org> <47B67E5E.4010001@linux.vnet.ibm.com>
In-Reply-To: <47B67E5E.4010001@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802172108.19696.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, 16 of February 2008, Kamalesh Babulal wrote:
> Hi,

Hi,
 
> The softlockup is seen from 2.6.25-rc1-git{1,3} and is visible in the 2.6.24-rc2 kernel,
> While booting up with the 2.6.25-rc1-git{1,3} and 2.6.25-rc2 kernel(s) on the powerbox

Can you update the Bugzilla entry at:
http://bugzilla.kernel.org/show_bug.cgi?id=9948
with the above information, please?

Rafael


> Loading st.ko module
> BUG: soft lockup - CPU#1 stuck for 61s! [insmod:379]
> NIP: c0000000001b0620 LR: c0000000001a5dcc CTR: 0000000000000040
> REGS: c00000077caab8a0 TRAP: 0901   Not tainted  (2.6.25-rc2-autotest)
> MSR: 8000000000009032 <EE,ME,IR,DR>  CR: 84004088  XER: 20000000
> TASK = c00000077cb450a0[379] 'insmod' THREAD: c00000077caa8000 CPU: 1
> GPR00: c00000077c9d4000 c00000077caabb20 c000000000538a40 000000000000000b 
> GPR04: ffc0000000000000 c00000077e0c0000 0000000000000036 000000000000000a 
> GPR08: 0040000000000000 c00000077c9d4250 c000000000000000 0000000000000000 
> GPR12: c00000077c9d4230 c000000000481d00 
> NIP [c0000000001b0620] .radix_tree_gang_lookup+0x100/0x1e4
> LR [c0000000001a5dcc] .call_for_each_cic+0x50/0x10c
> Call Trace:
> [c00000077caabb20] [c0000000001a5e2c] .call_for_each_cic+0xb0/0x10c (unreliable)
> [c00000077caabc60] [c00000000019dba4] .exit_io_context+0xf0/0x110
> [c00000077caabcf0] [c000000000061e38] .do_exit+0x820/0x850
> [c00000077caabda0] [c000000000061f34] .do_group_exit+0xcc/0xe8
> [c00000077caabe30] [c00000000000872c] syscall_exit+0x0/0x40
> Instruction dump:
> 7d296214 39290018 e8090000 7caa2038 39290008 2fa00000 409e0018 7caa4215 
> 396b0001 418200cc 424000b8 4bffffdc <79691f24> 7d296214 e9690018 2fab0000 
> INFO: task insmod:387 blocked for more than 120 seconds.
> "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> insmod        D 000000001000e144 12144   387      1
> Call Trace:
> [c00000077cb97600] [c0000000008fae80] 0xc0000000008fae80 (unreliable)
> [c00000077cb977d0] [c000000000010c7c] .__switch_to+0x11c/0x154
> [c00000077cb97860] [c000000000344498] .schedule+0x5d0/0x6b0
> [c00000077cb97950] [c0000000003447d8] .schedule_timeout+0x3c/0xe8
> [c00000077cb97a20] [c000000000343d34] .wait_for_common+0x150/0x22c
> [c00000077cb97ae0] [c00000000008ef00] .__stop_machine_run+0xbc/0xf0
> [c00000077cb97bb0] [c00000000008ef70] .stop_machine_run+0x3c/0x80
> [c00000077cb97c50] [c0000000000891f0] .sys_init_module+0x14e4/0x1af4
> [c00000077cb97e30] [c00000000000872c] syscall_exit+0x0/0x40
> -- 0:conmux-control -- time-stamp -- Feb/15/08 16:04:12 --
> INFO: task insmod:387 blocked for more than 120 seconds.
> "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> insmod        D 000000001000e144 12144   387      1
> Call Trace:
> [c00000077cb97600] [c0000000008fae80] 0xc0000000008fae80 (unreliable)
> [c00000077cb977d0] [c000000000010c7c] .__switch_to+0x11c/0x154
> [c00000077cb97860] [c000000000344498] .schedule+0x5d0/0x6b0
> [c00000077cb97950] [c0000000003447d8] .schedule_timeout+0x3c/0xe8
> [c00000077cb97a20] [c000000000343d34] .wait_for_common+0x150/0x22c
> [c00000077cb97ae0] [c00000000008ef00] .__stop_machine_run+0xbc/0xf0
> [c00000077cb97bb0] [c00000000008ef70] .stop_machine_run+0x3c/0x80
> [c00000077cb97c50] [c0000000000891f0] .sys_init_module+0x14e4/0x1af4
> [c00000077cb97e30] [c00000000000872c] syscall_exit+0x0/0x40
> -- 0:conmux-control -- time-stamp -- Feb/15/08 16:06:21 --



-- 
"Premature optimization is the root of all evil." - Donald Knuth
