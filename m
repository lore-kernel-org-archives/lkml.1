Return-Path: <linux-kernel-owner+w=401wt.eu-S1756164AbYHYOui@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756164AbYHYOui (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2008 10:50:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754987AbYHYOuN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Aug 2008 10:50:13 -0400
Received: from mx2.suse.de ([195.135.220.15]:38104 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754845AbYHYOuM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2008 10:50:12 -0400
Date: Mon, 25 Aug 2008 07:47:14 -0700
From: Greg KH <gregkh@suse.de>
To: Tejun Heo <tj@kernel.org>, Jens Axboe <jens.axboe@oracle.com>
Cc: Abdel Benamrouche <draconux@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCHSET 1/3 blk-for-2.6.28] block: misc fixes and
	improvements
Message-ID: <20080825144714.GA20813@suse.de>
References: <1219655740-11672-1-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1219655740-11672-1-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 25, 2008 at 06:15:35PM +0900, Tejun Heo wrote:
> Hello,
> 
> This patchset contains the following five patches containing misc
> fixes and improvements.
> 
>   0001-block-fix-partition-info-printouts.patch
>   0002-block-don-t-grab-block_class_lock-unnecessarily.patch
>   0003-block-use-class_dev_iterator-instead-of-class_for_e.patch
>   0004-block-allow-deleting-zero-length-partition.patch
>   0005-block-update-add_partition-error-handling.patch
> 
> Recent block_class iteration updates 5c6f35c5..27f3025 introduced a
> few bugs and trivial user visible behavior change.  0001-0003 update
> those issues and simplify related code using new class iterator.

The bugs should now be fixed in Linus's tree due to a fix from Kay,
right?

The user visable behavior change, I missed that, sorry, that is a
regression, do you think it's a big deal to fix in 2.6.27?

> 0004 fixes deletion of zero sized partitions.
> 
> d805dda4 tried to fix error handling path in add_partition() but had a
> few problems.  0005 fixes those and moves busy partition check into
> add_partition().
> 
> This patchset is against
> 
>   blk-for-2.6.28 (9abd7c437c02e7448fb1d2d3cfc0b9c1ab77cf2d)
> + [1] klist-dont-iterate-over-deleted-entries
> + [2] use-klist-for-class-device-list-and-implement-iterator
> 
> and available in the following git tree.
> 
>   http://git.kernel.org/?p=linux/kernel/git/tj/misc.git;a=shortlog;h=block-misc-fixes
>   git://git.kernel.org/pub/scm/linux/kernel/git/tj/misc.git block-misc-fixes
> 
> with the following combined diffstat

I have no problem taking all of these patches as I did this original
work and don't want to burden Jens with this.  Also, I'd like to work
off of the klist changes and class changes as that can be used in other
work that I want to do in the driver core.

Jens any objection to me taking them?  Do you also have changes in this
area that this needs to be merged with?

thanks,

greg k-h
