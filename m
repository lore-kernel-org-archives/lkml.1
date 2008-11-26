Return-Path: <linux-kernel-owner+w=401wt.eu-S1754202AbYKZNum@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754202AbYKZNum (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2008 08:50:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752292AbYKZNuc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Nov 2008 08:50:32 -0500
Received: from one.firstfloor.org ([213.235.205.2]:41413 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752234AbYKZNub (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2008 08:50:31 -0500
Date: Wed, 26 Nov 2008 15:00:54 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: eranian@googlemail.com, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, mingo@elte.hu, x86@kernel.org,
       andi@firstfloor.org, eranian@gmail.com, sfr@canb.auug.org.au
Subject: Re: [patch 05/24] perfmon: X86 generic code (x86)
Message-ID: <20081126140054.GX6703@one.firstfloor.org>
References: <492d0be1.09cc660a.0b75.44b7@mx.google.com> <alpine.LFD.2.00.0811261143480.3325@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0811261143480.3325@localhost.localdomain>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 26, 2008 at 02:35:18PM +0100, Thomas Gleixner wrote:
> > +	 * 	  does not work with other types of PMU registers.Thus, no
> > +	 * 	  address is ever exposed by counters
> > +	 *
> > +	 * 	- there is never a dependency between one pmd register and
> > +	 * 	  another
> > +	 */
> > +	for (i = 0; num; i++) {
> > +		if (likely(pfm_arch_bv_test_bit(i, set->used_pmds))) {
> > +			pfm_write_pmd(ctx, i, set->pmds[i]);
> > +			num--;
> > +		}
> > +	}
> 
>   This loop construct looks scary. It relies on set->nused_pmds >=
>   bits set in set->used_pmds. I had to look more than once to
>   understand that. It's used all over the code in variations.

FWIW this loop style tripped me up during review too.

> > +	 */
> > +	pfm_arch_resend_irq(ctx);
> 
> Do we really need this whole NMI business ?

Without it you cannot profile interrupts off regions well.

> 
> 9 simple wrappers around generic bitops. The only reason you need
> those is because you use 64bit variables and that does not work on
> 32bit BE machines.
> 
> I do not understand in the first place why you cant use simple
> unsigned longs for the bitfields, but if this is necessary for
> whatever non obvious reason, then its not an excuse to make this arch
> dependent code at all. You need a LE/BE64 and a BE32 version.  So you
> need a generic and a special be32 version. That's not arch specific.

Or a unsigned long x[VALUE_DEPENDS_ON_WORD_SIZE]

-Andi
