Return-Path: <linux-kernel-owner+w=401wt.eu-S936226AbXJQRbp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936226AbXJQRbp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2007 13:31:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762643AbXJQRbe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Oct 2007 13:31:34 -0400
Received: from brick.kernel.dk ([87.55.233.238]:9454 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761964AbXJQRbd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2007 13:31:33 -0400
Date: Wed, 17 Oct 2007 19:31:29 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [bug] block subsystem related crash with latest -git
Message-ID: <20071017173128.GJ15552@kernel.dk>
References: <20071017154655.GA13394@elte.hu> <alpine.LFD.0.999.0710170929270.26902@woody.linux-foundation.org> <20071017165949.GF15552@kernel.dk> <20071017170804.GG15552@kernel.dk> <20071017172158.GH15552@kernel.dk> <20071017173001.GA1266@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071017173001.GA1266@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 17 2007, Ingo Molnar wrote:
> 
> * Jens Axboe <jens.axboe@oracle.com> wrote:
> 
> > > -			sg = next_sg;
> > > -			next_sg = sg_next(sg);
> > > +			if (!sg)
> > > +				sg = sglist;
> > > +			else
> > > +				sg = sg_next(sg);
> > >  
> > >  			memset(sg, 0, sizeof(*sg));
> > >  			sg->page = bvec->bv_page;
> > > 
> > 
> > Scratch that, it cannot work... I'll think up a different approach.
> 
> too late, crashed my box with it already :-)

Sorry about that, please try the next one that includes the scsi_lib.c
one liner to clear the sg table on alloc :-)

-- 
Jens Axboe

