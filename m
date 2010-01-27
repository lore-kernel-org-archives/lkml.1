Return-Path: <linux-kernel-owner+w=401wt.eu-S1753992Ab0A0Jvt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753992Ab0A0Jvt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jan 2010 04:51:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753820Ab0A0Jvt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jan 2010 04:51:49 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:44265 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753249Ab0A0Jvs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jan 2010 04:51:48 -0500
Subject: Re: [PATCH RFC tip/core/rcu] accelerate grace period if last
 non-dynticked CPU
From: Peter Zijlstra <peterz@infradead.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
       dipankar@in.ibm.com, akpm@linux-foundation.org,
       mathieu.desnoyers@polymtl.ca, josh@joshtriplett.org, dvhltc@us.ibm.com,
       niv@us.ibm.com, tglx@linutronix.de, rostedt@goodmis.org,
       Valdis.Kletnieks@vt.edu, dhowells@redhat.com
In-Reply-To: <20100127094336.GA12522@basil.fritz.box>
References: <20100125034816.GA14043@linux.vnet.ibm.com>
	 <873a1sft9q.fsf@basil.nowhere.org>
	 <20100127052050.GC6807@linux.vnet.ibm.com>
	 <20100127094336.GA12522@basil.fritz.box>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 27 Jan 2010 10:50:50 +0100
Message-ID: <1264585850.4283.1992.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-01-27 at 10:43 +0100, Andi Kleen wrote:
> 
> Can't you simply check that at runtime then?
> 
> if (num_possible_cpus() > 20) 
>         ...
> 
> BTW the new small is large. This years high end desktop PC will come with 
> upto 12 CPU threads. It would likely be challenging to find a good
> number for 20 that holds up with the future. 

If only scalability were that easy :/

These massive core/thread count things are causing more problems as
well, the cpus/node ratios are constantly growing, giving grief in the
page allocator as well as other places that used to scale per node.

As to the current problem, the call_rcu() interface doesn't make a hard
promise that the callback will be done on the same cpu, right? So why
not simply move the callback list over to a more active cpu?

