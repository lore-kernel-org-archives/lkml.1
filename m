Return-Path: <linux-kernel-owner+w=401wt.eu-S1759043AbYEXTTq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759043AbYEXTTq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 May 2008 15:19:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751655AbYEXTTh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 May 2008 15:19:37 -0400
Received: from gateway-1237.mvista.com ([63.81.120.158]:17199 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751600AbYEXTTh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 May 2008 15:19:37 -0400
Subject: Re: [PATCH 3/3] futex: fix miss ordered wakeups
From: Daniel Walker <dwalker@mvista.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <alpine.LFD.1.10.0805242031560.3295@apollo.tec.linutronix.de>
References: <20080523042923.594531457@mvista.com>
	 <20080523042923.916202203@mvista.com>
	 <alpine.LFD.1.10.0805241039220.3295@apollo.tec.linutronix.de>
	 <1211643165.18130.166.camel@localhost.localdomain>
	 <alpine.LFD.1.10.0805241852490.3295@apollo.tec.linutronix.de>
	 <1211649860.18130.182.camel@localhost.localdomain>
	 <alpine.LFD.1.10.0805242031560.3295@apollo.tec.linutronix.de>
Content-Type: text/plain
Date: Sat, 24 May 2008 12:19:34 -0700
Message-Id: <1211656774.18130.198.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-3.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sat, 2008-05-24 at 20:35 +0200, Thomas Gleixner wrote: 
> > > A) A task on another CPU can get it independent of its priority
> > > B) In case of multiple waiters wakeup there is no guarantee either
> > 
> > This is how I would imagine the pre-plist code would work.
> 
> And it works this way even after the plist code.
> 
> May I politely suggest, that you carefully read futex_wake() and the
> corresponding libc implementation and figure out why there is no
> guarantee and why there can't be one?

Sure ..

> Sorry, I'm not abusive. You make claims about correctness and you seem
> to believe that the plist code gives guarantees except for the
> setscheduler corner case, but your hypothesis is simply wrong:
> 
> There is no kernel side controlled handover of a normal futex. The
> woken up waiters race for it and a low prio thread on another CPU can
> steal it even if there is a high prio waiter woken up.

After reading futex_wake, Doesn't it depend how many waiters are woken?
Given that comes from userspace, glibc could wake a single waiter and
obtain a priority ordering, couldn't it?

> The plist add on works correct in most of the cases, nothing else. To
> achieve full correctness there is much more necessary than this
> setscheduler issue. The plist changes were accepted because the
> overhead is really minimal, but achieving full correctness would hurt
> performance badly.

If that's the requirement then code that cleans up the corner case that
I've identified, which is also minimal should be acceptable .. Since
it's meeting the same requirement you layed out above for the original
plist changes.

Daniel

