Return-Path: <linux-kernel-owner+w=401wt.eu-S1764066AbXEUKT6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764066AbXEUKT6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 06:19:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762003AbXEUKK5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 06:10:57 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:50200 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762152AbXEUKKP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 06:10:15 -0400
Date: Mon, 21 May 2007 12:09:40 +0200
From: Ingo Molnar <mingo@elte.hu>
To: David Miller <davem@davemloft.net>
Cc: kernel@prachanda.info, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       tglx@linutronix.de
Subject: Re: bad networking related lag in v2.6.22-rc2
Message-ID: <20070521100940.GA4407@elte.hu>
References: <20070521075824.GA11198@elte.hu> <20070521080351.GA13375@elte.hu> <20070521081201.GB13858@elte.hu> <20070521.012903.18300561.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070521.012903.18300561.davem@davemloft.net>
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


* David Miller <davem@davemloft.net> wrote:

> >  gkrellm-5977 0..s.  0us : cond_resched_softirq 
> >  (established_get_next)
> 
> So it's not the 3c59x bug :-)
> 
> If you have a lot of sockets, there is not way to make the performance 
> of dumping /proc/net/tcp not suck, use the netlink socket dumping 
> which is:
> 
> 1) more efficient even for full dumps
> 2) allows filtering for the best possible performance

hm, there is a cond_resched_softirq() for every line output so the 
actual latency from this alone shouldnt be that bad. While /proc/net/tcp 
has a quadratic algorithm, the per-line latency is O(N), which shouldnt 
show up on the radar.

but note that Ananitya is running a fast system as a stock desktop 
system browsing the web, so there shouldnt be tons of sockets. So the 
latency isnt caused by /proc/net/tcp itself, but there does seem to be 
some networking related anomaly.

we'll hopefully be able to tell this more specifically from the re-done 
trace.

	Ingo
