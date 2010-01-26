Return-Path: <linux-kernel-owner+w=401wt.eu-S1753776Ab0AZPBS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753776Ab0AZPBS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jan 2010 10:01:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752414Ab0AZPBR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jan 2010 10:01:17 -0500
Received: from mx1.redhat.com ([209.132.183.28]:60661 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751717Ab0AZPBQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jan 2010 10:01:16 -0500
Date: Tue, 26 Jan 2010 10:00:15 -0500
From: "Frank Ch. Eigler" <fche@redhat.com>
To: Tom Tromey <tromey@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Kyle Moffett <kyle@moffetthome.net>, Oleg Nesterov <oleg@redhat.com>,
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
Message-ID: <20100126150015.GA24292@redhat.com>
References: <alpine.LFD.2.00.1001211724500.13231@localhost.localdomain> <20100122182827.GA13185@redhat.com> <20100122200129.GG22003@redhat.com> <alpine.LFD.2.00.1001221355250.13231@localhost.localdomain> <20100122221348.GA4263@redhat.com> <alpine.LFD.2.00.1001221604190.13231@localhost.localdomain> <alpine.LFD.2.00.1001221614520.13231@localhost.localdomain> <f73f7ab81001222220jfaf2edfwca3fa4c22b0b4d72@mail.gmail.com> <alpine.LFD.2.00.1001232051510.3574@localhost.localdomain> <m33a1tnbd9.fsf@fleche.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m33a1tnbd9.fsf@fleche.redhat.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi -

On Mon, Jan 25, 2010 at 02:05:54PM -0700, Tom Tromey wrote:
> [...]
> Nevertheless, if the Linux kernel were to present a new user-space API,
> and if it had an advantage over ptrace, then we would port GDB to use
> it.  There are other platforms where, IIRC, we now use some /proc thing
> instead of ptrace.
> 
> There are definitely things we would like from such an API.  Here's a
> few I can think of immediately, there are probably others.
> 
> * Use an fd, not SIGCHLD+wait, to report inferior state changes to gdb.
>   [...] Relatedly, don't mess with the inferior's parentage.

This is satisfied by the gdbstub prototype.

> * Support "displaced stepping" in the kernel [...]

I believe this is tantamount to hardware breakpoint support, which is
already present (via optional uprobes).

> * Support some kind of breakpoint expression in the kernel; this would
>   improve performance of conditional breakpoints.  Perhaps the existing
>   gdb agent expressions could be used.

This is in the todo list.


And that "KILLER FEATURE" of running strace plus gdb on the same
process?  It *already works* with the gdbstub, and unmodified strace +
gdb, thanks to utrace multiplexing process control.  It is still
artificially restricted in many ways, but this sort of thing is ready
for testing:

% process &
[1] 9999
% strace -o FILE -p 9999 &
% gdb process
(gdb) target remote /proc/9999/gdb
(gdb) backtrace 
(gdb) cont
(gdb) ^D
%
[process continues]
% cat FILE
[...]
% kill 9999


- FChE
