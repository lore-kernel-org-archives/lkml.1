Return-Path: <linux-kernel-owner+w=401wt.eu-S936631AbXHIBnK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936631AbXHIBnK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 21:43:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758247AbXHIBm4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 21:42:56 -0400
Received: from ns1.suse.de ([195.135.220.2]:56640 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756718AbXHIBmz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 21:42:55 -0400
Date: Thu, 9 Aug 2007 03:42:54 +0200
From: Nick Piggin <npiggin@suse.de>
To: Andi Kleen <ak@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, linux-arch@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [patch 2/2] x86_64: ticket lock spinlock
Message-ID: <20070809014254.GB12539@wotan.suse.de>
References: <20070808042234.GE11018@wotan.suse.de> <20070808042444.GF11018@wotan.suse.de> <200708081226.55651.ak@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200708081226.55651.ak@suse.de>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 08, 2007 at 12:26:55PM +0200, Andi Kleen wrote:
> 
> >   *
> >   * (the type definitions are in asm/spinlock_types.h)
> >   */
> >  
> > +#if (NR_CPUS > 256)
> > +#error spinlock supports a maximum of 256 CPUs
> > +#endif
> > +
> >  static inline int __raw_spin_is_locked(raw_spinlock_t *lock)
> >  {
> > -	return *(volatile signed int *)(&(lock)->slock) <= 0;
> > +	int tmp = *(volatile signed int *)(&(lock)->slock);
> 
> Why is slock not volatile signed int in the first place? 

Don't know really. Why does spin_is_locked need it to be volatile?


> > -	int oldval;
> > +	short tmp;
> > +        short oldval;
> 
> Broken white space?

Hmm, I'll fix it.

Thanks,
Nick
