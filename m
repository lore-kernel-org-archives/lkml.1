Return-Path: <linux-kernel-owner+w=401wt.eu-S1757591AbXLUV2t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757591AbXLUV2t (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2007 16:28:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753568AbXLUV2k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Dec 2007 16:28:40 -0500
Received: from gate.crashing.org ([63.228.1.57]:55446 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753421AbXLUV2j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2007 16:28:39 -0500
Subject: Re: [PATCH 1/2] DMA buffer alignment annotations
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Russell King <rmk+lkml@arm.linux.org.uk>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       rdreier@cisco.com, linux-scsi@vger.kernel.org, davem@davemloft.net,
       james.bottomley@steeleye.com, ralf@linux-mips.org
In-Reply-To: <20071221093905.GB31115@flint.arm.linux.org.uk>
References: <20071221023010.C56B7DDDF3@ozlabs.org>
	 <20071221093905.GB31115@flint.arm.linux.org.uk>
Content-Type: text/plain
Date: Sat, 22 Dec 2007 08:25:41 +1100
Message-Id: <1198272341.6737.12.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 2007-12-21 at 09:39 +0000, Russell King wrote:

> > +#ifndef ARCH_MIN_DMA_ALIGNMENT
> > +#define __dma_aligned
> > +#define __dma_buffer
> > +#else
> > +#define __dma_aligned	  	__attribute__((aligned(ARCH_MIN_DMA_ALIGNMENT)))
> > +#define __dma_buffer		__dma_buffer_line(__LINE__)
> > +#define __dma_buffer_line(line)	__dma_aligned;\
> > +				char __dma_pad_##line[0] __dma_aligned
> 
> You introduce __dma_buffer_line() if ARCH_MIN_DMA_ALIGNMENT is set but
> not if it isn't...

Yup, it's not meant to be used outside of __dma_buffer...

 .../...

> > +then dev->buffer will be safe for DMA on all architectures.  On a
> > +cache-coherent architecture the members of dev will be aligned exactly
> > +as they would have been without __dma_buffer; on a non-cache-coherent
> > +architecture buffer and field2 will be aligned so that buffer does not
> > +share a cache line with any other data.
> > +
> 
> ... but it's not described.  What's the purpose of it, and why would it
> only be used on CPUs with ARCH_MIN_DMA_ALIGNMENT set?

Hrm, I'm not the best at writing exlanations, care to send a patch ? :-)

Cheers,
Ben


