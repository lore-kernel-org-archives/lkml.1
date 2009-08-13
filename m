Return-Path: <linux-kernel-owner+w=401wt.eu-S1753458AbZHMIDJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753458AbZHMIDJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Aug 2009 04:03:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752399AbZHMIDH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Aug 2009 04:03:07 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:52639 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752204AbZHMIDE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Aug 2009 04:03:04 -0400
Date: Thu, 13 Aug 2009 10:02:45 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Lai Jiangshan <laijs@cn.fujitsu.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Jiaying Zhang <jiayingz@google.com>, Martin Bligh <mbligh@google.com>,
       Li Zefan <lizf@cn.fujitsu.com>, Jason Baron <jbaron@redhat.com>
Subject: Re: [RFD] Kprobes/Kretprobes perf support
Message-ID: <20090813080245.GA11497@elte.hu>
References: <1250016545-6601-1-git-send-email-fweisbec@gmail.com> <4A82EEC5.8000603@redhat.com> <4A82F5A0.2090603@redhat.com> <20090812191305.GB5974@nowhere> <4A832416.2010209@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A832416.2010209@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Masami Hiramatsu <mhiramat@redhat.com> wrote:

>> Speaking about your patches. You told recently you would be 
>> willing to implement a perf support for kprobes, right? :-)
>
> Hmm, perhaps, I meant a profiling 
> interface(http://lkml.org/lkml/2009/7/24/240). However, that is 
> interesting idea too.

Note that profiling via perf and perfcounters is a very young 
project, but already far more capable:

 - It is a generic framework. If you provide an event source, the 
   full framework will understand and support your events and will 
   expose it to users: 'perf stat' works, 'perf record',
   'perf report', 'perf top' all works the upcoming 'perf trace'
   and the upcoming 'perf view' GUI will all understand it. These 
   are all different modes of analysis, from the high-level 
   statistics bits, through profiling, down to lowlevel tracing - 
   based on the same stream of data.

 - It's very flexible: there's per cpu, per task or per workload 
   hierarchy stats/profiling/tracing.

 - It can do call-chain graph recording/reporting
   (try "perf record -g -f -a sleep 1" + "perf report")

 - There's a standard syscall interface to all this, making it 
   readily accessible and pushing it into apps and tools.

 - Your events can and will mix with all the other events. So there 
   can be hardware PMU events, software counters, tracepoints, etc. 
   - all in the same data file.

So while there's still a lot of work to do all across the 
perfcounters spectrum, it generally would be nice to expose kprobes 
events via perfcounters.

	Ingo
