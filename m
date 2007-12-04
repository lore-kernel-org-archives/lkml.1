Return-Path: <linux-kernel-owner+w=401wt.eu-S1752728AbXLDJ3x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752728AbXLDJ3x (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2007 04:29:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751821AbXLDJ3o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Dec 2007 04:29:44 -0500
Received: from mail.suse.de ([195.135.220.2]:34650 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751804AbXLDJ3m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2007 04:29:42 -0500
Date: Tue, 4 Dec 2007 10:29:40 +0100
From: Nick Piggin <npiggin@suse.de>
To: Rob Landley <rob@landley.net>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-fsdevel@vger.kernel.org,
       Christian Borntraeger <borntraeger@de.ibm.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Andrew Morton <akpm@linux-foundation.org>, Jens Axboe <axboe@kernel.dk>
Subject: Re: [patch] rewrite rd
Message-ID: <20071204092940.GA9618@wotan.suse.de>
References: <20071204042628.GA26636@wotan.suse.de> <200712040155.21124.rob@landley.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200712040155.21124.rob@landley.net>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 04, 2007 at 01:55:17AM -0600, Rob Landley wrote:
> On Monday 03 December 2007 22:26:28 Nick Piggin wrote:
> > There is one slight downside -- direct block device access and filesystem
> > metadata access goes through an extra copy and gets stored in RAM twice.
> > However, this downside is only slight, because the real buffercache of the
> > device is now reclaimable (because we're not playing crazy games with it),
> > so under memory intensive situations, footprint should effectively be the
> > same -- maybe even a slight advantage to the new driver because it can also
> > reclaim buffer heads.
> 
> For the embedded world, initramfs has pretty much rendered initrd obsolete, 
> and that was the biggest user of the ramdisk code I know of.  Beyond that, 
> loopback mounts give you more flexible transient block devices than ramdisks 
> do.  (In fact, ramdisks are such an amazing pain to use/size/free that if I 
> really needed something like that I'd just make a loopback mount in a ramfs 
> instance.)

They are, although we could easily hook up a couple more ioctls for them
now (if anybody is interested).

The rd driver can potentially be a _lot_ more scalable than the loop driver.
It's completely lockless in the fastpath and doesn't even dirty any
cachelines except for the actual destination memory. OK, this is only
really important for testing purposes (eg. testing scalability of a
filesystem etc.) But it is one reason why I (personally) want brd...
 

> Embedded users who still want a block interface for memory are generally 
> trying to use a cramfs or squashfs image out of ROM or flash, although there 
> are flash-specific filesystems for this and I dunno if they're actually 
> mounting /dev/mem at an offset or something (md?  losetup -o?  Beats me, I 
> haven't tried that myself yet...)

OK, it would be interesting to hear from anyone using rd for things like
cramfs. I don't think we can get rid of the code entirely, but it sounds
like the few downsides of the new code won't be big problems.

Thanks for the feedback.
