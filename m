Return-Path: <linux-kernel-owner+w=401wt.eu-S1759351AbXKBTuj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759351AbXKBTuj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2007 15:50:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754039AbXKBTuc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Nov 2007 15:50:32 -0400
Received: from nz-out-0506.google.com ([64.233.162.228]:28996 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753837AbXKBTub (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2007 15:50:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=Mg5BfuEaUQbhRRnGfsnTtFkPxz4r/chk/4LxtoHCwUZLcrhEXBYLrkZ5G0kp1+A8EPkAmRUenDVp5t2Gqz0ZxK8h3ZCxOzoale8jaxzNkHrsRuAb6+JRCLU1EhASrHPPL3GRK/Wmr2j8Xi9wNuXrfM1s6QLIBDUBNd14ugTaUWY=
Message-ID: <b6c5339f0711021250w78fc420ekbc68e3c74b9939d3@mail.gmail.com>
Date: Fri, 2 Nov 2007 15:50:29 -0400
From: "Bob Copeland" <me@bobcopeland.com>
To: "Dirk Hohndel" <hohndel@linux.intel.com>
Subject: Re: [PATCH] add_partition silently ignored errors
Cc: "Jens Axboe" <jens.axboe@oracle.com>,
       "Cornelia Huck" <cornelia.huck@de.ibm.com>,
       "Andries Brouwer" <aeb@cwi.nl>, "Al Viro" <viro@ftp.linux.org.uk>,
       linux-kernel@vger.kernel.org,
       "Linus Torvalds" <torvalds@linux-foundation.org>
In-Reply-To: <20071102192914.GA888@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20071029154339.00512901@gondolin.boeblingen.de.ibm.com>
	 <20071029154849.GA24187@bigserver.hohndel.org>
	 <20071030080742.GE4993@kernel.dk>
	 <20071030100934.6d2a8f12@gondolin.boeblingen.de.ibm.com>
	 <20071030165608.GA2601@linux.intel.com>
	 <20071030183112.7e860c23@gondolin.boeblingen.de.ibm.com>
	 <20071030225635.GA3401@linux.intel.com>
	 <20071102130438.GC28340@kernel.dk>
	 <20071102192914.GA888@linux.intel.com>
X-Google-Sender-Auth: 24e3be2766e7785b
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/2/07, Dirk Hohndel <hohndel@linux.intel.com> wrote:
> > > @@ -554,8 +573,11 @@ int rescan_partitions(struct gendisk *disk, struct block_device *bdev)
> > >             if (from + size > get_capacity(disk)) {
> > >                     printk(" %s: p%d exceeds device capacity\n",
> > >                             disk->disk_name, p);
> > > +                   return -EBUSY;
[snip]
> I was wondering about that myself - EBUSY seemed to be used in a couple of
> other cases where there wasn't a clear match, but I think EOVERFLOW actually
> might make more sense. Opinions?

ISTR that some people wanted to keep going in this case rather than
return an error, e.g. for forensic purposes...

.. digging... here's a thread from last year:

http://lkml.org/lkml/2006/5/11/64

-Bob
