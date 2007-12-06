Return-Path: <linux-kernel-owner+w=401wt.eu-S1755126AbXLFIwe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755126AbXLFIwe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2007 03:52:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753081AbXLFIw0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Dec 2007 03:52:26 -0500
Received: from cantor.suse.de ([195.135.220.2]:50290 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752838AbXLFIwZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2007 03:52:25 -0500
Date: Thu, 6 Dec 2007 09:52:23 +0100
From: Nick Piggin <npiggin@suse.de>
To: carsteno@de.ibm.com
Cc: Christian Borntraeger <borntraeger@de.ibm.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-fsdevel@vger.kernel.org,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Andrew Morton <akpm@linux-foundation.org>, rob@landley.net,
       Jens Axboe <axboe@kernel.dk>
Subject: Re: [patch] ext2: xip check fix
Message-ID: <20071206085223.GA25202@wotan.suse.de>
References: <20071204042628.GA26636@wotan.suse.de> <200712041054.51599.borntraeger@de.ibm.com> <20071204101009.GB9618@wotan.suse.de> <20071204112100.GA20420@wotan.suse.de> <20071204112327.GB20420@wotan.suse.de> <4756C714.2040809@de.ibm.com> <20071205233345.GB5617@wotan.suse.de> <4757B62F.2040608@de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4757B62F.2040608@de.ibm.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 06, 2007 at 09:43:27AM +0100, Carsten Otte wrote:
> Nick Piggin wrote:
> >>Xip does only work, if both do match PAGE_SIZE because it 
> >>does'nt support multiple calls to direct_access in the get_xip_page 
> >>address space operation. Thus we check both here, actually this was 
> >>changed from how it looks after your patch as a bugfix where our 
> >>tester tried a 4k filesystem on a 2k blockdev.
> >>Did I miss something?
> >
> >However, the bdev block size may be changed with sb_set_blocksize. It
> >doesn't actually have to match the hardware sector size -- if this
> >does matter for XIP, then I think you need some other check here.
> Hmmmmhh. For a bdev with PAGE_SIZE hardsect size, there is no other 
> valid value then PAGE_SIZE that one could set it to. Or can it indeed 
> be changed to a value greater then PAGE_SIZE or smaller then hardsect 
> size?

It can't be made smaller (or larger, in current kernels). But you
already get all that checking done for you -- both by checking that
the filesystem blocksize == PAGE_SIZE, and by the error checking in
sb_set_blocksize.

After my patch, we can do XIP in a hardsect size < PAGE_SIZE block
device -- this seems to be a fine thing to do at least for the
ramdisk code. Would this situation be problematic for existing drivers,
and if so, in what way?

Thanks,
Nick

