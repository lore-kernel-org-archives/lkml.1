Return-Path: <linux-kernel-owner+w=401wt.eu-S1756690AbZJHJlZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756690AbZJHJlZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Oct 2009 05:41:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754441AbZJHJlZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Oct 2009 05:41:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45968 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754351AbZJHJlY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Oct 2009 05:41:24 -0400
Date: Thu, 8 Oct 2009 11:40:55 +0200
From: Gleb Natapov <gleb@redhat.com>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       linux-api@vger.kernel.org
Subject: Re: [PATCH v2][RFC] add MAP_UNLOCKED mmap flag
Message-ID: <20091008094055.GE16702@redhat.com>
References: <20091006170218.GM9832@redhat.com>
 <20091006183436.GA23110@cmpxchg.org>
 <20091006185344.GA19692@redhat.com>
 <20091008093752.GA30858@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091008093752.GA30858@cmpxchg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 08, 2009 at 11:37:52AM +0200, Johannes Weiner wrote:
> On Tue, Oct 06, 2009 at 08:53:44PM +0200, Gleb Natapov wrote:
> > On Tue, Oct 06, 2009 at 08:34:36PM +0200, Johannes Weiner wrote:
> > > On Tue, Oct 06, 2009 at 07:02:18PM +0200, Gleb Natapov wrote:
> > > > diff --git a/include/asm-generic/mman.h b/include/asm-generic/mman.h
> > > > index 32c8bd6..59e0f29 100644
> > > > --- a/include/asm-generic/mman.h
> > > > +++ b/include/asm-generic/mman.h
> > > > @@ -12,6 +12,7 @@
> > > >  #define MAP_NONBLOCK	0x10000		/* do not block on IO */
> > > >  #define MAP_STACK	0x20000		/* give out an address that is best suited for process/thread stacks */
> > > >  #define MAP_HUGETLB	0x40000		/* create a huge page mapping */
> > > > +#define MAP_UNLOCKED	0x80000         /* force page unlocking */
> > > >  
> > > >  #define MCL_CURRENT	1		/* lock all current mappings */
> > > >  #define MCL_FUTURE	2		/* lock all future mappings */
> > > > diff --git a/mm/mmap.c b/mm/mmap.c
> > > > index 73f5e4b..7c2abdb 100644
> > > > --- a/mm/mmap.c
> > > > +++ b/mm/mmap.c
> > > > @@ -985,6 +985,9 @@ unsigned long do_mmap_pgoff(struct file *file, unsigned long addr,
> > > >  		if (!can_do_mlock())
> > > >  			return -EPERM;
> > > >  
> > > > +        if (flags & MAP_UNLOKED)
> > > > +                vm_flags &= ~VM_LOCKED;
> > 
> > > Should we do something special about (MAP_UNLOCKED | MAP_LOCKED)?
> >
> > It is simpler to just ignore it. What do you think?
> 
> I think we should filter it out.  It's unlocking even when MAP_LOCKED
> is set and doing mlock-specific checks also no mlock will happen.
> 
What do you mean by "filter it out"? Return error. mlock-specific checks
don't make much sense indeed since locking will not happen.

--
			Gleb.
