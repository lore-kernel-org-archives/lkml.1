Return-Path: <linux-kernel-owner+w=401wt.eu-S1756829AbYEKOme@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756829AbYEKOme (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2008 10:42:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752785AbYEKOm0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 May 2008 10:42:26 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:50627 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751288AbYEKOm0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2008 10:42:26 -0400
Date: Sun, 11 May 2008 16:42:03 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Matthew Wilcox <matthew@wil.cx>
Cc: Sven Wegener <sven.wegener@stealer.net>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Andi Kleen <andi@firstfloor.org>, LKML <linux-kernel@vger.kernel.org>,
       Alexander Viro <viro@ftp.linux.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [git pull] scheduler fixes
Message-ID: <20080511144203.GB3220@elte.hu>
References: <20080508144316.GA9869@elte.hu> <20080508151028.GA12109@elte.hu> <20080511110306.GP19219@parisc-linux.org> <20080511114803.GA8289@parisc-linux.org> <20080511125049.GA22513@elte.hu> <20080511125216.GA25040@elte.hu> <20080511130226.GR19219@parisc-linux.org> <20080511132636.GA22878@parisc-linux.org> <20080511140017.GA2457@elte.hu> <20080511141818.GT19219@parisc-linux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080511141818.GT19219@parisc-linux.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Matthew Wilcox <matthew@wil.cx> wrote:

> > > Current XFS CVS has a fix from myself and Christoph that gets rid 
> > > of the l_flushsema and replaces it with a staggered wakeup of each 
> > > task that's waiting as the previously woken task clears the 
> > > critical section.
> > 
> > the solution is to reduce semaphore usage by converting them to 
> > mutexes. Is anyone working on removing legacy semaphore use from 
> > XFS?
> 
> This race is completely irrelevant to converting semaphores to 
> mutexes. [...]

i was not talking about the race. I was just reacting on your comments 
about thundering herds and staggered wakeups - which is a performance 
detail. Semaphores should not regress AIM7 by 50% but otherwise they are 
legacy code and their use should be reduced monotonically, so i was 
asking why anyone still cares about tuning semaphore details in XFS 
instead of just working on removing semaphore use from them.

> [...] It can only occur for semaphores which /can't/ be converted to 
> mutexes.

exactly what usecase is that? Perhaps it could be converted to an atomic 
counter + the wait_event() APIs.

	Ingo
