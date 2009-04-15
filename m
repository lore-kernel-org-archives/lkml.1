Return-Path: <linux-kernel-owner+w=401wt.eu-S1756875AbZDOAcU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756875AbZDOAcU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 20:32:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753794AbZDOAcE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 20:32:04 -0400
Received: from mga14.intel.com ([143.182.124.37]:14387 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752920AbZDOAcD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 20:32:03 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.40,188,1239001200"; 
   d="scan'208";a="131519792"
Date: Wed, 15 Apr 2009 08:31:46 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Joe Perches <joe@perches.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] readahead: remove redundant test in
	shrink_readahead_size_eio()
Message-ID: <20090415003145.GA5737@localhost>
References: <20090414013730.GA8951@localhost> <1239726034.32203.129.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1239726034.32203.129.camel@localhost>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 15, 2009 at 12:20:33AM +0800, Joe Perches wrote:
> On Tue, 2009-04-14 at 09:37 +0800, Wu Fengguang wrote:
> > Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
> > ---
> >  mm/filemap.c |    3 ---
> >  1 file changed, 3 deletions(-)
> > 
> > --- mm.orig/mm/filemap.c
> > +++ mm/mm/filemap.c
> > @@ -1072,9 +1072,6 @@ EXPORT_SYMBOL(grab_cache_page_nowait);
> >  static void shrink_readahead_size_eio(struct file *filp,
> >  					struct file_ra_state *ra)
> >  {
> > -	if (!ra->ra_pages)
> > -		return;
> > -
> >  	ra->ra_pages /= 4;
> >  }
> 
> I'm not sure this is redundant.
> 
> Perhaps it was seen as an optimization
> given the expense of division.

Nope. It was mainly a way to avoid extra warning messages.
There used to be a printk() between the testing and division.

The division shall be optimized by gcc into a bit shift op.
Anyway this is a very cold execution path, so code size is
much more relevant than its efficiency.

Thanks,
Fengguang

