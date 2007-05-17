Return-Path: <linux-kernel-owner+w=401wt.eu-S1759645AbXEQSC7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759645AbXEQSC7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2007 14:02:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755706AbXEQSCw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 May 2007 14:02:52 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:54643 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754439AbXEQSCv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2007 14:02:51 -0400
Date: Thu, 17 May 2007 11:02:51 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Matt Mackall <mpm@selenic.com>
cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, Thomas Graf <tgraf@suug.ch>,
       David Miller <davem@davemloft.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Daniel Phillips <phillips@google.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: [PATCH 0/5] make slab gfp fair
In-Reply-To: <20070517175327.GX11115@waste.org>
Message-ID: <Pine.LNX.4.64.0705171101360.18085@schroedinger.engr.sgi.com>
References: <20070514131904.440041502@chello.nl>
 <Pine.LNX.4.64.0705161957440.13458@schroedinger.engr.sgi.com>
 <1179385718.27354.17.camel@twins> <Pine.LNX.4.64.0705171027390.17245@schroedinger.engr.sgi.com>
 <20070517175327.GX11115@waste.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 May 2007, Matt Mackall wrote:

> Simply stated, the problem is sometimes it's impossible to free memory
> without allocating more memory. Thus we must keep enough protected
> reserve that we can guarantee progress. This is what mempools are for
> in the regular I/O stack. Unfortunately, mempools are a bad match for
> network I/O.
> 
> It's absolutely correct that performance doesn't matter in the case
> this patch is addressing. All that matters is digging ourselves out of
> OOM. The box either survives the crisis or it doesn't.

Well we fail allocations in order to do so and these allocations may be 
even nonatomic allocs. Pretty dangerous approach.

> It's also correct that we should hardly ever get into a situation
> where we trigger this problem. But such cases are still fairly easy to
> trigger in some workloads. Swap over network is an excellent example,
> because we typically don't start swapping heavily until we're quite
> low on freeable memory.

Is it not possible to avoid failing allocs? Instead put processes to 
sleep? Run synchrononous reclaim?

