Return-Path: <linux-kernel-owner+w=401wt.eu-S933043AbZIDHGx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933043AbZIDHGx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 03:06:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933177AbZIDHGt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 03:06:49 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:59037 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932994AbZIDHGq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 03:06:46 -0400
Date: Fri, 4 Sep 2009 09:06:33 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Cc: David Miller <davem@davemloft.net>, rostedt@goodmis.org,
       nhorman@tuxdriver.com, fweisbec@gmail.com, yjwei@cn.fujitsu.com,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH resend] tracing/events: convert NAPI's tracepoint via
	TRACE_EVENT
Message-ID: <20090904070633.GF29829@elte.hu>
References: <4A9B6AA7.5020508@cn.fujitsu.com> <20090831084922.GB25811@elte.hu> <alpine.DEB.2.00.0908311407060.13931@gandalf.stny.rr.com> <20090901.182645.153420711.davem@davemloft.net> <4A9DE293.6050703@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A9DE293.6050703@cn.fujitsu.com>
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


* Xiao Guangrong <xiaoguangrong@cn.fujitsu.com> wrote:

> David Miller wrote:
> 
> > This patch can't be split up, so I'm wondering how you suggest to
> > handle this patch given that you have declared that define_trace.h
> > changes aren't to go through the subsystem tree?
> > 
> > If we do the define_trace.h change only, we break the build
> > (lack of macro defined for the trace).
> > 
> > If we do only the other parts of his patch, we get a duplicate
> > definition.
> > 
> 
> This patch cooperate with my previous patch to solve the include 
> file dependencies problem. So, we do better put those two patches 
> together. (both in -tip tree or/add both in network tree)

I would not mind a duplicate commit here. Whoever merges later in 
the merge window will resolve the (easy) conflict.

David, you definitely dont want to pull the full tracing tree into 
the networking tree. It wouldnt cause technical problems in 
linux-next (Git sorts out such merges just fine and both trees are 
well tested) but it creates an unwanted merge window dependency: if 
the tracing tree's push to Linus is delayed for whatever reason the 
networking tree is delayed too. That's not really good.

It's also not good on a conceptual angle - it makes it very 
difficult for Linus to reject any of the trees, due to the mingling.

A second variant would be that we could create a mini-topic (.31-rc8 
based) in -tip with just the skb bits and the header file changes 
and once we've tested it we could push it and you could pull that 
(small, -git based) tree into the networking tree.

A third variant would be that you could do such a mini-topic branch 
yourself in the networking tree and we could pull that into the 
tracing tree.

All of these variants work fine with Steve's and my workload, it's 
up to you and Neil - you are driving the changes so do whatever is 
most convenient to you.

	Ingo
