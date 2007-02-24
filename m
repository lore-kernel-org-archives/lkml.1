Return-Path: <linux-kernel-owner+w=401wt.eu-S933568AbXBXWZW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933568AbXBXWZW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Feb 2007 17:25:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933571AbXBXWZW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Feb 2007 17:25:22 -0500
Received: from x35.xmailserver.org ([64.71.152.41]:2106 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933568AbXBXWZV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Feb 2007 17:25:21 -0500
X-AuthUser: davidel@xmailserver.org
Date: Sat, 24 Feb 2007 14:25:18 -0800 (PST)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Kyle Moffett <mrmacman_g4@mac.com>
cc: Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Christoph Hellwig <hch@infradead.org>, Andrew Morton <akpm@zip.com.au>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Ulrich Drepper <drepper@redhat.com>, Zach Brown <zach.brown@oracle.com>,
       Evgeniy Polyakov <johnpol@2ka.mipt.ru>,
       "David S. Miller" <davem@davemloft.net>,
       Suparna Bhattacharya <suparna@in.ibm.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [patch 04/13] syslets: core code
In-Reply-To: <21665A89-1BEE-459D-8ED1-ACCB352CF8A4@mac.com>
Message-ID: <Pine.LNX.4.64.0702241422110.17345@alien.or.mcafeemobile.com>
References: <20070221211516.GD7579@elte.hu> <Pine.LNX.4.64.0702231504370.31281@alien.or.mcafeemobile.com>
 <20070224070409.GB3357@elte.hu> <Pine.LNX.4.64.0702241306070.17345@alien.or.mcafeemobile.com>
 <21665A89-1BEE-459D-8ED1-ACCB352CF8A4@mac.com>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 24 Feb 2007, Kyle Moffett wrote:

> On Feb 24, 2007, at 16:10:33, Davide Libenzi wrote:
> > On Sat, 24 Feb 2007, Ingo Molnar wrote:
> > > the on/off calls are shaped in a way that makes them ultimately
> > > vsyscall-able - the kernel only needs to know about the fact that we are
> > > in a threadlet (so that the scheduler can do its special
> > > push-head-to-another-context thing) - and this can be signalled via a
> > > small user-space-side info structure as well, put into the TLS.
> > 
> > IMO it's not a matter of speed. We'll have those two new syscalls, that I
> > don't see other practical use for. IMO the best thing would be to hide all
> > inside the sys_threadlet_exec (or whatever name).
> 
> No, it absolutely is a matter of speed.  The reason to have those two
> implemented that way is so that they can be implemented as vsyscalls
> completely in userspace.  This means that on most modern platforms you can
> implement the "make a threadlet when I block" semantic without even touching
> kernel-mode.  The way it's set up all you'd have to do is save some
> parameters, set up a new callstack, and poke a "1" into a memory address in
> the TLS.  To stop, you effectively just poke a "0" into the spot in the TLS
> and either return or terminate the thread.

Right. I don't why but I got the implression Ingo's threadlet_exec example 
was just sketch code to be moved in a syscall. That's why I was talking 
about a sys_threadlet_exec. But yeah, it makes a lot of sense to turn 
threadlet_exec in a glibc thing, and play everything in userspace at that 
point.



- Davide


