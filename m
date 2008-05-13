Return-Path: <linux-kernel-owner+w=401wt.eu-S1759776AbYEMRXj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759776AbYEMRXj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2008 13:23:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761239AbYEMRX3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 May 2008 13:23:29 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44728 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761449AbYEMRX0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2008 13:23:26 -0400
Date: Tue, 13 May 2008 10:22:17 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
cc: Matthew Wilcox <matthew@wil.cx>, Sven Wegener <sven.wegener@stealer.net>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Andi Kleen <andi@firstfloor.org>, LKML <linux-kernel@vger.kernel.org>,
       Alexander Viro <viro@ftp.linux.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [git pull] scheduler fixes
In-Reply-To: <20080513171352.GE22348@elte.hu>
Message-ID: <alpine.LFD.1.10.0805131019360.3019@woody.linux-foundation.org>
References: <20080511140017.GA2457@elte.hu> <20080511141818.GT19219@parisc-linux.org> <20080511144203.GB3220@elte.hu> <20080511144821.GW19219@parisc-linux.org> <20080511151909.GA3887@elte.hu> <20080511152942.GY19219@parisc-linux.org> <20080513141129.GC18798@elte.hu>
 <20080513142135.GF9324@parisc-linux.org> <20080513144207.GA4697@elte.hu> <20080513152846.GI9324@parisc-linux.org> <20080513171352.GE22348@elte.hu>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 13 May 2008, Ingo Molnar wrote:
> 
> hm, this sounds like damage that is inflicted on itself by the XFS code. 

No. You're confusing what a counting semaphore is.

> Why does it signal to its waiters that "resource is available", when in 
> reality that resource is not available but immediately serialized via a 
> lock? (even if the lock might technically be some _other_ object)

So you have 'n' resources available, and you use a counting semaphore for 
that resource counting.

But you'd still need a spinlock to actually protect the list of resources 
themselves. The spinlock protects a different thing than the semaphore. 
The semaphore isn't about mutual exclusion - it's about counting resources 
and waiting when there are too many things in flight.

And you seem to think that a counting semaphore is about mutual exclusion. 
It has nothing what-so-ever to do with that. 

			Linus
