Return-Path: <linux-kernel-owner+w=401wt.eu-S1762058AbXFIV5U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762058AbXFIV5U (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jun 2007 17:57:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760608AbXFIV5M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Jun 2007 17:57:12 -0400
Received: from waste.org ([66.93.16.53]:60176 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753573AbXFIV5M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jun 2007 17:57:12 -0400
Date: Sat, 9 Jun 2007 16:55:43 -0500
From: Matt Mackall <mpm@selenic.com>
To: Al Viro <viro@ftp.linux.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Kyle Moffett <mrmacman_g4@mac.com>, Ulrich Drepper <drepper@redhat.com>,
       Davide Libenzi <davidel@xmailserver.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Theodore Tso <tytso@mit.edu>,
       Eric Dumazet <dada1@cosmosbay.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [patch 7/8] fdmap v2 - implement sys_socket2
Message-ID: <20070609215543.GE11166@waste.org>
References: <466A0BFB.3070908@redhat.com> <20070609151521.GD4095@ftp.linux.org.uk> <466AD4BA.80407@redhat.com> <20070609165454.GE4095@ftp.linux.org.uk> <466ADEAB.7080202@redhat.com> <20070609172429.GF4095@ftp.linux.org.uk> <2E51520E-EC73-457F-809A-4749ED9A3C97@mac.com> <20070609200645.GG4095@ftp.linux.org.uk> <alpine.LFD.0.98.0706091311040.20321@woody.linux-foundation.org> <20070609204907.GH4095@ftp.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070609204907.GH4095@ftp.linux.org.uk>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 09, 2007 at 09:49:07PM +0100, Al Viro wrote:
> On Sat, Jun 09, 2007 at 01:21:24PM -0700, Linus Torvalds wrote:
> > Which is why you'd like to do the *initial* operation with a flag that 
> > says "please set the FD_CLOEXEC flag on the file descriptor", so that you 
> > *atomically* install the file file descriptor and set the FD_CLOEXEC bit.
> > 
> > It's trivial to do for open(), but there are about a million ways to get a 
> > file descriptor, and open() is just about the *only* one of those that 
> > actually takes a "flags" field that can be used to tell the kernel.
> 
> Eww...  Idea of pipe(2) taking flags as argument...
> 
> BTW, you also need that for recvmsg() (SCM_RIGHTS) and fsckloads of
> syscalls we've got duplicating open() for no good reason (and no, "BSD
> folks did it for sockets, so we'll do it for tons of new subsystems" doesn't
> really qualify ;-/).
> 
> I don't know if your indirect is a good idea in that respect, actually.
> AFAICS, you are suggesting per-syscall meanings of the flags, so it really
> smells like YAMultiplexor, free for abuse.

Well, of course it sucks. The question is does it suck less than
adding dozens of new syscalls to patch up problems with POSIX?

I don't think we can get this right in one iteration, so I actually
prefer Linus's approach as less likely to leave numerous vestiges of
incremental improvements around.

On the other hand, we don't want to end up in a future where the bulk
of our calls are through sys_indirect! Given the number of important
APIs that have gotten slight semantic bumps, that's a real
possibility.

-- 
Mathematics is the supreme nostalgia of our time.
