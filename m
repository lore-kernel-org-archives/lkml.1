Return-Path: <linux-kernel-owner+w=401wt.eu-S1752757AbYJCNup@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752757AbYJCNup (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2008 09:50:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751846AbYJCNug
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Oct 2008 09:50:36 -0400
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:41618 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751659AbYJCNuf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2008 09:50:35 -0400
Message-ID: <48E62253.1090000@bull.net>
Date: Fri, 03 Oct 2008 15:46:59 +0200
From: Gilles Carry <Gilles.Carry@bull.net>
User-Agent: Mozilla Thunderbird 1.0 (X11/20041206)
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Gregory Haskins <ghaskins@novell.com>
Cc: Chirag Jog <chirag@linux.vnet.ibm.com>, linux-rt-users@vger.kernel.org,
       linux-kernel@vger.kernel.org, rostedt@goodmis.org, dvhltc@us.ibm.com,
       dino@in.ibm.com
Subject: Re: [PATCH 2/2] RT: remove "paranoid" limit in push_rt_task
References: <20081003123745.17387.61782.stgit@dev.haskins.net> <20081003124305.17387.90233.stgit@dev.haskins.net>
In-Reply-To: <20081003124305.17387.90233.stgit@dev.haskins.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry Greg,

Neither PPC64 nor Intel64 make it with this patch.
At boot time, it stops at the BUG_ON you added:
0xc00000000004eca4 is in push_rt_task (kernel/sched_rt.c:1102)

I let you do more investigations.
Have a good week-end in you garage ;)

Gilles.


PPC64:
cpu 0x2: Vector: 700 (Program Check) at [c0000000ee2877b0]
     pc: c00000000004eca4: .push_rt_task+0x1f4/0x2d0
     lr: c00000000004ec24: .push_rt_task+0x174/0x2d0
     sp: c0000000ee287a30
    msr: 8000000000021032
   current = 0xc0000000ee276fe0
   paca    = 0xc0000000005c3780
     pid   = 36, comm = sirq-block/2
kernel BUG at kernel/sched_rt.c:1102!
enter ? for help
[c0000000ee287a30] c00000000004ec78 .push_rt_task+0x1c8/0x2d0 (unreliable)
[c0000000ee287ae0] c00000000004eda4 .push_rt_tasks+0x24/0x44
[c0000000ee287b70] c00000000004edf0 .post_schedule_rt+0x2c/0x50
[c0000000ee287c00] c000000000052864 .finish_task_switch+0x100/0x1a8
[c0000000ee287cb0] c0000000002cdbd0 .__schedule+0x6a0/0x75c
[c0000000ee287d90] c0000000002cdedc .schedule+0xf4/0x128
[c0000000ee287e20] c000000000061700 .ksoftirqd+0x124/0x37c
[c0000000ee287f00] c000000000076dc0 .kthread+0x84/0xd4
[c0000000ee287f90] c000000000029368 .kernel_thread+0x4c/0x68
2:mon>

Intel64:
kernel BUG at kernel/sched_rt.c:1102!
invalid opcode: 0000 [1] PREEMPT SMP
CPU 4
Modules linked in: mptsas scsi_transport_sas
Pid: 61, comm: sirq-block/4 Not tainted 2.6.26.5-rt9-00002-g3b27927-dirty #26
RIP: 0010:[<ffffffff8022b307>]  [<ffffffff8022b307>] push_rt_task+0x15f/0x20b
RSP: 0018:ffff81007f4d5d70  EFLAGS: 00010097
RAX: 0000000000000000 RBX: ffff81007edf09d0 RCX: 000000000822b765
RDX: 000000000822b765 RSI: 0000000000000000 RDI: ffff81000103f280
RBP: ffff81007f4d5da0 R08: ffff81007f4d4000 R09: ffff81007edcbe20
R10: 00000000ffffffff R11: ffffffff8021fa2c R12: 0000000000000000
R13: ffff810001034280 R14: ffff81007edf09e0 R15: ffff81000103f280
FS:  00007f2f26e776f0(0000) GS:ffff81007fc0ccc0(0000) knlGS:0000000000000000
CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
CR2: 00000000006b9fb0 CR3: 00000001bf4c9000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process sirq-block/4 (pid: 61, threadinfo ffff81007f4d4000, task
ffff81007f4d0e10)
Stack:  000000007f4d5e00 ffff81000103f280 ffff81007edf09d0 ffff8101bf457540
  0000000000000001 0000000000000002 ffff81007f4d5dc0 ffffffff8022b3c7
  ffff81007f4d5de0 ffff81000103f280 ffff81007f4d5de0 ffffffff8022b3e8
