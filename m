Return-Path: <linux-kernel-owner+w=401wt.eu-S1946582AbXBIUwl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946582AbXBIUwl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Feb 2007 15:52:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946670AbXBIUwk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Feb 2007 15:52:40 -0500
Received: from fallbackmx02.syd.optusnet.com.au ([211.29.133.72]:37929 "EHLO
	fallbackmx02.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1946582AbXBIUwk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Feb 2007 15:52:40 -0500
From: Con Kolivas <kernel@kolivas.org>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [ck] Re: Swap prefetch merge plans
Date: Sat, 10 Feb 2007 07:50:22 +1100
User-Agent: KMail/1.9.5
Cc: jos poortvliet <jos@mijnkamer.nl>, ck@vds.kolivas.org,
       linux-kernel@vger.kernel.org
References: <200702091038.37143.kernel@kolivas.org> <200702091413.06949.jos@mijnkamer.nl> <20070209123029.633934eb.akpm@linux-foundation.org>
In-Reply-To: <20070209123029.633934eb.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702100750.22487.kernel@kolivas.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 10 February 2007 07:30, Andrew Morton wrote:
> On Fri, 09 Feb 2007 14:13:03 +0100
>
> jos poortvliet <jos@mijnkamer.nl> wrote:
> > Nick's comment, replying to me some time ago:
>
> I think I was thinking of this:
>
> 	http://lkml.org/lkml/2006/2/6/509

Fortunately that predates a lot of changes where I did address all those. 
These will seem out of context without looking at that original email so I 
apologise in advance.

buffered_rmqueue and prefetching x86 specific (not into DMA) were dropped

It is NUMA aware

Global cacheline bouncing in page allocation and page reclaim paths I have no 
answer for as I have to tell swap prefetch that the vm is busy somehow and I 
do that by setting precisely one bit in a lockless manner.

The trylocks were dropped.

The other ideas were to :
-extend the prefetching. That's extra features
-knowing for sure when a system is really idle. I've tried hard to do that as 
cheaply as possible.
-putting pages on the lru? well it puts them on the tail
-papering over an issue? As I said, no matter how good the vm is, there will 
always be loads that swap.

-- 
-ck
