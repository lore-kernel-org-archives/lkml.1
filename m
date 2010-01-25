Return-Path: <linux-kernel-owner+w=401wt.eu-S1753690Ab0AYVHT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753690Ab0AYVHT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jan 2010 16:07:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753676Ab0AYVHO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jan 2010 16:07:14 -0500
Received: from mx1.redhat.com ([209.132.183.28]:59861 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753613Ab0AYVHL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jan 2010 16:07:11 -0500
From: Tom Tromey <tromey@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Kyle Moffett <kyle@moffetthome.net>, "Frank Ch. Eigler" <fche@redhat.com>,
       Oleg Nesterov <oleg@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Peter Zijlstra <peterz@infradead.org>,
       Fr??d??ric Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>, linux-next@vger.kernel.org,
       "H. Peter Anvin" <hpa@zytor.com>, utrace-devel@redhat.com,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: linux-next: add utrace tree
References: <20100121013822.28781960.sfr@canb.auug.org.au>
	<20100122005147.GD22003@redhat.com>
	<20100121170541.7425ff10.akpm@linux-foundation.org>
	<alpine.LFD.2.00.1001211724500.13231@localhost.localdomain>
	<20100122182827.GA13185@redhat.com>
	<20100122200129.GG22003@redhat.com>
	<alpine.LFD.2.00.1001221355250.13231@localhost.localdomain>
	<20100122221348.GA4263@redhat.com>
	<alpine.LFD.2.00.1001221604190.13231@localhost.localdomain>
	<alpine.LFD.2.00.1001221614520.13231@localhost.localdomain>
	<f73f7ab81001222220jfaf2edfwca3fa4c22b0b4d72@mail.gmail.com>
	<alpine.LFD.2.00.1001232051510.3574@localhost.localdomain>
Reply-To: tromey@redhat.com
X-Attribution: Tom
Date: Mon, 25 Jan 2010 14:05:54 -0700
In-Reply-To: <alpine.LFD.2.00.1001232051510.3574@localhost.localdomain> (Linus
	Torvalds's message of "Sat, 23 Jan 2010 21:04:56 -0800 (PST)")
Message-ID: <m33a1tnbd9.fsf@fleche.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Linus" == Linus Torvalds <torvalds@linux-foundation.org> writes:

Linus> No. There is absolutely _no_ reason to believe that gdb et al would ever 
Linus> delete the ptrace interfaces anyway. 

Yes, in GDB we approximately never delete anything.

Nevertheless, if the Linux kernel were to present a new user-space API,
and if it had an advantage over ptrace, then we would port GDB to use
it.  There are other platforms where, IIRC, we now use some /proc thing
instead of ptrace.

There are definitely things we would like from such an API.  Here's a
few I can think of immediately, there are probably others.

* Use an fd, not SIGCHLD+wait, to report inferior state changes to gdb.
  Internally we're already using a self-pipe to integrate this into
  gdb's main loop.  Relatedly, don't mess with the inferior's parentage.

* Support "displaced stepping" in the kernel; I think this would improve
  performance when debugging in non-stop mode.

* Support some kind of breakpoint expression in the kernel; this would
  improve performance of conditional breakpoints.  Perhaps the existing
  gdb agent expressions could be used.

Tom
