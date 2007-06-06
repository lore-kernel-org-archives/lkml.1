Return-Path: <linux-kernel-owner+w=401wt.eu-S1752986AbXFFHT6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752986AbXFFHT6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 03:19:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751337AbXFFHTw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 03:19:52 -0400
Received: from nic.NetDirect.CA ([216.16.235.2]:47147 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751239AbXFFHTv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 03:19:51 -0400
X-Originating-Ip: 72.143.66.27
Date: Wed, 6 Jun 2007 03:18:06 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@localhost.localdomain
To: Andrew Morton <akpm@linux-foundation.org>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] lib:  Replace calls to __get_free_pages() with
 __get_dma_pages().
In-Reply-To: <20070605170601.67bc2939.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0706060317010.26345@localhost.localdomain>
References: <Pine.LNX.4.64.0706051657350.20029@localhost.localdomain>
 <20070605170601.67bc2939.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Net-Direct-Inc-MailScanner-Information: Please contact the ISP for more information
X-Net-Direct-Inc-MailScanner: Found to be clean
X-Net-Direct-Inc-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=-16.8, required 5, autolearn=not spam, ALL_TRUSTED -1.80,
	BAYES_00 -15.00, INIT_RECVD_OUR_AUTH -20.00,
	RCVD_IN_SORBS_DUL 20.00)
X-Net-Direct-Inc-MailScanner-From: rpjday@mindspring.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 5 Jun 2007, Andrew Morton wrote:

> On Tue, 5 Jun 2007 16:58:57 -0400 (EDT)
> "Robert P. J. Day" <rpjday@mindspring.com> wrote:
>
> > Replace a couple calls to __get_free_pages() with the corresponding
> > calls to __get_dma_pages().
> >
> > Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>
> >
> > ---
> >
> >   that's the lot of them.
> >
> > diff --git a/lib/swiotlb.c b/lib/swiotlb.c
> > index 10c13ad..8fc38dc 100644
> > --- a/lib/swiotlb.c
> > +++ b/lib/swiotlb.c
> > @@ -201,8 +201,7 @@ swiotlb_late_init_with_default_size(size_t default_size)
> >  	bytes = io_tlb_nslabs << IO_TLB_SHIFT;
> >
> >  	while ((SLABS_PER_PAGE << order) > IO_TLB_MIN_SLABS) {
> > -		io_tlb_start = (char *)__get_free_pages(GFP_DMA | __GFP_NOWARN,
> > -		                                        order);
> > +		io_tlb_start = (char *)__get_dma_pages(__GFP_NOWARN, order);
>
> __get_dma_pages() is just pointless obfuscation.  I think it'd be better to
> go the other way: open-code the GFP_DMA at all callsites then send
> __get_dma_pages() bitbucketwards.

i have no objection to that.  it just seemed silly to have some calls
using one form and some using the other.

rday
-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://fsdev.net/wiki/index.php?title=Main_Page
========================================================================
