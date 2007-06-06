Return-Path: <linux-kernel-owner+w=401wt.eu-S1756048AbXFFHel@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756048AbXFFHel (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 03:34:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754879AbXFFHea
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 03:34:30 -0400
Received: from ug-out-1314.google.com ([66.249.92.170]:42623 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754751AbXFFHe2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 03:34:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=XobtBsEo0OBDmcgX8AMk+jUfl/m4mA52d0wyMHOaL6zRRJ5o7orijZstIUmIW7CgTgNsmXsbBD6n5Ydwe0abm7+VpzdpcryT7UK+tXlNU34RdjA67nvUueZ9VFtW4WmmZmN0kuaB+FCeIiHtwKDqO/9Ism81wnd8buxtuMC7VNg=
Message-ID: <91b13c310706060034g122e2d02oafb8a477bfc8f101@mail.gmail.com>
Date: Wed, 6 Jun 2007 15:34:27 +0800
From: "rae l" <crquan@gmail.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: [PATCH] lib: Replace calls to __get_free_pages() with __get_dma_pages().
Cc: "Robert P. J. Day" <rpjday@mindspring.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <20070605170601.67bc2939.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.64.0706051657350.20029@localhost.localdomain>
	 <20070605170601.67bc2939.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/6/07, Andrew Morton <akpm@linux-foundation.org> wrote:
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
> >       bytes = io_tlb_nslabs << IO_TLB_SHIFT;
> >
> >       while ((SLABS_PER_PAGE << order) > IO_TLB_MIN_SLABS) {
> > -             io_tlb_start = (char *)__get_free_pages(GFP_DMA | __GFP_NOWARN,
> > -                                                     order);
> > +             io_tlb_start = (char *)__get_dma_pages(__GFP_NOWARN, order);
>
> __get_dma_pages() is just pointless obfuscation.  I think it'd be better to
> go the other way: open-code the GFP_DMA at all callsites then send
> __get_dma_pages() bitbucketwards.
thus __get_free_pages(GFP_DMA ...) can do better, I don't think
__get_dma_pages is needed.

-- 
Denis Cheng
Linux Application Developer
