Return-Path: <linux-kernel-owner+w=401wt.eu-S1752459AbYAWV6w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752459AbYAWV6w (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2008 16:58:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751061AbYAWV6m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jan 2008 16:58:42 -0500
Received: from ms-smtp-04.nyroc.rr.com ([24.24.2.58]:32821 "EHLO
	ms-smtp-04.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751216AbYAWV6l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2008 16:58:41 -0500
Date: Wed, 23 Jan 2008 16:58:34 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Christoph Hellwig <hch@infradead.org>,
       Gregory Haskins <ghaskins@novell.com>,
       Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
       Thomas Gleixner <tglx@linutronix.de>, Tim Bird <tim.bird@am.sony.com>,
       Sam Ravnborg <sam@ravnborg.org>, "Frank Ch. Eigler" <fche@redhat.com>,
       Jan Kiszka <jan.kiszka@siemens.com>, John Stultz <johnstul@us.ibm.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [PATCH 06/20 -v5] add notrace annotations for NMI routines
In-Reply-To: <20080123213139.GB2282@Krystal>
Message-ID: <Pine.LNX.4.58.0801231650150.19550@gandalf.stny.rr.com>
References: <20080123160236.969334052@goodmis.org> <20080123160442.063076557@goodmis.org>
 <20080123213139.GB2282@Krystal>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 23 Jan 2008, Mathieu Desnoyers wrote:

> * Steven Rostedt (rostedt@goodmis.org) wrote:
> > This annotates NMI functions with notrace. Some tracers may be able
> > to live with this, but some cannot. So we turn off NMI tracing.
> >
> > One solution might be to make a notrace_nmi which would only turn
> > off NMI tracing if a trace utility needed it off.
> >
> Is this still needed with the atomic clocksource read ?

This never had to do with the clocksource. The tracer itself isn't atomic
against NMIs. hmm, it may actually be. It does a tracer disable for the
CPU by an atomic_inc and this would prevent the NMI from causing harm.

I'll test without this patch and see what happens when I turn on a high
rate of NMIS.

I still want to add a bit more notraces around for the simple
reason of cleaning up the output and prehaps speeding up the code a bit.

-- Steve

