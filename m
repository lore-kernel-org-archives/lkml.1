Return-Path: <linux-kernel-owner+w=401wt.eu-S1756235AbXGIQv7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756235AbXGIQv7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2007 12:51:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753989AbXGIQvw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jul 2007 12:51:52 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:38538 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753724AbXGIQvu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2007 12:51:50 -0400
Date: Mon, 9 Jul 2007 09:51:16 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Christoph Lameter <clameter@sgi.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, linux-mm@vger.kernel.org,
       suresh.b.siddha@intel.com, corey.d.gough@intel.com,
       Pekka Enberg <penberg@cs.helsinki.fi>, Matt Mackall <mpm@selenic.com>,
       Denis Vlasenko <vda.linux@googlemail.com>,
       Erik Andersen <andersen@codepoet.org>
Subject: Re: [patch 09/10] Remove the SLOB allocator for 2.6.23
Message-Id: <20070709095116.c2ea700f.akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0707090901410.13970@schroedinger.engr.sgi.com>
References: <20070708034952.022985379@sgi.com>
	<20070708035018.074510057@sgi.com>
	<20070708075119.GA16631@elte.hu>
	<20070708110224.9cd9df5b.akpm@linux-foundation.org>
	<4691A415.6040208@yahoo.com.au>
	<Pine.LNX.4.64.0707090901410.13970@schroedinger.engr.sgi.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 9 Jul 2007 09:06:46 -0700 (PDT) Christoph Lameter <clameter@sgi.com> wrote:

> But yes the power of 
> two caches are a necessary design feature of SLAB/SLUB that allows O(1) 
> operations of kmalloc slabs which in turns causes memory wastage because 
> of rounding of the alloc to the next power of two.

I've frequently wondered why we don't just create more caches for kmalloc:
make it denser than each-power-of-2-plus-a-few-others-in-between.

I assume the tradeoff here is better packing versus having a ridiculous
number of caches.  Is there any other cost?

Because even having 1024 caches wouldn't consume a terrible amount of
memory and I bet it would result in aggregate savings.

Of course, a scheme which creates kmalloc caches on-demand would be better,
but that would kill our compile-time cache selection, I suspect.
