Return-Path: <linux-kernel-owner+w=401wt.eu-S1751477AbZIBK0Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751477AbZIBK0Z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Sep 2009 06:26:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751401AbZIBK0Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Sep 2009 06:26:24 -0400
Received: from brick.kernel.dk ([93.163.65.50]:55471 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751350AbZIBK0Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Sep 2009 06:26:24 -0400
Date: Wed, 2 Sep 2009 12:26:26 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Jan Kara <jack@suse.cz>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       chris.mason@oracle.com, david@fromorbit.com, hch@infradead.org,
       tytso@mit.edu, akpm@linux-foundation.org
Subject: Re: [PATCH 1/8] writeback: get rid of generic_sync_sb_inodes()
	export
Message-ID: <20090902102626.GR12579@kernel.dk>
References: <1251880967-1136-1-git-send-email-jens.axboe@oracle.com> <1251880967-1136-2-git-send-email-jens.axboe@oracle.com> <20090902101333.GB17842@duck.novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090902101333.GB17842@duck.novell.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 02 2009, Jan Kara wrote:
> On Wed 02-09-09 10:42:40, Jens Axboe wrote:
> > This adds two new exported functions:
> > 
> > - sync_inodes_sb(), which writes out dirty inodes on a super_block, and
> > - sync_inodes_sb_wait(), which does the same but also waits for IO
> >   completion.
>   This is a nice cleanup. I only find the name sync_inodes_sb() slightly
> misleading and the comment by that function as well. The name should rather
> be something like writeback_inodes_sb() (and sync_inodes_sb_wait() could
> stay just sync_inodes_sb()) - the writeback it does does not really
> guarantee anything. For example it can skip inodes or pages it does not
> like for some reason. What that function really does is - try to write some
> dirty pages on that superblock and don't try too hard.
>   I don't insist on the renaming of the function but I really thing the
> comment should be improved.

I don't disagree, I was a bit torn on the naming as well. I will make
that change, thanks for the feedback!

I'd really like your feedback on the pin_sb_for_writeback() stuff too,
since that is the contentious bit. And, this goes for others as well,
I'd appreciate any reviewed-by and/or acked-by on patches.

-- 
Jens Axboe

