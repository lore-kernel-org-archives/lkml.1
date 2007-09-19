Return-Path: <linux-kernel-owner+w=401wt.eu-S1756363AbXISIE6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756363AbXISIE6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2007 04:04:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753723AbXISIEn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Sep 2007 04:04:43 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:37851 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752918AbXISIEl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2007 04:04:41 -0400
Date: Wed, 19 Sep 2007 17:05:59 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Christoph Lameter <clameter@sgi.com>
Cc: Christoph Hellwig <hch@lst.de>, Mel Gorman <mel@skynet.ie>,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       David Chinner <dgc@sgi.com>, Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [05/17] vunmap: return page array
Message-Id: <20070919170559.a0552679.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20070919033641.468440734@sgi.com>
References: <20070919033605.785839297@sgi.com>
	<20070919033641.468440734@sgi.com>
Organization: Fujitsu
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.10.11; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 18 Sep 2007 20:36:10 -0700
Christoph Lameter <clameter@sgi.com> wrote:

> Make vunmap return the page array that was used at vmap. This is useful
> if one has no structures to track the page array but simply stores the
> virtual address somewhere. The disposition of the page array can be
> decided upon after vunmap. vfree() may now also be used instead of
> vunmap which will release the page array after vunmap'ping it.
> 
> Signed-off-by: Christoph Lameter <clameter@sgi.com>
> 

Hmm, I don't like returning array which someone allocated in past and forgot.
And, area->page[] array under vmalloc() is allocated as following (in -rc6-mm1)
==
       if (array_size > PAGE_SIZE) {
                pages = __vmalloc_node(array_size, gfp_mask | __GFP_ZERO,
                                        PAGE_KERNEL, node);
                area->flags |= VM_VPAGES;
        } else {
                pages = kmalloc_node(array_size,
                                (gfp_mask & GFP_RECLAIM_MASK) | __GFP_ZERO,
                                node);
        }
==
A bit complicating.

At least, please add comments "How to free page-array returned by vummap"

Thanks,
-Kame

