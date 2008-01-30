Return-Path: <linux-kernel-owner+w=401wt.eu-S1761880AbYA3NSm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761880AbYA3NSm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 08:18:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756527AbYA3NSd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 08:18:33 -0500
Received: from ms-smtp-05.nyroc.rr.com ([24.24.2.59]:39414 "EHLO
	ms-smtp-05.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754745AbYA3NSc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 08:18:32 -0500
Date: Wed, 30 Jan 2008 08:18:19 -0500 (EST)
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
Subject: Re: [PATCH 17/22 -v7] mcount tracer for wakeup latency timings.
In-Reply-To: <1201685469.28547.172.camel@lappy>
Message-ID: <Pine.LNX.4.58.0801300817260.29020@gandalf.stny.rr.com>
References: <20080130031521.258552785@goodmis.org>  <20080130031842.783183063@goodmis.org>
 <1201685469.28547.172.camel@lappy>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 30 Jan 2008, Peter Zijlstra wrote:

>
> On Tue, 2008-01-29 at 22:15 -0500, Steven Rostedt wrote:
>
> > +static void notrace __wakeup_reset(struct tracing_trace *tr)
[...]
> > +
> > +	wakeup_task = NULL;
> > +
> > +	/*
> > +	 * Don't let the trace_enabled = 1 show up before
> > +	 * the wakeup_task is reset.
> > +	 */
> > +	smp_wmb();
> > +}
>
> Another un-balanced barrier.


This one is probably me being paranoid, but even so, it should have a
pair.  Will fix.

-- Steve

