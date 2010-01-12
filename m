Return-Path: <linux-kernel-owner+w=401wt.eu-S1751527Ab0ALFI7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751527Ab0ALFI7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jan 2010 00:08:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751116Ab0ALFI5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jan 2010 00:08:57 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:37001 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751036Ab0ALFI4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jan 2010 00:08:56 -0500
X-Authority-Analysis: v=1.0 c=1 a=g2MyM69NJrgA:10 a=7U3hwN5JcxgA:10 a=dSoPn6ytcG0D-0lOLHAA:9 a=FhOLUdBU3Uo-cgZvbh8A:7 a=UQUmolc5_3_zeSOV1qycMPWZzeUA:4
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: [RFC] [PATCH 7/7] Ftrace plugin for Uprobes
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Arnaldo Carvalho de Melo <acme@infradead.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       utrace-devel <utrace-devel@redhat.com>,
       Jim Keniston <jkenisto@us.ibm.com>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Maneesh Soni <maneesh@in.ibm.com>, Mark Wielaard <mjw@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20100112045454.GJ5243@nowhere>
References: <20100111122521.22050.3654.sendpatchset@srikar.in.ibm.com>
	 <20100111122608.22050.94088.sendpatchset@srikar.in.ibm.com>
	 <20100112045454.GJ5243@nowhere>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Kihon Technologies Inc.
Date: Tue, 12 Jan 2010 00:08:53 -0500
Message-ID: <1263272933.28171.3804.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-01-12 at 05:54 +0100, Frederic Weisbecker wrote:

> Now what if I want to launch ls and want to profile a function
> inside. What can I do with a trace event. I can't create the
> probe event based on a pid as I don't know it in advance.
> I could give it the ls cmdline and it manages to activate
> on the next ls launched. This is racy as another ls can
> be launched concurrently.

You make a wrapper script:

#!/bin/sh
<add probe to ls with pid> $$
exec $*

I do this all the time to limit the function tracer to a specific app.

#!/bin/sh
echo $$ > /debug/tracing/set_ftrace_pid
echo function > /debug/tracing/current_tracer
exec $*


The exec will cause the ls to have the pid of $$.

-- Steve



> 
> So I can only say there that an ftrace plugin or an ftrace trace
> event would be only a half-useful interface to exploit utrace
> possibilities because it only lets us trace already running
> apps. Moreover I bet the most chosen workflow to profile/trace
> uprobes is by launching an app and profile it from the beginning,
> not by profiling an already running one, which makes an ftrace
> interface even less than half useful there.
> 
> ftrace is cool to trace the kernel, but this kind of tricky
> userspace tracing workflow is not adapted to it.
> 
> What do you think?
> 


