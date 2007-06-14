Return-Path: <linux-kernel-owner+w=401wt.eu-S1755562AbXFNKDq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755562AbXFNKDq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2007 06:03:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754429AbXFNKCA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jun 2007 06:02:00 -0400
Received: from smtp4-g19.free.fr ([212.27.42.30]:43337 "EHLO smtp4-g19.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752377AbXFNKB7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2007 06:01:59 -0400
Message-ID: <46711215.4070108@free.fr>
Date: Thu, 14 Jun 2007 12:01:57 +0200
From: John Sigler <linux.kernel@free.fr>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061108 SeaMonkey/1.0.6
MIME-Version: 1.0
To: Chris Friesen <cfriesen@nortel.com>
CC: Helge Hafting <helge.hafting@aitel.hist.no>,
       Andrea Arcangeli <andrea@suse.de>, linux-kernel@vger.kernel.org
Subject: Re: Runaway process and oom-killer
References: <466FAF99.3070708@free.fr> <20070613090837.GD7443@v2.random> <466FB6E8.8020606@free.fr> <466FF154.7030905@aitel.hist.no> <467008E9.7070902@nortel.com>
In-Reply-To: <467008E9.7070902@nortel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Chris Friesen wrote:

> Helge Hafting wrote:
> 
>> My guess:
>> Something needs memory but finds there is none to be had
>> oom-killer is invoked and targets myapp.
>> myapp takes some time to die. Particularly, the memory it uses
>> isn't freed up instantly.
> 
> Has anyone considered actually bumping up the priority of the task being 
> killed so that it gets to run and free up its resources in a timely manner?

On this system,
myapp runs in SCHED_RR with priority 80.
IRQ handlers run in SCHED_FIFO with priority 50.

# ps -eo comm,class,rtprio,ni,pri --sort -rtprio
COMMAND         CLS RTPRIO  NI PRI
posix_cpu_timer FF      99   - 139
myapp           RR      80   - 120
softirq-high/0  FF      50   -  90
softirq-timer/0 FF      50   -  90
softirq-net-tx/ FF      50   -  90
softirq-net-rx/ FF      50   -  90
softirq-block/0 FF      50   -  90
softirq-tasklet FF      50   -  90
softirq-sched/0 FF      50   -  90
softirq-hrtimer FF      50   -  90
softirq-rcu/0   FF      50   -  90
IRQ-7           FF      50   -  90
IRQ-8           FF      50   -  90
IRQ-14          FF      50   -  90
IRQ-12          FF      50   -  90
IRQ-1           FF      50   -  90
IRQ-10          FF      50   -  90
IRQ-11          FF      50   -  90
IRQ-5           FF      50   -  90
IRQ-3           FF      50   -  90
IRQ-4           FF      50   -  90
events/0        FF       1   -  41
init            TS       -   0  24
desched/0       TS       - -10  34
khelper         TS       -  -5  29
kthread         TS       -  -5  27
kblockd/0       TS       -  -5  21
kacpid          TS       -  -5  19
kseriod         TS       -  -5  29
pdflush         TS       -   0  17
pdflush         TS       -   0  24
kswapd0         TS       -  -5  23
flush_filesd/0  TS       -  -5  29
aio/0           TS       -  -5  22
syslogd         TS       -   0  21
klogd           TS       -   0  21
sshd            TS       -   0  21
acpid           TS       -   0  16
agetty          TS       -   0  24
agetty          TS       -   0  21
agetty          TS       -   0  21
agetty          TS       -   0  21
[...]

How do the scheduling class and priority of the process come into play 
when the kernel comes to reclaim memory after the oom-killer has decided 
to snipe that particular process?

> We've done some experimenting with actually putting it in SCHED_RR and 
> it seems to help (in the case of other busy SCHED_RR tasks on the 
> system).  Admittedly we have an older kernel, so behaviour may be 
> different now.

Thanks for sharing your experience.

Regards.
