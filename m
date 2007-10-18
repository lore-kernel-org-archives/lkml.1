Return-Path: <linux-kernel-owner+w=401wt.eu-S933832AbXJRRNl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933832AbXJRRNl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2007 13:13:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758279AbXJRRNc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Oct 2007 13:13:32 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:46572 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753183AbXJRRNb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2007 13:13:31 -0400
Date: Thu, 18 Oct 2007 10:10:05 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jens Axboe <jens.axboe@oracle.com>, David Miller <davem@davemloft.net>,
       fujita.tomonori@lab.ntt.co.jp, mingo@elte.hu,
       linux-kernel@vger.kernel.org, jgarzik@pobox.com,
       alan@lxorguk.ukuu.org.uk, tomof@acm.org
Subject: Re: [bug] ata subsystem related crash with latest -git
Message-ID: <20071018101005.5681a365@laptopd505.fenrus.org>
In-Reply-To: <alpine.LFD.0.999.0710180952070.26902@woody.linux-foundation.org>
References: <alpine.LFD.0.999.0710171342550.26902@woody.linux-foundation.org>
	<20071018080048O.fujita.tomonori@lab.ntt.co.jp>
	<alpine.LFD.0.999.0710171801000.26902@woody.linux-foundation.org>
	<20071017.181907.63126798.davem@davemloft.net>
	<20071018082145.GK5063@kernel.dk>
	<alpine.LFD.0.999.0710180952070.26902@woody.linux-foundation.org>
Organization: Intel
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.0; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 18 Oct 2007 09:55:04 -0700 (PDT)
Linus Torvalds <torvalds@linux-foundation.org> wrote:

> 
> 
> On Thu, 18 Oct 2007, Jens Axboe wrote:
> > -		unsigned long addr = page_to_phys(s->page) +
> > s->offset; 
> > +		unsigned long addr = page_to_phys(sg_page(s)) +
> > s->offset; 
> 
> Umm. May I suggest (I haven't read the whole thread yet, maybe
> somebody else already did) that
> 
> 	static inline unsigned long sg_phys(struct scatterlist *sg)
> 	{
> 		return 	page_to_phys(sg_page(sg)) + sg->offset;
> 	}
> 
> would be a good thing to have?
> 
> Very few drivers should care so much about the *page* itself (or the 
> offset). That's something that the generic allocation code etc cares 
> about, but the driver is almost bound to care mostly about the actual
> DMA address

.... but will that work for systems with IOMMU ? or is it fundamentally
the wrong interface
