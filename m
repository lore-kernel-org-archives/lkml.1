Return-Path: <linux-kernel-owner+w=401wt.eu-S1761046AbZBXXs3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761046AbZBXXs3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Feb 2009 18:48:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757274AbZBXXsV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Feb 2009 18:48:21 -0500
Received: from cmpxchg.org ([85.214.51.133]:41819 "EHLO cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752100AbZBXXsU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Feb 2009 18:48:20 -0500
Date: Wed, 25 Feb 2009 00:49:49 +0100
From: Johannes Weiner <hannes@cmpxchg.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: hpa@zytor.com, mingo@redhat.com, tj@kernel.org, tglx@linutronix.de,
       linux-kernel@vger.kernel.org, linux-tip-commits@vger.kernel.org
Subject: Re: [tip:core/percpu] bootmem: clean up arch-specific bootmem wrapping
Message-ID: <20090224234949.GA1778@cmpxchg.org>
References: <tip-c132937556f56ee4b831ef4b23f1846e05fde102@kernel.org> <20090224214638.GA2049@cmpxchg.org> <20090224214932.GC12601@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090224214932.GC12601@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 24, 2009 at 10:49:32PM +0100, Ingo Molnar wrote:
> 
> * Johannes Weiner <hannes@cmpxchg.org> wrote:
> 
> > On Tue, Feb 24, 2009 at 08:23:03PM +0000, Tejun Heo wrote:
> > > Author:     Tejun Heo <tj@kernel.org>
> > > AuthorDate: Tue, 24 Feb 2009 11:57:20 +0900
> > > Commit:     Tejun Heo <tj@kernel.org>
> > > CommitDate: Tue, 24 Feb 2009 11:57:20 +0900
> > > 
> > > bootmem: clean up arch-specific bootmem wrapping
> > > 
> > > Impact: cleaner and consistent bootmem wrapping
> > > 
> > > By setting CONFIG_HAVE_ARCH_BOOTMEM_NODE, archs can define
> > > arch-specific wrappers for bootmem allocation.  However, this is done
> > > a bit strangely in that only the high level convenience macros can be
> > > changed while lower level, but still exported, interface functions
> > > can't be wrapped.  This not only is messy but also leads to strange
> > > situation where alloc_bootmem() does what the arch wants it to do but
> > > the equivalent __alloc_bootmem() call doesn't although they should be
> > > able to be used interchangeably.
> > > 
> > > This patch updates bootmem such that archs can override / wrap the
> > > backend function - alloc_bootmem_core() instead of the highlevel
> > > interface functions to allow simpler and consistent wrapping.  Also,
> > > HAVE_ARCH_BOOTMEM_NODE is renamed to HAVE_ARCH_BOOTMEM.
> > > 
> > > Signed-off-by: Tejun Heo <tj@kernel.org>
> > > Cc: Johannes Weiner <hannes@saeurebad.de>
> > 
> > What does this message mean?  That the patch was commited to 
> > the -tip tree?
> 
> yes.
> 
> > Well, why not... oh, right, it is broken ;-)
> 
> In your reply you pointed out a change that was not adequately 
> declared plus an opportunity for a cleanup - is that what you 
> mean by breakage?

No, when the patch was submitted for review, I pointed out the change
in semantics and gathered from Tejun's reaction that this wasn't done
intentionally.  So the problem is the change itself, not the missing
declaration.

>From the original mail:

	Johannes Weiner wrote:
	> This won't suffice as reserve_bootmem() doesn't use
	> alloc_bootmem_core(), so now you effectively removed the
	> node-0 restriction for reserve_bootmem() on this
	> configuration.

	Ah... right.  :-(

I just wrote again because I didn't understand why Tejun acknowledged
the error in the patch and then it went into -tip anyway.

The other part of my email was just suggestions for a cleanup, I
wasn't referring to that when I said 'broken' - sorry if that is how
it came over.
