Return-Path: <linux-kernel-owner+w=401wt.eu-S932173AbXDFTkY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932173AbXDFTkY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2007 15:40:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932253AbXDFTkY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Apr 2007 15:40:24 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:58860 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932173AbXDFTkX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2007 15:40:23 -0400
Date: Fri, 6 Apr 2007 21:40:10 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Howells <dhowells@redhat.com>, Jakub Jelinek <jakub@redhat.com>,
       Ulrich Drepper <drepper@redhat.com>, Andi Kleen <andi@firstfloor.org>,
       Rik van Riel <riel@redhat.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>, linux-mm@kvack.org,
       Hugh Dickins <hugh@veritas.com>
Subject: Re: preemption and rwsems (was: Re: missing madvise functionality)
Message-ID: <20070406194010.GA21322@elte.hu>
References: <46128CC2.9090809@redhat.com> <20070403172841.GB23689@one.firstfloor.org> <20070403125903.3e8577f4.akpm@linux-foundation.org> <4612B645.7030902@redhat.com> <20070403202937.GE355@devserv.devel.redhat.com> <19526.1175777338@redhat.com> <20070405191129.GC22092@elte.hu> <20070405133742.88abc4f8.akpm@linux-foundation.org> <20070406090822.GA2425@elte.hu> <20070406123010.802c76b4.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070406123010.802c76b4.akpm@linux-foundation.org>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Andrew Morton <akpm@linux-foundation.org> wrote:

> > i've attached an updated version of trace-it.c, which will turn this 
> > off itself, using a sysctl. I also made WAKEUP_TIMING default-off.
> 
> ok.  http://userweb.kernel.org/~akpm/to-ingo.txt is the trace of
> 
> 	taskset -c 0 ./jakubs-test-app
> 
> while the system was doing the 150,000 context switches/sec.
> 
> It isn't very interesting.

this shows an idle CPU#7: you should taskset -c 0 trace-it too - it only 
traces the current CPU by default. (there's the 
/proc/sys/kernel/trace_all_cpus flag to trace all cpus, but in this case 
we really want the trace of CPU#0)

	Ingo
