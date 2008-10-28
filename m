Return-Path: <linux-kernel-owner+w=401wt.eu-S1752526AbYJ1QDY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752526AbYJ1QDY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2008 12:03:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752127AbYJ1QDO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Oct 2008 12:03:14 -0400
Received: from mx2.redhat.com ([66.187.237.31]:54589 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752081AbYJ1QDN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2008 12:03:13 -0400
Date: Tue, 28 Oct 2008 12:00:31 -0400 (EDT)
Message-Id: <20081028.120031.71084925.k-ueda@ct.jp.nec.com>
To: nikanth@gmail.com
Cc: dm-devel@redhat.com, jens.axboe@oracle.com, agk@redhat.com,
       James.Bottomley@hansenpartnership.com, j-nomura@ce.jp.nec.com,
       linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
       knikanth@suse.de, k-ueda@ct.jp.nec.com
Subject: Re: [dm-devel] [PATCH 10/13] dm: add core functions for
 request-based dm
From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
In-Reply-To: <807b3a220810240044v1b9f12e3xc3bd5a429b9d4c5@mail.gmail.com>
References: <20080912.103814.74754581.k-ueda@ct.jp.nec.com>
	<20080912.104612.115643090.k-ueda@ct.jp.nec.com>
	<807b3a220810240044v1b9f12e3xc3bd5a429b9d4c5@mail.gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Nikanth,

On Fri, 24 Oct 2008 13:14:50 +0530, "Nikanth K" wrote:
> On Fri, Sep 12, 2008 at 8:16 PM, Kiyoshi Ueda wrote:
> <snip>
> 
> > +static int dm_make_request(struct request_queue *q, struct bio *bio)
> > +{
> > +       struct mapped_device *md = (struct mapped_device *)q->queuedata;
> > +
> > +       if (unlikely(bio_barrier(bio))) {
> > +               bio_endio(bio, -EOPNOTSUPP);
> > +               return 0;
> > +       }
> > +
> <snip>
> 
> Why not add barrier support in the beginning itself, so that targets
> can be developed with barriers in mind? At least can we make the target
> to return error, instead of the core?

Currently, there is no barrier support in dm, not only request-based.
Barrier support is a different feature in the next step, I think.

As you noticed in the PATCH#11, current request-based dm has
the limitation that multiple targets are not supported, so it may
look barrier support in request-based dm is easy.
But we may be able to remove the limitation in the future, so
depending on it is not a good idea.

Thanks,
Kiyoshi Ueda
