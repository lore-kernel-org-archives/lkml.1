Return-Path: <linux-kernel-owner+w=401wt.eu-S968973AbXEIGwQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968973AbXEIGwQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 02:52:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752274AbXEIGwD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 02:52:03 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:58228 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751709AbXEIGwB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 02:52:01 -0400
Date: Wed, 9 May 2007 08:49:23 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Alasdair G Kergon <agk@redhat.com>, dm-devel@redhat.com,
       linux-kernel@vger.kernel.org, Heinz Mauelshagen <hjm@redhat.com>
Subject: Re: [2.6.22 PATCH 22/26] dm: bio list helpers
Message-ID: <20070509064923.GO4163@kernel.dk>
References: <20070508194845.GC24114@agk.fab.redhat.com> <20070508174159.7d78a275.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070508174159.7d78a275.akpm@linux-foundation.org>
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAA==
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 08 2007, Andrew Morton wrote:
> >  static inline void bio_list_init(struct bio_list *bl)
> >  {
> >  	bl->head = bl->tail = NULL;
> >  }
> >  
> > +#define bio_list_for_each(bio, bl) \
> > +	for (bio = (bl)->head; bio && ({ prefetch(bio->bi_next); 1; }); \
> > +	     bio = bio->bi_next)
> > +
> 
> I have this vague memory from a long time ago that one particular CPU type
> wants to go oops when prefetching from an invalid address.
> 
> Maybe that went away for some reason - we'd have hit it again if it was
> real.

Besides, manual prefetching is very rarely a win. I dabbled with some
benchmarks a few weeks back (with the doubly linked lists), and in most
cases it was actually a loss. So I'd vote for just removing the
prefetch() above.

-- 
Jens Axboe

