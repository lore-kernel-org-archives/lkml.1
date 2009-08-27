Return-Path: <linux-kernel-owner+w=401wt.eu-S1752185AbZH0Jo4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752185AbZH0Jo4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Aug 2009 05:44:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752162AbZH0Joz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Aug 2009 05:44:55 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:55199 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752158AbZH0Joy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Aug 2009 05:44:54 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Thu, 27 Aug 2009 18:43:03 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: mmotm 2009-08-24-16-24 uploaded
Message-Id: <20090827184303.500ac1f0.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20090827093441.GA3451@redhat.com>
References: <200908242328.n7ONSUHI022326@imap1.linux-foundation.org>
	<20090827144453.25f1161b.kamezawa.hiroyu@jp.fujitsu.com>
	<20090827160532.d6386722.kamezawa.hiroyu@jp.fujitsu.com>
	<20090827093441.GA3451@redhat.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 27 Aug 2009 11:34:41 +0200
Oleg Nesterov <oleg@redhat.com> wrote:

> On 08/27, KAMEZAWA Hiroyuki wrote:
> >
> > On Thu, 27 Aug 2009 14:44:53 +0900
> > KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:
> >
> > >
> > > In the newest mmotom, my S14nfslock hangs up. (x86-64/Fedora10)
> > >
> > > On Mon, 24 Aug 2009 16:28:30 -0700
> > > akpm@linux-foundation.org wrote:
> > >
> > > > ptrace-__ptrace_detach-do-__wake_up_parent-if-we-reap-the-tracee.patch
> > > > do_wait-wakeup-optimization-shift-security_task_wait-from-eligible_child-to-wait_consider_task.patch
> > >
> > > bisected. following 2 patches for filtering SIGCHLD cause hang (for my environ).
> > >
> > > > do_wait-wakeup-optimization-change-__wake_up_parent-to-use-filtered-wakeup.patch
> > > > do_wait-wakeup-optimization-change-__wake_up_parent-to-use-filtered-wakeup-selinux_bprm_committed_creds-use-__wake_up_parent.patch
> 
> Confused. Which patch causes the hang? They should be applied in reverse order,
> 
> 	do_wait-wakeup-optimization-change-__wake_up_parent-to-use-filtered-wakeup-selinux_bprm_committed_creds-use-__wake_up_parent.patch
> 	do_wait-wakeup-optimization-change-__wake_up_parent-to-use-filtered-wakeup.patch
> 
> > removed S14nfslockd from rc5.d and check it by strace
> > ==
> >  2712] fstat(6, {st_mode=S_IFREG|0644, st_size=0, ...}) = 0
> > [pid  2712] mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7fc6f263c000
> > [pid  2712] dup(6)                      = 7
> > [pid  2712] write(6, "2712\n"..., 5)    = 5
> > [pid  2712] close(6)                    = 0
> > [pid  2712] munmap(0x7fc6f263c000, 4096) = 0
> > [pid  2712] clone(Process 2713 attached
> > child_stack=0, flags=CLONE_CHILD_CLEARTID|CLONE_CHILD_SETTID|SIGCHLD, child_tidptr=0x7fc6f2625780) = 2713
> > [pid  2712] wait4(2713, Process 2712 suspended
> >  <unfinished ...>
> > ==
> > When process 2713 exits, process 2712 don't wake up.
> 
> Hmm, very strange. How can I reproduce?
> 
Sorry, I don't know. 

But exited process's, but not caught, p->exit_signal was -1. (confirmed by printk)
(details in another mail)


> When the child (2713) exits and the parent hangs, could you send
> me the content of /proc/parent_pid/status?

Name:   rpc.statd
State:  S (sleeping)
Tgid:   2989
Pid:    2989
PPid:   2988
TracerPid:      2978
Uid:    0       0       0       0
Gid:    0       0       0       0
FDSize: 64
Groups: 0 1 2 3 4 6 10
VmPeak:     8204 kB
VmSize:     8200 kB
VmLck:         0 kB
VmHWM:       596 kB
VmRSS:       596 kB
VmData:      196 kB
VmStk:        84 kB
VmExe:        44 kB
VmLib:      1688 kB
VmPTE:        28 kB
Threads:        1
SigQ:   0/190743
SigPnd: 0000000000000000
ShdPnd: 0000000000000000
SigBlk: 0000000000000000
SigIgn: 0000000000011000
SigCgt: 0000000000004203
CapInh: 0000000000000000
CapPrm: fffffffffffffeff
CapEff: fffffffffffffeff
CapBnd: fffffffffffffeff
Cpus_allowed:   ff
Cpus_allowed_list:      0-7
Mems_allowed:   00000000,00000001
Mems_allowed_list:      0
voluntary_ctxt_switches:        89
nonvoluntary_ctxt_switches:     1
Stack usage:    0 kB

> 
> OK, suppose that due to the patch above we lost the notification.
> But, wait4 returns -ECHILD, who reaped this child???
> 
Not sure. 

> What does "$ ps CHILD_PID" say? /proc/child_pid/status please?
> 
Can't get it. It seems reaped.
==
[root@bluextal mmotm-2.6.31-Aug27]# kill -s 0 2990(CHILD's pid)
bash: kill: (2990) - No such process


Thanks
-Kame

