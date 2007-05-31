Return-Path: <linux-kernel-owner+w=401wt.eu-S1756858AbXEaBax@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756858AbXEaBax (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 21:30:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754264AbXEaBaq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 21:30:46 -0400
Received: from ms-smtp-03.nyroc.rr.com ([24.24.2.57]:57518 "EHLO
	ms-smtp-03.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753942AbXEaBap (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 21:30:45 -0400
Subject: Re: [BUG] futex_unlock_pi() hurts my brain and may cause
	application deadlock
From: Steven Rostedt <rostedt@goodmis.org>
To: john stultz <johnstul@us.ibm.com>
Cc: lkml <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Sripathi Kodi <sripathik@in.ibm.com>
In-Reply-To: <1180572567.6126.44.camel@localhost.localdomain>
References: <1180572567.6126.44.camel@localhost.localdomain>
Content-Type: text/plain
Date: Wed, 30 May 2007 21:29:53 -0400
Message-Id: <1180574993.21781.22.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-05-30 at 17:49 -0700, john stultz wrote:

> ...
> retry_locked:
> 	/*
> 	 * To avoid races, try to do the TID -> 0 atomic transition
> 	 * again. If it succeeds then we can return without waking
> 	 * anyone else up:
> 	 */
> 	if (!(uval & FUTEX_OWNER_DIED)) {
> 		pagefault_disable();
> 		uval = futex_atomic_cmpxchg_inatomic(uaddr, current->pid, 0);
> 		pagefault_enable();
> 	}

My question is to all the futex gurus out there.

This code is in futex_unlock_pi.  Can the owner of the mutex really die?
Isn't the owner the one doing the unlock?

-- Steve


