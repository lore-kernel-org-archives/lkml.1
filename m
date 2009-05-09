Return-Path: <linux-kernel-owner+w=401wt.eu-S1754733AbZEIOQd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754733AbZEIOQd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 May 2009 10:16:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752602AbZEIOQY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 May 2009 10:16:24 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:54656 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750996AbZEIOQY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 May 2009 10:16:24 -0400
Date: Sat, 9 May 2009 16:15:56 +0200
From: Ingo Molnar <mingo@elte.hu>
To: =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Jason Baron <jbaron@redhat.com>, Tom Zanussi <tzanussi@gmail.com>,
       linux-kernel@vger.kernel.org, laijs@cn.fujitsu.com, rostedt@goodmis.org,
       peterz@infradead.org, jiayingz@google.com, mbligh@google.com,
       roland@redhat.com, fche@redhat.com
Subject: Re: [RFC] convert ftrace syscall tracer to TRACE_EVENT()
Message-ID: <20090509141556.GA24082@elte.hu>
References: <20090508210347.GA3121@redhat.com> <20090509083737.GE3656@elte.hu> <c62985530905090553u538f8589l984b03428713d7ef@mail.gmail.com> <20090509133306.GA20684@elte.hu> <20090509135046.GA2344@Krystal> <c62985530905090706t52929c0qe21418f86aca9ba8@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <c62985530905090706t52929c0qe21418f86aca9ba8@mail.gmail.com>
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


* Frédéric Weisbecker <fweisbec@gmail.com> wrote:

> > I would expect to use copy_string_from_user (for strings) and 
> > copy_from_user for structures, because without any strings 
> > (especially), the trace information become much less useful.
> 
> Yeah, for structures we would just need the copy_from_user.

There's just a few places (mainly related to VFS APIs) where we 
really want to do that, and there we want to do it a bit later, not 
at syscall time: we want to do it after the getname(), to output a 
stable (and already copied to kernel space) copy of the file name.

So the right solution there would be to add special, case by case 
tracepoints to those few places. We dont need strings for the 
majority of the 300+ system calls that exist on Linux.

	Ingo
