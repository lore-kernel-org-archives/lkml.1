Return-Path: <linux-kernel-owner+w=401wt.eu-S1763905AbXGRWfh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763905AbXGRWfh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 18:35:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760169AbXGRWf3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 18:35:29 -0400
Received: from ik-out-1112.google.com ([66.249.90.179]:60319 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759657AbXGRWf2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 18:35:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=jF/AvTjQ4AZixBIk73QkJLaQLdBQTYx1dgjq3IKK0NAJ4Q021mm2WORpB6UT+RVoBHEKQG627NN5uGL2BxS960LksLaxrOcj0zihnBYq6uiUjg1QotSJtYx0NSFEEDdr3h4zwS9dCtKpDVhUuVOuMVE9SqQkGdYNmMwTSIuXPyc=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: regression: disk error loop (panic?) ide_do_rw_disk-bad:
Date: Thu, 19 Jul 2007 00:53:24 +0200
User-Agent: KMail/1.9.6
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Giacomo Catenazzi <cate@cateee.net>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       akpm@linux-foundation.org
References: <469D1D5E.8050609@cateee.net> <alpine.LFD.0.999.0707181313100.27353@woody.linux-foundation.org> <20070718202740.GN11657@kernel.dk>
In-Reply-To: <20070718202740.GN11657@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707190053.24578.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 18 July 2007, Jens Axboe wrote:
> On Wed, Jul 18 2007, Linus Torvalds wrote:
> > 
> > 
> > On Wed, 18 Jul 2007, Jens Axboe wrote:
> > > 
> > > I think your analysis is pretty good, however you'd probably want to
> > > incorporate that direct in ide_end_request().
> > 
> > Ok, that makes sense too.
> > 
> > And yes, the further cleanup would be:
> > 
> > > Better still would be to make __ide_end_request() take a byte count
> > > instead and use end_that_request_chunk(). Then you can get rid of the
> > > rounding as well.
> > 
> > and that sounds fine, but is an independent issue and not strictly 
> > necessary.
> 
> Oh yeah, it's just a further improvement, not strictly necessary for
> fixing this bug. So it could be done at a later time, all up to Bart...

Thanks for finding and fixing this.

The latest patch (with additional cleanups) also looks good and should be
safe enough (unchanged behavior for all non-pc requests) to merge it now.

Acked-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>

Thanks,
Bart
