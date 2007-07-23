Return-Path: <linux-kernel-owner+w=401wt.eu-S1756931AbXGWVYr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756931AbXGWVYr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 17:24:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752872AbXGWVYk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 17:24:40 -0400
Received: from waste.org ([66.93.16.53]:34864 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752804AbXGWVYj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 17:24:39 -0400
Date: Mon, 23 Jul 2007 16:24:20 -0500
From: Matt Mackall <mpm@selenic.com>
To: Christoph Lameter <clameter@sgi.com>
Cc: Paul Mundt <lethal@linux-sh.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] mm: Remove slab destructors from kmem_cache_create().
Message-ID: <20070723212420.GI11115@waste.org>
References: <20070720012846.GA22487@linux-sh.org> <20070721212851.GH11166@waste.org> <20070721234227.GA8303@linux-sh.org> <20070723140444.159343b2@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070723140444.159343b2@schroedinger.engr.sgi.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 23, 2007 at 02:04:44PM -0700, Christoph Lameter wrote:
> Please do not merge this patch. I will reuse the destructor field for
> the kmem_cache_ops in the slab defrag patchset. If you apply this patch
> then I need to readd the parameter later.

The vast majority of slabs won't have any cache ops, right? Wouldn't
it be cleaner to have a kmem_set_cache_ops() for the few that do?

While we're on the subject, has anyone reviewed your defrag stuff?

I read through it a while back and my initial impression is a) it's
awfully complex and invasive and b) it probably won't protect all
workloads.

As this and several other vexing problems stem from the dcache design,
I'd rather abandon the dcache out in the woods so we can replace it
with something less troublesome.

-- 
Mathematics is the supreme nostalgia of our time.
