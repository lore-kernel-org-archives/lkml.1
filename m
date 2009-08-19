Return-Path: <linux-kernel-owner+w=401wt.eu-S1752188AbZHSAHh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752188AbZHSAHh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Aug 2009 20:07:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751245AbZHSAHg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Aug 2009 20:07:36 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:62327 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751123AbZHSAHg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Aug 2009 20:07:36 -0400
Date: Tue, 18 Aug 2009 20:07:36 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Kumar Gala <galak@kernel.crashing.org>, linux-kernel@vger.kernel.org,
       mingo@elte.hu, tglx@linutronix.de, linuxppc-dev@ozlabs.org,
       peterz@infradead.org
Subject: Re: [PATCH] spinlock: __raw_spin_is_locked() should return true for
 UP
In-Reply-To: <alpine.LFD.2.01.0908181640120.3158@localhost.localdomain>
Message-ID: <alpine.DEB.2.00.0908182003430.18648@gandalf.stny.rr.com>
References: <1250635343-32546-1-git-send-email-galak@kernel.crashing.org> <alpine.LFD.2.01.0908181618420.3158@localhost.localdomain> <alpine.DEB.2.00.0908181931180.28398@gandalf.stny.rr.com> <alpine.LFD.2.01.0908181640120.3158@localhost.localdomain>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 18 Aug 2009, Linus Torvalds wrote:
> 
> > Thinking about it, UP probably should have spin_is_locked always return 
> > false, but if you want to make sure you are not in a critical section 
> > with the lock not held, then use assert_spin_locked, which on UP should be 
> > a nop.
> 
> That's what we do. That said, I also think we should generally try to 
> avoid the kind of code that depends on spin_is_locked always returning 
> false, for the same reason we should try to avoid any code that depends on 
> it always returning true. 

Perhaps we can deprecate spin_is_locked and replace it with 
"expect_spin_locked" and "expect_spin_unlocked" which on SMP would return 
true and false respectively if the lock was locked. But both would always 
return true on UP.

Or do some thing similar, that would remove the ambiguity on UP.

-- Steve

