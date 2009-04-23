Return-Path: <linux-kernel-owner+w=401wt.eu-S1756091AbZDWTVh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756091AbZDWTVh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 15:21:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754479AbZDWTVZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 15:21:25 -0400
Received: from brick.kernel.dk ([93.163.65.50]:34127 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753199AbZDWTVZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 15:21:25 -0400
Date: Thu, 23 Apr 2009 21:21:24 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Christoph Hellwig <hch@lst.de>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: get_fs_excl/put_fs_excl/has_fs_excl
Message-ID: <20090423192123.GL4593@kernel.dk>
References: <20090423191817.GA22521@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090423191817.GA22521@lst.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 23 2009, Christoph Hellwig wrote:
> Stumbled over these gems recently when investigating the
> lock_super/unlock_super removal.
> 
> These were added in commit 22e2c507c301c3dbbcf91b4948b88f78842ee6c9
> 
>         [PATCH] Update cfq io scheduler to time sliced design
> 
> which unfortunately doesn't contain any comments about it.  It seems to
> be used to allow boosting priority for some sort of central fs metadata
> updates, at least what the usage in the reiserfs journal code
> looks like that.
> 
> Do you happen to have some notes/anecdotes about it so that we can
> document it, give it saner naming and use it directly in the
> spots that need it (including inside xfs, btrfs, etc) instead of lock_super?

The intent was to add some sort of notification mechanism from the file
system to inform the IO scheduler (and others?) that this process is how
holding a file system wide resource. So if you have a low priority
process getting access to such a resource, you want to boost its
priority to avoid higher priority apps getting stuck beind it. Sort of a
poor mans priority inheritance.

It would be wonderful if you could kick this process more into gear on
the fs side...

-- 
Jens Axboe

