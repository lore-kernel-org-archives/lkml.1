Return-Path: <linux-kernel-owner+w=401wt.eu-S1755402AbXKBNEu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755402AbXKBNEu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2007 09:04:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753615AbXKBNEo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Nov 2007 09:04:44 -0400
Received: from brick.kernel.dk ([87.55.233.238]:23147 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753018AbXKBNEn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2007 09:04:43 -0400
Date: Fri, 2 Nov 2007 14:04:39 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Dirk Hohndel <hohndel@linux.intel.com>
Cc: Cornelia Huck <cornelia.huck@de.ibm.com>, Andries Brouwer <aeb@cwi.nl>,
       Al Viro <viro@ftp.linux.org.uk>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] add_partition silently ignored errors
Message-ID: <20071102130438.GC28340@kernel.dk>
References: <20071029154339.00512901@gondolin.boeblingen.de.ibm.com> <20071029154849.GA24187@bigserver.hohndel.org> <20071030080742.GE4993@kernel.dk> <20071030100934.6d2a8f12@gondolin.boeblingen.de.ibm.com> <20071030165608.GA2601@linux.intel.com> <20071030183112.7e860c23@gondolin.boeblingen.de.ibm.com> <20071030225635.GA3401@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071030225635.GA3401@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 30 2007, Dirk Hohndel wrote:
> On Tue, Oct 30, 2007 at 06:31:12PM +0100, Cornelia Huck wrote:
> > On Tue, 30 Oct 2007 09:56:08 -0700,
> > Dirk Hohndel <hohndel@linux.intel.com> wrote:
> > 
> > > > > IIRC, Al recently vetoed a similar patch. As far as I'm concerned, with
> > > > > the correct return values, the patch then looks fine to me.
> 
> So Al, are you ok with this one?
> 
> > > > We need some kind of check concerning the kobject to avoid mysterious
> > > > errors (especially checking for the failed kobject_add() is needed).
> > > > Whether we want just to inform the user of the failure instead of
> > > > failing the function is another question.
> > > 
> > > What are you suggesting? I'd love to make the behaviour consistent everywhere
> > > (and am willing to go through things in order to make that happen), but what is
> > > the consistent behaviour that we'd want?
> > 
> > I'd be fine with just propagating the error after cleanup (that is what
> > for example the driver core usually does), but I don't know the
> > surrounding code well enough for a definitive answer.
> 
> Ok, I think I have it consistent now. I also ran it through checkpatch.pl :-)
> 
> /D
> 
> 
> [FILESYSTEM] add_partition ignores errors

Looks good to me. One final return value note:

> @@ -554,8 +573,11 @@ int rescan_partitions(struct gendisk *disk, struct block_device *bdev)
>  		if (from + size > get_capacity(disk)) {
>  			printk(" %s: p%d exceeds device capacity\n",
>  				disk->disk_name, p);
> +			return -EBUSY;
>  		}

-EBUSY seems a bit confusing here, although I don't know what the best
value to return would be (and it probably doesn't matter). -EOVERFLOW?
-ENOSPC?

-- 
Jens Axboe

