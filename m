Return-Path: <linux-kernel-owner+w=401wt.eu-S1760944AbYHHVfe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760944AbYHHVfe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2008 17:35:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756358AbYHHVf1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Aug 2008 17:35:27 -0400
Received: from one.firstfloor.org ([213.235.205.2]:53942 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756076AbYHHVf0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2008 17:35:26 -0400
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, mingo@elte.hu,
       tglx@linutronix.de, marcin.slusarz@gmail.com,
       linux-kernel@vger.kernel.org, David Miller <davem@davemloft.net>,
       Steven Rostedt <rostedt@goodmis.org>,
       Paul E McKenney <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH] printk: robustify printk
From: Andi Kleen <andi@firstfloor.org>
References: <20080324122424.671168000@chello.nl>
	<alpine.LFD.1.00.0803241021350.17905@woody.linux-foundation.org>
	<1206382547.6437.131.camel@lappy>
	<20080324115738.85c72bb5.akpm@linux-foundation.org>
	<1218202249.8625.106.camel@twins>
	<alpine.LFD.1.10.0808080931550.3462@nehalem.linux-foundation.org>
	<1218215454.8625.133.camel@twins>
	<alpine.LFD.1.10.0808081014240.3462@nehalem.linux-foundation.org>
	<1218217257.29098.2.camel@lappy.programming.kicks-ass.net>
	<alpine.LFD.1.10.0808081043160.3462@nehalem.linux-foundation.org>
	<1218219269.29098.5.camel@lappy.programming.kicks-ass.net>
Date: Fri, 08 Aug 2008 23:35:20 +0200
In-Reply-To: <1218219269.29098.5.camel@lappy.programming.kicks-ass.net> (Peter Zijlstra's message of "Fri, 08 Aug 2008 20:14:28 +0200")
Message-ID: <8763qb42cn.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra <a.p.zijlstra@chello.nl> writes:

Hopefully nobody puts a printk into call_rcu now...
Also I'm not sure if there wouldn't be livelocks if someone puts
printk into some other parts of RCU (e.g. each RCU adding more
RCU events -- haven't checked that in detail so I might be wrong)

So you just trade one "hands off" part to another.


> +	kws = &__get_cpu_var(kws);
> +	if (!kws->pending) {
> +		kws->pending = 1;
> +		call_rcu(&kws->head, __wake_up_klogd);


How about a big comment describing why you do this?
And you should add comments to all the new hands-off parts
where printk is not allowed now.

-Andi
