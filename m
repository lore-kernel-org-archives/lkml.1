Return-Path: <linux-kernel-owner+w=401wt.eu-S1762857AbXEJWAx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762857AbXEJWAx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 18:00:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759358AbXEJWAp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 18:00:45 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:41297 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759085AbXEJWAp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 18:00:45 -0400
Date: Thu, 10 May 2007 23:38:39 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Benny Halevy <bhalevy@panasas.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 8/12] x86-64: update iommu/dma mapping functions to sg  helpers
Message-ID: <20070510213839.GZ4163@kernel.dk>
References: <11787972373654-git-send-email-jens.axboe@oracle.com> <11787972373765-git-send-email-jens.axboe@oracle.com> <464322BC.50101@panasas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <464322BC.50101@panasas.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 10 2007, Benny Halevy wrote:
> Jens Axboe wrote:
> <snip>
> > @@ -323,13 +324,17 @@ static int __dma_map_cont(struct scatterlist *sg, int start, int stopat,
> >  {
> >  	unsigned long iommu_start = alloc_iommu(pages);
> >  	unsigned long iommu_page = iommu_start; 
> > -	int i;
> > +	struct scatterlist *s;
> > +	int i, nelems;
> >  
> >  	if (iommu_start == -1)
> >  		return -1;
> > +
> > +	nelems = stopat - start;
> > +	while (start--)
> > +		sg = sg_next(sg);
> 
> Ouch.  This will suck if we merge many times in a long list.
> How about keeping and passing start as a struct scatterlist * rather
> than an index? (see attached example, (compiles, bu untested though)

It will suck indeed, I like your patch! I'll review and incorporate.
Your other points are good, noted.

-- 
Jens Axboe

