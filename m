Return-Path: <linux-kernel-owner+w=401wt.eu-S1760793AbXHaQeX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760793AbXHaQeX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2007 12:34:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759515AbXHaQeO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Aug 2007 12:34:14 -0400
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:46517 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759500AbXHaQeN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2007 12:34:13 -0400
Date: Fri, 31 Aug 2007 12:33:53 -0400
From: Josef Sipek <jsipek@fsl.cs.sunysb.edu>
To: Peter Zijlstra <peterz@infradead.org>
Cc: David Chinner <dgc@sgi.com>, Eric Sandeen <sandeen@sandeen.net>,
       linux-kernel Mailing List <linux-kernel@vger.kernel.org>,
       xfs-oss <xfs@oss.sgi.com>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] Increase lockdep MAX_LOCK_DEPTH
Message-ID: <20070831163353.GC13397@filer.fsl.cs.sunysb.edu>
References: <46D79C62.1010304@sandeen.net> <1188542389.6112.44.camel@twins> <20070831135042.GD422459@sgi.com> <1188570831.6112.64.camel@twins> <20070831150511.GA734179@sgi.com> <1188572961.6112.72.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1188572961.6112.72.camel@twins>
User-Agent: Mutt/1.5.16 (2007-07-16)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 31, 2007 at 05:09:21PM +0200, Peter Zijlstra wrote:
> On Sat, 2007-09-01 at 01:05 +1000, David Chinner wrote:
> 
> > > Trouble is, we'd like to have a sane upper bound on the amount of held
> > > locks at any one time, obviously this is just wanting, because a lot of
> > > lock chains also depend on the number of online cpus...
> > 
> > Sure - this is an obvious case where it is valid to take >30 locks at
> > once in a single thread. In fact, worst case here we are taking twice this
> > number of locks - we actually take 2 per inode (ilock and flock) so a
> > full 32 inode cluster free would take >60 locks in the middle of this
> > function and we should be busting this depth couter limit all the
> > time. 
> 
> I think this started because jeffpc couldn't boot without XFS busting
> lockdep :-)
 
It booted, but if I tried to build the kernel it would make lockdep blowup -
not very useful when you have your own code you'd like lockdep to check :)

Josef 'Jeff' Sipek.

-- 
I'm somewhere between geek and normal.
		- Linus Torvalds
