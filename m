Return-Path: <linux-kernel-owner+w=401wt.eu-S1757410AbYEKOsb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757410AbYEKOsb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2008 10:48:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754584AbYEKOsX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 May 2008 10:48:23 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:46017 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754541AbYEKOsX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2008 10:48:23 -0400
Date: Sun, 11 May 2008 08:48:21 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Ingo Molnar <mingo@elte.hu>
Cc: Sven Wegener <sven.wegener@stealer.net>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Andi Kleen <andi@firstfloor.org>, LKML <linux-kernel@vger.kernel.org>,
       Alexander Viro <viro@ftp.linux.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [git pull] scheduler fixes
Message-ID: <20080511144821.GW19219@parisc-linux.org>
References: <20080508151028.GA12109@elte.hu> <20080511110306.GP19219@parisc-linux.org> <20080511114803.GA8289@parisc-linux.org> <20080511125049.GA22513@elte.hu> <20080511125216.GA25040@elte.hu> <20080511130226.GR19219@parisc-linux.org> <20080511132636.GA22878@parisc-linux.org> <20080511140017.GA2457@elte.hu> <20080511141818.GT19219@parisc-linux.org> <20080511144203.GB3220@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080511144203.GB3220@elte.hu>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 11, 2008 at 04:42:03PM +0200, Ingo Molnar wrote:
> 
> * Matthew Wilcox <matthew@wil.cx> wrote:
> 
> > > > Current XFS CVS has a fix from myself and Christoph that gets rid 
> > > > of the l_flushsema and replaces it with a staggered wakeup of each 
> > > > task that's waiting as the previously woken task clears the 
> > > > critical section.
>
> i was not talking about the race. I was just reacting on your comments 
> about thundering herds and staggered wakeups - which is a performance 
> detail. Semaphores should not regress AIM7 by 50% but otherwise they are 
> legacy code and their use should be reduced monotonically, so i was 
> asking why anyone still cares about tuning semaphore details in XFS 
> instead of just working on removing semaphore use from them.

That's what we did.  l_flushsema is gone.  It actually got replaced with
a condition variable, but it's equivalent to a wait_event()

> exactly what usecase is that? Perhaps it could be converted to an atomic 
> counter + the wait_event() APIs.

Effectively, it's a completion.  It just works better with staggered
wakeups than it does with the naive completion.

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
