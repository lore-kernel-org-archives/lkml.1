Return-Path: <linux-kernel-owner+w=401wt.eu-S1759268AbZF2Tjj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759268AbZF2Tjj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jun 2009 15:39:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758602AbZF2Tj1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jun 2009 15:39:27 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:41313 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755162AbZF2Tj0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jun 2009 15:39:26 -0400
Date: Mon, 29 Jun 2009 21:39:18 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Frederic Weisbecker <fweisbec@gmail.com>,
       Arjan van de Ven <arjan@infradead.org>
Cc: Li Zefan <lizf@cn.fujitsu.com>, Steven Rostedt <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] tracing/fastboot: document the need of initcall_debug
Message-ID: <20090629193918.GA31577@elte.hu>
References: <4A48735E.9050002@cn.fujitsu.com> <20090629082152.GA2921@elte.hu> <4A488304.9000104@cn.fujitsu.com> <20090629091422.GA9724@elte.hu> <20090629111901.GB6265@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090629111901.GB6265@nowhere>
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


* Frederic Weisbecker <fweisbec@gmail.com> wrote:

> On Mon, Jun 29, 2009 at 11:14:22AM +0200, Ingo Molnar wrote:
> > 
> > * Li Zefan <lizf@cn.fujitsu.com> wrote:
> > 
> > > Ingo Molnar wrote:
> > > > * Li Zefan <lizf@cn.fujitsu.com> wrote:
> > > > 
> > > >> To use boot tracer, one should pass initcall_debug as well as
> > > >> ftrace=initcall to the command line.
> > > > 
> > > > I think both should be auto-enabled if BOOT_TRACER is enabled, for 
> > > > ease of use - agreed?
> > > 
> > > If both are auto-enabled, we'll always do boot tracing. But we 
> > > want BOOT_TRACER to be enabled and only enable boot tracing when 
> > > it's needed.
> > > 
> > > But maybe we can make ftrace=initcall implies initcall_debug=1?
> > 
> > That's reasonable indeed.
> > 
> > 	Ingo
> 
> Yeah.
> 
> Although I wonder if this tracer is still useful. It was first 
> written to debug fastboot, to get more than the initcall_debug 
> output, ie: the scheduling events but now I guess the latter is 
> not useful anymore. And using initcall_debug already does the job 
> of printing the initcall events.
> 
> What do you think?

Arjan is/was a frequent user of it. I think some neat stuff came out 
of it: the trace can be fed into sysprof/ftrace and can be 
visualized.

If we remove it we should first provide a replacement perfcounters 
feature for it. Something like a special sw counter that 'buffers' 
its events and so can be enabled during early bootup by the kernel, 
and disabled once init is executed. If user-space creates a counter 
on that event then it gets to read all the boot-time events in a 
stream.

Or something like that. That would integrate the boot tracer 
functionality into perfcounters tooling. We could do a 'perf report' 
display of boot delays for example, and other neat stuff. Sounds 
extremely useful and more usable than the boot tracer because this 
special 'boot delays' event would always be there and can be used by 
the regular 'perf' tooling to inspect bootup properties.

	Ingo
