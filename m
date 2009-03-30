Return-Path: <linux-kernel-owner+w=401wt.eu-S1755817AbZC3HlT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755817AbZC3HlT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Mar 2009 03:41:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751566AbZC3HlI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Mar 2009 03:41:08 -0400
Received: from mga03.intel.com ([143.182.124.21]:26842 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751504AbZC3HlH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Mar 2009 03:41:07 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.38,445,1233561600"; 
   d="scan'208";a="125545059"
Date: Mon, 30 Mar 2009 15:40:52 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Sascha Silbe <sascha-ccparty-c74088b0@silbe.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Flushing the (page?) cache for a block device
Message-ID: <20090330074052.GA9667@localhost>
References: <20090329125439.GB4697@twin.sascha.silbe.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090329125439.GB4697@twin.sascha.silbe.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sascha,

On Sun, Mar 29, 2009 at 02:54:39PM +0200, Sascha Silbe wrote:
> Hello!
>
> I'd like to do a verification step after writing to a USB stick (block  
> device level, no filesystem involved). For this to work as intended, I  
> need to ensure the reads are not satisfied from blocks still in cache,  
> i.e.: flush "the cache" (page cache IIUC) for the block device in  
> question (and _only_ this device).
> Some research resulted in the following options:
>
> 1. Open the target file using O_DIRECT while writing.
>      Doesn't feel like the right thing to do; only want to flush the  
> cache, not circumvent it. Might severly limit performance as writes are  
> synchronous.
>      Interface isn't very nice (need to ensure alignment to page size in 
> memory).
>
> 2. Use posix_fadvise() with POSIX_FADV_DONTNEED.
>      Probably works with the current kernel (haven't tested yet), but  
> there's absolutely no guarantee.
>      Interface much better than O_DIRECT.

FYI, here is a handy fadvise tool:
        http://www.zip.com.au/~akpm/linux/patches/stuff/ext3-tools.tar.gz

Usage:
        fadvise /some/file 0 0 dontneed

Thanks,
Fengguang

> 3. Flush the entire page cache using procfs.
>      Brute force, last resort. Will severly impact performance of my  
> tool (as it's going to write to several devices in parallel).
>
>
> Is there a better method I've not found yet? Nr. 2 sounds like the way  
> to go, but I don't like that it could (silently!) stop working with any  
> new kernel version.
>
>
> PS: Not subscribed, so please CC me.
>
> CU Sascha
>
> -- 
> http://sascha.silbe.org/
> http://www.infra-silbe.de/


