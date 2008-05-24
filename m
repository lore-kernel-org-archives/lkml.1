Return-Path: <linux-kernel-owner+w=401wt.eu-S1760984AbYEXRYa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760984AbYEXRYa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 May 2008 13:24:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757675AbYEXRYX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 May 2008 13:24:23 -0400
Received: from gateway-1237.mvista.com ([63.81.120.158]:8311 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755626AbYEXRYW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 May 2008 13:24:22 -0400
Subject: Re: [PATCH 3/3] futex: fix miss ordered wakeups
From: Daniel Walker <dwalker@mvista.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <alpine.LFD.1.10.0805241852490.3295@apollo.tec.linutronix.de>
References: <20080523042923.594531457@mvista.com>
	 <20080523042923.916202203@mvista.com>
	 <alpine.LFD.1.10.0805241039220.3295@apollo.tec.linutronix.de>
	 <1211643165.18130.166.camel@localhost.localdomain>
	 <alpine.LFD.1.10.0805241852490.3295@apollo.tec.linutronix.de>
Content-Type: text/plain
Date: Sat, 24 May 2008 10:24:20 -0700
Message-Id: <1211649860.18130.182.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-3.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sat, 2008-05-24 at 19:03 +0200, Thomas Gleixner wrote:
> On Sat, 24 May 2008, Daniel Walker wrote:
> > On Sat, 2008-05-24 at 10:55 +0200, Thomas Gleixner wrote:
> > 
> > > Normal futexes have no ordering guarantees at all. There is no
> > > mechanism to prevent lock stealing from lower priority tasks. So why
> > > should we care about the once a year case, where a sleepers priority
> > > is modified ?
> > 
> > Lock stealing?
> 
> Do you have the faintest idea how the futex code works at all ? There
> is no guarantee that the task which is woken up first gets the futex.

Thomas if you want to be abusive, talk to someone else.

> A) A task on another CPU can get it independent of its priority
> B) In case of multiple waiters wakeup there is no guarantee either

This is how I would imagine the pre-plist code would work.

> > > If you need ordering guarantees then use PI futexes.
> > 
> > There are degree's of overhead with each step.. Someone may not need or
> > want priority inheritance.
> 
> Then there is no need to add this artifical "correctness" at all.

huh?

> > > There are more issues vs. pi futexes as well. The simple case of
> > > futex_wait() vs. futex_adjust_waiters will just upset lockdep, but
> > > there are real dealocks vs. unqueue_me_pi waiting.
> > 
> > You mean the lock ordering would cause the deadlock vs. unqueue_me_pi ,
> > or are you talking about something else?
> 
> Do I write Chinese or what ?

I guess so .. 

Daniel

