Return-Path: <linux-kernel-owner+w=401wt.eu-S934264AbXEESJt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934264AbXEESJt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 May 2007 14:09:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934262AbXEESJt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 May 2007 14:09:49 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:52563 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934259AbXEESJr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 May 2007 14:09:47 -0400
Subject: Re: random bug generator (was: 2.6.21-git4 Scheduler, NOHZ, VFS
	bugs)
From: Kay Sievers <kay.sievers@vrfy.org>
To: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, viro@ftp.linux.org.uk,
       linux-ext4@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Linus Torvalds <torvalds@linux-foundation.org>
In-Reply-To: <463CC746.7050402@googlemail.com>
References: <463B5D63.2030109@googlemail.com>
	 <20070504110158.d2808170.akpm@linux-foundation.org>
	 <6bffcb0e0705050625m6bb05dc0ne0864ec2dba19256@mail.gmail.com>
	 <463CC746.7050402@googlemail.com>
Content-Type: text/plain; charset=utf-8
Date: Sat, 05 May 2007 20:07:07 +0200
Message-Id: <1178388427.9994.49.camel@lov.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.0 
Content-Transfer-Encoding: 8BIT
X-Provags-ID: V01U2FsdGVkX1/qfMLvve3iP60lK3BQOJdqNol+AJDPbV6e3cZ
 c1e5WEC8Io2Nd0aTh3AVN70bcBeqUn0WoXIKZxz0CPSb6qqLK5
 /xSWtB8BpqyPRulgdPdQ6OewRhsJ7Yq
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2007-05-05 at 20:04 +0200, Michal Piotrowski wrote:
> Hi,
> 
> Michal Piotrowski napisał(a):
> > On 04/05/07, Andrew Morton <akpm@linux-foundation.org> wrote:
> >> On Fri, 04 May 2007 18:20:51 +0200 Michal Piotrowski
> >> <michal.k.k.piotrowski@gmail.com> wrote:
> >>
> >> > I ran this script tree times,
> >> >
> >> > #! /bin/sh
> >> >
> >> > for i in `find /sys/ -type f`
> >> > do
> >> >     echo "wyświetlam $i"
> >> >     sudo cat $i > /dev/null
> >> > done
> >> >
> >> > First run - scheduler bug
> >> > Second run - NOHZ bug
> >> > Third - VFS bug
> >> >
> >> > Hmmmm...
> >> >
> >> > [93298.252601] BUG: at /mnt/md0/devel/linux-git/kernel/sched.c:3241
> >> add_preempt_count()
> >> > [93298.260334]  [<c0105039>] show_trace_log_lvl+0x1a/0x2f
> >> > [93298.265507]  [<c0105720>] show_trace+0x12/0x14
> >> > [93298.269974]  [<c01057d2>] dump_stack+0x16/0x18
> >> > [93298.274434]  [<c011d18a>] add_preempt_count+0x89/0x8b
> >> > [93298.279501]  [<c0126492>] irq_enter+0xd/0x2e
> >> > [93298.283788]  [<c0114c1e>] smp_apic_timer_interrupt+0x2a/0x84
> >> > [93298.289458]  [<c0104b2b>] apic_timer_interrupt+0x33/0x38
> >> > [93298.294783]  [<c0257b79>] show_uevent+0x58/0xcd
> >> > [93298.299329]  =======================
> >> > [93390.468056] NOHZ: local_softirq_pending 22
> >> > [93447.105850] NOHZ: local_softirq_pending 22
> >> > [93450.332884] BUG: unable to handle kernel paging request at
> >> virtual address 3e343c0c
> >> > [93450.340626]  printing eip:
> >> > [93450.343333] c018e2bc
> >> > [93450.345520] *pde = 00000000
> >> > [93450.348314] Oops: 0000 [#1]
> >>
> >> Nice.  What was the last file which it read before crashing?
> >>
> >> Are you able to consistently crash it by reading just that file?
> > 
> > Random files, random bugs (usually it starts with a slab corruption).
> > 
> > git-bisect will give an answer.
> 
> So this is a random bug generator...
> 
> git-bisect bad
> 16574dccd8f62dc1b585325f8a6a0aab10047ed8 is first bad commit
> commit 16574dccd8f62dc1b585325f8a6a0aab10047ed8
> Author: Kay Sievers <kay.sievers@vrfy.org>
> Date:   Fri Apr 6 01:40:38 2007 +0200
> 
>     Driver core: make uevent-environment available in uevent-file
> 
>     This allows sysfs to show the environment variables that are available
>     if the uevent happens.  This lets userspace not have to cache all of
>     this information as the kernel already knows it.
> 
>     Signed-off-by: Kay Sievers <kay.sievers@vrfy.org>
>     Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
> 
> :040000 040000 34152258985968083c04ab003ced54d73e92a790 c3301e8cd7705c293817c6747b3cc59d6cbf14bb M      drivers
> 
> http://www.stardust.webpages.pl/files/tbf/bitis-gabonica/2.6.21-git4/git-config

Greg fixed this:
  http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=c7308c81a8220ab68eebfadde37db881a2800064

Kay

