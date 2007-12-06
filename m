Return-Path: <linux-kernel-owner+w=401wt.eu-S1753687AbXLFKTV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753687AbXLFKTV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2007 05:19:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752542AbXLFKSw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Dec 2007 05:18:52 -0500
Received: from ns.suse.de ([195.135.220.2]:39029 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752358AbXLFKSu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2007 05:18:50 -0500
Date: Thu, 6 Dec 2007 11:18:48 +0100
From: Nick Piggin <npiggin@suse.de>
To: carsteno@de.ibm.com
Cc: Christian Borntraeger <borntraeger@de.ibm.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-fsdevel@vger.kernel.org,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Andrew Morton <akpm@linux-foundation.org>, rob@landley.net,
       Jens Axboe <axboe@kernel.dk>
Subject: Re: [patch] ext2: xip check fix
Message-ID: <20071206101848.GC25202@wotan.suse.de>
References: <20071204042628.GA26636@wotan.suse.de> <200712041054.51599.borntraeger@de.ibm.com> <20071204101009.GB9618@wotan.suse.de> <20071204112100.GA20420@wotan.suse.de> <20071204112327.GB20420@wotan.suse.de> <4756C714.2040809@de.ibm.com> <20071205233345.GB5617@wotan.suse.de> <4757B62F.2040608@de.ibm.com> <20071206085223.GA25202@wotan.suse.de> <4757C7E6.7050405@de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4757C7E6.7050405@de.ibm.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 06, 2007 at 10:59:02AM +0100, Carsten Otte wrote:
> Nick Piggin wrote:
> >After my patch, we can do XIP in a hardsect size < PAGE_SIZE block
> >device -- this seems to be a fine thing to do at least for the
> >ramdisk code. Would this situation be problematic for existing drivers,
> >and if so, in what way?
> I have done some archeology, and our ancient CVS logs show this check 
> was introduced in early 2005 into our 2.6.x. codebase. However, it 
> existed way before, and was copied from our prehistorical ext2 split 
> named xip2 back in the old days of 2.4.x where we did not really have 
> a block device behind because that one was scamped into the file 
> system in a very queer way.

OK, thanks for taking a look at that. It will be helpful for testing
XIP with my new ramdisk driver (did you see the patch?).


> After all, I don't see any risk in removing the check. The only driver 
> we have that does direct_access is drivers/s390/block/dcssblk.c, and 
> that one only supports block_size == PAGE_SIZE. I think the patch 
> should go into mainline.

Actually another one's recently sprung up too (arch/powerpc/sysdev/axonram.c)
but it looks like that one should be fine as it looks to be all simply memory
mapped.

 
> Acked-by: Carsten Otte <cotte@de.ibm.com>

Thanks! Andrew, would you queue this up for 2.6.25 please?
