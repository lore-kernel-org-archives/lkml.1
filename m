Return-Path: <linux-kernel-owner+w=401wt.eu-S1755022AbZHYQML@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755022AbZHYQML (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Aug 2009 12:12:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754887AbZHYQML
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Aug 2009 12:12:11 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:43833 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750873AbZHYQMK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Aug 2009 12:12:10 -0400
Date: Tue, 25 Aug 2009 09:12:08 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>, linux-kernel@vger.kernel.org,
       dipankar@in.ibm.com, akpm@linux-foundation.org,
       mathieu.desnoyers@polymtl.ca, josht@linux.vnet.ibm.com,
       dvhltc@us.ibm.com, niv@us.ibm.com, tglx@linutronix.de,
       peterz@infradead.org, rostedt@goodmis.org,
       Paul Mundt <lethal@linux-sh.org>
Subject: Re: [PATCH -tip 0/2] Temporary RCU fixes for notrace and hotplug CPU
Message-ID: <20090825161208.GE6616@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20090824164112.GA13693@linux.vnet.ibm.com> <20090825065501.GA29162@elte.hu> <20090825080047.GA16139@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090825080047.GA16139@elte.hu>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 25, 2009 at 10:00:47AM +0200, Ingo Molnar wrote:
> 
> btw., i'm still seeing crashes with the latest RCU bits:
> 
> [   20.621740] Testing event sys_enter_futex: OK
> [   20.629738] Testing event sys_exit_futex: OK
> [   20.637737] Testing event lock_acquire: [reboot]
> 
> Possibly due to infinite recursion as well. Config attached.

Color me confused...

Unless someone has a better idea, I will send in a patch that adds
"notrace" to every RCU API member used by any file in the kernel
that has "trace" in its name (excluding ptrace.c and rcutree_trace.c,
of course).  This list is as follows:

	call_rcu()
	call_rcu_sched()
	rcu_read_lock()
	rcu_read_unlock()

So, any better ideas?

							Thanx, Paul
