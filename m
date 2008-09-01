Return-Path: <linux-kernel-owner+w=401wt.eu-S1757230AbYIAJij@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757230AbYIAJij (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2008 05:38:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751731AbYIAJib
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Sep 2008 05:38:31 -0400
Received: from one.firstfloor.org ([213.235.205.2]:38024 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751657AbYIAJia (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2008 05:38:30 -0400
To: paulmck@linux.vnet.ibm.com
Cc: linux-kernel@vger.kernel.org, cl@linux-foundation.org, mingo@elte.hu,
       akpm@linux-foundation.org, manfred@colorfullife.com,
       dipankar@in.ibm.com, josht@linux.vnet.ibm.com, schamp@sgi.com,
       niv@us.ibm.com, dvhltc@us.ibm.com, ego@in.ibm.com, laijs@cn.fujitsu.com,
       rostedt@goodmis.org, peterz@infradead.org
Subject: Re: [PATCH, RFC, tip/core/rcu] v3 scalable classic RCU implementation
From: Andi Kleen <andi@firstfloor.org>
References: <20080821234318.GA1754@linux.vnet.ibm.com>
	<20080825000738.GA24339@linux.vnet.ibm.com>
	<20080830004935.GA28548@linux.vnet.ibm.com>
Date: Mon, 01 Sep 2008 11:38:29 +0200
In-Reply-To: <20080830004935.GA28548@linux.vnet.ibm.com> (Paul E. McKenney's message of "Fri, 29 Aug 2008 17:49:35 -0700")
Message-ID: <87ej44xl2i.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Paul E. McKenney" <paulmck@linux.vnet.ibm.com> writes:
>  
> -#if defined(CONFIG_PREEMPT_RCU) && defined(CONFIG_NO_HZ)
> +#if defined(CONFIG_NO_HZ)
>  extern void rcu_irq_enter(void);
>  extern void rcu_irq_exit(void);
>  #else
>  # define rcu_irq_enter() do { } while (0)
>  # define rcu_irq_exit() do { } while (0)
> -#endif /* CONFIG_PREEMPT_RCU */
> +#endif /* #if defined(CONFIG_NO_HZ) */

It would be better if you hung rcu_irq_enter in the irq_enter() if 
statement that checks if the task was idle or not. This way it would
be zero overhead for interruptions of non busy CPUs, keeping 
it out of many fast paths.

Haven't read everything, sorry.

-Andi
