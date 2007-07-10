Return-Path: <linux-kernel-owner+w=401wt.eu-S1763784AbXGJMDe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763784AbXGJMDe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2007 08:03:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763186AbXGJMDW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jul 2007 08:03:22 -0400
Received: from waste.org ([66.93.16.53]:41957 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761782AbXGJMDO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2007 08:03:14 -0400
Date: Tue, 10 Jul 2007 07:02:24 -0500
From: Matt Mackall <mpm@selenic.com>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>,
       Christoph Lameter <clameter@sgi.com>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       suresh.b.siddha@intel.com, corey.d.gough@intel.com,
       Denis Vlasenko <vda.linux@googlemail.com>,
       Erik Andersen <andersen@codepoet.org>
Subject: Re: [patch 09/10] Remove the SLOB allocator for 2.6.23
Message-ID: <20070710120224.GP11115@waste.org>
References: <20070708034952.022985379@sgi.com> <20070708035018.074510057@sgi.com> <20070708075119.GA16631@elte.hu> <20070708110224.9cd9df5b.akpm@linux-foundation.org> <4691A415.6040208@yahoo.com.au> <84144f020707090404l657a62c7x89d7d06b3dd6c34b@mail.gmail.com> <Pine.LNX.4.64.0707090907010.13970@schroedinger.engr.sgi.com> <Pine.LNX.4.64.0707101049230.23040@sbz-30.cs.Helsinki.FI> <469342DC.8070007@yahoo.com.au> <84144f020707100231p5013e1aer767562c26fc52eeb@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <84144f020707100231p5013e1aer767562c26fc52eeb@mail.gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 10, 2007 at 12:31:40PM +0300, Pekka Enberg wrote:
> Hi Nick,
> 
> Pekka J Enberg wrote:
> >> That's 92 KB advantage for SLUB with debugging enabled and 240 KB when
> >> debugging is disabled.
> 
> On 7/10/07, Nick Piggin <nickpiggin@yahoo.com.au> wrote:
> >Interesting. What kernel version are you using?
> 
> Linus' git head from yesterday so the results are likely to be
> sensitive to workload and mine doesn't represent real embedded use.

Using 2.6.22-rc6-mm1 with a 64MB lguest and busybox, I'm seeing the
following as the best MemFree numbers after several boots each:

SLAB: 54796
SLOB: 55044
SLUB: 53944
SLUB: 54788 (debug turned off)

These numbers bounce around a lot more from boot to boot than I
remember, so take these numbers with a grain of salt.

Disabling the debug code in the build gives this, by the way:

mm/slub.c: In function ‘init_kmem_cache_node’:
mm/slub.c:1873: error: ‘struct kmem_cache_node’ has no member named
‘full’

-- 
Mathematics is the supreme nostalgia of our time.
