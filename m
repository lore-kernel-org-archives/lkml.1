Return-Path: <linux-kernel-owner+w=401wt.eu-S1755160AbYLNXOR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755160AbYLNXOR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Dec 2008 18:14:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751687AbYLNXOD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Dec 2008 18:14:03 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:50704 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751589AbYLNXOB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Dec 2008 18:14:01 -0500
Date: Mon, 15 Dec 2008 00:13:32 +0100
From: Ingo Molnar <mingo@elte.hu>
To: eranian@gmail.com
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Vince Weaver <vince@deater.net>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Eric Dumazet <dada1@cosmosbay.com>,
       Robert Richter <robert.richter@amd.com>,
       Arjan van de Veen <arjan@infradead.org>, Peter Anvin <hpa@zytor.com>,
       Paul Mackerras <paulus@samba.org>,
       "David S. Miller" <davem@davemloft.net>
Subject: Re: [patch] Performance Counters for Linux, v3
Message-ID: <20081214231332.GA26942@elte.hu>
References: <20081211155230.GA4230@elte.hu> <Pine.LNX.4.64.0812111247510.22556@pianoman.cluster.toy> <1229070345.12883.12.camel@twins> <7c86c4470812120059s7f8e64a6h91ebeadbf938858d@mail.gmail.com> <1229073834.12883.41.camel@twins> <7c86c4470812120942x607a74f7w9f823adecbd73b85@mail.gmail.com> <7c86c4470812121001i765d663bq6db3080b633a1eef@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7c86c4470812121001i765d663bq6db3080b633a1eef@mail.gmail.com>
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


* stephane eranian <eranian@googlemail.com> wrote:

> Hi,
> 
> Given the level of abstractions you are using for the API, and given 
> your argument that the kernel can do the HW resource scheduling better 
> than anybody else.
> 
> What happens in the following test case:
> 
>    - 2-way system (cpu0, cpu1)
> 
>    - on cpu0, two processes P1, P2, each self-monitoring and counting event E1.
>      Event E1 can only be measured on counter C1.
> 
>    - on cpu1, there is a cpu-wide session, monitoring event E1, thus using C1
> 
>    - the scheduler decides to migrate P1 onto CPU1. You now have a
>      conflict on C1.
> 
> How is this managed?

If there's a single unit of sharable resource [such as an event counter, 
or a physical CPU], then there's just three main possibilities: either 
user 1 gets it all, or user 2 gets it all, or they share it.

We've implemented the essence of these variants, with sharing the resource 
being the sane default, and with the sysadmin also having a configuration 
vector to reserve the resource to himself permanently. (There could be 
more variations of this.)

What is your point?

	Ingo
