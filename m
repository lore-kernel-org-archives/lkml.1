Return-Path: <linux-kernel-owner+w=401wt.eu-S1764980AbXJRRL3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764980AbXJRRL3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2007 13:11:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933604AbXJRRLA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Oct 2007 13:11:00 -0400
Received: from brick.kernel.dk ([87.55.233.238]:10412 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760588AbXJRRK7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2007 13:10:59 -0400
Date: Thu, 18 Oct 2007 19:10:54 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: David Miller <davem@davemloft.net>, fujita.tomonori@lab.ntt.co.jp,
       mingo@elte.hu, linux-kernel@vger.kernel.org, jgarzik@pobox.com,
       alan@lxorguk.ukuu.org.uk, tomof@acm.org
Subject: Re: [bug] ata subsystem related crash with latest -git
Message-ID: <20071018171054.GG10674@kernel.dk>
References: <alpine.LFD.0.999.0710171342550.26902@woody.linux-foundation.org> <20071018080048O.fujita.tomonori@lab.ntt.co.jp> <alpine.LFD.0.999.0710171801000.26902@woody.linux-foundation.org> <20071017.181907.63126798.davem@davemloft.net> <20071018082145.GK5063@kernel.dk> <alpine.LFD.0.999.0710180952070.26902@woody.linux-foundation.org> <20071018170128.GF10674@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071018170128.GF10674@kernel.dk>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 18 2007, Jens Axboe wrote:
> On Thu, Oct 18 2007, Linus Torvalds wrote:
> > 
> > 
> > On Thu, 18 Oct 2007, Jens Axboe wrote:
> > > -		unsigned long addr = page_to_phys(s->page) + s->offset; 
> > > +		unsigned long addr = page_to_phys(sg_page(s)) + s->offset; 
> > 
> > Umm. May I suggest (I haven't read the whole thread yet, maybe somebody 
> > else already did) that
> > 
> > 	static inline unsigned long sg_phys(struct scatterlist *sg)
> > 	{
> > 		return 	page_to_phys(sg_page(sg)) + sg->offset;
> > 	}
> > 
> > would be a good thing to have?
> 
> Sure thing, it's used quite a lot.

Actually, only 11 occurrences in the patch. But still a nice little
cleanup.

-- 
Jens Axboe

