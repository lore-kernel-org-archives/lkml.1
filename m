Return-Path: <linux-kernel-owner+w=401wt.eu-S1753465AbYADNs5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753465AbYADNs5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2008 08:48:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752230AbYADNst
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jan 2008 08:48:49 -0500
Received: from ms-smtp-01.nyroc.rr.com ([24.24.2.55]:60623 "EHLO
	ms-smtp-01.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751015AbYADNss (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2008 08:48:48 -0500
Date: Fri, 4 Jan 2008 08:48:03 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Gautham R Shenoy <ego@in.ibm.com>
cc: Paul E McKenney <paulmck@us.ibm.com>,
       "K. Prasad" <prasad@linux.vnet.ibm.com>, mingo@elte.hu,
       linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org,
       dipankar@in.ibm.com, Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Subject: Re: __get_cpu_var() called from a preempt-unsafe context in
 __rcu_preempt_unboost() ?
In-Reply-To: <20080104120905.GA15640@in.ibm.com>
Message-ID: <Pine.LNX.4.58.0801040846360.16657@gandalf.stny.rr.com>
References: <20071231060911.GB6461@in.ibm.com> <20080103163055.GB27651@Krystal>
 <20080104120905.GA15640@in.ibm.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 4 Jan 2008, Gautham R Shenoy wrote:
> 		|
> 		|--> rcu_trace_boost_unboost_called(RCU_BOOST_ME)
>
>
> where RCU_BOOST_ME is #defined as &__get_cpu_var(rcu_boost_data).
>
> Is calling __get_cpu_var() safe in this context, since we've already
> enabled the local interrupts and we're not in a preempt_disabled() ?

Probably not, but the worst that can happen is that we corrupt the trace
counter, and miss an increment.  I'll see if I can fix that, but it should
be quite harmless wrt the stability of the system.

Thanks for pointing that out.

-- Steve
