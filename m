Return-Path: <linux-kernel-owner+w=401wt.eu-S1756031AbYFLP4q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756031AbYFLP4q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2008 11:56:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753832AbYFLP4g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jun 2008 11:56:36 -0400
Received: from gateway-1237.mvista.com ([63.81.120.158]:36812 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753543AbYFLP4g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2008 11:56:36 -0400
Subject: Re: [PATCH 5/5] futex: fix miss ordered wakeups
From: Daniel Walker <dwalker@mvista.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Ulrich Drepper <drepper@gmail.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Peter Zijlstra <peterz@infradead.org>
In-Reply-To: <alpine.LFD.1.10.0806121636380.3193@apollo.tec.linutronix.de>
References: <20080611204916.271608740@mvista.com>
	 <20080611204917.523866467@mvista.com>
	 <alpine.LFD.1.10.0806121022250.3193@apollo.tec.linutronix.de>
	 <1213277402.16459.25.camel@localhost.localdomain>
	 <alpine.LFD.1.10.0806121533270.3193@apollo.tec.linutronix.de>
	 <1213278286.16459.29.camel@localhost.localdomain>
	 <alpine.LFD.1.10.0806121636380.3193@apollo.tec.linutronix.de>
Content-Type: text/plain
Date: Thu, 12 Jun 2008 08:56:33 -0700
Message-Id: <1213286193.16459.53.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-5.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 2008-06-12 at 17:24 +0200, Thomas Gleixner wrote:
> > Just because you don't use it, doesn't make it useless .. At least
> > there's enough people asking for this that it warrants me writing it..
> 
> Which is not really a good technical reason to merge such a
> patch. Your handwaving about "enough people" is just irrelevant. Are
> you going to implement a root hole as well when enough people ask for
> it ?

People asking for something is a very good reason to merge "features" ..
You can like or dislike implementations , but that doesn't reflect on
the nature of the feature.

> But there is also a Real Good technical reason why these patches are
> going nowhere else than into /dev/null:
> 
>  your approach of hijacking blocked_on is fundamentaly wrong as it
>  mixes kernel internal state with user space state.

It mixes kernel state with kernel state, not to mention each state is
isolated from the others.

>  It will break in preempt-rt at the point when this state is set and
>  the code blocks on a spinlock, which uses the rtmutex based sleeping
>  spinlock implementation and overwrites blocked_on.

That's an intersting point, however "preempt-rt" is out of tree, so it's
certainly not going be a reason to reject mainline changes.

> If there would be a real good technical reason to fix this priority
> ordering it could be done with less than 20 lines of code without
> extra locking and wreckage waiting left and right, but I have not yet
> seen a single convincing technical argument or a relevant use case
> which might justify that.

The technical reasons for including this are the same technical reasons
why we want the waiters queued in priority order .. It's a requirement
of posix, where many calls need the ordering and ultimately feed into
the futex interface. So we have every reason to do the ordering
correctly..

If you have a 20 line fix for this then great tell me what it is..

Daniel

