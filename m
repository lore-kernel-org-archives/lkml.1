Return-Path: <linux-kernel-owner+w=401wt.eu-S1753966AbYJ0TqK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753966AbYJ0TqK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2008 15:46:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752269AbYJ0Tp4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Oct 2008 15:45:56 -0400
Received: from nf-out-0910.google.com ([64.233.182.185]:5501 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751889AbYJ0Tpz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2008 15:45:55 -0400
Message-ID: <49061AF0.8070106@colorfullife.com>
Date: Mon, 27 Oct 2008 20:48:00 +0100
From: Manfred Spraul <manfred@colorfullife.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: paulmck@linux.vnet.ibm.com
CC: linux-kernel@vger.kernel.org, cl@linux-foundation.org, mingo@elte.hu,
       akpm@linux-foundation.org, dipankar@in.ibm.com,
       josht@linux.vnet.ibm.com, schamp@sgi.com, niv@us.ibm.com,
       dvhltc@us.ibm.com, ego@in.ibm.com, laijs@cn.fujitsu.com,
       rostedt@goodmis.org, peterz@infradead.org, penberg@cs.helsinki.fi,
       andi@firstfloor.org, tglx@linutronix.de
Subject: Re: [PATCH, RFC] v7 scalable classic RCU implementation
References: <20081010160930.GA9777@linux.vnet.ibm.com> <48F21D58.3000404@colorfullife.com> <20081012224629.GA7353@linux.vnet.ibm.com> <48F38D73.8040804@colorfullife.com> <20081015011143.GE6874@linux.vnet.ibm.com> <48F5A638.8020003@colorfullife.com> <20081015152637.GA6739@linux.vnet.ibm.com> <48FF73C7.90709@colorfullife.com> <20081022210254.GE6766@linux.vnet.ibm.com> <48FF9A0E.90205@colorfullife.com> <20081027164529.GC6783@linux.vnet.ibm.com>
In-Reply-To: <20081027164529.GC6783@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul E. McKenney wrote:
> Agreed.  Perhaps a good change to make while introducing stall detection
> to preemptable RCU -- there would then be three examples, which should
> allow good generalization.
>   
Two implementations. IMHO the current rcu-classic code should be dropped 
immediately when you add rcu-tree:
rcu-classic is buggy, as far as I can see long-running interrupts on 
nohz cpus are not handled correctly. I don't think it makes sense to 
keep it in the kernel in parallel to rcu-tree.

I would propose that rcu-tree replaces rcu-classic.
I'll continue to update rcu-state, I think that it will achieve lower 
latency than rcu-tree [average/max time between call_rcu() and 
destruction callback] and it doesn't have the irq disabled loop to find 
the missing cpus.
If I find decent benchmarks where I can quantify the advantages, then 
I'll propose to merge rcu-state as a third implementation in addition to 
rcu-tree and rcu-preempt.

Paul: What do you think?

--
    Manfred


