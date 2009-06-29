Return-Path: <linux-kernel-owner+w=401wt.eu-S1758180AbZF2T3a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758180AbZF2T3a (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jun 2009 15:29:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752534AbZF2T3X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jun 2009 15:29:23 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:33291 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752384AbZF2T3W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jun 2009 15:29:22 -0400
Date: Mon, 29 Jun 2009 21:29:13 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Brice Goglin <Brice.Goglin@inria.fr>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, paulus@samba.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [perf] howto switch from pfmon
Message-ID: <20090629192913.GA29295@elte.hu>
References: <4A3FEF75.2020804@inria.fr> <20090623131450.GA31519@elte.hu> <20090623134749.GA6897@elte.hu> <4A40DFF5.7010207@inria.fr> <20090623143601.GA13415@elte.hu> <4A40F31F.4030609@inria.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A40F31F.4030609@inria.fr>
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


* Brice Goglin <Brice.Goglin@inria.fr> wrote:

> > How many threads does your workload typically run, and how do 
> > you get their stats displayed?
> 
> In the aforementioned OpenMP stuff, we use pfmon to get the 
> local/remote numa memory access ratio of each thread. In this 
> specific case, we bind one thread per core (even with a O(1) 
> scheduler, people tend to avoid launching hundreds of threads on 
> current machines). pfmon gives us something similar to the output 
> of 'perf stat' in a file whose filename contains process and 
> thread IDs. We apply our own custom script to convert these many 
> pfmon output files into a single summary saying for each thread, 
> its thread ID, its core binding, its individual numa node access 
> numbers and percentages, and if they were local or remote (with 
> the Barcelona counters we were talking about, you need to check 
> where you were running before you know if accesses to node X are 
> actually local or remote accesses).

Update: based on your feedback the latest perfcounters tree includes 
the following new perf record features:

    -s, --stat            per thread counts
    -n, --no-samples      don't sample

--stat instructs the kernel to gather precise per task/thread stats 
and emits those counts to the data file. Via --no-samples one can do 
non-profiling runs - i.e. only statistics collection.

The 'perf stat' pretty printing side is not fully implemented yet - 
right now you can only see these stats if you look for 
PERF_EVENT_READ counts in the raw event log:

   perf report -D | grep PERF_EVENT_READ

But the biggest piece, the kernel and perf record side is there 
already. What kind of output would you prefer? Maybe you'd like to 
take a stab at implementing the perf report side?

	Ingo
