Return-Path: <linux-kernel-owner+w=401wt.eu-S1759726AbYJVVWv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759726AbYJVVWv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 17:22:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754237AbYJVVWj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 17:22:39 -0400
Received: from fk-out-0910.google.com ([209.85.128.188]:31553 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752743AbYJVVWj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 17:22:39 -0400
Message-ID: <48FF9A0E.90205@colorfullife.com>
Date: Wed, 22 Oct 2008 23:24:30 +0200
From: Manfred Spraul <manfred@colorfullife.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: paulmck@linux.vnet.ibm.com
CC: linux-kernel@vger.kernel.org, cl@linux-foundation.org, mingo@elte.hu,
       akpm@linux-foundation.org, dipankar@in.ibm.com,
       josht@linux.vnet.ibm.com, schamp@sgi.com, niv@us.ibm.com,
       dvhltc@us.ibm.com, ego@in.ibm.com, laijs@cn.fujitsu.com,
       rostedt@goodmis.org, peterz@infradead.org, penberg@cs.helsinki.fi,
       andi@firstfloor.org, tglx@linutronix.de
Subject: Re: [PATCH, RFC] v7 scalable classic RCU implementation
References: <20080915160221.GA9660@linux.vnet.ibm.com> <20080923235340.GA12166@linux.vnet.ibm.com> <20081010160930.GA9777@linux.vnet.ibm.com> <48F21D58.3000404@colorfullife.com> <20081012224629.GA7353@linux.vnet.ibm.com> <48F38D73.8040804@colorfullife.com> <20081015011143.GE6874@linux.vnet.ibm.com> <48F5A638.8020003@colorfullife.com> <20081015152637.GA6739@linux.vnet.ibm.com> <48FF73C7.90709@colorfullife.com> <20081022210254.GE6766@linux.vnet.ibm.com>
In-Reply-To: <20081022210254.GE6766@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul E. McKenney wrote:
> Hmmm...  Looks like rcu_pending is also always called with its cpu
> parameter set to the current CPU, and same for rcu_needs_cpu().
> And given that all the external uses of rcu_check_callbacks() are
> of the following form:
>
> 	if (rcu_pending(cpu))
> 		rcu_check_callbacks(cpu, whatever);
>
>
> perhaps rcu_pending() should be an internal-to-RCU API invoked from
> rcu_check_callbacks().
>
> Thoughts?
>   
 From my point of view: Yes, change it.

In the long run, I'd like to move the stall detector code to rcupdate.c, 
with an 'rcu_cpu_missing' callback. That one would need a cpu flag, but 
that's a new function.

--
    Manfred
