Return-Path: <linux-kernel-owner+w=401wt.eu-S934128AbYDQQMN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934128AbYDQQMN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2008 12:12:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762435AbYDQQL6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Apr 2008 12:11:58 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:46166 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1763333AbYDQQL5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2008 12:11:57 -0400
Date: Thu, 17 Apr 2008 12:11:53 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Peter Zijlstra <peterz@infradead.org>
cc: Kernel development list <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>,
       Paul E McKenney <paulmck@linux.vnet.ibm.com>
Subject: Re: Semphore -> mutex in the device tree
In-Reply-To: <1208447153.7115.23.camel@twins>
Message-ID: <Pine.LNX.4.44L0.0804171204460.18040-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 Apr 2008, Peter Zijlstra wrote:

> On Thu, 2008-04-17 at 11:22 -0400, Alan Stern wrote:
> > Peter:
> > 
> > The obstacle to converting the semaphore in struct device to a mutex 
> > has been that its tree-oriented usage pattern isn't compatible with 
> > lockdep.
> > 
> > In order to get around this and at least begin the conversion process,
> > how about adding a provision for making some classes of mutex invisible
> > to lockdep?  I know it doesn't solve the fundamental problem, but maybe
> > it's a step in the right direction.
> 
> the device lock has two problems with lockdep:
> 
>  1) on suspend it takes more than MAX_LOCK_DEPTH (48) locks

This isn't true any more.  Not in Greg KH's development tree.

>  2) tree nesting
> 
> 
> Lets start with the easy one first; would a similar solution to the
> radix tree locking as found in -rt work?
> 
> http://programming.kicks-ass.net/kernel-patches/concurrent-pagecache/23-rc1-rt/radix-concurrent-lockdep.patch
> 
> That does mean you have to set an effective max depth to the tree, is
> that a practical issue?

I don't know.  But I suspect it wouldn't be sufficient to solve the 
problems associated with tree nesting.

For example, it's quite likely that some code somewhere needs to hold
two sibling nodes' locks at the same time.  Provided the parent node is
already locked, this operation is perfectly safe.  But is lockdep able
to handle it?

There are other, more subtle problems too; this is just one example.

> The harder part is 1), holding _that_ many locks. Would something
> obscene like this work for you:

This is no longer needed, fortunately.  :-)

Alan Stern

