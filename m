Return-Path: <linux-kernel-owner+w=401wt.eu-S1757752AbYHNRG3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757752AbYHNRG3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2008 13:06:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752029AbYHNRGV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Aug 2008 13:06:21 -0400
Received: from gw.goop.org ([64.81.55.164]:40632 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752223AbYHNRGU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2008 13:06:20 -0400
Message-ID: <48A465F2.8000701@goop.org>
Date: Thu, 14 Aug 2008 10:05:54 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <andi@firstfloor.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       Steven Rostedt <srostedt@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>, Roland McGrath <roland@redhat.com>,
       Ulrich Drepper <drepper@redhat.com>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Gregory Haskins <ghaskins@novell.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       "Luis Claudio R. Goncalves" <lclaudio@uudg.org>,
       Clark Williams <williams@redhat.com>,
       Christoph Lameter <cl@linux-foundation.org>
Subject: Re: [RFC PATCH] x86 alternatives : fix LOCK_PREFIX race with	preemptible
 kernel and CPU hotplug
References: <20080813193011.GC15547@Krystal> <20080813193715.GQ1366@one.firstfloor.org> <20080813200119.GA18966@Krystal> <20080813234156.GA25775@Krystal> <48A375E3.9090609@zytor.com> <48A388CE.2020404@goop.org> <20080814014944.GA31883@Krystal> <48A3A806.8060509@goop.org> <20080814151805.GA29507@Krystal> <48A459B1.2070601@zytor.com> <20080814165802.GC517@Krystal>
In-Reply-To: <20080814165802.GC517@Krystal>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mathieu Desnoyers wrote:
> * H. Peter Anvin (hpa@zytor.com) wrote:
>   
>> Mathieu Desnoyers wrote:
>>     
>>> I can't argue about the benefit of using VM CPU pinning to manage
>>> resources because I don't use it myself, but I ran some tests out of
>>> curiosity to find if uncontended locks were that cheap, and it turns out
>>> they aren't. Here are the results :
>>> Xeon 2.0GHz
>>> Summary
>>> make -j1 kernel/      33.94 +/- 0.07         34.91 +/- 0.27      2.8 %
>>> hackbench 50           2.99 +/- 0.01          3.74 +/- 0.01     25.1 %
>>> 1 CPU, replace smp lock prefixes with DS segment selector prefixes
>>> 1 CPU, noreplace-smp
>>>       
>> For reference, could you also compare replace smp lock with NOPs?
>>
>> 	-hpa
>>     
>
> Sure, here are the updated tables. Basically, they show no significant
> difference between the NOP and the DS segment selector prefix
> approaches.
>   

BTW, are you changing the initial prefix to DS too?  Ie, are you doing a 
nop->lock->ds transition, or ds->lock->ds?

    J
