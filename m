Return-Path: <linux-kernel-owner+w=401wt.eu-S1760039AbXKBUaf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760039AbXKBUaf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2007 16:30:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758012AbXKBUa0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Nov 2007 16:30:26 -0400
Received: from ns120.gr8dns.org ([193.108.181.120]:55804 "EHLO mail.gr8dns.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753445AbXKBUaZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2007 16:30:25 -0400
Date: Fri, 2 Nov 2007 13:29:49 -0700
From: Dirk Hohndel <hohndel@linux.intel.com>
To: Bob Copeland <me@bobcopeland.com>
Cc: Jens Axboe <jens.axboe@oracle.com>,
       Cornelia Huck <cornelia.huck@de.ibm.com>, Andries Brouwer <aeb@cwi.nl>,
       Al Viro <viro@ftp.linux.org.uk>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] add_partition silently ignored errors
Message-ID: <20071102202949.GA1128@linux.intel.com>
References: <20071029154339.00512901@gondolin.boeblingen.de.ibm.com> <20071029154849.GA24187@bigserver.hohndel.org> <20071030080742.GE4993@kernel.dk> <20071030100934.6d2a8f12@gondolin.boeblingen.de.ibm.com> <20071030165608.GA2601@linux.intel.com> <20071030183112.7e860c23@gondolin.boeblingen.de.ibm.com> <20071030225635.GA3401@linux.intel.com> <20071102130438.GC28340@kernel.dk> <20071102192914.GA888@linux.intel.com> <b6c5339f0711021250w78fc420ekbc68e3c74b9939d3@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b6c5339f0711021250w78fc420ekbc68e3c74b9939d3@mail.gmail.com>
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 02, 2007 at 03:50:29PM -0400, Bob Copeland wrote:
> On 11/2/07, Dirk Hohndel <hohndel@linux.intel.com> wrote:
> > > > @@ -554,8 +573,11 @@ int rescan_partitions(struct gendisk *disk, struct block_device *bdev)
> > > >             if (from + size > get_capacity(disk)) {
> > > >                     printk(" %s: p%d exceeds device capacity\n",
> > > >                             disk->disk_name, p);
> > > > +                   return -EBUSY;
> [snip]
> > I was wondering about that myself - EBUSY seemed to be used in a couple of
> > other cases where there wasn't a clear match, but I think EOVERFLOW actually
> > might make more sense. Opinions?
> 
> ISTR that some people wanted to keep going in this case rather than
> return an error, e.g. for forensic purposes...
> 
> .. digging... here's a thread from last year:
> 
> http://lkml.org/lkml/2006/5/11/64

Thanks for finding that! I took a different approach than Andries but can
appreciate the argument. I'll remove that line from my patch.

/D
