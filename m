Return-Path: <linux-kernel-owner+w=401wt.eu-S1753005AbZIJHn2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753005AbZIJHn2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Sep 2009 03:43:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752643AbZIJHn1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Sep 2009 03:43:27 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:42425 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752037AbZIJHn1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Sep 2009 03:43:27 -0400
Date: Thu, 10 Sep 2009 09:43:23 +0200
From: Ingo Molnar <mingo@elte.hu>
To: linux-kernel@vger.kernel.org
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Mike Galbraith <efault@gmx.de>,
       Con Kolivas <kernel@kolivas.org>
Subject: [updated] BFS vs. mainline scheduler benchmarks and measurements
Message-ID: <20090910074323.GA21751@elte.hu>
References: <20090906205952.GA6516@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090906205952.GA6516@elte.hu>
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


* Ingo Molnar <mingo@elte.hu> wrote:

>   OLTP performance (postgresql + sysbench)
>      http://redhat.com/~mingo/misc/bfs-vs-tip-oltp.jpg

To everyone who might care about this, i've updated the sysbench 
results to latest -tip:

    http://redhat.com/~mingo/misc/bfs-vs-tip-oltp-v2.jpg

This double checks the effects of the various interactivity fixlets 
in the scheduler tree (whose interactivity effects 
mentioned/documented in the various threads on lkml) in the 
throughput space too and they also improved sysbench performance.

Con, i'd also like to thank you for raising general interest in 
scheduler latencies once more by posting the BFS patch. It gave us 
more bugreports upstream and gave us desktop users willing to test 
patches which in turn helps us improve the code. When users choose 
to suffer in silence that is never helpful.

BFS isnt particularly strong in this graph - from having looked at 
the workload under BFS my impression was that this is primarily due 
to you having cut out much of the sched-domains SMP load-balancer 
code. BFS 'insta-balances' very agressively, which hurts cache 
affine workloads rather visibly.

You might want to have a look at that design detail if you care - 
load-balancing is in significant parts orthogonal to the basic 
design of a fair scheduler.

For example we kept much of the existing load-balancer when we went 
to CFS in v2.6.23 - the fairness engine and the load-balancer are in 
large parts independent units of code and can be improved/tweaked 
separately.

There's interactions, but the concepts are largely separate.

Thanks,

	Ingo
