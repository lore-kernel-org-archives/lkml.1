Return-Path: <linux-kernel-owner+w=401wt.eu-S1752455AbXBIWuK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752455AbXBIWuK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Feb 2007 17:50:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752461AbXBIWuJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Feb 2007 17:50:09 -0500
Received: from mail26.syd.optusnet.com.au ([211.29.133.167]:53741 "EHLO
	mail26.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752455AbXBIWuI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Feb 2007 17:50:08 -0500
X-Greylist: delayed 7170 seconds by postgrey-1.27 at vger.kernel.org; Fri, 09 Feb 2007 17:50:07 EST
From: Con Kolivas <kernel@kolivas.org>
To: ck@vds.kolivas.org
Subject: Re: Swap prefetch merge plans
Date: Sat, 10 Feb 2007 09:49:50 +1100
User-Agent: KMail/1.9.5
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
References: <200702091038.37143.kernel@kolivas.org> <20070209123029.633934eb.akpm@linux-foundation.org> <200702100750.22487.kernel@kolivas.org>
In-Reply-To: <200702100750.22487.kernel@kolivas.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702100949.50598.kernel@kolivas.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 10 February 2007 07:50, Con Kolivas wrote:
> On Saturday 10 February 2007 07:30, Andrew Morton wrote:
> > On Fri, 09 Feb 2007 14:13:03 +0100
> >
> > jos poortvliet <jos@mijnkamer.nl> wrote:
> > > Nick's comment, replying to me some time ago:
> >
> > I think I was thinking of this:
> >
> > 	http://lkml.org/lkml/2006/2/6/509
>
> Fortunately that predates a lot of changes where I did address all those.
> These will seem out of context without looking at that original email so I
> apologise in advance.
>
> buffered_rmqueue and prefetching x86 specific (not into DMA) were dropped
>
> It is NUMA aware
>
> Global cacheline bouncing in page allocation and page reclaim paths I have
> no answer for as I have to tell swap prefetch that the vm is busy somehow
> and I do that by setting precisely one bit in a lockless manner.
>
> The trylocks were dropped.
>
> The other ideas were to :
> -extend the prefetching. That's extra features
> -knowing for sure when a system is really idle. I've tried hard to do that
> as cheaply as possible.
> -putting pages on the lru? well it puts them on the tail
> -papering over an issue? As I said, no matter how good the vm is, there
> will always be loads that swap.

Perhaps I haven't made this clear enough.

Nick has been kind enough to review pretty much all of swap prefetch at every 
turn. He is understandably suspicious about any code that I generate since 
I'm a doctor and not a computer programmer. I have addressed every concern he 
has made along the way and even joked at the end that he "threatened to 
review it over and over and over" which he did not take in jest. 

Swap prefetch has actually had far more review than a lot of code so I'm 
surprised that this is a remaning concern.  It has been reviewed, and I have 
addressed the concerns. It is possible to hold back code forever at the 
suggestion that more review is always required, and basically that's what I 
feel this has become.

If there is one valid concern with swap prefetch, there is a numa=64 scenario 
that Rohit Seth brought to my attention and I gave him a patch to test 2 
months ago. I've pinged him since, but I understand he's busy so has not had 
a chance to test the patch.

-- 
-ck
