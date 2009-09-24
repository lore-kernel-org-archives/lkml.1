Return-Path: <linux-kernel-owner+w=401wt.eu-S1753140AbZIXQ0E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753140AbZIXQ0E (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Sep 2009 12:26:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752935AbZIXQ0E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Sep 2009 12:26:04 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:39839 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752450AbZIXQ0C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Sep 2009 12:26:02 -0400
Subject: Re: [PATCH 03/10] writeback: stop background writeback when below
 background threshold
From: Peter Zijlstra <peterz@infradead.org>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: linux-kernel@vger.kernel.org, fengguang.wu@intel.com, shaohua.li@intel.com,
       chris.mason@oracle.com, jack@suse.cz
In-Reply-To: <20090924161357.GL23126@kernel.dk>
References: <1253803236-20760-1-git-send-email-jens.axboe@oracle.com>
	 <1253803236-20760-4-git-send-email-jens.axboe@oracle.com>
	 <1253804615.18939.36.camel@laptop> <1253805536.18939.39.camel@laptop>
	 <20090924161357.GL23126@kernel.dk>
Content-Type: text/plain
Date: Thu, 24 Sep 2009 18:26:00 +0200
Message-Id: <1253809560.18939.69.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-09-24 at 18:13 +0200, Jens Axboe wrote:

> > > >  	for (;;) {
> > > >  		/*
> > > > +		 * Stop writeback when nr_pages has been consumed
> > > >  		 */
> > > > +		if (args->nr_pages <= 0)
> > > >  			break;
> > > >  
> > > >  		/*
> > > > +		 * For background writeout, stop when we are below the
> > > > +		 * background dirty threshold
> > > >  		 */
> > > > +		if (args->for_background && !over_bground_thresh())
> > > >  			break;
> > > 
> > > 
> > > What I'm not getting is why this is conditional on for_background(),
> > > shouldn't we always stop writeback when below the background threshold?
> > 
> > Ah, that would be for things like sync, which need to write out
> > everything, right?
> 
> Yes, wb_writeback() handles any kind of writeback. The definition of our
> background writeout is to stop when we are no longer over the background
> writeout threshold.

Right, ok

Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>

