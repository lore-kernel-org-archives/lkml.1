Return-Path: <linux-kernel-owner+w=401wt.eu-S932963AbXJROGi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932963AbXJROGi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2007 10:06:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753645AbXJROGb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Oct 2007 10:06:31 -0400
Received: from brick.kernel.dk ([87.55.233.238]:19521 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751706AbXJROGa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2007 10:06:30 -0400
Date: Thu, 18 Oct 2007 16:05:50 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Benny Halevy <bhalevy@panasas.com>
Cc: David Miller <davem@davemloft.net>, torvalds@linux-foundation.org,
       fujita.tomonori@lab.ntt.co.jp, mingo@elte.hu,
       linux-kernel@vger.kernel.org, jgarzik@pobox.com,
       alan@lxorguk.ukuu.org.uk, tomof@acm.org
Subject: Re: [bug] ata subsystem related crash with latest -git
Message-ID: <20071018140550.GO5063@kernel.dk>
References: <20071018082145.GK5063@kernel.dk> <20071018.045505.106265100.davem@davemloft.net> <20071018115702.GW5063@kernel.dk> <20071018.050554.115911163.davem@davemloft.net> <20071018120950.GX5063@kernel.dk> <20071018121547.GY5063@kernel.dk> <4717587E.6090301@panasas.com> <20071018135605.GL5063@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071018135605.GL5063@kernel.dk>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 18 2007, Jens Axboe wrote:
> On Thu, Oct 18 2007, Benny Halevy wrote:
> > >  	return sg;
> > >  }
> > > @@ -83,6 +96,9 @@ static inline struct scatterlist *sg_last(struct scatterlist *sgl,
> > >  		ret = sg;
> > >  
> > >  #endif
> > > +#ifdef CONFIG_DEBUG_SG
> > > +	BUG_ON(sgl[0].sg_magic != SG_MAGIC);
> > 
> > can it also do BUG_ON(!sg_is_last(sg))?
> 
> That would make sense, definitely. I'll add that.

        BUG_ON(!sg_is_last(ret));

it should be, not sg. That's what I merged.

-- 
Jens Axboe

