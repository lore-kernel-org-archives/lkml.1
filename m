Return-Path: <linux-kernel-owner+w=401wt.eu-S1756334AbZKZRKi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756334AbZKZRKi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Nov 2009 12:10:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755582AbZKZRKi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Nov 2009 12:10:38 -0500
Received: from na3sys009aog111.obsmtp.com ([74.125.149.205]:59103 "EHLO
	na3sys009aog111.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755069AbZKZRKh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Nov 2009 12:10:37 -0500
From: "Leyendecker, Robert" <Robert.Leyendecker@lsi.com>
To: Eric Paris <eparis@redhat.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: "hpa@zytor.com" <hpa@zytor.com>,
       "a.p.zijlstra@chello.nl" <a.p.zijlstra@chello.nl>,
       "efault@gmx.de" <efault@gmx.de>,
       "tglx@linutronix.de" <tglx@linutronix.de>,
       "mingo@elte.hu" <mingo@elte.hu>
Date: Thu, 26 Nov 2009 12:09:25 -0500
Subject: RE: [regression bisect -next] BUG: using smp_processor_id() in
 preemptible [00000000] code: rmmod
Thread-Topic: [regression bisect -next] BUG: using smp_processor_id() in
 preemptible [00000000] code: rmmod
Thread-Index: AcpuuZuDj8o1UPozRWifix5+kR1+OQAABmNQ
Message-ID: <8C8865ED624BB94F8FE50259E2B5C5B304593DAB99@palmail03.lsi.com>
References: <1256784158.2848.8.camel@dhcp231-106.rdu.redhat.com>
In-Reply-To: <1256784158.2848.8.camel@dhcp231-106.rdu.redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha.home.local id nAQHAp16031261


> -----Original Message-----
> From: linux-kernel-owner@vger.kernel.org [mailto:linux-kernel-
> owner@vger.kernel.org] On Behalf Of Eric Paris
> Sent: Wednesday, October 28, 2009 9:43 PM
> To: linux-kernel@vger.kernel.org
> Cc: hpa@zytor.com; a.p.zijlstra@chello.nl; efault@gmx.de;
> tglx@linutronix.de; mingo@elte.hu
> Subject: [regression bisect -next] BUG: using smp_processor_id() in
> preemptible [00000000] code: rmmod
> 
> I get a slew of these on boot.
> 
> [    4.590699] BUG: using smp_processor_id() in preemptible [00000000]
> code: rmmod/1314
> [    4.593043] caller is task_hot+0x86/0xd0
> [    4.593872] Pid: 1314, comm: rmmod Tainted: G        W  2.6.32-rc3-
> fanotify #127
> [    4.595443] Call Trace:
> [    4.596177]  [<ffffffff812ad35b>] debug_smp_processor_id+0x11b/0x120
> [    4.597337]  [<ffffffff81051d66>] task_hot+0x86/0xd0
> [    4.598320]  [<ffffffff81066275>] set_task_cpu+0x115/0x270
> [    4.599368]  [<ffffffff810985ab>] kthread_bind+0x6b/0x100
> [    4.600354]  [<ffffffff810914f0>] start_workqueue_thread+0x30/0x60
> [    4.601545]  [<ffffffff810941dd>] __create_workqueue_key+0x18d/0x2f0
> [    4.602526]  [<ffffffff810d9bee>] stop_machine_create+0x4e/0xd0
> [    4.603811]  [<ffffffff810c5818>] sys_delete_module+0x98/0x250
> [    4.604922]  [<ffffffff810e2505>] ? audit_syscall_entry+0x205/0x290
> [    4.606202]  [<ffffffff81013202>] system_call_fastpath+0x16/0x1b
> 
> f685ceacab07d3f6c236f04803e2f2f0dbcc5afb is first bad commit commit
> f685ceacab07d3f6c236f04803e2f2f0dbcc5afb
> Author: Mike Galbraith <efault@gmx.de>
> Date:   Fri Oct 23 23:09:22 2009 +0200
> 
>     sched: Strengthen buddies and mitigate buddy induced latencies
> 
>     This patch restores the effectiveness of LAST_BUDDY in preventing
>     pgsql+oltp from collapsing due to wakeup preemption. It also
>     switches LAST_BUDDY to exclusively do what it does best, namely
>     mitigate the effects of aggressive wakeup preemption, which
>     improves vmark throughput markedly, and restores mysql+oltp
>     scalability.
> 
> [snip]

Hi -

I have same oops (different cause-vector). Details here  http://lkml.org/lkml/2009/11/23/548

Can anyone tell me if they are related and/or recommend any work-arounds or troubleshooting steps?

Could this be related to scheduler trying to reschedule a task/thread on other proc and possibly a false alarm? 

Snip from trace is below.

-Bob

Nov 23 17:24:15 localhost kernel: BUG: using smp_processor_id() in preemptible
[00000000] code: smash/3062
Nov 23 17:24:15 localhost kernel: caller is __schedule+0x93/0x7d4
Nov 23 17:24:15 localhost kernel: Pid: 3062, comm: smash Not tainted
2.6.31.6-rt19 #1
Nov 23 17:24:15 localhost kernel: Call Trace:
Nov 23 17:24:15 localhost kernel: [<c06dc3df>] ? printk+0xf/0x18
Nov 23 17:24:15 localhost kernel: [<c05499a6>] debug_smp_processor_id+0xa6/0xbc
Nov 23 17:24:15 localhost kernel: [<c06dc70e>] __schedule+0x93/0x7d4
Nov 23 17:24:15 localhost kernel: [<c046621f>] ? audit_syscall_exit+0xfa/0x10f
Nov 23 17:24:15 localhost kernel: [<c040a955>] ? syscall_trace_leave+0xc8/0xef
Nov 23 17:24:15 localhost kernel: [<c040338a>] work_resched+0x5/0x19
Nov 23 17:24:15 localhost kernel: __ratelimit: 6 callbacks suppressed
Nov 23 17:24:15 localhost kernel: BUG: using smp_processor_id() in preemptible
[00000000] code: smash/3062

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
