Return-Path: <linux-kernel-owner+w=401wt.eu-S1752012AbZIYArQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752012AbZIYArQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Sep 2009 20:47:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751289AbZIYArP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Sep 2009 20:47:15 -0400
Received: from mga03.intel.com ([143.182.124.21]:51671 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750911AbZIYArO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Sep 2009 20:47:14 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,448,1249282800"; 
   d="scan'208";a="191451449"
Date: Fri, 25 Sep 2009 08:47:07 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Jens Axboe <jens.axboe@oracle.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "Li, Shaohua" <shaohua.li@intel.com>,
       "chris.mason@oracle.com" <chris.mason@oracle.com>,
       "jack@suse.cz" <jack@suse.cz>
Subject: Re: [PATCH 03/10] writeback: stop background writeback when below
	background threshold
Message-ID: <20090925004707.GA6190@localhost>
References: <1253803236-20760-1-git-send-email-jens.axboe@oracle.com> <1253803236-20760-4-git-send-email-jens.axboe@oracle.com> <1253804615.18939.36.camel@laptop> <1253805536.18939.39.camel@laptop> <20090924161357.GL23126@kernel.dk> <1253809560.18939.69.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1253809560.18939.69.camel@laptop>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 25, 2009 at 12:26:00AM +0800, Peter Zijlstra wrote:
> On Thu, 2009-09-24 at 18:13 +0200, Jens Axboe wrote:
> 
> > > > >  	for (;;) {
> > > > >  		/*
> > > > > +		 * Stop writeback when nr_pages has been consumed
> > > > >  		 */
> > > > > +		if (args->nr_pages <= 0)
> > > > >  			break;
> > > > >  
> > > > >  		/*
> > > > > +		 * For background writeout, stop when we are below the
> > > > > +		 * background dirty threshold
> > > > >  		 */
> > > > > +		if (args->for_background && !over_bground_thresh())
> > > > >  			break;
> > > > 
> > > > 
> > > > What I'm not getting is why this is conditional on for_background(),
> > > > shouldn't we always stop writeback when below the background threshold?
> > > 
> > > Ah, that would be for things like sync, which need to write out
> > > everything, right?

Besides sync, it's reasonable for periodic writeback to write all
inodes as long as they are expired.

> > Yes, wb_writeback() handles any kind of writeback. The definition of our
> > background writeout is to stop when we are no longer over the background
> > writeout threshold.
> 
> Right, ok
> 
> Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>

Thanks! This patch was partly inspired by your comments :)

Regards,
Fengguang
