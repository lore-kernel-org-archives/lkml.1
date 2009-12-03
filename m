Return-Path: <linux-kernel-owner+w=401wt.eu-S1752044AbZLCJ1T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752044AbZLCJ1T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Dec 2009 04:27:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751591AbZLCJ1S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Dec 2009 04:27:18 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:56722 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751053AbZLCJ1R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Dec 2009 04:27:17 -0500
Message-ID: <4B178440.5020701@cn.fujitsu.com>
Date: Thu, 03 Dec 2009 17:26:24 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
CC: linux-kernel@vger.kernel.org, mingo@elte.hu, dipankar@in.ibm.com,
       akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
       josh@joshtriplett.org, dvhltc@us.ibm.com, niv@us.ibm.com,
       tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
       Valdis.Kletnieks@vt.edu, dhowells@redhat.com
Subject: Re: [PATCH tip/core/rcu 3/4] rcu: add expedited grace-period support
 for preemptible RCU
References: <20091202200955.GA12950@linux.vnet.ibm.com> <1259784616158-git-send-email->
In-Reply-To: <1259784616158-git-send-email->
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul E. McKenney wrote:
> From: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> 
> Implement an synchronize_rcu_expedited() for preemptible RCU that actually
> is expedited.  This uses synchronize_sched_expedited() to force all
> threads currently running in a preemptible-RCU read-side critical section
> onto the appropriate ->blocked_tasks[] list, then takes a snapshot of
> all of these lists and waits for them to drain.
> 

> 3.	Add an implementation of synchronize_rcu_expedited() that
> 	actually expedites preemptible-RCU grace periods.

It's very nice.

But I don't understand all things.

1) Why it can be speeded up (in theory)?
synchronize_sched_expedited() does speed up, it is due to
migration_threads are the most highest priority threads.

But for synchronize_rcu_expedited(), some preempted tasks in ->blocked_tasks[]
may be waiting at runqueue for long long time because some other
higher priority threads comes.

simply comparison:
synchronize_sched_expedited()
==> wake_up_process(rq->migration_thread) to force schedule on cpus.
	which forces read-sides notify the end earlier,
	or we can say "it forces read-sides run to end faster"

synchronize_rcu_expedited()
==> Nothing to force preempted read-site run to end faster.

2) Why we introduce a API which no one use it.
I remember that Net guys request a expedited synchronize_rcu().
but currently there is still no one use it.


Beware my thinking may be wrong!
Thanks, Lai
