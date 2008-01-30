Return-Path: <linux-kernel-owner+w=401wt.eu-S1756997AbYA3Nk7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756997AbYA3Nk7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 08:40:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758541AbYA3Nke
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 08:40:34 -0500
Received: from ms-smtp-04.nyroc.rr.com ([24.24.2.58]:41886 "EHLO
	ms-smtp-04.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758514AbYA3Nkc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 08:40:32 -0500
Date: Wed, 30 Jan 2008 08:40:25 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Christoph Hellwig <hch@infradead.org>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Gregory Haskins <ghaskins@novell.com>,
       Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
       Thomas Gleixner <tglx@linutronix.de>, Tim Bird <tim.bird@am.sony.com>,
       Sam Ravnborg <sam@ravnborg.org>, "Frank Ch. Eigler" <fche@redhat.com>,
       Jan Kiszka <jan.kiszka@siemens.com>, John Stultz <johnstul@us.ibm.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [PATCH 19/22 -v7] trace preempt off critical timings
In-Reply-To: <1201686038.28547.176.camel@lappy>
Message-ID: <Pine.LNX.4.58.0801300837370.29020@gandalf.stny.rr.com>
References: <20080130031521.258552785@goodmis.org>  <20080130031843.112965593@goodmis.org>
 <1201686038.28547.176.camel@lappy>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 30 Jan 2008, Peter Zijlstra wrote:

>
> On Tue, 2008-01-29 at 22:15 -0500, Steven Rostedt wrote:
>
> > +static DEFINE_PER_CPU(int, tracing_cpu);
>
> Is the per-cpu tracing not also needed for irq off tracing?

The preempt off code shares the irq off code. With irq off only (before
this patch) all that was needed was to check if trace_enabled is set or
not. Now that the preempt off code is coupled with the irqs off code, we
may hit some paths where tracing is enabled but we are not currently
tracing. This variable was added to facilitate this knowledge.

>
> Also, its not mentioned in the changelog.

It was more of an internal design change than a feature.

-- Steve
