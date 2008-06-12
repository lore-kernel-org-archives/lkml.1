Return-Path: <linux-kernel-owner+w=401wt.eu-S1759195AbYFLXGS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759195AbYFLXGS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2008 19:06:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755317AbYFLXGI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jun 2008 19:06:08 -0400
Received: from gateway-1237.mvista.com ([63.81.120.158]:44099 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751011AbYFLXGF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2008 19:06:05 -0400
Subject: Re: [PATCH 5/5] futex: fix miss ordered wakeups
From: Daniel Walker <dwalker@mvista.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Ulrich Drepper <drepper@gmail.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Peter Zijlstra <peterz@infradead.org>
In-Reply-To: <alpine.LFD.1.10.0806130023440.3193@apollo.tec.linutronix.de>
References: <20080611204916.271608740@mvista.com>
	 <20080611204917.523866467@mvista.com>
	 <alpine.LFD.1.10.0806121022250.3193@apollo.tec.linutronix.de>
	 <1213277402.16459.25.camel@localhost.localdomain>
	 <alpine.LFD.1.10.0806121533270.3193@apollo.tec.linutronix.de>
	 <1213278286.16459.29.camel@localhost.localdomain>
	 <alpine.LFD.1.10.0806121636380.3193@apollo.tec.linutronix.de>
	 <1213286193.16459.53.camel@localhost.localdomain>
	 <alpine.LFD.1.10.0806121802050.3193@apollo.tec.linutronix.de>
	 <1213308598.16459.82.camel@localhost.localdomain>
	 <alpine.LFD.1.10.0806130023440.3193@apollo.tec.linutronix.de>
Content-Type: text/plain
Date: Thu, 12 Jun 2008 16:06:02 -0700
Message-Id: <1213311963.16459.89.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-5.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 2008-06-13 at 00:43 +0200, Thomas Gleixner wrote:
> On Thu, 12 Jun 2008, Daniel Walker wrote:
> 
> > 
> > On Thu, 2008-06-12 at 21:55 +0200, Thomas Gleixner wrote:
> > > Also your interpretation of the POSIX requirement is very
> > > questionable:
> > > 
> > >  "If there are threads blocked on the mutex object referenced by mutex
> > >  when pthread_mutex_unlock() is called, resulting in the mutex
> > >  becoming available, the scheduling policy shall determine which
> > >  thread shall acquire the mutex."
> > 
> > The key is "scheduling policy" .. When the mutex is un-blocked the next
> > task to run is the same as if the scheduler was selecting tasks from the
> > list of blocked tasks .. For Linux, that means the highest priority
> > tasks should be selected.. So it's no more acceptable for the scheduler
> > to priority invert some tasks than it is for the futex to do it.
> 
> Sigh, when do you actually get a gripe that the default futex
> implementation does not and can not guarantee that at all and therefor
> your "correctness" patch is as important as a bag of rice which
> toopled over in China ?

Well, the last email I got from Arjan said this,

".. Don't look at the release path... look at the acquire path.
If a thread sees the futex is free, it'll take it, without even going
to the kernel at all."

And yes, I understand that fully.

> Provide answers to the real questions I asked more than once: 
> 
> What's the real world problem ? Who cares about that - except you ?

Any application which starts a thread, and later changes the priority
can observe the miss-ordering.. That's pretty common..

Daniel

