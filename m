Return-Path: <linux-kernel-owner+w=401wt.eu-S1760494AbXKBT35@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760494AbXKBT35 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2007 15:29:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757615AbXKBT3s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Nov 2007 15:29:48 -0400
Received: from ns120.gr8dns.org ([193.108.181.120]:53734 "EHLO mail.gr8dns.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759272AbXKBT3s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2007 15:29:48 -0400
Date: Fri, 2 Nov 2007 12:29:14 -0700
From: Dirk Hohndel <hohndel@linux.intel.com>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Cornelia Huck <cornelia.huck@de.ibm.com>, Andries Brouwer <aeb@cwi.nl>,
       Al Viro <viro@ftp.linux.org.uk>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] add_partition silently ignored errors
Message-ID: <20071102192914.GA888@linux.intel.com>
References: <20071029154339.00512901@gondolin.boeblingen.de.ibm.com> <20071029154849.GA24187@bigserver.hohndel.org> <20071030080742.GE4993@kernel.dk> <20071030100934.6d2a8f12@gondolin.boeblingen.de.ibm.com> <20071030165608.GA2601@linux.intel.com> <20071030183112.7e860c23@gondolin.boeblingen.de.ibm.com> <20071030225635.GA3401@linux.intel.com> <20071102130438.GC28340@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071102130438.GC28340@kernel.dk>
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 02, 2007 at 02:04:39PM +0100, Jens Axboe wrote:
> > > 
> > > > > > IIRC, Al recently vetoed a similar patch. As far as I'm concerned, with
> > > > > > the correct return values, the patch then looks fine to me.
> > 
> > So Al, are you ok with this one?

Still haven't seen feedback from Al...

> > [FILESYSTEM] add_partition ignores errors
> 
> Looks good to me. One final return value note:
> 
> > @@ -554,8 +573,11 @@ int rescan_partitions(struct gendisk *disk, struct block_device *bdev)
> >  		if (from + size > get_capacity(disk)) {
> >  			printk(" %s: p%d exceeds device capacity\n",
> >  				disk->disk_name, p);
> > +			return -EBUSY;
> >  		}
> 
> -EBUSY seems a bit confusing here, although I don't know what the best
> value to return would be (and it probably doesn't matter). -EOVERFLOW?
> -ENOSPC?

I was wondering about that myself - EBUSY seemed to be used in a couple of
other cases where there wasn't a clear match, but I think EOVERFLOW actually
might make more sense. Opinions?

/D
