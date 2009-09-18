Return-Path: <linux-kernel-owner+w=401wt.eu-S1754196AbZIRQ6L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754196AbZIRQ6L (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Sep 2009 12:58:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751794AbZIRQ6K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Sep 2009 12:58:10 -0400
Received: from fifo99.com ([67.223.236.141]:42826 "EHLO fifo99.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751879AbZIRQ6K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Sep 2009 12:58:10 -0400
Subject: Re: [PATCH tip/core/rcu 2/3] Apply results of code inspection of
 kernel/rcutree_plugin.h
From: Daniel Walker <dwalker@fifo99.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
       dipankar@in.ibm.com, akpm@linux-foundation.org,
       mathieu.desnoyers@polymtl.ca, josh@joshtriplett.org, dvhltc@us.ibm.com,
       niv@us.ibm.com, tglx@linutronix.de, peterz@infradead.org,
       rostedt@goodmis.org, Valdis.Kletnieks@vt.edu
In-Reply-To: <12532926201851-git-send-email->
References: <20090918164955.GA22272@linux.vnet.ibm.com>
	 <12532926201851-git-send-email->
Content-Type: text/plain
Date: Fri, 18 Sep 2009 09:58:20 -0700
Message-Id: <1253293100.7060.46.camel@desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-09-18 at 09:50 -0700, Paul E. McKenney wrote:

> diff --git a/kernel/rcutree_plugin.h b/kernel/rcutree_plugin.h
> index 2b996c3..a2d586c 100644
> --- a/kernel/rcutree_plugin.h
> +++ b/kernel/rcutree_plugin.h
> @@ -117,9 +117,9 @@ static void rcu_preempt_note_context_switch(int cpu)
>  		 * on line!
>  		 */
>  	    	WARN_ON_ONCE((rdp->grpmask & rnp->qsmaskinit) == 0);
> -		phase = !(rnp->qsmask & rdp->grpmask) ^ (rnp->gpnum & 0x1);
> +	    	WARN_ON_ONCE(!list_empty(&t->rcu_node_entry));
> +		phase = (rnp->gpnum + !(rnp->qsmask & rdp->grpmask)) & 0x1;
>  		list_add(&t->rcu_node_entry, &rnp->blocked_tasks[phase]);
> -		smp_mb();  /* Ensure later ctxt swtch seen after above. */
>  		spin_unlock_irqrestore(&rnp->lock, flags);
>  	}

ERROR: code indent should use tabs where possible
#149: FILE: kernel/rcutree_plugin.h:120:
+^I    ^IWARN_ON_ONCE(!list_empty(&t->rcu_node_entry));$


One funny indent in the line above.. If your intending for Ingo to take
this he might just fix it on apply ..

Daniel

