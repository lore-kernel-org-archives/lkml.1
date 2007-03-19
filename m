Return-Path: <linux-kernel-owner+w=401wt.eu-S1753778AbXCSLkk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753778AbXCSLkk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2007 07:40:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753780AbXCSLkk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Mar 2007 07:40:40 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:33043 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753778AbXCSLkj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2007 07:40:39 -0400
Date: Mon, 19 Mar 2007 13:40:37 +0200 (EET)
From: Pekka J Enberg <penberg@cs.helsinki.fi>
To: Andrew Morton <akpm@linux-foundation.org>
cc: ast@domdv.de, clameter@sgi.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] slab: deal with NULL pointers passed to kmem_cache_free
In-Reply-To: <20070319033108.b51bed63.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0703191334280.14446@sbz-30.cs.Helsinki.FI>
References: <Pine.LNX.4.64.0703191022310.8671@sbz-30.cs.Helsinki.FI>
 <20070319033108.b51bed63.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, 19 Mar 2007, Andrew Morton wrote:
> err, we don't want to do this, do we?  It adds overhead for something which
> we've carefully taught all our programmers to not do.  The only known code
> which will benefit from this is buggy.

Well, I actually disagree with that. It makes little sense for 
kmem_cache_free() to behave differently from kfree() especially since the 
overhead is minimal. But anyway, if you're unhappy with the patch, then we 
should make it explicit that you're not allowed to pass NULL to 
kmem_cache_free(), mempool_free() and perhaps others as well in which case 
kfree() comes even more special...

I know this has been discussed in the past but I think you should be able 
to blindly pass whetever pointer the allocator fuction gives you to the 
corresponding release function which is why I wanted to fix 
kmem_cache_free() in the first place.

On Mon, 19 Mar 2007, Andrew Morton wrote:
> s/fix/hide/

No, even though there is clearly some problem with either the scsi or 
block layer not allocating any pages for the iovec, I do think slab should 
deal with NULL pointers properly.

				Pekka
