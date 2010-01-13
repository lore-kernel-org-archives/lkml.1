Return-Path: <linux-kernel-owner+w=401wt.eu-S1753210Ab0AMB1V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753210Ab0AMB1V (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jan 2010 20:27:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752001Ab0AMB1U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jan 2010 20:27:20 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40760 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751644Ab0AMB1T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jan 2010 20:27:19 -0500
Date: Tue, 12 Jan 2010 17:26:47 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Andreas Schwab <schwab@linux-m68k.org>
cc: Ingo Molnar <mingo@elte.hu>, Peter Anvin <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: x86-32: clean up rwsem inline asm statements
In-Reply-To: <m2fx6ahly3.fsf@igel.home>
Message-ID: <alpine.LFD.2.00.1001121725110.17145@localhost.localdomain>
References: <alpine.LFD.2.00.1001121613560.17145@localhost.localdomain> <m2fx6ahly3.fsf@igel.home>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 13 Jan 2010, Andreas Schwab wrote:

> Linus Torvalds <torvalds@linux-foundation.org> writes:
> 
> > @@ -249,7 +249,7 @@ static inline int rwsem_atomic_update(int delta, struct rw_semaphore *sem)
> >  {
> >  	int tmp = delta;
> >  
> > -	asm volatile(LOCK_PREFIX "xadd %0,%1"
> > +	asm volatile(LOCK_PREFIX "xadd%z0 %0,%1"
> >  		     : "+r" (tmp), "+m" (sem->count)
> >  		     : : "memory");
> 
> I think %z0 should be %z1 here.

You're right, but Peter made it all a non-issue anyway.

Thanks for noticing, though, since it implies that somebody read the patch 
carefully. It's always a bit scary to change fundamental inline asms, 
especially for something like a locking routine where the core _semantics_ 
are so subtle (and if you get locking wrong, things may still work - you 
just end up with some really odd race conditions).

		Linus
