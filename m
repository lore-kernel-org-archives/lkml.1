Return-Path: <linux-kernel-owner+w=401wt.eu-S1756111AbXJ3Q4q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756111AbXJ3Q4q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 12:56:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752461AbXJ3Q4i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 12:56:38 -0400
Received: from ns120.gr8dns.org ([193.108.181.120]:53766 "EHLO mail.gr8dns.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752155AbXJ3Q4h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 12:56:37 -0400
Date: Tue, 30 Oct 2007 09:56:08 -0700
From: Dirk Hohndel <hohndel@linux.intel.com>
To: Cornelia Huck <cornelia.huck@de.ibm.com>
Cc: Jens Axboe <jens.axboe@oracle.com>, Andries Brouwer <aeb@cwi.nl>,
       Al Viro <viro@ftp.linux.org.uk>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] add_partition silently ignored errors
Message-ID: <20071030165608.GA2601@linux.intel.com>
References: <20071029154339.00512901@gondolin.boeblingen.de.ibm.com> <20071029154849.GA24187@bigserver.hohndel.org> <20071030080742.GE4993@kernel.dk> <20071030100934.6d2a8f12@gondolin.boeblingen.de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071030100934.6d2a8f12@gondolin.boeblingen.de.ibm.com>
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 30, 2007 at 10:09:34AM +0100, Cornelia Huck wrote:
> On Tue, 30 Oct 2007 09:07:42 +0100,
> Jens Axboe <jens.axboe@oracle.com> wrote:
> 
> > >  
> > > -void add_partition(struct gendisk *disk, int part, sector_t start, sector_t len, int flags)
> > > +int add_partition(struct gendisk *disk, int part, sector_t start, sector_t len, int flags)
> > >  {
> > >  	struct hd_struct *p;
> > >  
> > >  	p = kzalloc(sizeof(*p), GFP_KERNEL);
> > >  	if (!p)
> > > -		return;
> > > +		return -1;
> > 
> > Why not return the 'correct' error codes, instead of always -1 and
> > making that -EBUSY at the caller? This one should be -ENOMEM.
> 
> Oops, you're right. I agree.

Duh. That was dumb of me.

> > IIRC, Al recently vetoed a similar patch. As far as I'm concerned, with
> > the correct return values, the patch then looks fine to me.
> 
> We need some kind of check concerning the kobject to avoid mysterious
> errors (especially checking for the failed kobject_add() is needed).
> Whether we want just to inform the user of the failure instead of
> failing the function is another question.

What are you suggesting? I'd love to make the behaviour consistent everywhere
(and am willing to go through things in order to make that happen), but what is
the consistent behaviour that we'd want?

/D
