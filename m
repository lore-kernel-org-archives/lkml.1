Return-Path: <linux-kernel-owner+w=401wt.eu-S1758528AbYDMM6M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758528AbYDMM6M (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Apr 2008 08:58:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754125AbYDMM6A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Apr 2008 08:58:00 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:59500 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753119AbYDMM6A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Apr 2008 08:58:00 -0400
Date: Sun, 13 Apr 2008 06:57:58 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Ingo Molnar <mingo@elte.hu>
Cc: Roland Dreier <rdreier@cisco.com>, Peter Zijlstra <peterz@infradead.org>,
       Ingo Oeser <ioe-lkml@rameria.de>, Daniel Walker <dwalker@mvista.com>,
       linux-kernel@vger.kernel.org, Linus Torvalds <torvalds@osdl.org>
Subject: Re: [PATCH] Replace completions with semaphores
Message-ID: <20080413125758.GQ11962@parisc-linux.org>
References: <20080411210022.GJ11962@parisc-linux.org> <1208003081.7427.7.camel@twins> <20080412172606.GL11962@parisc-linux.org> <adaskxqrgsl.fsf@cisco.com> <20080412204748.GN11962@parisc-linux.org> <20080413070833.GC19773@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080413070833.GC19773@elte.hu>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 13, 2008 at 09:08:33AM +0200, Ingo Molnar wrote:
> but semaphores will be _removed_, _completely_. Rewriting them in 
> generic C code is just the first step towards that - it consolidates all 
> the myriads of semaphore implementations that Linux has spread out.

I think you're dreaming.  We have 11 places in the tree that currently
demand to use a counting semaphore (with 'n' plausibly greater than 1).
If we remove the facility, these places are going to invent their own
weird locking schemes.

> your proposed change to change completions to semaphores is totally 
> backwards and prolongs an API we want to get rid of. Did you miss this 
> aspect of the mutex rewrite, of the semaphore-to-mutex, 
> semaphore-to-completions and semaphore-to-rwsem conversions?

Yes -- because it wasn't raised at the time for semaphore-to-completions.
It was raised for semaphore-to-mutex, of course.  And I agree that we
/want/ to be rid of counting semaphores, but I don't see a way to do it.
I do believe tht we should be converting all the semaphore users to
mutexes that we can (eg scx200_wdt.c), and converting semaphore users to
completions where that makes sense (eg libusual.c).  But there's still
the other dozen places to support.

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
