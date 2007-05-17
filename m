Return-Path: <linux-kernel-owner+w=401wt.eu-S1756941AbXEQQmv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756941AbXEQQmv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2007 12:42:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755850AbXEQQmo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 May 2007 12:42:44 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:34248 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755827AbXEQQmn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2007 12:42:43 -0400
Date: Thu, 17 May 2007 09:45:57 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Nicolas Mailhot <nicolas.mailhot@laposte.net>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "bugme-daemon@kernel-bugs.osdl.org" 
	<bugme-daemon@bugzilla.kernel.org>,
       linux-kernel@vger.kernel.org, Mel Gorman <mel@csn.ul.ie>,
       Christoph Lameter <clameter@sgi.com>
Subject: Re: [Bug 8473] New: Oops: 0010 [1] SMP
Message-Id: <20070517094557.c96f7e54.randy.dunlap@oracle.com>
In-Reply-To: <1179396003.31796.4.camel@rousalka.dyndns.org>
References: <200705132102.l4DL2onF003014@fire-2.osdl.org>
	<20070513154718.bb338ceb.akpm@linux-foundation.org>
	<1179098742.7322.5.camel@rousalka.dyndns.org>
	<1179396003.31796.4.camel@rousalka.dyndns.org>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-Whitelist: TRUE
X-Whitelist: TRUE
X-Brightmail-Tracker: AAAAAQAAAAI=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 May 2007 12:00:02 +0200 Nicolas Mailhot wrote:

> Le lundi 14 mai 2007 à 01:25 +0200, Nicolas Mailhot a écrit :
> 
> > It happened once so far. The load was moderate (and certainly not
> > comparable to what I did for Mel yesterday)
> 
> Make that twice. The interesting thing is it was preceded by CD/DVD
> access just before, to something is rotten there.
> 
> 10:52:35 ISO 9660 Extensions: RRIP_1991A
> 11:52:36 Unable to handle kernel NULL pointer dereference at 0000000000000000 RIP: 
> 11:52:36 [<0000000000000000>]
> 11:52:36 PGD 2438a067 PUD c484067 PMD 0 
> 11:52:36 Oops: 0010 [1] SMP 
> 11:52:36 CPU 1 
> 11:52:36 Pid: 30655, comm: bash Not tainted 2.6.21-11.mm2.fc7.nim #1

so just what is this kernel?  A hybrid of -mm and -fc7 or what?

> 11:52:36 RIP: 0010:[<0000000000000000>]  [<0000000000000000>]
> 11:52:36 RSP: 0000:ffff810006199ee0  EFLAGS: 00010296
> 11:52:36 RAX: ffffffff804426a0 RBX: ffff81000903f800 RCX: 00007fff8a5e9874
> 11:52:36 RDX: 0000000000005410 RSI: ffff81000903f800 RDI: ffff810006a37b88
> 11:52:36 RBP: 00007fff8a5e9874 R08: 0000000000000000 R09: 0000000000000004
> 11:52:36 R10: 0000000000000008 R11: 0000000000000246 R12: 0000000000005410
> 11:52:36 R13: 00000000000000ff R14: 00000000000000ff R15: 0000000000000008
> 11:52:36 FS:  00002b1c204ccf40(0000) GS:ffff810004017180(0000) knlGS:0000000000000000
> 11:52:36 CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> 11:52:36 CR2: 0000000000000000 CR3: 000000000f83b000 CR4: 00000000000006e0
> 11:52:36 Process bash (pid: 30655, threadinfo ffff810006198000, task ffff810024319c80)
> 11:52:36 Stack:  ffffffff80285451 ffff81000903f800 00007fff8a5e9874 00007fff8a5e9874
> 11:52:36 ffffffff802856be 0000000000005410 00000000000000ff ffff81000903f800
> 11:52:36 0000000000000000 00007fff8a5e9874 0000000000005410 00000000000000ff
> 11:52:36 Call Trace:
> 11:52:36 [<ffffffff80285451>] do_ioctl+0x55/0x6b
> 11:52:36 [<ffffffff802856be>] vfs_ioctl+0x257/0x270
> 11:52:36 [<ffffffff80285730>] sys_ioctl+0x59/0x79
> 11:52:36 [<ffffffff8020955c>] tracesys+0xdc/0xe1
> 11:52:36 
> 11:52:36 INFO: lockdep is turned off.
> 11:52:36 
> 11:52:36 Code:  Bad RIP value.
> 11:52:36 RIP  [<0000000000000000>]
> 11:52:36 RSP <ffff810006199ee0>
> 11:52:36 CR2: 0000000000000000
> 
> I'd try rc2-mm1, but I don't know if the patches of Mel Gorman &
> Christoph Lameter for bug #8464 have been merged yet

Can you boot with "kstack=32" so that we can see more of the stack?


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
