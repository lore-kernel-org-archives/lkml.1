Return-Path: <linux-kernel-owner+w=401wt.eu-S1755672AbZBJOLP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755672AbZBJOLP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Feb 2009 09:11:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754476AbZBJOK7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Feb 2009 09:10:59 -0500
Received: from fg-out-1718.google.com ([72.14.220.158]:10259 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754441AbZBJOK6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Feb 2009 09:10:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=FoOhZatHWJ4QfcT9/QFMP2HTalB2XVQ3xNuKh2h/ZA8gGzL1aSiDw2nx+IHFVa7rf7
         W+Vs7cH2stMGP0LiSTYRKK5hdMotV+M8Zil4QofRPR5ak+F/b+r8hJnsZQpRLwi9C4Ll
         q9zZP9nN5pFd8WQQFdRzd2RNQqO28LJvLtagQ=
Date: Tue, 10 Feb 2009 15:10:54 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
       Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: Re: [PATCH 1/2] tracing/sysprof: add missing
	tracing_{start,stop}_record_cmdline()
Message-ID: <20090210141052.GA5836@nowhere>
References: <4990fdb7.0e0f660a.1d27.5399@mx.google.com> <20090210122726.GA21531@elte.hu> <20090210123145.GA1403@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090210123145.GA1403@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 10, 2009 at 01:31:45PM +0100, Ingo Molnar wrote:
> 
> * Ingo Molnar <mingo@elte.hu> wrote:
> 
> > * Frederic Weisbecker <fweisbec@gmail.com> wrote:
> > 
> > > Add the missing pair tracing_{start,stop}_record_cmdline() to record well
> > > the cmdline associated with pid.
> > > 
> > > Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> > > ---
> > >  kernel/trace/trace_sysprof.c |    3 +++
> > >  1 files changed, 3 insertions(+), 0 deletions(-)
> > 
> > applied to tip/tracing/sysprof, thanks Frederic!
> 
> hm, causes a build failure:
> 
> kernel/built-in.o: In function `stack_trace_reset':
> trace_sysprof.c:(.text+0x3e91a): undefined reference to `tracing_stop_cmdline_record'
> kernel/built-in.o: In function `stack_trace_init':
> trace_sysprof.c:(.text+0x3e953): undefined reference to `tracing_start_cmdline_record'
> 
> 	Ingo

Sorry, this fixlet solves the problem:

--
>From 97113f668e9aef7ba101fbb3399e5ebb27aeec4c Mon Sep 17 00:00:00 2001
From: Frederic Weisbecker <fweisbec@gmail.com>
Date: Tue, 10 Feb 2009 15:07:22 +0100
Subject: [PATCH] tracing/sysprof: fix a build error on sysprof tracer

Fix the following build error:

kernel/built-in.o: In function `stack_trace_reset':
trace_sysprof.c:(.text+0x3e91a): undefined reference to `tracing_stop_cmdline_record'
kernel/built-in.o: In function `stack_trace_init':
trace_sysprof.c:(.text+0x3e953): undefined reference to `tracing_start_cmdline_record'

Reported-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 kernel/trace/Kconfig |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/kernel/trace/Kconfig b/kernel/trace/Kconfig
index 79be773..620f9cd 100644
--- a/kernel/trace/Kconfig
+++ b/kernel/trace/Kconfig
@@ -134,6 +134,7 @@ config SYSPROF_TRACER
 	bool "Sysprof Tracer"
 	depends on X86
 	select TRACING
+	select CONTEXT_SWITCH_TRACER
 	help
 	  This tracer provides the trace needed by the 'Sysprof' userspace
 	  tool.
-- 
1.6.1

