Return-Path: <linux-kernel-owner+w=401wt.eu-S1755925AbZEKMP1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755925AbZEKMP1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 08:15:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752435AbZEKMPK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 08:15:10 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:51400 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752260AbZEKMPI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 08:15:08 -0400
Date: Sun, 10 May 2009 07:36:29 +0200
From: Pavel Machek <pavel@ucw.cz>
To: David Wagner <daw-news@cs.berkeley.edu>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] x86-64: seccomp: fix 32/64 syscall hole
Message-ID: <20090510053629.GB1363@ucw.cz>
References: <20090228030226.C0D34FC3DA@magilla.sf.frob.com> <20090506212913.GC4861@elte.hu> <904b25810905061446m73c42040nfff47c9b8950bcfa@mail.gmail.com> <20090507073121.2FAADFC39E@magilla.sf.frob.com> <gu03l7$tb8$1@taverner.cs.berkeley.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <gu03l7$tb8$1@taverner.cs.berkeley.edu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> >> Ptrace has performance and/or reliability problems when used to
> >> sandbox threaded applications due to potential race conditions when
> >> inspecting system call arguments. We hope that we can avoid this
> >> problem with seccomp.
> >
> >ptrace certainly has performance issues.  I take it the only "reliability
> >problems" you are talking about are MT races with modifications to user
> >memory that is relevant to a system call.  (Is there something else?)
> 
> As of 1999, I believe there were some other issues for using ptrace
> securely:
> 
> 1. I do not know of a good way to reliably ensure that all children of
> a traced program will be traced as well.  If you wait for the fork()
> call to return, check the pid, and start tracing the child process,
> you are subject to race conditions.  (strace's solution is to modify
> the code of the traced program to put a trapping instruction immediately
> after the call site to fork().  This is a grody hack and I had a hard
> time convincing myself that this will be secure in all cases.)
> 
> 2. ptrace disrupts the process hierarchy and Unix signals.  Because of
> the way ptrace overloads signals to deliver tracing events, tracing is
> not transparent.  For instance, if the parent and child are both traced,
> and the parent waits for a signal from the child, things may no longer
> work the same way while being traced.  Working around this requires
> non-trivial code.  Complexity is the enemy of security and makes it hard
> to gain confidence this doesn't introduce subtle issues.
> 
> 3. If the tracing application should happen to die unexpectedly
> (OOM, anyone?), I believe the traced application continues running,
> now without any security checks.
> 
> 4. I seem to recall that when I looked at this in 1999, if the traced
> app makes a syscall that should not be allowed, I couldn't find a good
> way to prevent that syscall from executing.  I don't know if current
> ptrace has solved this problem.
> 
> Disclaimer: I haven't checked whether these all still apply today.

subterfugue.net has ptrace-based monitor that is secure AFAICT. We
improved ptrace for it a bit...
								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
