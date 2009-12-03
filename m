Return-Path: <linux-kernel-owner+w=401wt.eu-S1754398AbZLCBeb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754398AbZLCBeb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Dec 2009 20:34:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753685AbZLCBea
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Dec 2009 20:34:30 -0500
Received: from mga14.intel.com ([143.182.124.37]:2603 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753283AbZLCBea (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Dec 2009 20:34:30 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.47,316,1257148800"; 
   d="scan'208";a="218194793"
Date: Thu, 3 Dec 2009 09:34:33 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Christoph Lameter <cl@linux-foundation.org>
Cc: Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 02/24] migrate: page could be locked by hwpoison, dont
	BUG()
Message-ID: <20091203013433.GA8520@localhost>
References: <20091202031231.735876003@intel.com> <20091202043043.840044332@intel.com> <alpine.DEB.2.00.0912020848300.31731@router.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.0912020848300.31731@router.home>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 02, 2009 at 10:50:10PM +0800, Christoph Lameter wrote:
> On Wed, 2 Dec 2009, Wu Fengguang wrote:
> 
> >  mm/migrate.c |    2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > --- linux-mm.orig/mm/migrate.c	2009-11-02 10:18:45.000000000 +0800
> > +++ linux-mm/mm/migrate.c	2009-11-02 10:26:16.000000000 +0800
> > @@ -556,7 +556,7 @@ static int move_to_new_page(struct page
> >  	 * holding a reference to the new page at this point.
> >  	 */
> >  	if (!trylock_page(newpage))
> > -		BUG();
> > +		return -EAGAIN;		/* got by hwpoison */
> >
> >  	/* Prepare mapping for the new page.*/
> >  	newpage->index = page->index;
> 
> The error handling code in umap_and_move() assumes that the page is
> locked upon return from move_to_new_page() even if it failed.
> 
> If you return EAGAIN then it may try to unlock a page that is not
> locked.

Ah yes, thanks!  We could fix it with more changes, however it seems
better to just drop this patch.

Thanks,
Fengguang
