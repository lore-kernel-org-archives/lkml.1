Return-Path: <linux-kernel-owner+w=401wt.eu-S1752113Ab0ALFo3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752113Ab0ALFo3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jan 2010 00:44:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751319Ab0ALFo2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jan 2010 00:44:28 -0500
Received: from mail-ew0-f209.google.com ([209.85.219.209]:33849 "EHLO
	mail-ew0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750741Ab0ALFo2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jan 2010 00:44:28 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=xBXGLx3NDMNs0eqUY4EFpozRcP4bNOOF4g4V7UQ8cw7wdO8GhM0Zqk22y9tLOeFa8I
         37mSRx7UxynZNVdyPV9NH5EP9mb/kNutn8YmYlzPWA5LQBydd+RLqApkhdWcAP1FWPbw
         L8AVHviDrXDlbKr767VT0GMv7akhwL7pKdSrs=
Date: Tue, 12 Jan 2010 06:44:23 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Arnaldo Carvalho de Melo <acme@infradead.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       utrace-devel <utrace-devel@redhat.com>,
       Jim Keniston <jkenisto@us.ibm.com>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Maneesh Soni <maneesh@in.ibm.com>, Mark Wielaard <mjw@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] [PATCH 7/7] Ftrace plugin for Uprobes
Message-ID: <20100112054422.GM5243@nowhere>
References: <20100111122521.22050.3654.sendpatchset@srikar.in.ibm.com> <20100111122608.22050.94088.sendpatchset@srikar.in.ibm.com> <20100112045454.GJ5243@nowhere> <1263272933.28171.3804.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1263272933.28171.3804.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 12, 2010 at 12:08:53AM -0500, Steven Rostedt wrote:
> On Tue, 2010-01-12 at 05:54 +0100, Frederic Weisbecker wrote:
> 
> > Now what if I want to launch ls and want to profile a function
> > inside. What can I do with a trace event. I can't create the
> > probe event based on a pid as I don't know it in advance.
> > I could give it the ls cmdline and it manages to activate
> > on the next ls launched. This is racy as another ls can
> > be launched concurrently.
> 
> You make a wrapper script:
> 
> #!/bin/sh
> <add probe to ls with pid> $$
> exec $*
> 
> I do this all the time to limit the function tracer to a specific app.
> 
> #!/bin/sh
> echo $$ > /debug/tracing/set_ftrace_pid
> echo function > /debug/tracing/current_tracer
> exec $*
> 
> 
> The exec will cause the ls to have the pid of $$.


Sounds like a good idea. In this case we could indeed
think about a trace event.

It would typically have the benefit to have the same
interface than kprobes.

We can use it with perf, the only constraint is that we need
to launch the record right after creating the trace event.
Or we can pre-create them and set the pid of the target
later when we launch perf record.

And we need an enable on exec option in the probe definition.

That's a nice option.