Call Trace:
  [<ffffffff8022b3c7>] push_rt_tasks+0x14/0x1c
  [<ffffffff8022b3e8>] post_schedule_rt+0x19/0x25
  [<ffffffff8022d7ee>] finish_task_switch+0x73/0x121
  [<ffffffff805bbe3d>] thread_return+0x4f/0xdc
  [<ffffffff805bc066>] schedule+0xd4/0xf0
  [<ffffffff80237eeb>] ksoftirqd+0xb3/0x260
  [<ffffffff80237e38>] ? ksoftirqd+0x0/0x260
  [<ffffffff80245209>] ? kthread+0x47/0x76
  [<ffffffff8022e9f9>] ? schedule_tail+0x43/0x97
  [<ffffffff8020c3d8>] ? child_rip+0xa/0x12
  [<ffffffff802451c2>] ? kthread+0x0/0x76
  [<ffffffff8020c3ce>] ? child_rip+0x0/0x12


Code: 48 c7 c6 c0 1d 23 80 e8 83 b3 03 00 e9 ee fe ff ff 4c 89 e7 e8 b1 31 39
00 eb ba 48 8b 43 08 8b 40 18 41 3b 87 90 0e 00 00 74 04 <0f> 0b eb fe 48 89
de 4c 89 ff e8 5b fe ff ff f0 41 ff 0e 0f 94
RIP  [<ffffffff8022b307>] push_rt_task+0x15f/0x20b
  RSP <ffff81007f4d5d70>


Gregory Haskins wrote:
> A panic was discovered by Chirag Jog and investigated by Gilles Carry
> to be originating in the fact that a task being pushed away
> may get migrated away during a double_lock_balance.  The result was
> that the pushable_tasks list may become corrupted.
> 
> The root cause is that the "paranoid" retry limit could cause us to
> bail out of a retry, but still try to remove the item from the (now
> potentially incorrect) list.  There are numerous ways to correct the
> condition, but the paranoid feature is no longer relevant with the new
> pushable logic (since pushable naturally limits the loop anyway), so
> lets just remove it.
> 
> Reported By: Chirag Jog <chirag@linux.vnet.ibm.com>
> Found-by: Gilles Carry <gilles.carry@bull.net>
> Signed-off-by: Gregory Haskins <ghaskins@novell.com>
> ---
> 
>  kernel/sched_rt.c |    5 +++--
>  1 files changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/kernel/sched_rt.c b/kernel/sched_rt.c
> index 59ead84..5a754fe 100644
> --- a/kernel/sched_rt.c
> +++ b/kernel/sched_rt.c
> @@ -1056,7 +1056,6 @@ static int push_rt_task(struct rq *rq)
>  {
>  	struct task_struct *next_task;
>  	struct rq *lowest_rq;
> -	int paranoid = RT_MAX_TRIES;
>  
>  	if (!rq->rt.overloaded)
>  		return 0;
> @@ -1094,12 +1093,14 @@ static int push_rt_task(struct rq *rq)
>  		 * If it has, then try again.
>  		 */
>  		task = pick_next_pushable_task(rq);
> -		if (unlikely(task != next_task) && task && paranoid--) {
> +		if (unlikely(task != next_task) && task) {
>  			put_task_struct(next_task);
>  			next_task = task;
>  			goto retry;
>  		}
>  
> +		BUG_ON(task_cpu(next_task) != rq->cpu);
> +
>  		/*
>  		 * Once we have failed to push this task, we will not
>  		 * try again, since the other cpus will pull from us
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rt-users" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 
