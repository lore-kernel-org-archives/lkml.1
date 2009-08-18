Return-Path: <linux-kernel-owner+w=401wt.eu-S1751824AbZHRXVY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751824AbZHRXVY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Aug 2009 19:21:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750997AbZHRXVX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Aug 2009 19:21:23 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42671 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750872AbZHRXVX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Aug 2009 19:21:23 -0400
Date: Tue, 18 Aug 2009 16:20:43 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Kumar Gala <galak@kernel.crashing.org>
cc: linux-kernel@vger.kernel.org, mingo@elte.hu, tglx@linutronix.de,
       linuxppc-dev@ozlabs.org, peterz@infradead.org, rostedt@goodmis.org
Subject: Re: [PATCH] spinlock: __raw_spin_is_locked() should return true for
 UP
In-Reply-To: <1250635343-32546-1-git-send-email-galak@kernel.crashing.org>
Message-ID: <alpine.LFD.2.01.0908181618420.3158@localhost.localdomain>
References: <1250635343-32546-1-git-send-email-galak@kernel.crashing.org>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 18 Aug 2009, Kumar Gala wrote:
>
> For some reason __raw_spin_is_locked() has been returning false for the
> uni-processor, non-CONFIG_DEBUG_SPINLOCK.  The UP + CONFIG_DEBUG_SPINLOCK
> handles this correctly.
> 
> Found this by enabling CONFIG_DEBUG_VM on PPC and hitting always hitting
> a BUG_ON that was testing to make sure the pte_lock was held.
> 
> Signed-off-by: Kumar Gala <galak@kernel.crashing.org>
> ---
> 
> Linus, a fix for 2.6.31

This really isn't all that clear.

The thing is, some people may assert that a lock is held, but others could 
easily be looping until it's not held using something like

	while (spin_is_locked(lock))
		cpu_relax();

so it's hard to tell whether it should return true or false in the case 
where spin-locking simply doesn't exist.

		Linus
