Return-Path: <linux-kernel-owner+w=401wt.eu-S1755415AbZC3HxT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755415AbZC3HxT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Mar 2009 03:53:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752202AbZC3HxG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Mar 2009 03:53:06 -0400
Received: from mga03.intel.com ([143.182.124.21]:6816 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750872AbZC3HxE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Mar 2009 03:53:04 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.38,445,1233561600"; 
   d="scan'208";a="125547866"
Date: Mon, 30 Mar 2009 15:52:52 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Sascha Silbe <sascha-ccparty-c74088b0@silbe.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Flushing the (page?) cache for a block device
Message-ID: <20090330075252.GA9850@localhost>
References: <20090329125439.GB4697@twin.sascha.silbe.org> <20090330074052.GA9667@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090330074052.GA9667@localhost>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 30, 2009 at 03:40:52PM +0800, Wu Fengguang wrote:
> Hi Sascha,
> 
> On Sun, Mar 29, 2009 at 02:54:39PM +0200, Sascha Silbe wrote:
> > Hello!
> >
> > I'd like to do a verification step after writing to a USB stick (block  
> > device level, no filesystem involved). For this to work as intended, I  
> > need to ensure the reads are not satisfied from blocks still in cache,  
> > i.e.: flush "the cache" (page cache IIUC) for the block device in  
> > question (and _only_ this device).
> > Some research resulted in the following options:
> >
> > 1. Open the target file using O_DIRECT while writing.
> >      Doesn't feel like the right thing to do; only want to flush the  
> > cache, not circumvent it. Might severly limit performance as writes are  
> > synchronous.
> >      Interface isn't very nice (need to ensure alignment to page size in 
> > memory).
> >
> > 2. Use posix_fadvise() with POSIX_FADV_DONTNEED.
> >      Probably works with the current kernel (haven't tested yet), but  
> > there's absolutely no guarantee.
> >      Interface much better than O_DIRECT.
> 
> FYI, here is a handy fadvise tool:
>         http://www.zip.com.au/~akpm/linux/patches/stuff/ext3-tools.tar.gz
> 
> Usage:
>         fadvise /some/file 0 0 dontneed

And I'd recommend to make a fsync() call before posix_fadvise() to
makes it work more reliably, because dirty pages are not guaranteed
to be freed by posix_fadvise().

Thanks,
Fengguang

