Return-Path: <linux-kernel-owner+w=401wt.eu-S1755363AbZANS1c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755363AbZANS1c (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 13:27:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755008AbZANS1R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 13:27:17 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:55879 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753156AbZANS1Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 13:27:16 -0500
Date: Wed, 14 Jan 2009 19:27:06 +0100
From: Pavel Machek <pavel@suse.cz>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] ext2: Add blk_issue_flush() to syncing paths
Message-ID: <20090114182706.GA24719@elf.ucw.cz>
References: <1231945948-23676-1-git-send-email-jack@suse.cz> <1231945948-23676-2-git-send-email-jack@suse.cz> <20090114101834.fbb9ea12.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090114101834.fbb9ea12.akpm@linux-foundation.org>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> Also, the changelog needs some work, methinks.
> 
> /**
>  * blkdev_issue_flush - queue a flush
>  * @bdev:	blockdev to issue flush for
>  * @error_sector:	error sector
>  *
>  * Description:
>  *    Issue a flush for the block device in question. Caller can supply
>  *    room for storing the error offset in case of a flush error, if they
>  *    wish to.  Caller must run wait_for_completion() on its own.
>  */
> 
> So afaict the change you've made is incomplete.  We'll queue a
> writeback command to the disk but we won't wait for it to be sent down
> the wire.  Nor do we wait for the command to complete at the device
> end.  So it can still be a looong time (seconds!) before the data which
> the user thinks is on disk really is safe.
> 
> Yes?
> 
> If so, this design decision should be described in the changelog, and
> justified.  Actually, doing this in the comment over
> ext3_blkdev_issue_flush() would be good.

Actually, if sync() and fsync() do not work, it probably needs more
than a comment in changelog. Like comment in documentation, in big
bold letters.
									Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
