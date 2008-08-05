Return-Path: <linux-kernel-owner+w=401wt.eu-S1761524AbYHEPjA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761524AbYHEPjA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2008 11:39:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761384AbYHEPip
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Aug 2008 11:38:45 -0400
Received: from mail-out.m-online.net ([212.18.0.9]:49838 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761281AbYHEPin (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2008 11:38:43 -0400
X-Auth-Info: QgylhOFiHLFFuwzbBPRXZ2gaEktQVto0gaSHB1nNzJQ=
X-Auth-Info: D4M4+GlHcr/4nEXhtMCYf3iIixw7BxIvN9SbHqUUQtA=
X-Auth-Info: D4M4+GlHcr/4nEXhtMCYf3iIixw7BxIvN9SbHqUUQtA=
X-Auth-Info: D4M4+GlHcr/4nEXhtMCYf3iIixw7BxIvN9SbHqUUQtA=
X-Auth-Info: D4M4+GlHcr/4nEXhtMCYf3iIixw7BxIvN9SbHqUUQtA=
X-Auth-Info: D4M4+GlHcr/4nEXhtMCYf3iIixw7BxIvN9SbHqUUQtA=
X-Auth-Info: D4M4+GlHcr/4nEXhtMCYf3iIixw7BxIvN9SbHqUUQtA=
Message-ID: <48987486.6010100@grandegger.com>
Date: Tue, 05 Aug 2008 17:40:54 +0200
From: Wolfgang Grandegger <wg@grandegger.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: paulmck@linux.vnet.ibm.com
CC: Steven Rostedt <rostedt@goodmis.org>, Luotao Fu <l.fu@pengutronix.de>,
       LKML <linux-kernel@vger.kernel.org>,
       RT <linux-rt-users@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: 2.6.24-rc8-rt1: Strange latencies on mpc5200 powerpc - RCU	issue?
References: <20080130010716.GB16069@linux.vnet.ibm.com> <47A032E9.4080105@grandegger.com> <20080130102255.GA24890@linux.vnet.ibm.com> <47A0552D.20605@grandegger.com> <20080130105715.GE24890@linux.vnet.ibm.com> <20080130111559.GC20089@pengutronix.de> <486A3EBB.6030905@grandegger.com> <Pine.LNX.4.58.0807011036510.26650@gandalf.stny.rr.com> <486A573E.60107@grandegger.com> <486B607F.9040903@grandegger.com> <20080801210913.GC14851@linux.vnet.ibm.com>
In-Reply-To: <20080801210913.GC14851@linux.vnet.ibm.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul E. McKenney wrote:
> On Wed, Jul 02, 2008 at 01:03:27PM +0200, Wolfgang Grandegger wrote:
>> Wolfgang Grandegger wrote:
>>> Steven Rostedt wrote:
>>> There seems to be something in trace_mark() keeping latency low:
>>>   http://lxr.linux.no/linux+v2.6.24.4/include/linux/marker.h#L52
>>> I will follow your suggestions.
>> I removed all "likely" and "unlikely" macros, but the latencies did not 
>> improve. Then I added
>>
>> 	preempt_disable();
>> 	preempt_enable();
>>
>> at the two locations mentioned above, like trace_mark() does,  and disabled 
>> CONFIG_RCU_TRACE. That helped to keep the latencies low, and it did for 
>> 2.6.25.8-rt7 as well. As I see it, adding preemption points seem to prevent 
>> high latencies.
> 
> Interesting.  Perhaps a preempt_enable_no_resched() somewhere that
> should be preempt_enable()?

FYI, Thomas fixed the real problem a week ago and the patch went into 
2.6.24.7-rt16. See his mail with the subject "2.6.24.7-rt16".

Wolfgang.
