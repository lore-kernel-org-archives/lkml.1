Return-Path: <linux-kernel-owner+w=401wt.eu-S1031463AbXEDSCk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031463AbXEDSCk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2007 14:02:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031472AbXEDSCj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 May 2007 14:02:39 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:42112 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1031463AbXEDSCg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2007 14:02:36 -0400
Date: Fri, 4 May 2007 11:01:58 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       viro@ftp.linux.org.uk, linux-ext4@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.21-git4 Scheduler, NOHZ, VFS bugs
Message-Id: <20070504110158.d2808170.akpm@linux-foundation.org>
In-Reply-To: <463B5D63.2030109@googlemail.com>
References: <463B5D63.2030109@googlemail.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 04 May 2007 18:20:51 +0200 Michal Piotrowski <michal.k.k.piotrowski@gmail.com> wrote:

> I ran this script tree times,
> 
> #! /bin/sh
> 
> for i in `find /sys/ -type f`
> do
>     echo "wyświetlam $i"
>     sudo cat $i > /dev/null
> done
> 
> First run - scheduler bug
> Second run - NOHZ bug
> Third - VFS bug
> 
> Hmmmm...
> 
> [93298.252601] BUG: at /mnt/md0/devel/linux-git/kernel/sched.c:3241 add_preempt_count()
> [93298.260334]  [<c0105039>] show_trace_log_lvl+0x1a/0x2f
> [93298.265507]  [<c0105720>] show_trace+0x12/0x14
> [93298.269974]  [<c01057d2>] dump_stack+0x16/0x18
> [93298.274434]  [<c011d18a>] add_preempt_count+0x89/0x8b
> [93298.279501]  [<c0126492>] irq_enter+0xd/0x2e
> [93298.283788]  [<c0114c1e>] smp_apic_timer_interrupt+0x2a/0x84
> [93298.289458]  [<c0104b2b>] apic_timer_interrupt+0x33/0x38
> [93298.294783]  [<c0257b79>] show_uevent+0x58/0xcd
> [93298.299329]  =======================
> [93390.468056] NOHZ: local_softirq_pending 22
> [93447.105850] NOHZ: local_softirq_pending 22
> [93450.332884] BUG: unable to handle kernel paging request at virtual address 3e343c0c
> [93450.340626]  printing eip:
> [93450.343333] c018e2bc
> [93450.345520] *pde = 00000000
> [93450.348314] Oops: 0000 [#1]

Nice.  What was the last file which it read before crashing?

Are you able to consistently crash it by reading just that file?
