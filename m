Return-Path: <linux-kernel-owner+w=401wt.eu-S932663AbXBGBkp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932663AbXBGBkp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Feb 2007 20:40:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752269AbXBGBkp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Feb 2007 20:40:45 -0500
Received: from smtp.osdl.org ([65.172.181.24]:58559 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751446AbXBGBko (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Feb 2007 20:40:44 -0500
Date: Tue, 6 Feb 2007 17:40:35 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Neil Brown <neilb@suse.de>
Cc: "Kai" <epimetreus@fastmail.fm>, stable@suse.de, org@suse.de,
       linux-kernel@vger.kernel.org, Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH] Re: Bio device too big | kernel BUG at
 mm/filemap.c:537!
Message-Id: <20070206174035.eccb4e3b.akpm@linux-foundation.org>
In-Reply-To: <17865.11199.612391.738320@notabene.brown>
References: <1170734919.15636.1173102761@webmail.messagingengine.com>
	<20070205203750.7be7f772.akpm@linux-foundation.org>
	<17864.4339.925700.626157@notabene.brown>
	<17865.3776.511594.763544@notabene.brown>
	<20070206171509.f92e0ed2.akpm@linux-foundation.org>
	<17865.11199.612391.738320@notabene.brown>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 7 Feb 2007 12:30:39 +1100
Neil Brown <neilb@suse.de> wrote:

> On Tuesday February 6, akpm@linux-foundation.org wrote:
> > On Wed, 7 Feb 2007 10:26:56 +1100
> > Neil Brown <neilb@suse.de> wrote:
> > 
> > > +static int bio_fits_rdev(struct bio *bi)
> > > +{
> > > +	request_queue_t *q = bdev_get_queue(bi->bi_bdev);
> > > +
> > > +	if ((bi->bi_size>>9) > q->max_sectors)
> > > +		return 0;
> > > +	blk_recount_segments(q, bi);
> > > +	if (bi->bi_phys_segments > q->max_phys_segments ||
> > > +	    bi->bi_hw_segments > q->max_hw_segments)
> > > +		return 0;
> > > +
> > > +	if (q->merge_bvec_fn)
> > > +		/* it's too hard to apply the merge_bvec_fn at this stage,
> > > +		 * just just give up
> > > +		 */
> > > +		return 0;
> > > +
> > > +	return 1;
> > > +}
> > 
> > Isn't think going to return 0 rather a lot of the time?
> 
> Why do you say that?

Because I was too lazy to go off and work out who's setting merge_bvec_fn.

> merge_bvec_fn is only set for dm, md, pktcdvd.c so what won't cause a
> zero in real-world cases (it rarely makes sense to put a raid5 on top
> of those things).

OK.   Hopefully it'll stay that way...

