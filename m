Return-Path: <linux-kernel-owner+w=401wt.eu-S1752165AbZHZRIO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752165AbZHZRIO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 13:08:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752107AbZHZRIN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 13:08:13 -0400
Received: from tomts5-srv.bellnexxia.net ([209.226.175.25]:38488 "EHLO
	tomts5-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751923AbZHZRIM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 13:08:12 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Au4EAGcHlUpMROOX/2dsb2JhbACBU9dWhBoF
Date: Wed, 26 Aug 2009 13:08:12 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
       Hendrik Brueckner <brueckner@linux.vnet.ibm.com>,
       Jason Baron <jbaron@redhat.com>, linux-kernel@vger.kernel.org,
       mingo@elte.hu, laijs@cn.fujitsu.com, rostedt@goodmis.org,
       jiayingz@google.com, mbligh@google.com, lizf@cn.fujitsu.com,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: Re: [PATCH 08/12] add trace events for each syscall entry/exit
Message-ID: <20090826170812.GC21456@Krystal>
References: <20090825141547.GE6114@nowhere> <20090825160237.GG4639@cetus.boeblingen.de.ibm.com> <20090825162004.GA25058@Krystal> <20090825165912.GI6114@nowhere> <20090825173107.GJ6114@nowhere> <20090825183119.GC2448@Krystal> <1251267669.7538.1195.camel@twins>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <1251267669.7538.1195.camel@twins>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.27.31-grsec (i686)
X-Uptime: 13:05:34 up 8 days,  3:55,  2 users,  load average: 0.78, 0.37,
	0.32
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Peter Zijlstra (peterz@infradead.org) wrote:
> On Tue, 2009-08-25 at 14:31 -0400, Mathieu Desnoyers wrote:
> 
> > (Well, I do not have time currently to look into the gory details
> > (sorry), but let's try to take a step back from the problem.)
> > 
> > The design proposal for this kthread behavior wrt syscalls is based on a
> > very specific and current kernel behavior, that may happen to change and
> > that I have actually seen proven incorrect. For instance, some
> > proprietary Linux driver does very odd things with system calls within
> > kernel threads, like invoking them with int 0x80.
> > 
> > Yes, this is odd, but do we really want to tie the tracer that much to
> > the actual OS implementation specificities ?
> > 
> > That sounds like a recipe for endless breakages and missing bits of
> > instrumentation.
> > 
> > So my advice would be: if we want to trace the syscall entry/exit paths,
> > let's trace them for the _whole_ system, and find ways to make it work
> > for corner-cases rather than finding clever ways to diminish
> > instrumentation coverage.
> > 
> > Given the ret from fork example happens to be the first event fired
> > after the thread is created, we should be able to deal with this problem
> > by initializing the thread structure used by syscall exit tracing to an
> > initial "ret from fork" value.
> 
> So you're saying we should let proprietary crap influence the design of
> the kernel in any way?

Nah. And I start to feel comfortable with syscall entry/exit being only
be traced for userspace threads. But as I pointed out in a follow-up
email, the lack of sys_*() tracing for invocation from within the kernel
might be problematic. This is actually my main point.

Mathieu

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
