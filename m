Return-Path: <linux-kernel-owner+w=401wt.eu-S1030824AbXD1V2y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030824AbXD1V2y (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2007 17:28:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030848AbXD1V2y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Apr 2007 17:28:54 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:53655 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1030824AbXD1V2w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2007 17:28:52 -0400
Date: Sat, 28 Apr 2007 14:28:34 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: William Lee Irwin III <wli@holomorphy.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Nick Piggin <nickpiggin@yahoo.com.au>, David Chinner <dgc@sgi.com>,
       Christoph Lameter <clameter@sgi.com>, linux-kernel@vger.kernel.org,
       Mel Gorman <mel@skynet.ie>, Jens Axboe <jens.axboe@oracle.com>,
       Badari Pulavarty <pbadari@gmail.com>,
       Maxim Levitsky <maximlevitsky@gmail.com>
Subject: Re: [00/17] Large Blocksize Support V3
Message-Id: <20070428142834.95bcf9d1.akpm@linux-foundation.org>
In-Reply-To: <20070428191956.GY31925@holomorphy.com>
References: <Pine.LNX.4.64.0704270007100.5388@schroedinger.engr.sgi.com>
	<20070427002640.22a71d06.akpm@linux-foundation.org>
	<20070427163620.GI32602149@melbourne.sgi.com>
	<20070427173432.GJ32602149@melbourne.sgi.com>
	<20070427121108.9ee05710.akpm@linux-foundation.org>
	<4632A6DF.7080301@yahoo.com.au>
	<1177747448.28223.26.camel@twins>
	<20070428012251.fae10a71.akpm@linux-foundation.org>
	<20070428140907.GU19966@holomorphy.com>
	<20070428112640.5b92b995.akpm@linux-foundation.org>
	<20070428191956.GY31925@holomorphy.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 28 Apr 2007 12:19:56 -0700 William Lee Irwin III <wli@holomorphy.com> wrote:

> I'm skeptical, however, that the contiguity gains will compensate for
> the CPU required to do such with the pcp lists.

It wouldn't surprise me if approximate contiguity is a pretty common case
in the pcp lists.  Recaim isn't very important here: most pages get freed
in truncate and particularly unmap_vmas.  If the allocator is handing out
pages in reasonably contiguous fashion (and it does, and we're talking
about strengthening that) then I'd expect that very often we end up freeing
pages which have a lot of locality too.  So the sort of tricks which you're
discussing might get a pretty good hit rate.

otoh, it's not obvious to me that there's a lot to be gained here.  If we
repeatedly call the buddy allocator freeing contiguous order-0 pages, all
the data structures which are needed to handle those should be in L1 cache
and the buddy itself becomes our point-of-collection, if you see what I
mean.

Dunno.  Profiling should tell?
