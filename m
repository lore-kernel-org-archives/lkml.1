Return-Path: <linux-kernel-owner+w=401wt.eu-S1760766AbYEMOWG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760766AbYEMOWG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2008 10:22:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755608AbYEMOVy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 May 2008 10:21:54 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:39581 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756922AbYEMOVx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2008 10:21:53 -0400
Date: Tue, 13 May 2008 08:21:35 -0600
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
Message-ID: <20080513142135.GF9324@parisc-linux.org>
References: <20080511125216.GA25040@elte.hu> <20080511130226.GR19219@parisc-linux.org> <20080511132636.GA22878@parisc-linux.org> <20080511140017.GA2457@elte.hu> <20080511141818.GT19219@parisc-linux.org> <20080511144203.GB3220@elte.hu> <20080511144821.GW19219@parisc-linux.org> <20080511151909.GA3887@elte.hu> <20080511152942.GY19219@parisc-linux.org> <20080513141129.GC18798@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080513141129.GC18798@elte.hu>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 13, 2008 at 04:11:29PM +0200, Ingo Molnar wrote:
> 
> * Matthew Wilcox <matthew@wil.cx> wrote:
> 
> > > So why not transform it to real completions instead? And if our 
> > > current 'struct completion' abstraction is insufficient for whatever 
> > > reason, why not extend that instead?
> > 
> > My point is that for the only user of counting semaphores and/or 
> > semaphores-abused-as-completions that has so far hit this race, the 
> > serialised wake-up performs better.  You have not pointed at a 
> > scenario that _shows_ a parallel wake-up to perform better. [...]
> 
> a 50% AIM7 slowdown maybe? With the BKL being a spinlock again it doesnt 
> matter much in practice though.

You're not understanding me.  This is completely inapplicable to the BKL
because only one task can be in wakeup at a time (due to it having a
maximum value of 1).  There's no way to hit this race with the BKL.
The only kind of semaphore that can hit this race is the kind that can
have more than one wakeup in progress at a time -- ie one which can have
a value >1.  Like completions and real counting semaphores.

So the only thing worth talking about (and indeed, it's now entirely
moot) is what's the best way to solve this problem /for this kind of
semaphore/.

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
