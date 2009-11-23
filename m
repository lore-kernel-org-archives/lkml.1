Return-Path: <linux-kernel-owner+w=401wt.eu-S1755671AbZKWIgT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755671AbZKWIgT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Nov 2009 03:36:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752845AbZKWIgS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Nov 2009 03:36:18 -0500
Received: from cantor.suse.de ([195.135.220.2]:42446 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751123AbZKWIgS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Nov 2009 03:36:18 -0500
Date: Mon, 23 Nov 2009 09:36:23 +0100
From: Nick Piggin <npiggin@suse.de>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Roland McGrath <roland@redhat.com>
Subject: Re: Zombie process when ptracing
Message-ID: <20091123083623.GD5602@wotan.suse.de>
References: <20091119102543.GB5602@wotan.suse.de> <20091120012930.GA3985@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091120012930.GA3985@redhat.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 20, 2009 at 02:29:30AM +0100, Oleg Nesterov wrote:
> Hi,
> 
> On 11/19, Nick Piggin wrote:
> >
> > Running recent git kernel, I have a process stuck in Z state
> >
> > bash          ? 0000000000000000     0  3188   3187 0x00000000
> >  ffff88012e24fec8 0000000000000046 0000000000000000 0000000000000012
> >  ffff88012e24fec8 ffff88012e24e000 ffff88012e24ffd8 ffff88012e24e000
> >  000000000000efc8 ffff88012e24e000 ffff88012ea82090 ffff88012ff78640
> > Call Trace:
> >  [<ffffffff8124baee>] ? proc_clear_tty+0x5e/0x70
> >  [<ffffffff810587a8>] ? exit_ptrace+0xb8/0x140
> >  [<ffffffff8105126a>] do_exit+0x58a/0x7c0
> >  [<ffffffff810514dd>] do_group_exit+0x3d/0xb0
> >  [<ffffffff81051562>] sys_exit_group+0x12/0x20
> >  [<ffffffff8100b3eb>] system_call_fastpath+0x16/0x1b
> >
> > This was after stracing a few test programs.
> >
> > It also seems to have lost job control (^C) at the same time.
> 
> This can happen if the tracer (strace) itself hangs, zombies
> should go away once the tracer is killed. Or its ->real_parent
> is stopped or hangs...
> 
> (I assume you didn't strace /sbin/init)

No, I straced something else, and all straces seemed to be
killed but bash remained. I was running a script that in
turn launched another process, so I ran it via
strace -ff bash ./script.sh


> But,
> 
> > Hmm, and the kernel just paniced with an nmi lockup while I was
> > trying to get more info.
> 
> this probably means we have a kernel bug ;)

Hmm sorry that seemed like it _may_ have been an unrelated issue
(with the ssh connection).

 
> If you see a zombie again, could you look at its /ptoc/pid/status?

OK, any other hints if I see it again?


> And of course, which programs did you trace and how? It would be
> great if we can reproduce the problem.

At this stage I have not reproduced it, and I can't share the program
which was being straced. If it does happen again and I cannot distil
a simple test case, I will ask permission to distribute it.

Thanks,
Nick
