Return-Path: <linux-kernel-owner+w=401wt.eu-S1755324AbYKJMuj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755324AbYKJMuj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2008 07:50:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754724AbYKJMu2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Nov 2008 07:50:28 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:44766 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754700AbYKJMu1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2008 07:50:27 -0500
Date: Mon, 10 Nov 2008 13:50:01 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Mike Galbraith <efault@gmx.de>
Cc: netdev <netdev@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
       Miklos Szeredi <mszeredi@suse.cz>,
       Rusty Russell <rusty@rustcorp.com.au>,
       David Miller <davem@davemloft.net>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Mike Travis <travis@sgi.com>
Subject: Re: [regression]  benchmark throughput loss from a622cf6..f7160c7
	pull
Message-ID: <20081110125001.GA28643@elte.hu>
References: <1226313350.10058.16.camel@marge.simson.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1226313350.10058.16.camel@marge.simson.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Mike Galbraith <efault@gmx.de> wrote:

> Greetings,
> 
> While retesting that recent scheduler fixes/improvements had 
> survived integration into mainline, I found that we've regressed a 
> bit since.. yesterday.  In testing, it seems that CFS has finally 
> passed what the old O(1) scheduler could deliver in scalability and 
> throughput, but we already lost a bit.

but CFS backported to a kernel with no other regressions measurably 
surpasses O(1) performance in all the metrics you are following, 
right?

i.e. the current state of things, when comparing these workloads to 
2.6.22 is that we slowed down in non-scheduler codepaths and the CFS 
speedups helps offset some of that slowdown.

But not all of it, and we also have new slowdowns:

> Reverting 984f2f3 cd83e42 2d3854a and 6209344 recovered the loss.

hm, that's two changes in essence:

 2d3854a: cpumask: introduce new API, without changing anything
 6209344: net: unix: fix inflight counting bug in garbage collector

i'm surprised about the cpumask impact, it's just new APIs in essence, 
with little material changes elsewhere.

	Ingo
