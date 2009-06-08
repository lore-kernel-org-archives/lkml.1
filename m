Return-Path: <linux-kernel-owner+w=401wt.eu-S1751606AbZFHSA1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751606AbZFHSA1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jun 2009 14:00:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751292AbZFHSAS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Jun 2009 14:00:18 -0400
Received: from cmpxchg.org ([85.214.51.133]:59815 "EHLO cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751016AbZFHSAR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jun 2009 14:00:17 -0400
Date: Mon, 8 Jun 2009 19:58:08 +0200
From: Johannes Weiner <hannes@cmpxchg.org>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Rik van Riel <riel@redhat.com>
Subject: Re: [rfc][patch] swap: virtual swap readahead
Message-ID: <20090608175808.GD7563@cmpxchg.org>
References: <1243436746-2698-1-git-send-email-hannes@cmpxchg.org> <20090608075246.GA12644@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090608075246.GA12644@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 08, 2009 at 03:52:46PM +0800, Wu Fengguang wrote:
> On Wed, May 27, 2009 at 05:05:46PM +0200, Johannes Weiner wrote:
> > The current swap readahead implementation reads a physically
> > contiguous group of swap slots around the faulting page to take
> > advantage of the disk head's position and in the hope that the
> > surrounding pages will be needed soon as well.
> > 
> > This works as long as the physical swap slot order approximates the
> > LRU order decently, otherwise it wastes memory and IO bandwidth to
> > read in pages that are unlikely to be needed soon.
> > 
> > However, the physical swap slot layout diverges from the LRU order
> > with increasing swap activity, i.e. high memory pressure situations,
> > and this is exactly the situation where swapin should not waste any
> > memory or IO bandwidth as both are the most contended resources at
> > this point.
> > 
> > This patch makes swap-in base its readaround window on the virtual
> > proximity of pages in the faulting VMA, as an indicator for pages
> > needed in the near future, while still taking physical locality of
> > swap slots into account.
> > 
> > This has the advantage of reading in big batches when the LRU order
> > matches the swap slot order while automatically throttling readahead
> > when the system is thrashing and swap slots are no longer nicely
> > grouped by LRU order.
> 
> Hi Johannes,
> 
> You may want to test the patch against a real desktop :)
> The attached scripts can do that. I also have the setup to
> test it out conveniently, so if you send me the latest patch..

Thanks a bunch for the offer!  I'm just now incorporating Hugh's
feedback and hope I will be back soon with the next version.  I will
let you know, for sure.

	Hannes
