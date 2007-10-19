Return-Path: <linux-kernel-owner+w=401wt.eu-S934769AbXJSJAf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934769AbXJSJAf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2007 05:00:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756961AbXJSJA1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Oct 2007 05:00:27 -0400
Received: from tama55.ecl.ntt.co.jp ([129.60.39.103]:58179 "EHLO
	tama55.ecl.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756905AbXJSJA0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2007 05:00:26 -0400
To: jens.axboe@oracle.com
Cc: arjan@infradead.org, torvalds@linux-foundation.org, davem@davemloft.net,
       fujita.tomonori@lab.ntt.co.jp, mingo@elte.hu,
       linux-kernel@vger.kernel.org, jgarzik@pobox.com,
       alan@lxorguk.ukuu.org.uk, tomof@acm.org
Subject: Re: [bug] ata subsystem related crash with latest -git
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20071018171429.GH10674@kernel.dk>
References: <alpine.LFD.0.999.0710180952070.26902@woody.linux-foundation.org>
	<20071018101005.5681a365@laptopd505.fenrus.org>
	<20071018171429.GH10674@kernel.dk>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20071019175903N.fujita.tomonori@lab.ntt.co.jp>
Date: Fri, 19 Oct 2007 17:59:03 +0900
X-Dispatcher: imput version 20040704(IM147)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 18 Oct 2007 19:14:29 +0200
Jens Axboe <jens.axboe@oracle.com> wrote:

> On Thu, Oct 18 2007, Arjan van de Ven wrote:
> > On Thu, 18 Oct 2007 09:55:04 -0700 (PDT)
> > Linus Torvalds <torvalds@linux-foundation.org> wrote:
> > 
> > > 
> > > 
> > > On Thu, 18 Oct 2007, Jens Axboe wrote:
> > > > -		unsigned long addr = page_to_phys(s->page) +
> > > > s->offset; 
> > > > +		unsigned long addr = page_to_phys(sg_page(s)) +
> > > > s->offset; 
> > > 
> > > Umm. May I suggest (I haven't read the whole thread yet, maybe
> > > somebody else already did) that
> > > 
> > > 	static inline unsigned long sg_phys(struct scatterlist *sg)
> > > 	{
> > > 		return 	page_to_phys(sg_page(sg)) + sg->offset;
> > > 	}
> > > 
> > > would be a good thing to have?
> > > 
> > > Very few drivers should care so much about the *page* itself (or the 
> > > offset). That's something that the generic allocation code etc cares 
> > > about, but the driver is almost bound to care mostly about the actual
> > > DMA address
> > 
> > .... but will that work for systems with IOMMU ? or is it fundamentally
> > the wrong interface
> 
> They use foo_to_bus() on the address. sg_phys() should of course only be
> used where the user previously did page_to_phys() on the sg page.

I can take care of IOMMU stuff when I'll send IOMMU merging fix
patchset:

http://marc.info/?l=linux-scsi&m=119079718126157&w=2
