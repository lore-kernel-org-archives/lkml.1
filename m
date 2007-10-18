Return-Path: <linux-kernel-owner+w=401wt.eu-S933958AbXJRROm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933958AbXJRROm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2007 13:14:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753183AbXJRROf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Oct 2007 13:14:35 -0400
Received: from brick.kernel.dk ([87.55.233.238]:9809 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756754AbXJRROe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2007 13:14:34 -0400
Date: Thu, 18 Oct 2007 19:14:29 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       David Miller <davem@davemloft.net>, fujita.tomonori@lab.ntt.co.jp,
       mingo@elte.hu, linux-kernel@vger.kernel.org, jgarzik@pobox.com,
       alan@lxorguk.ukuu.org.uk, tomof@acm.org
Subject: Re: [bug] ata subsystem related crash with latest -git
Message-ID: <20071018171429.GH10674@kernel.dk>
References: <alpine.LFD.0.999.0710171342550.26902@woody.linux-foundation.org> <20071018080048O.fujita.tomonori@lab.ntt.co.jp> <alpine.LFD.0.999.0710171801000.26902@woody.linux-foundation.org> <20071017.181907.63126798.davem@davemloft.net> <20071018082145.GK5063@kernel.dk> <alpine.LFD.0.999.0710180952070.26902@woody.linux-foundation.org> <20071018101005.5681a365@laptopd505.fenrus.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071018101005.5681a365@laptopd505.fenrus.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 18 2007, Arjan van de Ven wrote:
> On Thu, 18 Oct 2007 09:55:04 -0700 (PDT)
> Linus Torvalds <torvalds@linux-foundation.org> wrote:
> 
> > 
> > 
> > On Thu, 18 Oct 2007, Jens Axboe wrote:
> > > -		unsigned long addr = page_to_phys(s->page) +
> > > s->offset; 
> > > +		unsigned long addr = page_to_phys(sg_page(s)) +
> > > s->offset; 
> > 
> > Umm. May I suggest (I haven't read the whole thread yet, maybe
> > somebody else already did) that
> > 
> > 	static inline unsigned long sg_phys(struct scatterlist *sg)
> > 	{
> > 		return 	page_to_phys(sg_page(sg)) + sg->offset;
> > 	}
> > 
> > would be a good thing to have?
> > 
> > Very few drivers should care so much about the *page* itself (or the 
> > offset). That's something that the generic allocation code etc cares 
> > about, but the driver is almost bound to care mostly about the actual
> > DMA address
> 
> .... but will that work for systems with IOMMU ? or is it fundamentally
> the wrong interface

They use foo_to_bus() on the address. sg_phys() should of course only be
used where the user previously did page_to_phys() on the sg page.

-- 
Jens Axboe

