Return-Path: <linux-kernel-owner+w=401wt.eu-S1752488AbZIHXhc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752488AbZIHXhc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Sep 2009 19:37:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752255AbZIHXhc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Sep 2009 19:37:32 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:49668 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752187AbZIHXhb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Sep 2009 19:37:31 -0400
Subject: Re: [PATCH tip/core/rcu 0/3] increase rcutorture intensity and fix
 a couple resulting bugs
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: paulmck@linux.vnet.ibm.com
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
       dipankar@in.ibm.com, akpm@linux-foundation.org,
       mathieu.desnoyers@polymtl.ca, josht@linux.vnet.ibm.com,
       dvhltc@us.ibm.com, niv@us.ibm.com, tglx@linutronix.de,
       peterz@infradead.org
In-Reply-To: <20090908225349.GA19524@linux.vnet.ibm.com>
References: <20090908225349.GA19524@linux.vnet.ibm.com>
Content-Type: text/plain
Organization: Kihon Technologies Inc.
Date: Tue, 08 Sep 2009 19:37:30 -0400
Message-Id: <1252453051.20985.9.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-09-08 at 15:53 -0700, Paul E. McKenney wrote:
> This patch series increases the intensity of rcutorture testing for
> TREE_PREEMPT_RCU and provides fixes for a couple resulting bugs.
> 
> o	Make rcutorture's RCU read-side critical sections occasionally
> 	spin for a few tens of milliseconds, which greatly increases
> 	the probability that they will be preempted and that quiescent
> 	states will be forced.  Yes, this does uncover some bugs in
> 	TREE_PREEMPT_RCU (though TREE_RCU passes with flying colors).
> 
> o	Fix a bug where rnp->gpnum was not being updated.  This
> 	increases TREE_PREEMPT_RCU's reliability considerably, though
> 	bugs still remain.
> 
> o	Make the initialization of multi-node trees of rcu_node
> 	structures unconditionally acquire rnp->lock.  This simplifies
> 	the code a bit and will make it easier to allow grace-period
> 	initialization become preemptable, should this be needed.
> 
> Next steps include applying review comments, adding expedited grace
> periods, and chasing down remaining bugs.  Longer term, RCU priority
> boosting.

Hi Paul,

These patches look decent to me.

If it makes you feel comfy:

Acked-by: Steven Rostedt <rostedt@goodmis.org>

-- Steve


