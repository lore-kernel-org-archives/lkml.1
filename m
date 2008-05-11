Return-Path: <linux-kernel-owner+w=401wt.eu-S1756071AbYEKPaQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756071AbYEKPaQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2008 11:30:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754476AbYEKP3p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 May 2008 11:29:45 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:48019 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754221AbYEKP3o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2008 11:29:44 -0400
Date: Sun, 11 May 2008 09:29:43 -0600
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
Message-ID: <20080511152942.GY19219@parisc-linux.org>
References: <20080511114803.GA8289@parisc-linux.org> <20080511125049.GA22513@elte.hu> <20080511125216.GA25040@elte.hu> <20080511130226.GR19219@parisc-linux.org> <20080511132636.GA22878@parisc-linux.org> <20080511140017.GA2457@elte.hu> <20080511141818.GT19219@parisc-linux.org> <20080511144203.GB3220@elte.hu> <20080511144821.GW19219@parisc-linux.org> <20080511151909.GA3887@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080511151909.GA3887@elte.hu>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 11, 2008 at 05:19:09PM +0200, Ingo Molnar wrote:
> * Matthew Wilcox <matthew@wil.cx> wrote:
> > > exactly what usecase is that? Perhaps it could be converted to an 
> > > atomic counter + the wait_event() APIs.
> > 
> > Effectively, it's a completion.  It just works better with staggered 
> > wakeups than it does with the naive completion.
> 
> So why not transform it to real completions instead? And if our current 
> 'struct completion' abstraction is insufficient for whatever reason, why 
> not extend that instead?

My point is that for the only user of counting semaphores and/or
semaphores-abused-as-completions that has so far hit this race, the
serialised wake-up performs better.  You have not pointed at a scenario
that _shows_ a parallel wake-up to perform better.  Some hand-waving
and talking about lofty principles, yes.  But no actual data.

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
