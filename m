Return-Path: <linux-kernel-owner+w=401wt.eu-S1761018AbYHAVNX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761018AbYHAVNX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2008 17:13:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760856AbYHAVKA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Aug 2008 17:10:00 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:57856 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760867AbYHAVJ5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2008 17:09:57 -0400
Date: Fri, 1 Aug 2008 14:09:45 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Wolfgang Grandegger <wg@grandegger.com>
Cc: Luotao Fu <l.fu@pengutronix.de>, Steven Rostedt <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>,
       RT <linux-rt-users@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: 2.6.24-rc8-rt1: Strange latencies on mpc5200 powerpc - RCU
	issue?
Message-ID: <20080801210945.GI14851@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <486A573E.60107@grandegger.com> <486B607F.9040903@grandegger.com> <Pine.LNX.4.58.0807052041350.8466@gandalf.stny.rr.com> <48709348.6000101@grandegger.com> <20080708150826.GA30586@pengutronix.de> <4873C363.3070306@grandegger.com> <4874B4C0.5090500@pengutronix.de> <4874B9D5.1020309@grandegger.com> <20080709145217.GB30586@pengutronix.de> <4875BF57.8030405@grandegger.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4875BF57.8030405@grandegger.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 10, 2008 at 09:50:47AM +0200, Wolfgang Grandegger wrote:
> Luotao Fu wrote:
>> Hi Wolfgang,
>> On Wed, Jul 09, 2008 at 03:15:01PM +0200, Wolfgang Grandegger wrote:
>>> Hi Fu (without n)
>>>
>> ....
>>> OK, in the past you have been able to reproduce the high latencies with  
>>> 2.6.24-rt1 and CONFIG_RCU_TRACE disabled, IIRC. Did you use a different  
>>> toolchain at that time?
>>>
>> Nope. As mentioned above, trace_mark() does some "real" works (what ever 
>> it is.),
>> while the new mechahnismen use flags to remember the state of preemption. 
>> Maybe
>
> I don't known what you refer to, but in __rcu_preempt_unboost() of 
> 2.6.25.8-rt7, the trace code simply increments a counter:
>
>        static void rcu_trace_boost_##type(struct rcu_boost_dat *rbd)   \
>        {                                                               \
>                rbd->rbs_stat_##type++;                                 \
>        }
>
> and that's the reason why latency is not affected by switching 
> CONFIG_RCU_TRACE
> on (while trace_mark uses preempt_disable/preempt_enable around).

This changed -- preempt_disable()/preempt_enable() pair
was added for rcu_trace_boost_boost_called_preempt() and
rcu_trace_boost_unboost_called_preempt() later to suppress a warning
(and also make that statistic accurate in face of preemption).

						Thanx, Paul

>> something here got optimized away? I take for grant, that you use gcc in 
>> your
>> toolchain. Which version do you have?
>
> The ELDK v4.2 uses:
>
>  ppc_6xx-gcc (GCC) 4.2.2
>
> and 
>  GLIBC v2.6
>
> But I measured the same latencies with ELDK v4.1:
>
>  ppc_6xx-gcc (GCC) 4.0.0 (DENX ELDK 4.1 4.0.0)
>
>  GLIBC v2.3.5
>
> Wolfgang.
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rt-users" 
> in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
