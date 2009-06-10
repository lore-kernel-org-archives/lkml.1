Return-Path: <linux-kernel-owner+w=401wt.eu-S932313AbZFJJpf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932313AbZFJJpf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jun 2009 05:45:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760195AbZFJJnS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Jun 2009 05:43:18 -0400
Received: from casper.infradead.org ([85.118.1.10]:47621 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760182AbZFJJnP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jun 2009 05:43:15 -0400
Subject: Re: [patch v3] swap: virtual swap readahead
From: Peter Zijlstra <peterz@infradead.org>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Johannes Weiner <hannes@cmpxchg.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Rik van Riel <riel@redhat.com>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Andi Kleen <andi@firstfloor.org>, Minchan Kim <minchan.kim@gmail.com>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <20090610085638.GA32511@localhost>
References: <20090609190128.GA1785@cmpxchg.org>
	 <20090609193702.GA2017@cmpxchg.org> <20090610050342.GA8867@localhost>
	 <20090610074508.GA1960@cmpxchg.org> <20090610081132.GA27519@localhost>
	 <20090610173249.50e19966.kamezawa.hiroyu@jp.fujitsu.com>
	 <20090610085638.GA32511@localhost>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Wed, 10 Jun 2009 11:42:56 +0200
Message-Id: <1244626976.13761.11593.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-06-10 at 16:56 +0800, Wu Fengguang wrote:
> 
> Yes it worked!  But then I run into page allocation failures:
> 
> [  340.639803] Xorg: page allocation failure. order:4, mode:0x40d0
> [  340.645744] Pid: 3258, comm: Xorg Not tainted 2.6.30-rc8-mm1 #303
> [  340.651839] Call Trace:
> [  340.654289]  [<ffffffff810c8204>] __alloc_pages_nodemask+0x344/0x6c0
> [  340.660645]  [<ffffffff810f7489>] __slab_alloc_page+0xb9/0x3b0
> [  340.666472]  [<ffffffff810f8608>] __kmalloc+0x198/0x250
> [  340.671786]  [<ffffffffa014bf9f>] ? i915_gem_execbuffer+0x17f/0x11e0 [i915]
> [  340.678746]  [<ffffffffa014bf9f>] i915_gem_execbuffer+0x17f/0x11e0 [i915]

Jesse Barnes had a patch to add a vmalloc fallback to those largish kms
allocs.

But order-4 allocs failing isn't really strange, but it might indicate
this patch fragments stuff sooner, although I've seen these particular
failues before.
