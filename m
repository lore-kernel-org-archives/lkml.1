Return-Path: <linux-kernel-owner+w=401wt.eu-S1763415AbYCCVbn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763415AbYCCVbn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 16:31:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762660AbYCCVbR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 16:31:17 -0500
Received: from relay1.sgi.com ([192.48.171.29]:47609 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1762353AbYCCVbP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 16:31:15 -0500
Date: Mon, 3 Mar 2008 13:31:14 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Nick Piggin <npiggin@suse.de>
cc: netdev@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       yanmin_zhang@linux.intel.com, David Miller <davem@davemloft.net>,
       Eric Dumazet <dada1@cosmosbay.com>
Subject: Re: [rfc][patch 2/3] slab: introduce SMP alignment
In-Reply-To: <20080303202411.GH8974@wotan.suse.de>
Message-ID: <Pine.LNX.4.64.0803031327330.4375@schroedinger.engr.sgi.com>
References: <20080303093449.GA15091@wotan.suse.de> <20080303093529.GB15091@wotan.suse.de>
 <Pine.LNX.4.64.0803031104570.6917@schroedinger.engr.sgi.com>
 <20080303200355.GB8974@wotan.suse.de> <Pine.LNX.4.64.0803031208400.16049@schroedinger.engr.sgi.com>
 <20080303201211.GE8974@wotan.suse.de> <Pine.LNX.4.64.0803031216430.3110@schroedinger.engr.sgi.com>
 <20080303202411.GH8974@wotan.suse.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 3 Mar 2008, Nick Piggin wrote:

> On Mon, Mar 03, 2008 at 12:17:20PM -0800, Christoph Lameter wrote:
> > On Mon, 3 Mar 2008, Nick Piggin wrote:
> > 
> > > > You want two ways of specifying alignments?
> > > 
> > > I want a way to ask for SMP friendly allocation.
> > 
> > Then align the objects at cacheline boundaries by providing a value for 
> > the align parameter to kmem_cache_create().
> 
> max(num_possible_cpus() > 1 ? cache_line_size() : 0, mandatory_alignment)?

The mandatory alignment is applied anyways. You do not need to max() on 
that.

One could simply specify cache_line_size() with Pekka's patch. 
cache_line_size() could default to 0 if !SMP.

> Then suppose we want a CONFIG_TINY option to eliminate it?

No slab allocator supports that right now. However, SLOB in the past has 
ignored the alignment in order to reduce memory use. So maybe Matt wants 
to introduce this?

> And maybe the VSMP guys will want to blow this out to their internode
> alignment?
> 
> max(!CONFIG_TINY && num_possible_cpus() > 1 ? (is_vsmp ? internode_alignemnt : cache_line_size()) : 0, mandatory_alignment)

No the slab allocators were optimized for VSMP so that the 
internode_alignment is not necessary there. That was actually one of the 
requirements that triggered the slab numa work.

