Return-Path: <linux-kernel-owner+w=401wt.eu-S1753328AbZJNAiR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753328AbZJNAiR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 20:38:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751796AbZJNAiR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 20:38:17 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:58578 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751719AbZJNAiQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 20:38:16 -0400
Message-ID: <4AD51D3E.60103@cn.fujitsu.com>
Date: Wed, 14 Oct 2009 08:37:18 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: paulmck@linux.vnet.ibm.com
CC: linux-kernel@vger.kernel.org, mingo@elte.hu, dipankar@in.ibm.com,
       akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
       josh@joshtriplett.org, dvhltc@us.ibm.com, niv@us.ibm.com,
       tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
       Valdis.Kletnieks@vt.edu, dhowells@redhat.com, avi@redhat.com,
       mtosatti@redhat.com, torvalds@linux-foundation.org
Subject: Re: [PATCH RFC tip/core/rcu 1/3] rcu: The Bloatwatch Edition, v7
References: <20091009224954.GA26516@linux.vnet.ibm.com> <4AD42FF5.2080109@cn.fujitsu.com> <20091013170022.GA6782@linux.vnet.ibm.com>
In-Reply-To: <20091013170022.GA6782@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul E. McKenney wrote:
>> It's an old issue.
>> It's not only about RCUTINY, it's also about other rcu implementations:
>>
>> rcu_enter_nohz()/rcu_exit_nohz() are not called in pairs.
>>
>> irq_exit() calls tick_nohz_stop_sched_tick() which calls rcu_enter_nohz(),
>> where is the corresponding rcu_exit_nohz()?
>> (or tick_nohz_restart_sched_tick())?
> 
> The tick_nohz_restart_sched_tick() function is called from the various
> per-architecture cpu_idle() functions (or default_idle() or whatever
> name that the architecture uses).  For example, in:
> 
> 	arch/x86/kernel/process_64.c
> 
> the cpu_idle() function invokes tick_nohz_restart_sched_tick() just
> before invoking schedule() to exit the idle loop.
> 
> And, as you say, tick_nohz_restart_sched_tick() invokes rcu_exit_nohz().
> 
> 							Thanx, Paul
> 
> 

These tick_nohz_restart_sched_tick() which are called from the various
per-architecture cpu_idle() functions are not the opposite of
the tick_nohz_stop_sched_tick() in *irq_exit()*. So I figure that 
rcu_enter_nohz()/rcu_exit_nohz() are not called in pairs.
