Return-Path: <linux-kernel-owner+w=401wt.eu-S1756345AbZBYNDS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756345AbZBYNDS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Feb 2009 08:03:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753205AbZBYNDA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Feb 2009 08:03:00 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:46645 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753152AbZBYNC7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Feb 2009 08:02:59 -0500
Date: Wed, 25 Feb 2009 14:02:02 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 1/2] tracing/core: introduce per cpu tracing files
Message-ID: <20090225130202.GH26273@elte.hu>
References: <49a4e2c1.0508d00a.21e6.2eea@mx.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49a4e2c1.0508d00a.21e6.2eea@mx.google.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Frederic Weisbecker <fweisbec@gmail.com> wrote:

> Impact: split up tracing output per cpu

> So this patch creates a new directory inside /debug/tracing 
> (provided you have a debugfs mountpoint on /debug). Inside 
> this directory, you will now find one trace_pipe file, one 
> trace file and one latency_trace file per cpu. Which means if 
> you have two cpus, you will have:
> 
> trace0
> trace1
> trace_pipe0
> trace_pipe1

Very nice! I've applied your patches to tip:tracing/ftrace.

Could you please do one more tweak? The /debug/tracing/per_cpu/ 
directory looks a bit cluttered on a 16-way box. It would be a 
nicer structure to have per CPU directories, i.e.:

 /debug/tracing/per_cpu/cpu0/trace
 /debug/tracing/per_cpu/cpu0/trace_pipe
 /debug/tracing/per_cpu/cpu1/trace
 /debug/tracing/per_cpu/cpu1/trace_pipe

etc.

Besides being easier to handle, this also makes it easy to 
extend the list of per CPU attributes as well, without 
cluttering the /debug/tracing/per_cpu/ directory.

	Ingo
