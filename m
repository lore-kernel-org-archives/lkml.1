Return-Path: <linux-kernel-owner+w=401wt.eu-S1762693AbXISRed@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762693AbXISRed (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2007 13:34:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762402AbXISRdL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Sep 2007 13:33:11 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:51943 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1762215AbXISRdJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2007 13:33:09 -0400
Date: Wed, 19 Sep 2007 10:33:07 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Eric Dumazet <dada1@cosmosbay.com>
cc: Anton Altaparmakov <aia21@cam.ac.uk>, Christoph Hellwig <hch@lst.de>,
       Mel Gorman <mel@skynet.ie>, David Chinner <dgc@sgi.com>,
       Jens Axboe <jens.axboe@oracle.com>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [00/17] [RFC] Virtual Compound Page Support
In-Reply-To: <20070919103400.7bc8ffd9.dada1@cosmosbay.com>
Message-ID: <Pine.LNX.4.64.0709191030370.11138@schroedinger.engr.sgi.com>
References: <20070919033605.785839297@sgi.com> <3A6E599E-07AC-4273-8643-ADFC8014D3E6@cam.ac.uk>
 <20070919103400.7bc8ffd9.dada1@cosmosbay.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 19 Sep 2007, Eric Dumazet wrote:

> 1) Only power of two allocations are good candidates, or we waste RAM

Correct.

> 2) On i386 machines, we have a small vmalloc window. (128 MB default value)
>   Many servers with >4GB memory (PAE) like to boot with vmalloc=32M option to get 992MB of LOWMEM.
>   If we allow some slub caches to fallback to vmalloc land, we'll have problems to tune this.

We would first do the vmalloc conversion to GFP_VFALLBACK which would 
reduce the vmalloc requirements of drivers and core significantly. The 
patchset should actually reduce the vmalloc space requirements 
significantly. They are only needed in situations where the page allocator 
cannot provide a contiguous mapping and that gets rarer the better Mel's 
antifrag code works.
 
> 4) vmalloc() currently uses a linked list of vm_struct. Might need something more scalable.

If its rarely used then its not that big of a deal. The better the anti 
fragmentation measures the less vmalloc use.
