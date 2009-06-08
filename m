Return-Path: <linux-kernel-owner+w=401wt.eu-S1756552AbZFHWAm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756552AbZFHWAm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jun 2009 18:00:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755766AbZFHWA3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Jun 2009 18:00:29 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:53794 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755975AbZFHWA2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jun 2009 18:00:28 -0400
Date: Tue, 9 Jun 2009 00:00:13 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jason Baron <jbaron@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
       fweisbec@gmail.com, laijs@cn.fujitsu.com, rostedt@goodmis.org,
       peterz@infradead.org, mathieu.desnoyers@polymtl.ca, jiayingz@google.com,
       mbligh@google.com, roland@redhat.com, fche@redhat.com
Subject: Re: [PATCH 2/2] convert to syscall tracepoints
Message-ID: <20090608220013.GC22049@elte.hu>
References: <cover.1244222378.git.jbaron@redhat.com> <af4031af81ce372eac2be125dabc2ea746b4308b.1244222378.git.jbaron@redhat.com> <20090607132936.GC12088@elte.hu> <20090608202406.GA3181@redhat.com> <20090608204056.GA26832@elte.hu> <20090608211150.GC3181@redhat.com> <20090608212526.GA22049@elte.hu> <20090608213833.GD3181@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090608213833.GD3181@redhat.com>
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


* Jason Baron <jbaron@redhat.com> wrote:

> Yes, this can easily be done....but that wasn't the problem I was 
> interested in solving. I wanted a per syscall tracepoint site. I 
> thought I had been making that clear all along...

We can do that, but _not in the syscall_.

There's absolutely nothing wrong with having an array of 
tracepoints/callbacks that is being called by the TIF_FTRACE code. 
We already have per syscall attributes - that can include a callback 
too.

> [...] Please notice that the implementation I've proposed obtains 
> the syscall number, and then jumps to the appropriate tracepoint 
> and then exits. Its quite efficient. In fact, I've enabled all of 
> the syscalls using my proposed method and running tbench I'm able 
> to get more throughput then using the current syscall method. I've 
> also done 'getpid()' loops and seen no performance difference 
> between the approaches. I'm happy to run any other benchmarks...

If you cannot see a performance difference in getpid() loop that's 
possibly because glibc caches getpid() results ...

Try getppid().

Anyway - bloating every syscall with a tracepoint check is out of 
question and unnecessary. We already have the TIF_ flag based 
machinery to call back on syscalls - and what we need is the proper 
type/field info extracted and /debug/tracing/syscalls/* entries 
created.

	Ingo
