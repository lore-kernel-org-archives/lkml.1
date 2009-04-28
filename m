Return-Path: <linux-kernel-owner+w=401wt.eu-S1762058AbZD1PVl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762058AbZD1PVl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 11:21:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761037AbZD1PVa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 11:21:30 -0400
Received: from tomts13.bellnexxia.net ([209.226.175.34]:53167 "EHLO
	tomts13-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760976AbZD1PV3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 11:21:29 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AsIEABu29klMQW1W/2dsb2JhbACBUM12g3MF
Date: Tue, 28 Apr 2009 11:21:26 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Ingo Molnar <mingo@elte.hu>
Cc: =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>, Li Zefan <lizf@cn.fujitsu.com>,
       linux-kernel@vger.kernel.org
Subject: Re: LTTng "TIF_KERNEL_TRACE"
Message-ID: <20090428152126.GC31212@Krystal>
References: <20090428132037.GA27519@Krystal> <20090428150102.GB26546@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20090428150102.GB26546@elte.hu>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 11:17:21 up 59 days, 11:43,  1 user,  load average: 0.44, 0.59,
	0.47
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Ingo Molnar (mingo@elte.hu) wrote:
> 
> * Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca> wrote:
> 
> > Hi Ingo,
> > 
> > Looking at the current -tip tree, I notice that the 
> > TIF_SYSCALL_FTRACE flag is only implemented for x86.
> > 
> > I have TIF_KERNEL_TRACE in my lttng tree which applies to all 
> > architectures to do the exact same thing :
> > 
> > lttng-kernel-trace-thread-flag-alpha.patch
> > lttng-kernel-trace-thread-flag-arm.patch
> > lttng-kernel-trace-thread-flag-avr32.patch
> > lttng-kernel-trace-thread-flag-blackfin.patch
> > lttng-kernel-trace-thread-flag-cris.patch
> > lttng-kernel-trace-thread-flag-frv.patch
> > lttng-kernel-trace-thread-flag-h8300.patch
> > lttng-kernel-trace-thread-flag-ia64.patch
> > lttng-kernel-trace-thread-flag-m32r.patch
> > lttng-kernel-trace-thread-flag-m68k.patch
> > lttng-kernel-trace-thread-flag-mips.patch
> > lttng-kernel-trace-thread-flag-parisc.patch
> > lttng-kernel-trace-thread-flag-powerpc.patch
> > lttng-kernel-trace-thread-flag-s390.patch
> > lttng-kernel-trace-thread-flag-sh.patch
> > lttng-kernel-trace-thread-flag-sparc.patch
> > lttng-kernel-trace-thread-flag-um.patch
> > lttng-kernel-trace-thread-flag-x86.patch
> > lttng-kernel-trace-thread-flag-xtensa.patch
> > lttng-kernel-trace-thread-flag-api.patch
> > 
> > Is there any way we could get this merged ?
> > 
> > One thing I like about the name TIF_KERNEL_TRACE compared to 
> > TIF_SYSCALL_FTRACE is that it gives us a per-thread flag that 
> > could eventually be used for more kernel tracing purposes than 
> > just syscalls.
> 
> Yeah - TIF_KERNEL_TRACE indeed sounds more descriptive and less 
> restrictive. TIF_SYSCALL_FTRACE was a bit ad-hoc.
> 
> 	Ingo

lttng-kernel-trace-thread-flag-api.patch adds the enable/disable API,
with refcount, in kernel/sched.c just because I did not know where to
put it. Should we move this to its own file in kernel/trace/???.c ?

One option is kernel/trace/trace.c, which is compiled as soon as
CONFIG_TRACING is enabled.

I added the prototypes to linux/sched.h, they should probably be moved
to... linux/trace.h ?

Mathieu

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
