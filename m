Return-Path: <linux-kernel-owner+w=401wt.eu-S1765120AbXJRRBl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765120AbXJRRBl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2007 13:01:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756776AbXJRRBe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Oct 2007 13:01:34 -0400
Received: from brick.kernel.dk ([87.55.233.238]:21549 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756754AbXJRRBd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2007 13:01:33 -0400
Date: Thu, 18 Oct 2007 19:01:29 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: David Miller <davem@davemloft.net>, fujita.tomonori@lab.ntt.co.jp,
       mingo@elte.hu, linux-kernel@vger.kernel.org, jgarzik@pobox.com,
       alan@lxorguk.ukuu.org.uk, tomof@acm.org
Subject: Re: [bug] ata subsystem related crash with latest -git
Message-ID: <20071018170128.GF10674@kernel.dk>
References: <alpine.LFD.0.999.0710171342550.26902@woody.linux-foundation.org> <20071018080048O.fujita.tomonori@lab.ntt.co.jp> <alpine.LFD.0.999.0710171801000.26902@woody.linux-foundation.org> <20071017.181907.63126798.davem@davemloft.net> <20071018082145.GK5063@kernel.dk> <alpine.LFD.0.999.0710180952070.26902@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.999.0710180952070.26902@woody.linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 18 2007, Linus Torvalds wrote:
> 
> 
> On Thu, 18 Oct 2007, Jens Axboe wrote:
> > -		unsigned long addr = page_to_phys(s->page) + s->offset; 
> > +		unsigned long addr = page_to_phys(sg_page(s)) + s->offset; 
> 
> Umm. May I suggest (I haven't read the whole thread yet, maybe somebody 
> else already did) that
> 
> 	static inline unsigned long sg_phys(struct scatterlist *sg)
> 	{
> 		return 	page_to_phys(sg_page(sg)) + sg->offset;
> 	}
> 
> would be a good thing to have?

Sure thing, it's used quite a lot.

> Very few drivers should care so much about the *page* itself (or the 
> offset). That's something that the generic allocation code etc cares 
> about, but the driver is almost bound to care mostly about the actual DMA 
> address, so adding that helper function that abstracts the sg access would 
> be helpful in hiding some of the cruft?

I'll add it to the mix.

-- 
Jens Axboe

