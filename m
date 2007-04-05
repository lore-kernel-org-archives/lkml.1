Return-Path: <linux-kernel-owner+w=401wt.eu-S1767231AbXDETLk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767231AbXDETLk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2007 15:11:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767236AbXDETLk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Apr 2007 15:11:40 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:42986 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1767231AbXDETLj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2007 15:11:39 -0400
Date: Thu, 5 Apr 2007 21:11:29 +0200
From: Ingo Molnar <mingo@elte.hu>
To: David Howells <dhowells@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Jakub Jelinek <jakub@redhat.com>, Ulrich Drepper <drepper@redhat.com>,
       Andi Kleen <andi@firstfloor.org>, Rik van Riel <riel@redhat.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>, linux-mm@kvack.org,
       Hugh Dickins <hugh@veritas.com>
Subject: Re: preemption and rwsems (was: Re: missing madvise functionality)
Message-ID: <20070405191129.GC22092@elte.hu>
References: <20070404160006.8d81a533.akpm@linux-foundation.org> <46128051.9000609@redhat.com> <p73648dz5oa.fsf@bingen.suse.de> <46128CC2.9090809@redhat.com> <20070403172841.GB23689@one.firstfloor.org> <20070403125903.3e8577f4.akpm@linux-foundation.org> <4612B645.7030902@redhat.com> <20070403202937.GE355@devserv.devel.redhat.com> <19526.1175777338@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <19526.1175777338@redhat.com>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* David Howells <dhowells@redhat.com> wrote:

> But short of recording the lock sequence, I don't think there's anyway 
> to find out for sure.  printk probably won't cut it as a recording 
> mechanism because its overheads are too great.

getting a good trace of it is easy: pick up the latest -rt kernel from:

	http://redhat.com/~mingo/realtime-preempt/

enable EVENT_TRACING in that kernel, run the workload 
and do:

	scripts/trace-it > to-ingo.txt

and send me the output. It will be large but interesting. That should 
get us a whole lot closer to what happens. A (much!) more finegrained 
result would be to also enable FUNCTION_TRACING and to do:

	echo 1 > /proc/sys/kernel/mcount_enabled

before running trace-it.

	Ingo

