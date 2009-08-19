Return-Path: <linux-kernel-owner+w=401wt.eu-S1751889AbZHSClf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751889AbZHSClf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Aug 2009 22:41:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751644AbZHSCle
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Aug 2009 22:41:34 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50685 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751587AbZHSCle (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Aug 2009 22:41:34 -0400
Date: Tue, 18 Aug 2009 19:40:16 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Kumar Gala <galak@kernel.crashing.org>
cc: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
       mingo@elte.hu, tglx@linutronix.de, linuxppc-dev@ozlabs.org,
       peterz@infradead.org
Subject: Re: [PATCH] spinlock: __raw_spin_is_locked() should return true for
 UP
In-Reply-To: <BB2762BC-C760-4D4C-BDCF-76EFD3E1B18D@kernel.crashing.org>
Message-ID: <alpine.LFD.2.01.0908181937400.3158@localhost.localdomain>
References: <1250635343-32546-1-git-send-email-galak@kernel.crashing.org> <alpine.LFD.2.01.0908181618420.3158@localhost.localdomain> <alpine.DEB.2.00.0908181931180.28398@gandalf.stny.rr.com> <alpine.LFD.2.01.0908181640120.3158@localhost.localdomain>
 <alpine.DEB.2.00.0908182003430.18648@gandalf.stny.rr.com> <BB2762BC-C760-4D4C-BDCF-76EFD3E1B18D@kernel.crashing.org>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 18 Aug 2009, Kumar Gala wrote:
> 
> I agree its a little too easy to abuse spin_is_locked.  However we should be
> consistent between spin_is_locked on UP between with and without
> CONFIG_DEBUG_SPINLOCK enabled.

No we shouldn't.

With CONFIG_DEBUG_SPINLOCK, you have an actual lock variable for debugging 
purposes, so spin_is_locked() can clearly return a _valid_ answer, and 
should do so.

Without DEBUG_SPINLOCK, there isn't any answer to return.

So there's no way we can or should be consistent. In one case an answer 
exists, in another one the answer is meaningless and doesn't exist.

> How much of this do we want to try and address in .31?

Absolutely nothing.

> The PPC test really should be using assert_spin_locked and I'll send a patch
> to Ben for that.

Yes, that's the correct fix.

		Linus
