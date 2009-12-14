Return-Path: <linux-kernel-owner+w=401wt.eu-S933122AbZLNWSd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933122AbZLNWSd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 17:18:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932908AbZLNWSc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 17:18:32 -0500
Received: from casper.infradead.org ([85.118.1.10]:34319 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932814AbZLNWSa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 17:18:30 -0500
Subject: Re: [patch 1/2] sched: Change the nohz ilb logic from pull to push
 model
From: Peter Zijlstra <peterz@infradead.org>
To: venkatesh.pallipadi@intel.com
Cc: Gautham R Shenoy <ego@in.ibm.com>,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org,
       Suresh Siddha <suresh.b.siddha@intel.com>
In-Reply-To: <20091211013056.305998000@intel.com>
References: <20091211012748.267627000@intel.com>
	 <20091211013056.305998000@intel.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 14 Dec 2009 23:18:12 +0100
Message-ID: <1260829092.8023.115.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-12-10 at 17:27 -0800, venkatesh.pallipadi@intel.com wrote:
> +/*
> + * idle load balancing details
> + * - One of the idle CPUs nominates itself as idle load_balancer, while
> + *   entering idle.
> + * - With previous logic, this idle load balancer CPU will not go into
> + *   tickless mode when it is idle and does the idle load balancing for
> + *   all the idle CPUs.
> + * - With new logic, this idle load balancer CPU will also go into
> + *   tickless mode when it is idle, just like all other idle CPUs
> + * - When one of the busy CPUs notice that there may be an idle rebalancing
> + *   needed, they will kick the idle load balancer, which then does idle
> + *   load balancing for all the idle CPUs.
> + * - As idle load balancing looks at the load of all the CPUs, not all busy
> + *   CPUs need to do this idle load balancer kick.
> + * - first_pick_cpu is the one of the busy CPUs which will kick
> + *   idle load balancer when it has more than one process active. This
> + *   eliminates the need for idle load balancing altogether when we have
> + *   only one running process in the system (common case).
> + * - If there are more than one busy CPU, idle load balancer may have
> + *   to run for active_load_balance to happen (i.e., two busy CPUs are
> + *   SMT or core siblings and can run better if they move to different
> + *   physical CPUs). So, second_pick_cpu is the second of the busy CPUs
> + *   which will kick idle load balancer as soon as it has any load.
> + * - With previous logic, idle load balancer used to run at every tick.
> + *   With new logic, idle load balancer tracks the rq->next_balance for all
> + *   the idle CPUs and does idle load balancing only when needed.
> + */ 

This isn't a very helpful comment for someone trying to understand the
current code who has never seen the previous bits.

Only describe the new behaviour, there is no point in describing
something that is not longer relevant.

