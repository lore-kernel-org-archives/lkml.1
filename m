Return-Path: <linux-kernel-owner+w=401wt.eu-S1755691AbYIRQzx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755691AbYIRQzx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2008 12:55:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753477AbYIRQzq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Sep 2008 12:55:46 -0400
Received: from ug-out-1314.google.com ([66.249.92.173]:56373 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752789AbYIRQzp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2008 12:55:45 -0400
Message-ID: <48D2882B.9060806@colorfullife.com>
Date: Thu, 18 Sep 2008 18:56:11 +0200
From: Manfred Spraul <manfred@colorfullife.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: paulmck@linux.vnet.ibm.com
CC: Lai Jiangshan <laijs@cn.fujitsu.com>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Dipankar Sarma <dipankar@in.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>
Subject: Re: [RFC PATCH] rcu: introduce kfree_rcu()
References: <48D1D694.9010802@cn.fujitsu.com> <20080918064406.GC6397@linux.vnet.ibm.com>
In-Reply-To: <20080918064406.GC6397@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul E. McKenney wrote:
> On Thu, Sep 18, 2008 at 12:18:28PM +0800, Lai Jiangshan wrote:
>   
>> sometimes a rcu callback is just calling kfree() to free a struct's memory
>> (we say this callback is a trivial callback.).
>> this patch introduce kfree_rcu() to do these things directly, easily.
>>     
>
> Interesting!  Please see questions and comments below.
>
>   
>> There are 4 reasons that we need kfree_rcu():
>>
>> 1) unloadable modules:
>>    a module(rcu callback is defined in this module) using rcu must
>>    call rcu_barrier() when unload. rcu_barrier() will increase
>>    the system's overhead(the more cpus the worse) and
>>    rcu_barrier() is very time-consuming. if all rcu callback defined
>>    in this module are trivial callback, we can just call kfree_rcu()
>>    instead, save a rcu_barrier() when unload.
>>     
Hmm: why is rcu_barrier() sufficient to prevent races?
Offlining a cpu reorders rcu callbacks - rcu_barrier() can return before 
all previous call_rcu() callbacks were called.

--
    Manfred

