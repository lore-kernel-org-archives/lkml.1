Return-Path: <linux-kernel-owner+w=401wt.eu-S1755009AbZBILwX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755009AbZBILwX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Feb 2009 06:52:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753122AbZBILwP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Feb 2009 06:52:15 -0500
Received: from mx2.redhat.com ([66.187.237.31]:58031 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753065AbZBILwO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Feb 2009 06:52:14 -0500
Date: Mon, 9 Feb 2009 09:51:51 -0200
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Steven Rostedt <rostedt@goodmis.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH tip 1/1] tracing: handle unregistering the current
	tracer
Message-ID: <20090209115151.GB5265@ghostprotocols.net>
References: <20090207205259.GB11892@ghostprotocols.net> <20090209095816.GB20467@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090209095816.GB20467@elte.hu>
X-Url: http://oops.ghostprotocols.net:81/blog
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Mon, Feb 09, 2009 at 10:58:16AM +0100, Ingo Molnar escreveu:
> 
> * Arnaldo Carvalho de Melo <acme@redhat.com> wrote:
> 
> > Impact: simplification
> > 
> > Instead of requiring that plugins have the sequence:
> > 
> >   my_tracer_stop(my_trace_array);
> >   unregister_tracer(my_tracer);
> > 
> > it should be possible just do a:
> > 
> >   unregister_tracer(my_tracer);
> > 
> > Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
> > ---
> >  kernel/trace/trace.c |    9 +++++++++
> >  1 files changed, 9 insertions(+), 0 deletions(-)
> 
> Applied to tip/tracing/ftrace, thanks Arnaldo!
> 
> Nice one - we should try to shoot for the smallest physically
> possible linecount for any new (possibly trivial) tracer plugin.

That and also for as few as possible EXPORT_SYMBOL_GPL entries, now, for
converting net/ipv4/tcp_probe.c to an ftrace plugin + one tracepoint at
tcp_rcv_established we need:

doppio linux-2.6-tip]$ grep ^+EXPORT_SYMBOL ~/tcp_cwnd_tracer.patch 
+EXPORT_SYMBOL_GPL(register_tracer);
+EXPORT_SYMBOL_GPL(unregister_tracer);
+EXPORT_SYMBOL_GPL(tracing_record_cmdline);
+EXPORT_SYMBOL_GPL(trace_buffer_lock_reserve);
+EXPORT_SYMBOL_GPL(trace_buffer_unlock_commit);
+EXPORT_SYMBOL_GPL(trace_seq_printf);
+EXPORT_SYMBOL_GPL(register_ftrace_event);
+EXPORT_SYMBOL_GPL(unregister_ftrace_event);
[acme@doppio linux-2.6-tip]$

- Arnaldo
