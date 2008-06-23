Return-Path: <linux-kernel-owner+w=401wt.eu-S1757354AbYFWKYJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757354AbYFWKYJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2008 06:24:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755414AbYFWKXz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jun 2008 06:23:55 -0400
Received: from rv-out-0506.google.com ([209.85.198.227]:26756 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753638AbYFWKXy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2008 06:23:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=OsUhRdIZXGFsp6Tx2Pk3PieG4lJXN/MCCp81wtNMTDiXaWuJgq3IQ4c0trfHEdGBZv
         xsAe7WuM5Y50KRLaF0+78wvDYLwrfIHcNKDmpCYwp+29OHkVautXbuCB5KIpxlhcsTxB
         wzS2GmZpVGlrbSNWJEavKYf1SNUb3KvWXtbvo=
Message-ID: <19f34abd0806230323o6373015fj93a85b929545a7a8@mail.gmail.com>
Date: Mon, 23 Jun 2008 12:23:52 +0200
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "Stephen Rothwell" <sfr@canb.auug.org.au>,
       "Steven Rostedt" <srostedt@redhat.com>
Subject: Re: linux-next: Tree for June 23
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20080623182549.b0552851.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080623182549.b0552851.sfr@canb.auug.org.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 23, 2008 at 10:25 AM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> I have created today's linux-next tree at
> git://git.kernel.org/pub/scm/linux/kernel/git/sfr/linux-next.git
> (patches at
> http://www.kernel.org/pub/linux/kernel/people/sfr/linux-next/).  If you
> are tracking the linux-next tree using git, you should not use "git pull"
> to do so as that will try to merge the new linux-next release with the
> old one.  You should use "git fetch" as mentioned in the FAQ on the wiki
> (see below).

Hi,

I got this:

Testing tracer sched_switch: PASSED
Testing tracer sysprof: PASSED
Testing tracer ftrace: PASSED
Testing dynamic ftrace: PASSED
Testing tracer irqsoff: PASSED
Testing tracer preemptoff: PASSED
Testing tracer preemptirqsoff: <4>------------[ cut here ]------------
WARNING: at kernel/lockdep.c:2680 check_flags+0x142/0x160()
Pid: 2, comm: kthreadd Not tainted 2.6.26-rc6-next-20080620 #34
 [<c01388a4>] warn_on_slowpath+0x54/0x70
 [<c015a9d5>] ? trace_hardirqs_off_caller+0x15/0xb0
 [<c015aa7b>] ? trace_hardirqs_off+0xb/0x10
 [<c0109e85>] ? native_sched_clock+0xb5/0x110
 [<c05bdb28>] ? _spin_unlock_irqrestore+0x48/0x80
 [<c02b5748>] ? debug_locks_off+0x8/0x50
 [<c017dcbe>] ? ftrace_record_ip+0x12e/0x240
 [<c010455c>] ? mcount_call+0x5/0x9
 [<c0159f22>] check_flags+0x142/0x160
 [<c014d3c0>] ? kthreadd+0xf0/0x160
 [<c015e089>] lock_acquire+0x59/0xd0
 [<c014d3c0>] ? kthreadd+0xf0/0x160
 [<c05bd2ad>] _spin_lock+0x3d/0x70
 [<c014d3c0>] ? kthreadd+0xf0/0x160
 [<c014d3c0>] kthreadd+0xf0/0x160
 [<c014d2d0>] ? kthreadd+0x0/0x160
 [<c0104547>] kernel_thread_helper+0x7/0x10
 =======================
---[ end trace a7919e7f17c0a725 ]---
possible reason: unannotated irqs-on.
irq event stamp: 3198
hardirqs last  enabled at (3197): [<c015cb2b>] trace_hardirqs_on+0xb/0x10
hardirqs last disabled at (3198): [<c015aa7b>] trace_hardirqs_off+0xb/0x10
softirqs last  enabled at (0): [<c01370ad>] copy_process+0x43d/0x1120
softirqs last disabled at (0): [<00000000>] 0x0
PASSED
Testing tracer wakeup: PASSED


Also, shouldn't there be a MAINTAINERS entry or some file in
Documentation/ for ftrace?


Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036
