Return-Path: <linux-kernel-owner+w=401wt.eu-S1754516AbZFBNxp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754516AbZFBNxp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jun 2009 09:53:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752004AbZFBNxi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Jun 2009 09:53:38 -0400
Received: from mga14.intel.com ([143.182.124.37]:10304 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751829AbZFBNxh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jun 2009 09:53:37 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.41,291,1241420400"; 
   d="scan'208";a="149728626"
Date: Tue, 2 Jun 2009 21:53:24 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Nick Piggin <npiggin@suse.de>, "hugh@veritas.com" <hugh@veritas.com>,
       "riel@redhat.com" <riel@redhat.com>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "chris.mason@oracle.com" <chris.mason@oracle.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: [PATCH] [13/16] HWPOISON: The high level memory error handler
	in the VM v3
Message-ID: <20090602135324.GB21338@localhost>
References: <20090528122357.GM6920@wotan.suse.de> <20090528135428.GB16528@localhost> <20090601115046.GE5018@wotan.suse.de> <20090601183225.GS1065@one.firstfloor.org> <20090602120042.GB1392@wotan.suse.de> <20090602124757.GG1065@one.firstfloor.org> <20090602125713.GG1392@wotan.suse.de> <20090602132538.GK1065@one.firstfloor.org> <20090602132441.GC6262@wotan.suse.de> <20090602134126.GM1065@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090602134126.GM1065@one.firstfloor.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 02, 2009 at 09:41:26PM +0800, Andi Kleen wrote:
> On Tue, Jun 02, 2009 at 03:24:41PM +0200, Nick Piggin wrote:
> > On Tue, Jun 02, 2009 at 03:25:38PM +0200, Andi Kleen wrote:
> > > On Tue, Jun 02, 2009 at 02:57:13PM +0200, Nick Piggin wrote:
> > > > > > not a big deal and just avoids duplicating code. I attached an
> > > > > > (untested) patch.
> > > > > 
> > > > > Thanks. But the function in the patch is not doing the same what
> > > > > the me_pagecache_clean/dirty are doing. For once there is no error
> > > > > checking, as in the second try_to_release_page()
> > > > > 
> > > > > Then it doesn't do all the IO error and missing mapping handling.
> > > > 
> > > > Obviously I don't mean just use that single call for the entire
> > > > handler. You can set the EIO bit or whatever you like. The
> > > > "error handling" you have there also seems strange. You could
> > > > retain it, but the page is assured to be removed from pagecache.
> > > 
> > > The reason this code double checks is that someone could have 
> > > a reference (remember we can come in any time) we cannot kill immediately.
> > 
> > Can't kill what? The page is gone from pagecache. It may remain
> > other kernel references, but I don't see why this code will
> > consider this as a failure (and not, for example, a raised error
> > count).
> 
> It's a failure because the page was still used and not successfully
> isolated.
> 
> > +        * remove_from_page_cache assumes (mapping && !mapped)
> > +        */
> > +       if (page_mapping(p) && !page_mapped(p)) {
> 
> Ok you're right. That one is not needed. I will remove it.

No! Please read the comment. In fact __remove_from_page_cache() has a

                BUG_ON(page_mapped(page));

Or, at least correct that BUG_ON() line together.

Thanks,
Fengguang

