Return-Path: <linux-kernel-owner+w=401wt.eu-S1752874Ab0A0FUz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752874Ab0A0FUz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jan 2010 00:20:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751254Ab0A0FUy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jan 2010 00:20:54 -0500
Received: from e1.ny.us.ibm.com ([32.97.182.141]:44111 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750966Ab0A0FUy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jan 2010 00:20:54 -0500
Date: Tue, 26 Jan 2010 21:20:50 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
       dipankar@in.ibm.com, akpm@linux-foundation.org,
       mathieu.desnoyers@polymtl.ca, josh@joshtriplett.org, dvhltc@us.ibm.com,
       niv@us.ibm.com, tglx@linutronix.de, peterz@infradead.org,
       rostedt@goodmis.org, Valdis.Kletnieks@vt.edu, dhowells@redhat.com
Subject: Re: [PATCH RFC tip/core/rcu] accelerate grace period if last
	non-dynticked CPU
Message-ID: <20100127052050.GC6807@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20100125034816.GA14043@linux.vnet.ibm.com> <873a1sft9q.fsf@basil.nowhere.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <873a1sft9q.fsf@basil.nowhere.org>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 26, 2010 at 10:30:57PM +0100, Andi Kleen wrote:
> "Paul E. McKenney" <paulmck@linux.vnet.ibm.com> writes:
> 
> Kind of offtopic to the original patch, but I couldn't 
> resist...
> 
> > +config RCU_FAST_NO_HZ
> > +	bool "Accelerate last non-dyntick-idle CPU's grace periods"
> > +	depends on TREE_RCU && NO_HZ && SMP
> 
> Having such a thing as a config option doesn't really make 
> any sense to me. Who would want to recompile their kernel
> to enable/disable this? If anything it should be runtime, or better
> just unconditionally on.

It adds significant overhead on entry to dyntick-idle mode for systems
with large numbers of CPUs.  :-(

> In general RCU could probably reduce its number of "weird"
> Kconfig options.
> 
> While I think I have a better understanding of RCU than a lot
> of normal users I often have no clue what to set there when
> building a kernel.

One approach would be to make it be default for small numbers of CPUs
(as in systems likely to be battery powered) but not for large numbers
of CPUs.  The reason I didn't do this initially is that a server-class
four-CPU system would have no need for this, but a four-core cellphone
most definitely would.  So I just created another config variable.

In any case, I do agree with your point about reducing the number of
config variables.

							Thanx, Paul
