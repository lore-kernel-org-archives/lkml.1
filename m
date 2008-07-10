Return-Path: <linux-kernel-owner+w=401wt.eu-S1755386AbYGJHuO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755386AbYGJHuO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2008 03:50:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751370AbYGJHuA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jul 2008 03:50:00 -0400
Received: from mail-out.m-online.net ([212.18.0.9]:52767 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751017AbYGJHt6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2008 03:49:58 -0400
X-Auth-Info: OJl5tgK++R9JjkNG1qww9gpab+HUg0lvA6F62fakjbA=
X-Auth-Info: OJl5tgK++R9JjkNG1qww9gpab+HUg0lvA6F62fakjbA=
X-Auth-Info: OJl5tgK++R9JjkNG1qww9gpab+HUg0lvA6F62fakjbA=
X-Auth-Info: OJl5tgK++R9JjkNG1qww9gpab+HUg0lvA6F62fakjbA=
X-Auth-Info: h0DVBOxcv4teTlUmG7Y9uoZaJvX3MUslOXHbktyTp4A=
X-Auth-Info: h0DVBOxcv4teTlUmG7Y9uoZaJvX3MUslOXHbktyTp4A=
X-Auth-Info: h0DVBOxcv4teTlUmG7Y9uoZaJvX3MUslOXHbktyTp4A=
X-Auth-Info: h0DVBOxcv4teTlUmG7Y9uoZaJvX3MUslOXHbktyTp4A=
Message-ID: <4875BF57.8030405@grandegger.com>
Date: Thu, 10 Jul 2008 09:50:47 +0200
From: Wolfgang Grandegger <wg@grandegger.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Wolfgang Grandegger <wg@grandegger.com>, Luotao Fu <l.fu@pengutronix.de>,
       Steven Rostedt <rostedt@goodmis.org>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>,
       RT <linux-rt-users@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: 2.6.24-rc8-rt1: Strange latencies on mpc5200 powerpc - RCU	issue?
References: <486A3EBB.6030905@grandegger.com> <Pine.LNX.4.58.0807011036510.26650@gandalf.stny.rr.com> <486A573E.60107@grandegger.com> <486B607F.9040903@grandegger.com> <Pine.LNX.4.58.0807052041350.8466@gandalf.stny.rr.com> <48709348.6000101@grandegger.com> <20080708150826.GA30586@pengutronix.de> <4873C363.3070306@grandegger.com> <4874B4C0.5090500@pengutronix.de> <4874B9D5.1020309@grandegger.com> <20080709145217.GB30586@pengutronix.de>
In-Reply-To: <20080709145217.GB30586@pengutronix.de>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Luotao Fu wrote:
> Hi Wolfgang,
> On Wed, Jul 09, 2008 at 03:15:01PM +0200, Wolfgang Grandegger wrote:
>> Hi Fu (without n)
>>
> ....
>> OK, in the past you have been able to reproduce the high latencies with  
>> 2.6.24-rt1 and CONFIG_RCU_TRACE disabled, IIRC. Did you use a different  
>> toolchain at that time?
>>
> 
> Nope. As mentioned above, trace_mark() does some "real" works (what ever it is.),
> while the new mechahnismen use flags to remember the state of preemption. Maybe

I don't known what you refer to, but in __rcu_preempt_unboost() of 2.6.25.8-rt7, 
the trace code simply increments a counter:

        static void rcu_trace_boost_##type(struct rcu_boost_dat *rbd)   \
        {                                                               \
                rbd->rbs_stat_##type++;                                 \
        }

and that's the reason why latency is not affected by switching CONFIG_RCU_TRACE
on (while trace_mark uses preempt_disable/preempt_enable around).

> something here got optimized away? I take for grant, that you use gcc in your
> toolchain. Which version do you have?

The ELDK v4.2 uses:

  ppc_6xx-gcc (GCC) 4.2.2

and 

  GLIBC v2.6

But I measured the same latencies with ELDK v4.1:

  ppc_6xx-gcc (GCC) 4.0.0 (DENX ELDK 4.1 4.0.0)

  GLIBC v2.3.5

Wolfgang.

