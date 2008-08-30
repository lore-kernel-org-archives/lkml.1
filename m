Return-Path: <linux-kernel-owner+w=401wt.eu-S1753418AbYH3OKU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753418AbYH3OKU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Aug 2008 10:10:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751018AbYH3OKH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Aug 2008 10:10:07 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:45453 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750808AbYH3OKF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Aug 2008 10:10:05 -0400
Date: Sat, 30 Aug 2008 07:10:01 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, cl@linux-foundation.org, mingo@elte.hu,
       akpm@linux-foundation.org, manfred@colorfullife.com,
       dipankar@in.ibm.com, josht@linux.vnet.ibm.com, schamp@sgi.com,
       niv@us.ibm.com, dvhltc@us.ibm.com, ego@in.ibm.com, laijs@cn.fujitsu.com,
       rostedt@goodmis.org, Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Subject: Re: [PATCH, RFC, tip/core/rcu] v3 scalable classic RCU
	implementation
Message-ID: <20080830141001.GD7107@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20080821234318.GA1754@linux.vnet.ibm.com> <20080825000738.GA24339@linux.vnet.ibm.com> <20080830004935.GA28548@linux.vnet.ibm.com> <1220088780.8426.1.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1220088780.8426.1.camel@twins>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 30, 2008 at 11:33:00AM +0200, Peter Zijlstra wrote:
> On Fri, 2008-08-29 at 17:49 -0700, Paul E. McKenney wrote:
> 
> > Some shortcomings:
> > 
> > o	Entering and leaving dynticks idle mode is a quiescent state,
> > 	but the current patch doesn't take advantage of this (noted
> > 	by Manfred).  It appears that it should be possible to make
> > 	nmi_enter() and nmi_exit() provide an in_nmi(), which would make
> > 	it possible for rcu_irq_enter() and rcu_irq_exit() to figure
> > 	out whether it is safe to tell RCU about the quiescent state --
> > 	and also greatly simplify the code.
> 
> Already done and available in the -tip tree, curtesy of Mathieu.

Very cool!!!  I see one of his patches at http://lkml.org/lkml/2008/4/17/342,
but how do I find out which branch of -tip this is on?  (I am learning
git, but it is a slow process...)

This would also simplify preemptable RCU's dyntick interface, removing
the need for proofs.

							Thanx, Paul
