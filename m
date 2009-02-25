Return-Path: <linux-kernel-owner+w=401wt.eu-S1761961AbZBYKxw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761961AbZBYKxw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Feb 2009 05:53:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753328AbZBYKxm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Feb 2009 05:53:42 -0500
Received: from mx2.suse.de ([195.135.220.15]:56575 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752211AbZBYKxl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Feb 2009 05:53:41 -0500
Date: Wed, 25 Feb 2009 11:53:38 +0100
From: Nick Piggin <npiggin@suse.de>
To: Jeff Garzik <jeff@garzik.org>
Cc: linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [patch][rfc] fs: move bdev code out of buffer.c
Message-ID: <20090225105338.GH22785@wotan.suse.de>
References: <20090225094419.GF22785@wotan.suse.de> <49A51EFF.4020600@garzik.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49A51EFF.4020600@garzik.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 25, 2009 at 05:35:43AM -0500, Jeff Garzik wrote:
> Nick Piggin wrote:
> >Move some block device related code out from buffer.c and put it in
> >block_dev.c. I'm trying to move non-buffer_head code out of buffer.c
> >
> >Is this OK?
> >
> >---
> > fs/block_dev.c              |  146 
> > ++++++++++++++++++++++++++++++++++++++++++++
> > fs/buffer.c                 |  145 
> > -------------------------------------------
> > include/linux/buffer_head.h |    7 --
> > include/linux/fs.h          |    7 ++
> > 4 files changed, 153 insertions(+), 152 deletions(-)
> 
> If you are going to churn all this old code, maybe the blkdev stuff 
> better belongs in block/ dir?

If you have a look at it, it's all dealing with buffercache and
filesystem metadata I think. So I think fs/block_dev.c is the
right place for it.

block/ shouldn't know about filesystems or pagecache.

