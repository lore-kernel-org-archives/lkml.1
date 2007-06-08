Return-Path: <linux-kernel-owner+w=401wt.eu-S967755AbXFHDR5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967755AbXFHDR5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 23:17:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966973AbXFHDRt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 23:17:49 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53046 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S966864AbXFHDRs convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 23:17:48 -0400
Date: Thu, 7 Jun 2007 20:16:04 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: =?ISO-8859-1?B?Qmr2cm4=?= Steinbrink <B.Steinbrink@gmx.de>,
       Arnd Bergmann <arnd@arndb.de>, Paul Fulghum <paulkf@microgate.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Nicolas Mailhot <nicolas.mailhot@laposte.net>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       "bugme-daemon@kernel-bugs.osdl.org" 
	<bugme-daemon@bugzilla.kernel.org>,
       linux-kernel@vger.kernel.org, Mel Gorman <mel@csn.ul.ie>,
       Christoph Lameter <clameter@sgi.com>
Subject: Re: [Bug 8473] New: Oops: 0010 [1] SMP
Message-Id: <20070607201604.726094fc.akpm@linux-foundation.org>
In-Reply-To: <20070608030629.GA18493@atjola.homenet>
References: <200705132102.l4DL2onF003014@fire-2.osdl.org>
	<20070513154718.bb338ceb.akpm@linux-foundation.org>
	<1179098742.7322.5.camel@rousalka.dyndns.org>
	<1179396003.31796.4.camel@rousalka.dyndns.org>
	<20070517094557.c96f7e54.randy.dunlap@oracle.com>
	<1179421196.5000.5.camel@rousalka.dyndns.org>
	<1180206615.3430.8.camel@rousalka.dyndns.org>
	<20070608030629.GA18493@atjola.homenet>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 8 Jun 2007 05:06:29 +0200 Björn Steinbrink <B.Steinbrink@gmx.de> wrote:

> On 2007.05.26 21:10:15 +0200, Nicolas Mailhot wrote:
> > Le jeudi 17 mai 2007 à 18:59 +0200, Nicolas Mailhot a écrit :
> > > Le jeudi 17 mai 2007 à 09:45 -0700, Randy Dunlap a écrit :
> > > 
> > > > Can you boot with "kstack=32" so that we can see more of the stack?
> > > 
> > > I can try. It's not triggering quickly though
> > 
> > Seems I was completely wrong about the trigger, but anyway it happened
> > again, this time on 2.6.22-rc2.mm1.cfs14 (and I had kept kstack=32)
> > 
> >  BUG: using smp_processor_id() in preemptible [00000001] code: bash/3857
> >  caller is oops_begin+0xb/0x6f
> >  
> >  Call Trace:
> >  [<ffffffff8020ab4d>] show_trace+0x34/0x4f
> >  [<ffffffff8020ab7a>] dump_stack+0x12/0x17
> >  [<ffffffff8030d92d>] debug_smp_processor_id+0xad/0xbc
> >  [<ffffffff8042388f>] oops_begin+0xb/0x6f
> >  [<ffffffff8042520b>] do_page_fault+0x66a/0x7c0
> >  [<ffffffff804234bd>] error_exit+0x0/0x84

hm that was dumb.  I'll stick a raw_smp_processor_id() in there.

