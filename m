Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752560Ab0BAKKT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Feb 2010 05:10:19 -0500
Received: from one.firstfloor.org ([213.235.205.2]:58879 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751011Ab0BAKKR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Feb 2010 05:10:17 -0500
Date: Mon, 1 Feb 2010 11:10:13 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Nick Piggin <npiggin@suse.de>
Cc: Al Viro <viro@ZenIV.linux.org.uk>,
       Christoph Lameter <cl@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>, Dave Chinner <david@fromorbit.com>,
       Alexander Viro <viro@ftp.linux.org.uk>,
       Christoph Hellwig <hch@infradead.org>,
       Christoph Lameter <clameter@sgi.com>, Rik van Riel <riel@redhat.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>, akpm@linux-foundation.org,
       Miklos Szeredi <miklos@szeredi.hu>,
       Nick Piggin <nickpiggin@yahoo.com.au>, Hugh Dickins <hugh@veritas.com>,
       linux-kernel@vger.kernel.org
Subject: Re: dentries: dentry defragmentation
Message-ID: <20100201101013.GG29555@one.firstfloor.org>
References: <20100129204931.789743493@quilx.com> <20100129205007.832823807@quilx.com> <20100129220044.GA31305@ZenIV.linux.org.uk> <20100201070835.GE9085@laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100201070835.GE9085@laptop>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 01, 2010 at 06:08:35PM +1100, Nick Piggin wrote:
> I always preferred to do defrag in the opposite way. Ie. query the
> slab allocator from existing shrinkers rather than opposite way
> around. This lets you reuse more of the locking and refcounting etc.

I looked at this for hwpoison soft offline.

But it works really badly because the LRU list ordering 
has nothing to do with the actual ordering inside the slab pages.

Christoph's basic approach is more efficient.

> So you have a pin on the object somehow via the normal shrinker path,
> and therefore you get a pin on the underlying slab. I would just like
> to see even performance of a real simple approach that just asks
> whether we are in this slab defrag mode, and if so, whether the slab
> is very sparse. If yes, then reclaim aggressively.

The typical result is that you need to get through most of the LRU
list (and prune them all) just to free the page.

> 
> If that doesn't perform well enough and you have to go further and

It doesn't.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
