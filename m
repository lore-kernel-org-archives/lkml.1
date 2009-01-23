Return-Path: <linux-kernel-owner+w=401wt.eu-S1757748AbZAWMz2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757748AbZAWMz2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2009 07:55:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755309AbZAWMzR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Jan 2009 07:55:17 -0500
Received: from cantor2.suse.de ([195.135.220.15]:44578 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754837AbZAWMzQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2009 07:55:16 -0500
Date: Fri, 23 Jan 2009 13:55:08 +0100
From: Nick Piggin <npiggin@suse.de>
To: Andi Kleen <andi@firstfloor.org>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>,
       Linux Memory Management List <linux-mm@kvack.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Lin Ming <ming.m.lin@intel.com>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Christoph Lameter <clameter@engr.sgi.com>
Subject: Re: [patch] SLQB slab allocator
Message-ID: <20090123125508.GG19986@wotan.suse.de>
References: <20090121143008.GV24891@wotan.suse.de> <87hc3qcpo1.fsf@basil.nowhere.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87hc3qcpo1.fsf@basil.nowhere.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 23, 2009 at 10:55:26AM +0100, Andi Kleen wrote:
> Nick Piggin <npiggin@suse.de> writes:
> > +#ifdef CONFIG_NUMA
> > +void *__kmalloc_node(size_t size, gfp_t flags, int node);
> > +void *kmem_cache_alloc_node(struct kmem_cache *, gfp_t flags, int node);
> > +
> > +static __always_inline void *kmalloc_node(size_t size, gfp_t flags, int node)
> 
> kmalloc_node should be infrequent, i suspect it can be safely out of lined.

Hmm, it only takes up another couple of hundred bytes for a full
numa kernel. Completely out of lining it can take a slightly slower
path and makes the code slightly different from the kmalloc case.
So I'll leave this change for now.