> >  Unable to handle kernel NULL pointer dereference at 0000000000000000 RIP: 
> >  [<0000000000000000>]
> >  PGD bdd2067 PUD c133067 PMD 0 
> >  Oops: 0010 [1] PREEMPT SMP 
> >  CPU 1 
> >  Pid: 3857, comm: bash Not tainted 2.6.22-0.8.rc2.mm1.cfs14.fc8.nim #1
> >  RIP: 0010:[<0000000000000000>]  [<0000000000000000>]
> >  RSP: 0018:ffff81000cb03ee0  EFLAGS: 00010296
> >  RAX: ffffffff8044dbc0 RBX: ffff81000c3aa8c0 RCX: 00007fff549dcae4
> >  RDX: 0000000000005410 RSI: ffff81000c3aa8c0 RDI: ffff81000ba913d8
> >  RBP: 00007fff549dcae4 R08: 0000000000000000 R09: 00000000ffffffff
> >  R10: 0000000000000008 R11: 0000000000000246 R12: 0000000000005410
> >  R13: 00000000000000ff R14: 00000000000000ff R15: 0000000000000000
> >  FS:  00002b06560d8f40(0000) GS:ffff810004017180(0000) knlGS:0000000000000000
> >  CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> >  CR2: 0000000000000000 CR3: 000000000bc55000 CR4: 00000000000006e0
> >  Process bash (pid: 3857, threadinfo ffff81000cb02000, task ffff81000adc59a0)
> >  Stack:  ffffffff8028ada9 ffff81000c3aa8c0 00007fff549dcae4 00007fff549dcae4
> >  ffffffff8028b016 0000000000005410 00000000000000ff ffff81000c3aa8c0
> >  0000000000000000 00007fff549dcae4 0000000000005410 00000000000000ff
> >  ffffffff8028b088 0000000000000000 0000000080209571 00000000ffffffff
> >  00007fff549dce87 0000000000000f11 00007fff549dcfb8 00007fff549dddb0
> >  ffffffff802095dc 0000000000000246 0000000000000008 00000000ffffffff
> >  0000000000000000 ffffffffffffffda ffffffffffffffff 00007fff549dcae4
> >  0000000000005410 00000000000000ff 0000000000000010 0000003d340c9117
> >  Call Trace:
> >  Inexact backtrace:
> >  [<ffffffff8028ada9>] do_ioctl+0x55/0x6b
> >  [<ffffffff8028b016>] vfs_ioctl+0x257/0x270
> >  [<ffffffff8028b088>] sys_ioctl+0x59/0x79
> >  [<ffffffff802095dc>] tracesys+0xdc/0xe1
> >  
> >  INFO: lockdep is turned off.
> >  
> >  Code:  Bad RIP value.
> >  RIP  [<0000000000000000>]
> >  RSP <ffff81000cb03ee0>
> >  CR2: 0000000000000000
> 
> This is do_tty_hangup() exchanging the fops while we're waiting for the
> lock. The new fops (hung_up_tty_fops) only have the unlocked variant and
> thus we Oops our way.

ah, yes, that explains it, thanks.  Culprit:

commit e10cc1df1d2014f68a4bdcf73f6dd122c4561f94
Author: Paul Fulghum <paulkf@microgate.com>
Date:   Thu May 10 22:22:50 2007 -0700

    tty: add compat_ioctl
    
    Add compat_ioctl method for tty code to allow processing of 32 bit ioctl
    calls on 64 bit systems by tty core, tty drivers, and line disciplines.
    
    Based on patch by Arnd Bergmann:
    http://www.uwsg.iu.edu/hypermail/linux/kernel/0511.0/1732.html
    
    [akpm@linux-foundation.org: make things static]
    Signed-off-by: Paul Fulghum <paulkf@microgate.com>
    Acked-by: Arnd Bergmann <arnd@arndb.de>
    Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
    Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>


> The following program reproduces it quite easily on a SMP box. I'm
> running it from X as root like this:
> while true; do xterm /path/to/program; done
> 
> #include <pthread.h>
> #include <stdio.h>
> #include <unistd.h>
> 
> #include <sys/ioctl.h>
> 
> pid_t pid;
> 
> void *thread(void *arg)
> {
> 	while (1)
> 		ioctl(0, TIOCSPGRP, &pid);
> }
> 
> int main()
> {
> 	pthread_t t;
> 
> 	pid = getpid();
> 
> 	pthread_create(&t, NULL, thread, NULL);
> 	sleep(1);
> 	vhangup();
> 	perror("vhangup");
> 	return 0;
> }
> 
> I'm not exactly sure how to solve that in a clean way, though. Moving
> the call to lock_kernel() up would make the Oops go away, but could
> result in the wrong error code being returned. Checking for ioctl first
> and unlocked_ioctl last would cause useless locking. And retrying the
> unlocked ioctl doesn't look nice either :-(
> 
> Björn
