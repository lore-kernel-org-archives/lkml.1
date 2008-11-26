Return-Path: <linux-kernel-owner+w=401wt.eu-S1753205AbYKZNdE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753205AbYKZNdE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2008 08:33:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752173AbYKZNcx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Nov 2008 08:32:53 -0500
Received: from www.tglx.de ([62.245.132.106]:49175 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752076AbYKZNcx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2008 08:32:53 -0500
Date: Wed, 26 Nov 2008 14:32:13 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Stephen Rothwell <sfr@canb.auug.org.au>
cc: Andi Kleen <andi@firstfloor.org>, eranian@googlemail.com,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org, mingo@elte.hu,
       x86@kernel.org, eranian@gmail.com
Subject: Re: [patch 05/24] perfmon: X86 generic code (x86)
In-Reply-To: <20081126230529.ab37fb32.sfr@canb.auug.org.au>
Message-ID: <alpine.LFD.2.00.0811261430120.3325@localhost.localdomain>
References: <492d0be1.09cc660a.0b75.44b7@mx.google.com> <20081126113309.GS6703@one.firstfloor.org> <20081126230529.ab37fb32.sfr@canb.auug.org.au>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 26 Nov 2008, Stephen Rothwell wrote:
> Hi Andi,
> 
> On Wed, 26 Nov 2008 12:33:09 +0100 Andi Kleen <andi@firstfloor.org> wrote:
> >
> > > + * x86 does not need extra alignment requirements for the sampling buffer
> > > + */
> > > +#define PFM_ARCH_SMPL_ALIGN_SIZE	0
> > > +
> > > +asmlinkage void  pmu_interrupt(void);
> > > +
> > > +static inline void pfm_arch_bv_copy(u64 *a, u64 *b, int nbits)
> > 
> > All these bitmap wrappers just seem like unnecessary obfuscation.
> > Could you just drop them and call the standard functions directly?
> 
> These were added after comments from the PowerPC maintainer since how the
> bitmaps are accessed needs to be arch specific.

Just because perfmon uses u64 for bitfields instead of unsigned
long, therefor it breaks on BE32 machines.

I have not yet found a good reason why it needs to use u64 instead of
using what's there already.

Thanks,

	tglx
