Return-Path: <linux-kernel-owner+w=401wt.eu-S1753556AbZKWOJG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753556AbZKWOJG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Nov 2009 09:09:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753080AbZKWOJF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Nov 2009 09:09:05 -0500
Received: from casper.infradead.org ([85.118.1.10]:47391 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753000AbZKWOJE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Nov 2009 09:09:04 -0500
Subject: Re: LinSched updated to current linux kernel version
From: Peter Zijlstra <peterz@infradead.org>
To: Jon Tore Hafstad <jontore@gmail.com>
Cc: linux-kernel@vger.kernel.org, dhaval.giani@gmail.com, mingo@elte.hu,
       tglx@linutronix.de, bbb@cs.unc.edu, henrik@austad.us, jmc@cs.unc.edu,
       Jeff Dike <jdike@addtoit.com>
In-Reply-To: <78b8ce680911181211k6c15a976u52186b5849224040@mail.gmail.com>
References: <78b8ce680911181211k6c15a976u52186b5849224040@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 23 Nov 2009 15:08:15 +0100
Message-ID: <1258985295.4531.496.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-11-18 at 21:11 +0100, Jon Tore Hafstad wrote:
>  Hi all
> 
> I wish to inform you about an update of LinSched (The Linux Scheduler
> Simulator([1])) I'm currently working on.

> == Motivation ==
> I wished to implement different EDF schedulers to gain a better
> understanding of kernel internals as well as scheduling dynamics. I
> got some feedback from Henrik Austad  that LinSched was a tool that
> made implementing a scheduler in to  the linux kernel easier,  since
> the code compiles in a fraction of the time the kernel does (Yes, I
> know you can pull all sorts of tricks and tweaks in order to speed up
> a kernel compilation), a segfault will be a segfault, and not a kernel
> oops ;),and the full range of debuggers and memory analyzers will be
> available.

I would have expected people to use UML for this (User-Mode-Linux, not
the draw lots of silly pictures thing).

The main draw-back is that UML doesn't currently support SMP and any
interesting preemption modes, but adding that to UML would help out more
people -- I know the VM (virtual Memory, not the machine thing) people
used to use UML for exactly these reasons, easy gdb, etc..

But I suspect that with KVM's gdb stub getting usable more and more
people are abandoning this.

> == Remaining Work ==
> One of the major issues right now is the hrtimers, which large
> portions of the scheduler now use. I have not decided exactly how to
> solve this issue yet,but this will be the focus of my work for the
> coming weeks.

The typical implementation would be signals using the posix timers.

Have the spin_lock_irq variants mask signals etc..

