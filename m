Return-Path: <linux-kernel-owner+w=401wt.eu-S1030680AbXDULKo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030680AbXDULKo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Apr 2007 07:10:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030694AbXDULKo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Apr 2007 07:10:44 -0400
Received: from amsfep16-int.chello.nl ([62.179.120.11]:40606 "EHLO
	amsfep16-int.chello.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030680AbXDULKn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Apr 2007 07:10:43 -0400
Subject: Re: [PATCH 09/10] mm: expose BDI statistics in sysfs.
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, miklos@szeredi.hu,
       neilb@suse.de, dgc@sgi.com, tomoki.sekiyama.qu@hitachi.com,
       nikita@clusterfs.com, trond.myklebust@fys.uio.no,
       yingchao.zhou@gmail.com
In-Reply-To: <20070421025528.03105b60.akpm@linux-foundation.org>
References: <20070420155154.898600123@chello.nl>
	 <20070420155503.473053637@chello.nl>
	 <20070421025528.03105b60.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Sat, 21 Apr 2007 13:08:51 +0200
Message-Id: <1177153731.2934.46.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2007-04-21 at 02:55 -0700, Andrew Morton wrote:
> On Fri, 20 Apr 2007 17:52:03 +0200 Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> 
> > Expose the per BDI stats in /sys/block/<dev>/queue/*
> > 
> > Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> > ---
> >  block/ll_rw_blk.c |   32 ++++++++++++++++++++++++++++++++
> >  1 file changed, 32 insertions(+)
> > 
> > Index: linux-2.6-mm/block/ll_rw_blk.c
> > ===================================================================
> > --- linux-2.6-mm.orig/block/ll_rw_blk.c
> > +++ linux-2.6-mm/block/ll_rw_blk.c
> > @@ -3976,6 +3976,15 @@ static ssize_t queue_max_hw_sectors_show
> >  	return queue_var_show(max_hw_sectors_kb, (page));
> >  }
> >  
> > +static ssize_t queue_nr_reclaimable_show(struct request_queue *q, char *page)
> > +{
> > +	return sprintf(page, "%lld\n", bdi_stat(&q->backing_dev_info, BDI_RECLAIMABLE));
> > +}
> 
> We try to present memory statistics to userspace in bytes or kbytes rather
> than number-of-pages.  Because page-size varies between architectures and
> between .configs.  Displaying number-of-pages is just inviting people to write
> it-broke-when-i-moved-it-to-ia64 applications.
> 
> Plus kbytes is a bit more user-friendly, particularly when the user will
> want to compare these numbers to /proc/meminfo, for example.
> 
> Using %llu might be more appropriate than %lld.


Right, the biggest problem I actually have with his piece of code is
that is does not represent all BDIs in the system. For example, the BDI
of NFS mounts is not accessible.

Will fix the other points.

