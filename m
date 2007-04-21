Return-Path: <linux-kernel-owner+w=401wt.eu-S1030581AbXDUKbm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030581AbXDUKbm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Apr 2007 06:31:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030599AbXDUKbm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Apr 2007 06:31:42 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:42280 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030581AbXDUKbl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Apr 2007 06:31:41 -0400
Date: Sat, 21 Apr 2007 12:31:29 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Willy Tarreau <w@1wt.eu>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [Announce] [patch] Modular Scheduler Core and Completely Fair Scheduler [CFS]
Message-ID: <20070421103129.GA12621@elte.hu>
References: <20070414063254.GB14875@elte.hu> <20070414064334.GA19463@elte.hu> <20070414080833.GL943@1wt.eu> <20070414083625.GM943@1wt.eu> <20070414105338.GB19454@elte.hu> <20070414130101.GA2538@1wt.eu> <20070419090144.GA17100@elte.hu> <20070419125438.GA27584@1wt.eu> <20070419151803.GB30959@elte.hu> <20070419184534.GA29096@1wt.eu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070419184534.GA29096@1wt.eu>
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


* Willy Tarreau <w@1wt.eu> wrote:

> I hacked it a bit to make it accept two parameters :
>   -R <run_time_in_microsecond> : time spent burning CPU cycles at each round
>   -S <sleep_time_in_microsecond> : time spent getting a rest
> 
> It now advances what it thinks is a second at each iteration, so that 
> it makes it easy to compare its progress with other instances (there 
> are seconds, minutes and hours, so it's easy to visually count up to 
> around 43200).
> 
> The modified code is here :
> 
>   http://linux.1wt.eu/sched/orbitclock-0.2bench.tgz
> 
> What is interesting to note is that it's easy to make X work a lot 
> (99%) by using 0 as the sleeping time, and it's easy to make the 
> process work a lot by using large values for the running time 
> associated with very low values (or 0) for the sleep time.
> 
> Ah, and it supports -geometry ;-)
> 
> It could become a useful scheduler benchmark !

i just tried ocbench-0.3, and it is indeed very nice!

Would it make sense perhaps to (optionally?) also log some sort of 
periodic text feedback to stdout, about the quality of scheduling? Maybe 
even a 'run this many seconds' option plus a summary text output at the 
end (which would output measured runtime, observed longest/smallest 
latency and standard deviation of latencies maybe)? That would make it 
directly usable both as a 'consistency of X app scheduling' visual test 
and as an easily shareable benchmark with an objective numeric result as 
well.

	Ingo
