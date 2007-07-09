Return-Path: <linux-kernel-owner+w=401wt.eu-S1758061AbXGIQAl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758061AbXGIQAl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2007 12:00:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754917AbXGIQAc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jul 2007 12:00:32 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:48387 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754595AbXGIQAb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2007 12:00:31 -0400
Date: Mon, 9 Jul 2007 09:00:30 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Ingo Molnar <mingo@elte.hu>
cc: linux-kernel@vger.kernel.org, linux-mm@vger.kernel.org,
       suresh.b.siddha@intel.com, corey.d.gough@intel.com,
       Pekka Enberg <penberg@cs.helsinki.fi>, akpm@linux-foundation.org,
       Matt Mackall <mpm@selenic.com>
Subject: Re: [patch 09/10] Remove the SLOB allocator for 2.6.23
In-Reply-To: <20070708075119.GA16631@elte.hu>
Message-ID: <Pine.LNX.4.64.0707090859100.13970@schroedinger.engr.sgi.com>
References: <20070708034952.022985379@sgi.com> <20070708035018.074510057@sgi.com>
 <20070708075119.GA16631@elte.hu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 8 Jul 2007, Ingo Molnar wrote:

> actually, one real advantage of the SLOB is that it is a minimal, really 
> simple allocator. Its text and data size is so small as well.
> 
> here's the size comparison:
> 
>    text    data     bss     dec     hex filename
>   10788     837      16   11641    2d79 mm/slab.o
>    6205    4207     124   10536    2928 mm/slub.o
>    1640      44       4    1688     698 mm/slob.o
> 
> slab/slub have roughly the same footprint, but slob is 10% of that size. 
> Would be a waste to throw this away.

The last of my tests showed that SLOB is at about 50% of the size of 
SLUB. You need to compile SLUB in embedded mode with !CONFIG_SLUB_DEBUG to 
get a reduce code size.
