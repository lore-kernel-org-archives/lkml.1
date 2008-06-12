Return-Path: <linux-kernel-owner+w=401wt.eu-S1761366AbYFLNaS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761366AbYFLNaS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2008 09:30:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757802AbYFLNaG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jun 2008 09:30:06 -0400
Received: from gateway-1237.mvista.com ([63.81.120.158]:60995 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757748AbYFLNaE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2008 09:30:04 -0400
Subject: Re: [PATCH 5/5] futex: fix miss ordered wakeups
From: Daniel Walker <dwalker@mvista.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, Ulrich Drepper <drepper@gmail.com>,
       Arjan van de Ven <arjan@infradead.org>
In-Reply-To: <alpine.LFD.1.10.0806121022250.3193@apollo.tec.linutronix.de>
References: <20080611204916.271608740@mvista.com>
	 <20080611204917.523866467@mvista.com>
	 <alpine.LFD.1.10.0806121022250.3193@apollo.tec.linutronix.de>
Content-Type: text/plain
Date: Thu, 12 Jun 2008 06:30:02 -0700
Message-Id: <1213277402.16459.25.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-5.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 2008-06-12 at 10:56 +0200, Thomas Gleixner wrote:
> On Wed, 11 Jun 2008, Daniel Walker wrote:
> > Adds an additional function call to the sched_setscheduler to update the
> > waiter position of a task if it happens to be waiting on a futex. This
> > ensures that the kernel level waiter ordering is correctly maintained
> > based on the changed priority of the task.
> > 
> > I fixed the locking issue noticed by Thomas Gleixner.
> > 
> > This doesn't address userspace at all, only the kernel level wakeups and
> > kernel level ordering.
> > 
> > The additional locking added to the futex_wait function has no visible speed
> > impact, and only effects waiters which actual enter the kernel.
> 
> The additional locking is just broken and you did not even bother to
> test your changes with lockdep.

I ran it with lockdep enabled , I didn't get any warnings..

> Aside of this, these patches still add 100 lines of code to achieve
> nothing - as dicussed when you previously submitted your changes. 
> 
> Please stop wasting everyone's time with that.

It achieves correct ordering of the futex waiters inside the kernel,
that is in fact _something_ ..

Daniel


