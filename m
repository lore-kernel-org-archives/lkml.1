Return-Path: <linux-kernel-owner+w=401wt.eu-S1762036AbZC0AAl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762036AbZC0AAl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Mar 2009 20:00:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761574AbZC0AAV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Mar 2009 20:00:21 -0400
Received: from THUNK.ORG ([69.25.196.29]:34442 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760035AbZC0AAT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Mar 2009 20:00:19 -0400
Date: Thu, 26 Mar 2009 19:59:36 -0400
From: Theodore Tso <tytso@mit.edu>
To: Ingo Molnar <mingo@elte.hu>
Cc: Jan Kara <jack@suse.cz>, Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Arjan van de Ven <arjan@infradead.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Nick Piggin <npiggin@suse.de>,
       Jens Axboe <jens.axboe@oracle.com>, David Rees <drees76@gmail.com>,
       Jesper Krogh <jesper@krogh.cc>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Oleg Nesterov <oleg@redhat.com>, Roland McGrath <roland@redhat.com>
Subject: Re: ext3 IO latency measurements (was: Linux 2.6.29)
Message-ID: <20090326235936.GK6239@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>, Ingo Molnar <mingo@elte.hu>,
	Jan Kara <jack@suse.cz>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Alan Cox <alan@lxorguk.ukuu.org.uk>,
	Arjan van de Ven <arjan@infradead.org>,
	Peter Zijlstra <a.p.zijlstra@chello.nl>,
	Nick Piggin <npiggin@suse.de>, Jens Axboe <jens.axboe@oracle.com>,
	David Rees <drees76@gmail.com>, Jesper Krogh <jesper@krogh.cc>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Oleg Nesterov <oleg@redhat.com>, Roland McGrath <roland@redhat.com>
References: <20090325185824.GO32307@mit.edu> <alpine.LFD.2.00.0903251341050.3032@localhost.localdomain> <20090325215137.GQ32307@mit.edu> <alpine.LFD.2.00.0903251613300.3032@localhost.localdomain> <20090325235041.GA11024@duck.suse.cz> <20090326090630.GA9369@elte.hu> <20090326113705.GV32307@mit.edu> <20090326140312.GB14822@elte.hu> <20090326152815.GB6239@mit.edu> <20090326230240.GA18808@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090326230240.GA18808@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 27, 2009 at 12:02:40AM +0100, Ingo Molnar wrote:
> This isnt me streaming gigs of data in and out of the system 
> dirtying 90% of all RAM. This is a trivial workload barely 
> scratching the RAM and CPU capabilities of the system.

Have you tried with maxcpus set to say, 2?  My guess is you won't see
the problems in that case.  So I'm not sure saying "barely scratching
the CPU capabilities of the system" is completely fair.  I can
probably get be able to get temporary access to a 16 CPU system, but
that's not the kind of system that I normally get to use for my kernel
devleopment.

> Have you tried to reproduce it? Have you tried CONFIG_LATENCYTOP? We 
> implemented that kernel feature specifically to make it easy for 
> developers to instrument their kernel and keep system latencies 
> down. This isnt some oddball workload or oddball system. These 
> latencies are reproducible on just about any Linux development 
> system i ever tried with ext3.

My normal development is not all that different from yours (make
-j<numcpus*2>) and I do edit and save files while the compile is
going.  I use emacs, but it calls fsync() when saving files, just like
vim does.  The big difference is that for me, numcpus is normally 2.
And my machine has 4 gigs of memory, not 12 gigs.  So I don't see
these problems.  I agree that what you have isn't an "oddball
workload"; as far as whether it is an "oddball system", it is
certainly a system I would lust after.  And I acknowledge the world is
a bit different from when Linus declared that 99% of the world was 1
or 2 CPU's.  I suspect the percentage of machines with 16 CPU's is
still somewhat small, though.

So I'll try to reproduce it on a 16 CPU system, when I have a chance
--- but it's something that I'm going to have to borrow and try to get
remote access to play with such a system.  Clearly your employer is
way more generous with equipment than mine is, at least for personal
development machines.  :-)

In the meantime, if you could run some of the tests and vary some of
the variables I requested, I'd appreciate it, and thank you for your
help.  Otherwise, I'll try to run them when I get remote access to
such a machine where I'm allowed to replace kernels and mount random
test filesystems.

						- Ted

P.S.  Another interesting test would be to plot the vim save latencies
versus the number of CPU's enabled when running the kernel build
workload.

P.P.S.  I assume there's no way you could give me remote ssh access to
your nice 16-way machine?  :-)
