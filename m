Return-Path: <linux-kernel-owner+w=401wt.eu-S1754752AbZEIOHq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754752AbZEIOHq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 May 2009 10:07:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752511AbZEIOHi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 May 2009 10:07:38 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:55580 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751553AbZEIOHh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 May 2009 10:07:37 -0400
Date: Sat, 9 May 2009 16:07:17 +0200
From: Ingo Molnar <mingo@elte.hu>
To: =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>
Cc: Jason Baron <jbaron@redhat.com>, Tom Zanussi <tzanussi@gmail.com>,
       linux-kernel@vger.kernel.org, laijs@cn.fujitsu.com, rostedt@goodmis.org,
       peterz@infradead.org, mathieu.desnoyers@polymtl.ca, jiayingz@google.com,
       mbligh@google.com, roland@redhat.com, fche@redhat.com
Subject: Re: [RFC] convert ftrace syscall tracer to TRACE_EVENT()
Message-ID: <20090509140717.GB22000@elte.hu>
References: <20090508210347.GA3121@redhat.com> <20090509083737.GE3656@elte.hu> <c62985530905090553u538f8589l984b03428713d7ef@mail.gmail.com> <20090509133306.GA20684@elte.hu> <c62985530905090702o536c8787m1910540d560a0a22@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <c62985530905090702o536c8787m1910540d560a0a22@mail.gmail.com>
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

> > Note, this assumes that all syscall types can be described via 
> > __field() - i think that's correct. (we dont want to deref 
> > strings as they are untrusted, and there are no arrays in 
> > syscall parameters)
> 
> Yeah, but we can also define a __string_from_user(), should be 
> trivial.

We cannot really do that, because we cannot check the type in a 
macro. So we dont know when to inject __field() versus 
__string_from_user().

> > Can you see any complication?
> 
> Just about the order of headers to include and headers 
> dependencies....

That is testable and any problems will be found at the build stage, 
so it should be solvable.

	Ingo
