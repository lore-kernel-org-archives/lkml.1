Return-Path: <linux-kernel-owner+w=401wt.eu-S1762996AbXKHUVI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762996AbXKHUVI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2007 15:21:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761075AbXKHUU4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Nov 2007 15:20:56 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:45854 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760864AbXKHUUz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2007 15:20:55 -0500
Subject: Re: [patch 01/28] cpu alloc: The allocator
From: Peter Zijlstra <peterz@infradead.org>
To: Christoph Lameter <clameter@sgi.com>
Cc: akpm@linux-foundation.org, linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0711081030380.7871@schroedinger.engr.sgi.com>
References: <20071106195144.983665861@sgi.com>
	 <20071106195157.878563669@sgi.com> <1194522615.6289.136.camel@twins>
	 <Pine.LNX.4.64.0711081030380.7871@schroedinger.engr.sgi.com>
Content-Type: text/plain
Date: Thu, 08 Nov 2007 21:19:08 +0100
Message-Id: <1194553148.20832.10.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 2007-11-08 at 10:31 -0800, Christoph Lameter wrote:
> On Thu, 8 Nov 2007, Peter Zijlstra wrote:
> 
> > > +#define CPU_OFFSET(__cpu) \
> > > +	((unsigned long)(__cpu) << (CONFIG_CPU_AREA_ORDER + PAGE_SHIFT))
> > > +
> > > +#define CPU_PTR(__p, __cpu) ((__typeof__(__p))((void *)(__p) + \
> > > +							CPU_OFFSET(__cpu)))
> > > +
> > > +#define CPU_ALLOC(type, flags)	cpu_alloc(sizeof(type), flags, \
> > > +					__alignof__(type))
> > > +#define CPU_FREE(pointer)	cpu_free(pointer, sizeof(*(pointer)))
> > > +
> > > +#define THIS_CPU(__p)	CPU_PTR(__p, smp_processor_id())
> > > +#define __THIS_CPU(__p)	CPU_PTR(__p, raw_smp_processor_id())
> > > +
> > > +/*
> > > + * Raw calls
> > > + */
> > > +void *cpu_alloc(unsigned long size, gfp_t gfp, unsigned long align);
> > > +void cpu_free(void *cpu_pointer, unsigned long size);
> > > +
> > > +#endif /* _LINUX_CPU_ALLOC_H_ */
> > 
> > I don't like those shouting macros.
> 
> The convention for macros is to use upper case.

We have plent macros that look like regular functions. And as a primary
interface to this functionality these shouting things look really out of
place.

