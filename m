Return-Path: <linux-kernel-owner+w=401wt.eu-S1760206AbXKHMhx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760206AbXKHMhx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2007 07:37:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752858AbXKHMhp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Nov 2007 07:37:45 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:58971 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750886AbXKHMho (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2007 07:37:44 -0500
Subject: Re: [patch 01/28] cpu alloc: The allocator
From: Peter Zijlstra <peterz@infradead.org>
To: Christoph Lameter <clameter@sgi.com>
Cc: akpm@linux-foundation.org, linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <1194525257.6289.145.camel@twins>
References: <20071106195144.983665861@sgi.com>
	 <20071106195157.878563669@sgi.com>  <1194525257.6289.145.camel@twins>
Content-Type: text/plain
Date: Thu, 08 Nov 2007 13:37:39 +0100
Message-Id: <1194525459.6289.148.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-11-08 at 13:34 +0100, Peter Zijlstra wrote:
> On Tue, 2007-11-06 at 11:51 -0800, Christoph Lameter wrote:

> > +#ifndef _LINUX_CPU_ALLOC_H_
> > +#define _LINUX_CPU_ALLOC_H_
> > +
> > +#define CPU_OFFSET(__cpu) \
> > +	((unsigned long)(__cpu) << (CONFIG_CPU_AREA_ORDER + PAGE_SHIFT))
> > +
> > +#define CPU_PTR(__p, __cpu) ((__typeof__(__p))((void *)(__p) + \
> > +							CPU_OFFSET(__cpu)))
> > +
> > +#define CPU_ALLOC(type, flags)	cpu_alloc(sizeof(type), flags, \
> > +					__alignof__(type))
> > +#define CPU_FREE(pointer)	cpu_free(pointer, sizeof(*(pointer)))
> > +
> > +#define THIS_CPU(__p)	CPU_PTR(__p, smp_processor_id())
> > +#define __THIS_CPU(__p)	CPU_PTR(__p, raw_smp_processor_id())
> > +
> > +/*
> > + * Raw calls
> > + */
> > +void *cpu_alloc(unsigned long size, gfp_t gfp, unsigned long align);
> > +void cpu_free(void *cpu_pointer, unsigned long size);
> > +
> > +#endif /* _LINUX_CPU_ALLOC_H_ */
> 
> Like said in the previous mail (which due to creative mailing from your
> end never made it out to the lists), I dislike those shouting macros.
> Please lowercase them.

sed -i -e 's/CPU_OFFSET/cpu_offset/g' -e 's/CPU_PTR/cpu_ptr/' -e
's/CPU_ALLOC/cpu_alloc_type/g'  -e 's/cpu_free/__cpu_free/g' -e
's/CPU_FREE/cpu_free/' -e 's/THIS_CPU/this_cpu/g' patches/*.patch

should get you there.

