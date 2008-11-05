Return-Path: <linux-kernel-owner+w=401wt.eu-S1756017AbYKEV1t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756017AbYKEV1t (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2008 16:27:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752055AbYKEV1l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Nov 2008 16:27:41 -0500
Received: from e6.ny.us.ibm.com ([32.97.182.146]:39752 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751306AbYKEV1k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2008 16:27:40 -0500
Date: Wed, 5 Nov 2008 13:27:17 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Manfred Spraul <manfred@colorfullife.com>
Cc: linux-kernel@vger.kernel.org, cl@linux-foundation.org, mingo@elte.hu,
       akpm@linux-foundation.org, dipankar@in.ibm.com,
       josht@linux.vnet.ibm.com, schamp@sgi.com, niv@us.ibm.com,
       dvhltc@us.ibm.com, ego@in.ibm.com, laijs@cn.fujitsu.com,
       rostedt@goodmis.org, peterz@infradead.org, penberg@cs.helsinki.fi,
       andi@firstfloor.org, tglx@linutronix.de
Subject: Re: [PATCH, RFC] v7 scalable classic RCU implementation
Message-ID: <20081105212717.GA6692@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20080821234318.GA1754@linux.vnet.ibm.com> <20080825000738.GA24339@linux.vnet.ibm.com> <20080830004935.GA28548@linux.vnet.ibm.com> <20080905152930.GA8124@linux.vnet.ibm.com> <20080915160221.GA9660@linux.vnet.ibm.com> <20080923235340.GA12166@linux.vnet.ibm.com> <20081010160930.GA9777@linux.vnet.ibm.com> <490E094F.7090007@colorfullife.com> <20081103203336.GG6792@linux.vnet.ibm.com> <4911F872.8010400@colorfullife.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4911F872.8010400@colorfullife.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 05, 2008 at 08:48:02PM +0100, Manfred Spraul wrote:
> Paul E. McKenney wrote:
>>
>>> Attached is a hack that I use right now for myself.
>>> Btw - on my 4-cpu system, the average latency from call_rcu() to the rcu 
>>> callback is 4-5 milliseconds, (CONFIG_HZ_1000).
>>
>> Hmmm...  I would expect that if you have some CPUs in dyntick idle mode.
>> But if I run treercu on an CONFIG_HZ_250 8-CPU Power box, I see 2.5
>> jiffies per grace period if CPUs are kept out of dyntick idle mode, and
>> 4 jiffies per grace period if CPUs are allowed to enter dyntick idle mode.
>>
>> Alternatively, if you were testing with multiple concurrent
>> synchronize_rcu() invocations, you can also see longer grace-period
>> latencies due to the fact that a new synchronize_rcu() must wait for an
>> earlier grace period to complete before starting a new one.
>>   
> That's the reason why I decided to measure the real latency, from 
> call_rcu() to the final callback. It includes the delays for waiting until 
> the current grace period completes, until the softirq is scheduled, etc.

I believe that I get very close to the same effect by timing a call to
synchronize_rcu() in a kernel module.  Repeating measurements and
printing out cumulative statistics periodically reduces the heisenberg
effect.

> Probably one cpu was not in user space when the timer interrupt arrived.
> I'll continue to investigate that. Unfortunately, my first attempt failed: 
> adding too many printk's results in too much time spent within do_syslog(). 
> And then the timer interrupt always arrives on the spin_unlock_irqrestore 
> in do_syslog()....

;-)

							Thanx, Paul
