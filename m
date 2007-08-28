Return-Path: <linux-kernel-owner+w=401wt.eu-S932589AbXH1T5S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932589AbXH1T5S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2007 15:57:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763685AbXH1T4w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Aug 2007 15:56:52 -0400
Received: from verein.lst.de ([213.95.11.210]:57319 "EHLO mail.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762842AbXH1T4s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2007 15:56:48 -0400
Date: Tue, 28 Aug 2007 21:55:03 +0200
From: Christoph Hellwig <hch@lst.de>
To: J??rn Engel <joern@logfs.org>
Cc: clameter@sgi.com, torvalds@linux-foundation.org,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       Christoph Hellwig <hch@lst.de>, Mel Gorman <mel@skynet.ie>,
       William Lee Irwin III <wli@holomorphy.com>, David Chinner <dgc@sgi.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Badari Pulavarty <pbadari@gmail.com>,
       Maxim Levitsky <maximlevitsky@gmail.com>,
       Fengguang Wu <fengguang.wu@gmail.com>, swin wang <wangswin@gmail.com>,
       totty.lu@gmail.com, "H. Peter Anvin" <hpa@zytor.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [07/36] Use page_cache_xxx in mm/filemap_xip.c
Message-ID: <20070828195503.GA15903@lst.de>
References: <20070828190551.415127746@sgi.com> <20070828190729.308864359@sgi.com> <20070828194937.GA23020@lazybastard.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070828194937.GA23020@lazybastard.org>
User-Agent: Mutt/1.3.28i
X-Spam-Score: 0 () 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 28, 2007 at 09:49:38PM +0200, J??rn Engel wrote:
> On Tue, 28 August 2007 12:05:58 -0700, clameter@sgi.com wrote:
> >  
> > -	index = *ppos >> PAGE_CACHE_SHIFT;
> > -	offset = *ppos & ~PAGE_CACHE_MASK;
> > +	index = page_cache_index(mapping, *ppos);
> > +	offset = page_cache_offset(mapping, *ppos);
> 
> Part of me feels inclined to marge this patch now because it makes the
> code more readable, even if page_cache_index() is implemented as
> #define page_cache_index(mapping, pos) ((pos) >> PAGE_CACHE_SHIFT)
> 
> I know there is little use in yet another global search'n'replace
> wankfest and Andrew might wash my mouth just for mentioning it.  Still,
> hard to dislike this part of your patch.

Yes, I I suggested that before.  Andrew seems to somehow hate this
patchset, but even if we don;'t get it in the lowercase macros are much
much better then the current PAGE_CACHE_* confusion.
