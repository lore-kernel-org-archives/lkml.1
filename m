Return-Path: <linux-kernel-owner+w=401wt.eu-S1753529AbYDZNkk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753529AbYDZNkk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Apr 2008 09:40:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751284AbYDZNka
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Apr 2008 09:40:30 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:57757 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751005AbYDZNk3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Apr 2008 09:40:29 -0400
Subject: Re: Announce: Semaphore-Removal tree
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Christoph Hellwig <hch@infradead.org>
Cc: Daniel Walker <dwalker@mvista.com>, Matthew Wilcox <matthew@wil.cx>,
       linux-kernel@vger.kernel.org, Stephen Rothwell <sfr@canb.auug.org.au>
In-Reply-To: <20080426093048.GA11443@infradead.org>
References: <20080425170021.GH14990@parisc-linux.org>
	 <1209155917.12461.46.camel@localhost.localdomain>
	 <20080425211250.GA13858@infradead.org>
	 <1209158552.12461.53.camel@localhost.localdomain>
	 <20080426093048.GA11443@infradead.org>
Content-Type: text/plain
Date: Sat, 26 Apr 2008 15:39:13 +0200
Message-Id: <1209217153.1956.14.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2008-04-26 at 05:30 -0400, Christoph Hellwig wrote:
> On Fri, Apr 25, 2008 at 02:22:31PM -0700, Daniel Walker wrote:
> > If you can make a case for converting some semaphores to spinlocks be my
> > guest .. If you have good reasoning I wouldn't stand in the way.. (Real
> > time converts all the spinlocks to mutexes anyway ..)
> 
> Right at hand I have the XFS inode hash lock was converted from a rw_semaphore
> to a rwlock_t becuase the context switch overhead was killing
> performance in various benchmarks. This is a very typical scenary for
> locks that are taken often and held for a rather short time.  Add to
> that fact that a spinlock is compltely optimized away for an UP kernel
> while a mutex is not and the amount of memory that any mutex takes
> compared to a spinlock you have a clear winner.

I'm guessing RCU would be a bit more work?

The problem with rwlock_t is that for it to be a spinning lock the hold
times should be short, for it to be a rwlock over a spinlock there
should be a significant amount of concurrency, these two things together
make for a cache-line bouncing fest.



