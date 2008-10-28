Return-Path: <linux-kernel-owner+w=401wt.eu-S1753191AbYJ1RTQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753191AbYJ1RTQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2008 13:19:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752457AbYJ1RTA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Oct 2008 13:19:00 -0400
Received: from mail-gx0-f18.google.com ([209.85.217.18]:63898 "EHLO
	mail-gx0-f18.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752307AbYJ1RS7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2008 13:18:59 -0400
Message-ID: <49074A02.4080703@colorfullife.com>
Date: Tue, 28 Oct 2008 18:21:06 +0100
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
References: <20081015011143.GE6874@linux.vnet.ibm.com> <48F5A638.8020003@colorfullife.com> <20081015152637.GA6739@linux.vnet.ibm.com> <48FF73C7.90709@colorfullife.com> <20081022210254.GE6766@linux.vnet.ibm.com> <48FF9A0E.90205@colorfullife.com> <20081027164529.GC6783@linux.vnet.ibm.com> <49061AF0.8070106@colorfullife.com> <20081027235201.GK6783@linux.vnet.ibm.com> <4906A370.3000502@colorfullife.com> <20081028151738.GB6779@linux.vnet.ibm.com>
In-Reply-To: <20081028151738.GB6779@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul E. McKenney wrote:
>> How do you intend to handle nohz cpus?
>>     
>
> In which variant of RCU?  My current thought is to apply the rcutree.c
> version to rcupreempt.c.  If rcuclassic.c can be dropped, my thought
> would be to leave it alone -- it is unnecessarily awakening CPUs, but
> this is a non-fatal issue.
>
>   
For rcuclassic.

As far as  I can see, rcuclassic treats nohz cpus as always outside 
rcu_read_lock():
rcu_start_batch() contains
 >
 >                cpus_andnot(rcp->cpumask, cpu_online_map, nohz_cpu_mask);
 >
As soon as all cpus from rcp->cpumask reported a grace period, the 
callbacks are called.
That a bug, therefore I would drop rcuclassic as soon as rcutree is merged.

--
    Manfred

