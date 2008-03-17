Return-Path: <linux-kernel-owner+w=401wt.eu-S1754094AbYCQS0L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754094AbYCQS0L (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2008 14:26:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752420AbYCQS0A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Mar 2008 14:26:00 -0400
Received: from x346.tv-sign.ru ([89.108.83.215]:34489 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752434AbYCQSZ7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2008 14:25:59 -0400
Date: Mon, 17 Mar 2008 21:30:47 +0300
From: Oleg Nesterov <oleg@tv-sign.ru>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, rostedt@goodmis.org,
       linux-rt-users@vger.kernel.org, mingo@elte.hu, ego@in.ibm.com,
       dipankar@in.ibm.com, tytso@us.ibm.com, dvhltc@us.ibm.com,
       akpm@linux-foundation.org, josh@freedesktop.org, tglx@linutronix.de,
       niv@us.ibm.com
Subject: Re: [PATCH] fix misplaced mb() in rcu_enter/exit_nohz()
Message-ID: <20080317183047.GA188@tv-sign.ru>
References: <20080317010821.GA29875@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080317010821.GA29875@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/16, Paul E. McKenney wrote:
> 
> In the process of writing up the mechanical proof of correctness for the
> dynticks/preemptable-RCU interface, I noticed misplaced memory barriers
> in rcu_enter_nohz() and rcu_exit_nohz().

Can't comment this patch, there is no rcu_enter_nohz() in my rcupreempt.h ;)

I'm not sure the code below is up to date, but what I have in
arch/s390/kernel/time.c is:

	stop_hz_timer:

		cpu_set(cpu, nohz_cpu_mask);
		
		if (rcu_needs_cpu(cpu) || local_softirq_pending()) {
			cpu_clear(cpu, nohz_cpu_mask);
			return;
		}

Don't we need smp_mb() after cpu_set() ?

Oleg.

