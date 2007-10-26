Return-Path: <linux-kernel-owner+w=401wt.eu-S1763239AbXJZADO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763239AbXJZADO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 20:03:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760568AbXJZAC5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 20:02:57 -0400
Received: from ozlabs.org ([203.10.76.45]:48575 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756879AbXJZAC4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 20:02:56 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH 09/10] Change table chaining layout
Date: Fri, 26 Oct 2007 10:03:18 +1000
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Boaz Harrosh <bharrosh@panasas.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Geert Uytterhoeven <geert@linux-m68k.org>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>, mingo@elte.hu
References: <1193076664-13652-10-git-send-email-jens.axboe@oracle.com> <20071025091140.GK5053@kernel.dk> <200710252154.45542.rusty@rustcorp.com.au>
In-Reply-To: <200710252154.45542.rusty@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710261003.19287.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 25 October 2007 21:54:44 Rusty Russell wrote:
> On Thursday 25 October 2007 19:11:40 Jens Axboe wrote:
> > On Thu, Oct 25 2007, Rusty Russell wrote:
> > > What irritates me more is that scatterlists aren't quite generically
> > > useful. The virtio code wants to join a scatterlist created by
> > > blk_rq_map_sg() with two others, yet it won't work because sg_chain()
> > > doesn't remove the end marker from the first entry.
> >
> > That's a minor nit for your special purpose, we/you can change that.
>
> Well currently sg_chain() only joins "incomplete" (ie. unterminated) sg
> chains.  That works great for you, but it feels more like a special purpose
> to me.
>
> > > If this patch weren't already included, I'd be strongly arguing for the
> > > bio idea: I find the chained sg code tricksy and ugly (sorry Jens).
> >
> > What is the bio idea? A bio works in essentially the same way, the only
> > difference is having a specific next pointer. It's still just a linked
> > lists of arbitrarily sized sg tables (the bio_vec arrays).
>
> It was suggested by analogy earlier in this thread, to use a two-level
> structure.
>
> In this case I would have first renamed struct scatterlist to struct
> scatterelem.  Then struct scatterlist looks like:
>
> 	struct scatterlist {
> 		unsigned int num;
> 		struct scatterelem elems[0];
> 	};

To correct my own thoughts, it'd be better to just put a "struct list_head 
list;" in there for chaining.  That's more along standard kernel lines, and 
neatly handles the single-scatterlist case.

Cheers,
Rusty.
