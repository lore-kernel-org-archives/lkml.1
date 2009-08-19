Return-Path: <linux-kernel-owner+w=401wt.eu-S1751643AbZHSJkY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751643AbZHSJkY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Aug 2009 05:40:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751310AbZHSJkX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Aug 2009 05:40:23 -0400
Received: from dspnet.fr.eu.org ([213.186.44.138]:1750 "EHLO dspnet.fr.eu.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751275AbZHSJkW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Aug 2009 05:40:22 -0400
X-Greylist: delayed 517 seconds by postgrey-1.27 at vger.kernel.org; Wed, 19 Aug 2009 05:40:22 EDT
Date: Wed, 19 Aug 2009 11:31:45 +0200
From: Olivier Galibert <galibert@pobox.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Kumar Gala <galak@kernel.crashing.org>,
       Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
       mingo@elte.hu, tglx@linutronix.de, linuxppc-dev@ozlabs.org,
       peterz@infradead.org
Subject: Re: [PATCH] spinlock: __raw_spin_is_locked() should return true for UP
Message-ID: <20090819093145.GA53298@dspnet.fr.eu.org>
Mail-Followup-To: Olivier Galibert <galibert@pobox.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Kumar Gala <galak@kernel.crashing.org>,
	Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
	mingo@elte.hu, tglx@linutronix.de, linuxppc-dev@ozlabs.org,
	peterz@infradead.org
References: <1250635343-32546-1-git-send-email-galak@kernel.crashing.org> <alpine.LFD.2.01.0908181618420.3158@localhost.localdomain> <alpine.DEB.2.00.0908181931180.28398@gandalf.stny.rr.com> <alpine.LFD.2.01.0908181640120.3158@localhost.localdomain> <alpine.DEB.2.00.0908182003430.18648@gandalf.stny.rr.com> <BB2762BC-C760-4D4C-BDCF-76EFD3E1B18D@kernel.crashing.org> <alpine.LFD.2.01.0908181937400.3158@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.01.0908181937400.3158@localhost.localdomain>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 18, 2009 at 07:40:16PM -0700, Linus Torvalds wrote:
> 
> 
> On Tue, 18 Aug 2009, Kumar Gala wrote:
> > 
> > I agree its a little too easy to abuse spin_is_locked.  However we should be
> > consistent between spin_is_locked on UP between with and without
> > CONFIG_DEBUG_SPINLOCK enabled.
> 
> No we shouldn't.
> 
> With CONFIG_DEBUG_SPINLOCK, you have an actual lock variable for debugging 
> purposes, so spin_is_locked() can clearly return a _valid_ answer, and 
> should do so.
> 
> Without DEBUG_SPINLOCK, there isn't any answer to return.
> 
> So there's no way we can or should be consistent. In one case an answer 
> exists, in another one the answer is meaningless and doesn't exist.

I always thought behaviour should be consistent between code with
debugging on and code without.  Otherwise you may end up with cases of
"it starts working when I turn on debugging" which are a pain to fix.
Has something changed?

Or in other words, do you think lockdep should try solving deadlocks
instead of just reporting them for instance?

  OG.
