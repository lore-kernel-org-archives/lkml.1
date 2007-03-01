Return-Path: <linux-kernel-owner+w=401wt.eu-S932431AbXCABel@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932431AbXCABel (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Feb 2007 20:34:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932956AbXCABel
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Feb 2007 20:34:41 -0500
Received: from mx1.suse.de ([195.135.220.2]:38584 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932431AbXCABek (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Feb 2007 20:34:40 -0500
Date: Thu, 1 Mar 2007 02:33:01 +0100
From: Andrea Arcangeli <andrea@suse.de>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Davide Libenzi <davidel@xmailserver.org>,
       Ulrich Drepper <drepper@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Christoph Hellwig <hch@infradead.org>, Andrew Morton <akpm@zip.com.au>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Zach Brown <zach.brown@oracle.com>,
       Evgeniy Polyakov <johnpol@2ka.mipt.ru>,
       "David S. Miller" <davem@davemloft.net>,
       Suparna Bhattacharya <suparna@in.ibm.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [patch 00/13] Syslets, "Threadlets", generic AIO support, v3
Message-ID: <20070301013301.GK21944@v2.random>
References: <20070221211355.GA7302@elte.hu> <f2b55d220702211446l78af6f14hc3e0dd0084016770@mail.gmail.com> <20070221233111.GB5895@elte.hu> <45DCD9E5.2010106@redhat.com> <20070222074044.GA4158@elte.hu> <Pine.LNX.4.64.0702221130050.1356@alien.or.mcafeemobile.com> <20070228094522.GA17716@elte.hu> <Pine.LNX.4.64.0702280740250.5935@alien.or.mcafeemobile.com> <Pine.LNX.4.64.0702280836080.12485@woody.linux-foundation.org> <20070228231228.GA12328@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070228231228.GA12328@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 01, 2007 at 12:12:28AM +0100, Ingo Molnar wrote:
> more capable by providing more special system calls like sys_upcall() to 
> execute a user-space function. (that way a syslet could still execute 
> user-space code without having to exit out of kernel mode too 
> frequently) Or perhaps a sys_x86_bytecode() call, that would execute a 
> pre-verified, kernel-stored sequence of simplified x86 bytecode, using 
> the kernel stack.

Which means the userspace code would then run with kernel privilege
level somehow (after security verifier, whatever). You remember I
think it's a plain crazy idea...

I don't want to argue about syslets, threadlets, whatever async or
syscall-merging mechanism here, I'm just focusing on the idea of yours
of running userland code in kernel space somehow (I hoped you given up
on it by now). Fixing the greatest syslets limitation is going to open
a can of worms as far as security is concerned.

The fact that userland code must not run with kernel privilege level,
is the reason why syslets aren't very useful (but again: focusing on
the syslets vs async-syscalls isn't my interest).

Frankly I think this idea of running userland code with kernel
privileges fits in the same category of porting linux to segmentation
to avoid the cost of pagetables to gain some bit of performance
despite losing in many other areas. Nobody in real life will want to
make that trade, for such an incredibly small performance
improvement.

For things that can be frequently combined, it's much simpler and
cheaper to created a "merged" syscall (i.e. sys_spawn =
sys_fork+sys_exec) than to invent a way to upload userland generated
bytecodes to kernel space to do that.
