Return-Path: <linux-kernel-owner+w=401wt.eu-S1753164AbYJ0QqR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753164AbYJ0QqR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2008 12:46:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751208AbYJ0QqF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Oct 2008 12:46:05 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:47509 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750842AbYJ0QqE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2008 12:46:04 -0400
Date: Mon, 27 Oct 2008 09:45:29 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Manfred Spraul <manfred@colorfullife.com>
Cc: linux-kernel@vger.kernel.org, cl@linux-foundation.org, mingo@elte.hu,
       akpm@linux-foundation.org, dipankar@in.ibm.com,
       josht@linux.vnet.ibm.com, schamp@sgi.com, niv@us.ibm.com,
       dvhltc@us.ibm.com, ego@in.ibm.com, laijs@cn.fujitsu.com,
       rostedt@goodmis.org, peterz@infradead.org, penberg@cs.helsinki.fi,
       andi@firstfloor.org, tglx@linutronix.de
Subject: Re: [PATCH, RFC] v7 scalable classic RCU implementation
Message-ID: <20081027164529.GC6783@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20081010160930.GA9777@linux.vnet.ibm.com> <48F21D58.3000404@colorfullife.com> <20081012224629.GA7353@linux.vnet.ibm.com> <48F38D73.8040804@colorfullife.com> <20081015011143.GE6874@linux.vnet.ibm.com> <48F5A638.8020003@colorfullife.com> <20081015152637.GA6739@linux.vnet.ibm.com> <48FF73C7.90709@colorfullife.com> <20081022210254.GE6766@linux.vnet.ibm.com> <48FF9A0E.90205@colorfullife.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48FF9A0E.90205@colorfullife.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 22, 2008 at 11:24:30PM +0200, Manfred Spraul wrote:
> Paul E. McKenney wrote:
>> Hmmm...  Looks like rcu_pending is also always called with its cpu
>> parameter set to the current CPU, and same for rcu_needs_cpu().
>> And given that all the external uses of rcu_check_callbacks() are
>> of the following form:
>>
>> 	if (rcu_pending(cpu))
>> 		rcu_check_callbacks(cpu, whatever);
>>
>>
>> perhaps rcu_pending() should be an internal-to-RCU API invoked from
>> rcu_check_callbacks().
>>
>> Thoughts?
>>   
> From my point of view: Yes, change it.
>
> In the long run, I'd like to move the stall detector code to rcupdate.c, 
> with an 'rcu_cpu_missing' callback. That one would need a cpu flag, but 
> that's a new function.

Agreed.  Perhaps a good change to make while introducing stall detection
to preemptable RCU -- there would then be three examples, which should
allow good generalization.

							Thanx, Paul
