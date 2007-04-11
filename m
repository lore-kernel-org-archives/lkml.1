Return-Path: <linux-kernel-owner+w=401wt.eu-S1030770AbXDKEA2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030770AbXDKEA2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2007 00:00:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030778AbXDKEA1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Apr 2007 00:00:27 -0400
Received: from ozlabs.org ([203.10.76.45]:34397 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030770AbXDKEA0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2007 00:00:26 -0400
Subject: Re: PATCH 7/8] lguest: the block driver
From: Rusty Russell <rusty@rustcorp.com.au>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
       virtualization <virtualization@lists.linux-foundation.org>,
       Andi Kleen <ak@muc.de>, jens.axboe@oracle.com
In-Reply-To: <84144f020704100436y3405f104x8345c72556d961e9@mail.gmail.com>
References: <1176203068.26372.21.camel@localhost.localdomain>
	 <1176203130.26372.23.camel@localhost.localdomain>
	 <1176203176.26372.25.camel@localhost.localdomain>
	 <1176203231.26372.27.camel@localhost.localdomain>
	 <1176203285.26372.29.camel@localhost.localdomain>
	 <1176203333.26372.31.camel@localhost.localdomain>
	 <1176203475.26372.37.camel@localhost.localdomain>
	 <1176203528.26372.40.camel@localhost.localdomain>
	 <84144f020704100428r6e35e34cued8758c94728a6a0@mail.gmail.com>
	 <84144f020704100436y3405f104x8345c72556d961e9@mail.gmail.com>
Content-Type: text/plain
Date: Wed, 11 Apr 2007 14:00:24 +1000
Message-Id: <1176264024.26372.93.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-04-10 at 14:36 +0300, Pekka Enberg wrote:
> On 4/10/07, Rusty Russell <rusty@rustcorp.com.au> wrote:
> > > +/* Jens gave me this nice helper to end all chunks of a request. */
> > > +static void end_entire_request(struct request *req, int uptodate)
> > > +{
> > > +       if (end_that_request_first(req, uptodate, req->hard_nr_sectors))
> > > +               BUG();
> > > +       add_disk_randomness(req->rq_disk);
> > > +       blkdev_dequeue_request(req);
> > > +       end_that_request_last(req, uptodate);
> > > +}
> 
> On 4/10/07, Pekka Enberg <penberg@cs.helsinki.fi> wrote:
> > Perhaps we should move this to generic code (i.e. block/ll_rw_blk.c)?

Yeah, Jens said to put it in here and he'd hoist it later.

> Uhm, I am bit confused now. Why don't you just use end_request() here?

What a question!  end_request() doesn't end a request!  What a crazy
idea!

As far as I can tell, every name in the block layer is actually some
variant of "fuck off, this is too complicated for you to understand".

Hope that clarifies!
Rusty.

