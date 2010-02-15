Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755293Ab0BOHSP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Feb 2010 02:18:15 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:39766
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755043Ab0BOHSO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Feb 2010 02:18:14 -0500
Date: Sun, 14 Feb 2010 23:18:27 -0800 (PST)
Message-Id: <20100214.231827.257182182.davem@davemloft.net>
To: mingo@elte.hu
Cc: eric.dumazet@gmail.com, paulmck@linux.vnet.ibm.com,
       linux-kernel@vger.kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
       akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
       josh@joshtriplett.org, dvhltc@us.ibm.com, niv@us.ibm.com,
       tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
       Valdis.Kletnieks@vt.edu, dhowells@redhat.com, netdev@vger.kernel.org
Subject: Re: [PATCH tip/core/rcu 05/13] net: add checking to
 rcu_dereference() primitives
From: David Miller <davem@davemloft.net>
In-Reply-To: <20100214082314.GA12658@elte.hu>
References: <1265932839-25899-5-git-send-email-paulmck@linux.vnet.ibm.com>
	<1265948152.2891.25.camel@edumazet-laptop>
	<20100214082314.GA12658@elte.hu>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ingo Molnar <mingo@elte.hu>
Date: Sun, 14 Feb 2010 09:23:14 +0100

> 
> * Eric Dumazet <eric.dumazet@gmail.com> wrote:
> 
>> Le jeudi 11 f??vrier 2010 ?? 16:00 -0800, Paul E. McKenney a ??crit :
>> > Update rcu_dereference() primitives to use new lockdep-based checking.
>> > The rcu_dereference() in __in6_dev_get() may be protected either by
>> > rcu_read_lock() or RTNL, per Eric Dumazet.  The rcu_dereference()
>> > in __sk_free() is protected by the fact that it is never reached if an
>> > update could change it.  Check for this by using rcu_dereference_check()
>> > to verify that the struct sock's ->sk_wmem_alloc counter is zero.
>> > 
>> > Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
>> 
>> CC to netdev and David Miller, network maintainer.
>> 
>> Acked-by: Eric Dumazet <eric.dumazet@gmail.com>
>> 
>> Thanks Paul, great work !
> 
> Dave, does this look good to you too? Cannot pick up the rest of the patchset 
> without these checks/annotations into the RCU tree as there's too many 
> warnings triggering in the networking code. So it's an all-or-nothing 
> patchset in that regard.

Looks good:

Acked-by: David S. Miller <davem@davemloft.net>
