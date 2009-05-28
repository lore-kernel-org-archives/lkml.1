Return-Path: <linux-kernel-owner+w=401wt.eu-S1756689AbZE1Koa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756689AbZE1Koa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 May 2009 06:44:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753135AbZE1KoX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 May 2009 06:44:23 -0400
Received: from one.firstfloor.org ([213.235.205.2]:59493 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750983AbZE1KoW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 May 2009 06:44:22 -0400
Date: Thu, 28 May 2009 12:51:03 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Andi Kleen <andi@firstfloor.org>, Nick Piggin <npiggin@suse.de>,
       "hugh@veritas.com" <hugh@veritas.com>,
       "riel@redhat.com" <riel@redhat.com>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "chris.mason@oracle.com" <chris.mason@oracle.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: [PATCH] [13/16] HWPOISON: The high level memory error handler in the VM v3
Message-ID: <20090528105103.GG1065@one.firstfloor.org>
References: <200905271012.668777061@firstfloor.org> <20090527201239.C2C9C1D0294@basil.firstfloor.org> <20090528082616.GG6920@wotan.suse.de> <20090528095934.GA10678@localhost> <20090528101111.GE1065@one.firstfloor.org> <20090528103300.GA15133@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090528103300.GA15133@localhost>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 28, 2009 at 06:33:00PM +0800, Wu Fengguang wrote:
> > > > You haven't waited on writeback here AFAIKS, and have you
> > > > *really* verified it is safe to call delete_from_swap_cache?
> > > 
> > > Good catch. I'll soon submit patches for handling the under
> > > read/write IO pages. In this patchset they are simply ignored.
> > 
> > Yes, we assume the IO device does something sensible with the poisoned
> > cache lines and aborts. Later we can likely abort IO requests in a early
> > stage on the Linux, but that's more advanced.
> > 
> > The question is if we need to wait on writeback for correctness? 
> 
> Not necessary. Because I'm going to add a me_writeback() handler.

Ok but without it. Let's assume me_writeback() is in the future.

I'm mainly interested in correctness (as in not crashing) of this
version now.

Also writeback seems to be only used by nfs/afs/nilfs2, not in
the normal case, unless I'm misreading the code. 

The nilfs2 case seems weird, I haven't completely read that.

> Then the writeback pages simply won't reach here. And it won't
> magically go into writeback state, since the page has been locked.

But since we take the page lock they should not be in writeback anyways,
no?

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
