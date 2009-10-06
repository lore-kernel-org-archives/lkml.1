Return-Path: <linux-kernel-owner+w=401wt.eu-S933004AbZJFSHH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933004AbZJFSHH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 14:07:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932989AbZJFSHG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 14:07:06 -0400
Received: from brick.kernel.dk ([93.163.65.50]:37034 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932987AbZJFSHF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 14:07:05 -0400
Date: Tue, 6 Oct 2009 20:06:28 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Jeff Moyer <jmoyer@redhat.com>
Cc: zach.brown@oracle.com, linux-aio <linux-aio@kvack.org>,
       Linux Kernel Mailing <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [patch v4 0/3] aio: implement request batching [more
	performance numbers]
Message-ID: <20091006180628.GB5216@kernel.dk>
References: <x49zl8976g3.fsf@segfault.boston.devel.redhat.com> <x49eipga02o.fsf@segfault.boston.devel.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <x49eipga02o.fsf@segfault.boston.devel.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 06 2009, Jeff Moyer wrote:
> Here's a mail I got from Nathan Roberts.
> 
> Cheers,
> Jeff
> 
> ---
> 
> Similar test as before. I had to re-upload the files so comparing
> against last time isn't really apples-apples.
> 
> Disk is a cciss logical drive consisting of 12 SATA drives in a RAID6
> configuration with 128K stripes.
> 
> Test case 1 is to read 1 million random 40K files (no file is read
> more than once), 16 4K iocbs at a time, 100 threads.
> 
> Test case 2 is the same except 100,000 128K files are read.
> 
> Unit of measure is "files read per second".
> 
> 
> 40K
> -------------------------------------------------
> Kernel                              NOOP
> ------                              ----
> 2.6.30.5                            682
> 2.6.30.5 (w/o drop_caches)          718
> 2.6.30.5+patch_v4                   900
> 2.6.30.5+patch_v4 (w/o drop caches) 965
> 
> 
> 128K
> -------------------------------------------------
> Kernel                              NOOP
> ------                              ----
> 2.6.30.5                            242
> 2.6.30.5 (w/o drop_caches)          350
> 2.6.30.5+patch_v4                   292
> 2.6.30.5+patch_v4 (w/o drop caches) 420

Nice numbers! The patch looks good to me from a quick look, if you want
I can throw it into the testing mix tomorrow and see what kind of
improvements I see here. With performance increase of that magnitude, we
should get it in sooner rather than later.

-- 
Jens Axboe

