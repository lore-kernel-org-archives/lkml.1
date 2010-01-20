Return-Path: <linux-kernel-owner+w=401wt.eu-S1753144Ab0ATPaK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753144Ab0ATPaK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jan 2010 10:30:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751250Ab0ATPaH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jan 2010 10:30:07 -0500
Received: from f0.cmpxchg.org ([85.214.51.133]:56185 "EHLO cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751863Ab0ATPaG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jan 2010 10:30:06 -0500
Date: Wed, 20 Jan 2010 16:30:00 +0100
From: Johannes Weiner <hannes@cmpxchg.org>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       Ralf Baechle <ralf@linux-mips.org>, x86@kernel.org
Subject: Re: [RFC 1/1] bootmem: move big allocations behing 4G
Message-ID: <20100120153000.GA13172@cmpxchg.org>
References: <1263855390-32497-1-git-send-email-jslaby@suse.cz> <20100119143355.GB7932@cmpxchg.org> <4B570A15.8040601@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B570A15.8040601@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jiri,

On Wed, Jan 20, 2010 at 02:50:13PM +0100, Jiri Slaby wrote:
> On 01/19/2010 03:33 PM, Johannes Weiner wrote:
> > --- a/include/linux/bootmem.h
> > +++ b/include/linux/bootmem.h
> > @@ -96,20 +96,26 @@ extern void *__alloc_bootmem_low_node(pg_data_t *pgdat,
> >  				      unsigned long align,
> >  				      unsigned long goal);
> >  
> > +#ifdef MAX_DMA32_PFN
> > +#define BOOTMEM_DEFAULT_GOAL	(__pa(MAX_DMA32_PFN << PAGE_SHIFT))
> > +#else
> > +#define BOOTMEM_DEFAULT_GOAL	MAX_DMA_ADDRESS
> 
> I just noticed this should write:
> #define BOOTMEM_DEFAULT_GOAL   __pa(MAX_DMA_ADDRESS)

Pardon my sloppiness, it's all backwards.  The other case should
be without the __pa(), of course.

I'll send a fixed and tested version later.

Thanks,
	Hannes
