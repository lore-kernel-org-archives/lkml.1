Return-Path: <linux-kernel-owner+w=401wt.eu-S1754902AbYAZNDr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754902AbYAZNDr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jan 2008 08:03:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752267AbYAZNDj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Jan 2008 08:03:39 -0500
Received: from ms-smtp-04.nyroc.rr.com ([24.24.2.58]:38849 "EHLO
	ms-smtp-04.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752380AbYAZNDi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jan 2008 08:03:38 -0500
Date: Sat, 26 Jan 2008 08:03:23 -0500 (EST)
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
       Arjan van de Ven <arjan@infradead.org>, Pavel Machek <pavel@ucw.cz>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [PATCH 01/23 -v6] printk - dont wakeup klogd with interrupts
 disabled
In-Reply-To: <1201341017.27573.17.camel@lappy>
Message-ID: <Pine.LNX.4.58.0801260802330.16244@gandalf.stny.rr.com>
References: <20080126042152.526086719@goodmis.org>  <20080126042801.280369398@goodmis.org>
 <1201341017.27573.17.camel@lappy>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sat, 26 Jan 2008, Peter Zijlstra wrote:
>
> Right, while this might appear to be sound, I hate to point out that we
> only want to exclude it when current holds the rq->lock. This could lead
> to spuriously missing klogd wakeups because other cpus hold our
> rq->lock.

Hmm, good point. Not hard to solve ;-)

>
> Now, is this klogd thing only relevant for dumping stuff into the log,
> or also for writing stuff out to the serial line?

It's only responsible for the log (userland stuff).

-- Steve

