Return-Path: <linux-kernel-owner+w=401wt.eu-S1756119AbYAWSoP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756119AbYAWSoP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2008 13:44:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751216AbYAWSoA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jan 2008 13:44:00 -0500
Received: from ms-smtp-04.nyroc.rr.com ([24.24.2.58]:57932 "EHLO
	ms-smtp-04.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751103AbYAWSn7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2008 13:43:59 -0500
Date: Wed, 23 Jan 2008 13:43:55 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Daniel Walker <dwalker@mvista.com>
cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Christoph Hellwig <hch@infradead.org>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Gregory Haskins <ghaskins@novell.com>,
       Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
       Thomas Gleixner <tglx@linutronix.de>, Tim Bird <tim.bird@am.sony.com>,
       Sam Ravnborg <sam@ravnborg.org>, "Frank Ch. Eigler" <fche@redhat.com>,
       Jan Kiszka <jan.kiszka@siemens.com>, John Stultz <johnstul@us.ibm.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [PATCH 01/20 -v5] printk - dont wakeup klogd with interrupts
 disabled
In-Reply-To: <1201112899.13596.25.camel@imap.mvista.com>
Message-ID: <Pine.LNX.4.58.0801231336540.9982@gandalf.stny.rr.com>
References: <20080123160236.969334052@goodmis.org>  <20080123160441.236562634@goodmis.org>
  <1201107978.13596.16.camel@imap.mvista.com>  <Pine.LNX.4.58.0801231213430.12932@gandalf.stny.rr.com>
  <1201110185.13596.22.camel@imap.mvista.com>  <Pine.LNX.4.58.0801231315500.6127@gandalf.stny.rr.com>
 <1201112899.13596.25.camel@imap.mvista.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 23 Jan 2008, Daniel Walker wrote:

>
> On Wed, 2008-01-23 at 13:18 -0500, Steven Rostedt wrote:
>
> > The wakeup hook in schedule is when we find out that we hit our max. I
> > could postpone that somehow, but that would require more glue code than I
> > would like to add.
>
> Which hook specifically ?

The wakeup tracer does a print on max when the new task is about to be
switched to (in context_switch).

>
> > As for -rt, we've disabled printk for consoles not ATOMIC safe. So the
> > only consoles that will print in atomic sections so far are, earlyprintk
> > and the VGA.
>
> Is this code you added recently for tracing?

Nope, it's been there for a few releases and had nothing to do with the
latency tracer.

<looks at code>

Hmm, seems that only the "hack" fix is in upstream. The Red Hat version
has the better fix, but mainline didn't get it. OK, I'll add that to the
next -rt release.

-- Steve

