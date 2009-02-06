Return-Path: <linux-kernel-owner+w=401wt.eu-S1759067AbZBFWbX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759067AbZBFWbX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Feb 2009 17:31:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758093AbZBFWbD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Feb 2009 17:31:03 -0500
Received: from mail.gmx.net ([213.165.64.20]:59410 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753299AbZBFWbA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Feb 2009 17:31:00 -0500
X-Authenticated: #20450766
X-Provags-ID: V01U2FsdGVkX1/OQtAe6bnO4rc8d/r42PWJop2dhV7l//IViSOLPq
	jEgH55CrCDLO65
Date: Fri, 6 Feb 2009 23:30:56 +0100 (CET)
From: Guennadi Liakhovetski <lg@denx.de>
X-X-Sender: lyakh@axis700.grange
To: Andrew Morton <akpm@linux-foundation.org>
cc: linux-kernel@vger.kernel.org, lethal@linux-sh.org,
       adrian@newgolddream.dyndns.info, lkmladrian@gmail.com,
       linux-sh@vger.kernel.org, penberg@cs.helsinki.fi, dbaryshkov@gmail.com,
       penguin-kernel@i-love.sakura.ne.jp, hannes@cmpxchg.org
Subject: Re: [PATCH] fix broken size test in bitmap_find_free_region()
In-Reply-To: <20090206132950.96c3f92e.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0902062328300.7686@axis700.grange>
References: <8b67d60901201348r6a59928dw3fcf8c9c823d5c68@mail.gmail.com>
 <1232488507.6794.8.camel@localhost.localdomain> <20090121033951.GB14094@linux-sh.org>
 <20090121081118.GA14537@linux-sh.org> <20090127134831.3dd04182.akpm@linux-foundation.org>
 <20090127225458.GA8756@linux-sh.org> <Pine.LNX.4.64.0901280913090.4926@axis700.grange>
 <Pine.LNX.4.64.0902061313260.6241@axis700.grange>
 <20090206132950.96c3f92e.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 6 Feb 2009, Andrew Morton wrote:

> On Fri, 6 Feb 2009 13:22:33 +0100 (CET)
> Guennadi Liakhovetski <lg@denx.de> wrote:
> 
> > This loop and test in bitmap_find_free_region()
> > 
> > 	for (pos = 0; pos < bits; pos += (1 << order))
> > 		if (__reg_op(bitmap, pos, order, REG_OP_ISFREE))
> > 			break;
> > 	if (pos == bits)
> > 		return -ENOMEM;
> > 
> > can only return an error (-ENOMEM) if bits is a multiple of (1 << order), 
> > which is, for instance, true, if bits is (also) a power of 2. This 
> > is not necessarily the case with dma_alloc_from_coherent(). A failure to 
> > recognise too large a request leads in dma_alloc_from_coherent() to 
> > accessing beyond available memory, and to writing beyond the bitmap.
> > 
> 
> Do we have any reports of dma_alloc_from_coherent() actually behaving
> in that way?

Does this count:

http://marc.info/?l=linux-kernel&m=123313185800954&w=2

Yes, I did see this behaviour with a video driver, that's still not in the 
mainline (expected in the next cycle), using videobuf-dma-contig.c in the 
__videobuf_mmap_mapper() function.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.

DENX Software Engineering GmbH,     MD: Wolfgang Denk & Detlev Zundel
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany
Phone: +49-8142-66989-0 Fax: +49-8142-66989-80  Email: office@denx.de
