Return-Path: <linux-kernel-owner+w=401wt.eu-S1753611Ab0A0FVj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753611Ab0A0FVj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jan 2010 00:21:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750991Ab0A0FVh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jan 2010 00:21:37 -0500
Received: from e9.ny.us.ibm.com ([32.97.182.139]:46493 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750870Ab0A0FVh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jan 2010 00:21:37 -0500
Date: Tue, 26 Jan 2010 21:21:33 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
       akpm@linux-foundation.org, josh@joshtriplett.org, dvhltc@us.ibm.com,
       niv@us.ibm.com, tglx@linutronix.de, peterz@infradead.org,
       rostedt@goodmis.org, Valdis.Kletnieks@vt.edu, dhowells@redhat.com
Subject: Re: [PATCH RFC tip/core/rcu] accelerate grace period if last
	non-dynticked CPU
Message-ID: <20100127052133.GD6807@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20100125034816.GA14043@linux.vnet.ibm.com> <873a1sft9q.fsf@basil.nowhere.org> <20100126235516.GA15855@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100126235516.GA15855@Krystal>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 26, 2010 at 06:55:16PM -0500, Mathieu Desnoyers wrote:
> * Andi Kleen (andi@firstfloor.org) wrote:
> > "Paul E. McKenney" <paulmck@linux.vnet.ibm.com> writes:
> > 
> > Kind of offtopic to the original patch, but I couldn't 
> > resist...
> > 
> > > +config RCU_FAST_NO_HZ
> > > +	bool "Accelerate last non-dyntick-idle CPU's grace periods"
> > > +	depends on TREE_RCU && NO_HZ && SMP
> > 
> > Having such a thing as a config option doesn't really make 
> > any sense to me. Who would want to recompile their kernel
> > to enable/disable this? If anything it should be runtime, or better
> > just unconditionally on.
> > 
> > In general RCU could probably reduce its number of "weird"
> > Kconfig options.
> > 
> > While I think I have a better understanding of RCU than a lot
> > of normal users I often have no clue what to set there when
> > building a kernel.
> 
> Maybe we could keep them under a CONFIG_DEBUG_RCU umbrella. Compiling
> out parts of the rcu options can be useful for debugging purposes, but
> I agree with you that end users should not be bothered with that much
> options when some of them are "obviously" wanted.
> 
> OTOH, I understand that Paul seems to want to introduce new RCU
> features gradually, without hitting all kernel users with bugs in newer
> features. That's a sane approach to keep things generally stable, but
> maybe it is time to set some of the stabilized RCU options to default Y
> and move their config to the debug menu.

That is indeed a big part of the motivation.  ;-)

							Thanx, Paul

> Let's see what Paul has to say about this...
> 
> Thanks,
> 
> Mathieu
> 
> > 
> > -Andi
> > 
> > -- 
> > ak@linux.intel.com -- Speaking for myself only.
> 
> -- 
> Mathieu Desnoyers
> OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
