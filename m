Return-Path: <linux-kernel-owner+w=401wt.eu-S1755024AbXITAqo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755024AbXITAqo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2007 20:46:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752072AbXITAqg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Sep 2007 20:46:36 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:44129 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752041AbXITAqe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2007 20:46:34 -0400
Date: Thu, 20 Sep 2007 09:47:20 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Christoph Lameter <clameter@sgi.com>
Cc: Christoph Hellwig <hch@lst.de>, Mel Gorman <mel@skynet.ie>,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       David Chinner <dgc@sgi.com>, Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [05/17] vunmap: return page array
Message-Id: <20070920094720.46e781ec.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <Pine.LNX.4.64.0709191510470.3402@schroedinger.engr.sgi.com>
References: <20070919033605.785839297@sgi.com>
	<20070919033641.468440734@sgi.com>
	<20070919170559.a0552679.kamezawa.hiroyu@jp.fujitsu.com>
	<Pine.LNX.4.64.0709191510470.3402@schroedinger.engr.sgi.com>
Organization: Fujitsu
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.10.11; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 19 Sep 2007 15:15:58 -0700 (PDT)
Christoph Lameter <clameter@sgi.com> wrote:

> On Wed, 19 Sep 2007, KAMEZAWA Hiroyuki wrote:
> 
> > Hmm, I don't like returning array which someone allocated in past and forgot.
> 
> But that is exactly the point. There is no need to keep track of the 
> information that is of no interest until the disposition of the mapping.
> 
yes. But I think neat style of this kind function is
==
/* If array != NULL, pointer of unmapped pages are stored in array[] */
extern int vunmap(const void *addr, struct page **array);
==
But yes, this costs.

> > And, area->page[] array under vmalloc() is allocated as following (in -rc6-mm1)
> > ==
> >        if (array_size > PAGE_SIZE) {
> >                 pages = __vmalloc_node(array_size, gfp_mask | __GFP_ZERO,
> >                                         PAGE_KERNEL, node);
> >                 area->flags |= VM_VPAGES;
> >         } else {
> >                 pages = kmalloc_node(array_size,
> >                                 (gfp_mask & GFP_RECLAIM_MASK) | __GFP_ZERO,
> >                                 node);
> >         }
> > ==
> > A bit complicating.
> 
> Not at all. You can pass a __vmalloc'ed entity to vmap if you add VM_VPAGES 
> to the flags passed to it.
> 
> > At least, please add comments "How to free page-array returned by vummap"
> 
> But that depends on how the vmap was called. The caller knows what he has 
> done to acquire the memory and therefore also knows how to get rid of it.
>  
Hm, it seems all your patch are for hiding usage of vmalloc()/vmap().
If freeing pages[] array is also hidden in your patch's context, no problem.

Thanks,
-Kame


