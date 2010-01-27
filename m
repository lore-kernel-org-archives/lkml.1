Return-Path: <linux-kernel-owner+w=401wt.eu-S1752536Ab0A0IZA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752536Ab0A0IZA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jan 2010 03:25:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751018Ab0A0IY5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jan 2010 03:24:57 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:59897 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752268Ab0A0IY4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jan 2010 03:24:56 -0500
Date: Wed, 27 Jan 2010 09:24:40 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Avi Kivity <avi@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Jim Keniston <jkenisto@us.ibm.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Srikar Dronamraju <srikar@linux.vnet.ibm.com>, ananth@in.ibm.com,
       Arnaldo Carvalho de Melo <acme@infradead.org>,
       utrace-devel <utrace-devel@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Maneesh Soni <maneesh@in.ibm.com>, Mark Wielaard <mjw@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] [PATCH 1/7] User Space Breakpoint Assistance Layer (UBP)
Message-ID: <20100127082440.GA16640@elte.hu>
References: <20100118124419.GC1628@linux.vnet.ibm.com>
 <84144f021001180451k2a84f17x3dc24796fea986c9@mail.gmail.com>
 <4B5459CA.9060603@redhat.com>
 <4B545ACF.40203@cs.helsinki.fi>
 <1263852957.2266.38.camel@localhost.localdomain>
 <4B556855.6040800@redhat.com>
 <1263923265.4998.28.camel@localhost.localdomain>
 <4B56D027.3010808@redhat.com>
 <1263981472.4283.843.camel@laptop>
 <4B56F588.2060109@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B56F588.2060109@redhat.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Avi Kivity <avi@redhat.com> wrote:

> On 01/20/2010 11:57 AM, Peter Zijlstra wrote:
> >On Wed, 2010-01-20 at 11:43 +0200, Avi Kivity wrote:
> >> 1. Write a trace entry into shared memory, trap into the kernel on 
> >>    overflow.
> >> 2. Trap if a condition is satisfied (fast watchpoint implementation).
> >
> > So now you want to consume more of a process' address space to store trace 
> > data as well?
> 
> Yes.  I know I'm bad.

No, you are just wrong.

> > Not to mention that that process could wreck the trace data rendering it 
> > utterly unreliable.
> 
> It could, but it also might not.  Are we going to deny high performance 
> tracing to users just because it doesn't work in all cases?

Tracing and monitoring is foremost about being able to trust the instrument, 
then about performance and usability. That's one of the big things about 
ftrace and perf.

By proposing 'user space tracing' you are missing two big aspects:

 - That self-contained, kernel-driven tracing can be replicated in user-space.
   It cannot. Sharing and global state is much harder to maintain reliably,
   but the bigger problem is that user-space can stomp on its own tracing
   state and can make it unreliable. Tracing is often used to figure out bugs,
   and tracers will be trusted less if they can stomp on themselves.

 - That somehow it's much faster and that this edge matters. It isnt and it
   doesnt matter. The few places that need very very fast tracing wont use any
   of these facilities - it will use something specialized.

So you are creating a solution for special cases that dont need it, and you 
are also ignoring prime qualities of a good tracing framework.

	Ingo
