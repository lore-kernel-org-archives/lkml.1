Return-Path: <linux-kernel-owner+w=401wt.eu-S1761219AbYHAVLi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761219AbYHAVLi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2008 17:11:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760774AbYHAVJg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Aug 2008 17:09:36 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:39385 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760765AbYHAVJe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2008 17:09:34 -0400
Date: Fri, 1 Aug 2008 14:09:13 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Wolfgang Grandegger <wg@grandegger.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, Luotao Fu <l.fu@pengutronix.de>,
       LKML <linux-kernel@vger.kernel.org>,
       RT <linux-rt-users@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: 2.6.24-rc8-rt1: Strange latencies on mpc5200 powerpc - RCU
	issue?
Message-ID: <20080801210913.GC14851@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20080130010716.GB16069@linux.vnet.ibm.com> <47A032E9.4080105@grandegger.com> <20080130102255.GA24890@linux.vnet.ibm.com> <47A0552D.20605@grandegger.com> <20080130105715.GE24890@linux.vnet.ibm.com> <20080130111559.GC20089@pengutronix.de> <486A3EBB.6030905@grandegger.com> <Pine.LNX.4.58.0807011036510.26650@gandalf.stny.rr.com> <486A573E.60107@grandegger.com> <486B607F.9040903@grandegger.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <486B607F.9040903@grandegger.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 02, 2008 at 01:03:27PM +0200, Wolfgang Grandegger wrote:
> Wolfgang Grandegger wrote:
>> Steven Rostedt wrote:
>> There seems to be something in trace_mark() keeping latency low:
>>   http://lxr.linux.no/linux+v2.6.24.4/include/linux/marker.h#L52
>> I will follow your suggestions.
>
> I removed all "likely" and "unlikely" macros, but the latencies did not 
> improve. Then I added
>
> 	preempt_disable();
> 	preempt_enable();
>
> at the two locations mentioned above, like trace_mark() does,  and disabled 
> CONFIG_RCU_TRACE. That helped to keep the latencies low, and it did for 
> 2.6.25.8-rt7 as well. As I see it, adding preemption points seem to prevent 
> high latencies.

Interesting.  Perhaps a preempt_enable_no_resched() somewhere that
should be preempt_enable()?

							Thanx, Paul
