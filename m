Return-Path: <linux-kernel-owner+w=401wt.eu-S1763550AbXLMTbo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763550AbXLMTbo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 14:31:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759060AbXLMTbg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 14:31:36 -0500
Received: from blue.zero.ad.jp ([211.11.96.147]:37031 "EHLO blue.zero.ad.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757501AbXLMTbf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 14:31:35 -0500
X-Greylist: delayed 2066 seconds by postgrey-1.27 at vger.kernel.org; Thu, 13 Dec 2007 14:31:35 EST
Date: Thu, 13 Dec 2007 13:57:11 -0500 (EST)
Message-Id: <20071213.135711.59651704.k-ueda@ct.jp.nec.com>
To: Mike.Miller@hp.com, jmarchan@redhat.com, axboe@kernel.dk
Cc: linux-kernel@vger.kernel.org, j-nomura@ce.jp.nec.com, k-ueda@ct.jp.nec.com
Subject: Re: [Patch 4/8] Enhanced partition statistics: cciss fix
From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
In-Reply-To: <DEE40752C8AF224BB890E455C7B8E0FE157ACB37@G6W0268.americas.hpqcorp.net>
References: <47615B2E.1040608@redhat.com>
	<DEE40752C8AF224BB890E455C7B8E0FE157ACB37@G6W0268.americas.hpqcorp.net>
X-Mailer: Mew version 4.2 on Emacs 21.4 / Mule 5.0
 =?iso-2022-jp?B?KBskQjgtTFobKEIp?=
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Thank you for noticing this, Mike.

On Thu, 13 Dec 2007 16:55:06 +0000, "Miller, Mike" wrote:
> > Updates the enhanced partition statistics in cciss driver.
> >
> > Signed-off-by: Jerome Marchand <jmarchan@redhat.com>
> > ---
> >  cciss.c |    3 ++-
> >  1 file changed, 2 insertions(+), 1 deletion(-) diff -urNp -X
> > linux-2.6/Documentation/dontdiff
> > linux-2.6.orig/drivers/block/cciss.c linux-2.6/drivers/block/cciss.c
> > --- linux-2.6.orig/drivers/block/cciss.c        2007-12-04
> > 17:37:13.000000000 +0100
> > +++ linux-2.6/drivers/block/cciss.c     2007-12-05
> > 13:46:29.000000000 +0100
> > @@ -1268,7 +1268,8 @@ static void cciss_softirq_done(struct re
> >         if (blk_fs_request(rq)) {
> >                 const int rw = rq_data_dir(rq);
> >
> > -               disk_stat_add(rq->rq_disk, sectors[rw],
> > rq->nr_sectors);
> > +               all_stat_add(rq->rq_disk, sectors[rw],
> > +                            rq->nr_sectors, rq->sector);
> >         }
> 
> How does this mesh with the changes submitted by Kiyoshi Ueda? Any conflicts?
 
I think no conflict with my patch technically.

Jerome's patch changes __end_that_request_first(), too, as same as
the change above.
And my patch changes cciss/cpqarray to use blk_end_request, which
uses __end_that_request_first() internally, instead of doing
disk_stat_add() by themselves.
(http://marc.info/?l=linux-kernel&m=119741542206258&w=2)

So Jerome can just drop the cciss/cpqarray changes from his patch-set,
if my patch-set is merged.

> -- mikem

Thanks,
Kiyoshi Ueda
