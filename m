Return-Path: <linux-kernel-owner+w=401wt.eu-S1755082AbZIPS3c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755082AbZIPS3c (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 14:29:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754259AbZIPS3a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 14:29:30 -0400
Received: from brick.kernel.dk ([93.163.65.50]:56890 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753282AbZIPS33 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 14:29:29 -0400
Date: Wed, 16 Sep 2009 20:29:32 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Jan Kara <jack@suse.cz>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       chris.mason@oracle.com, hch@infradead.org, tytso@mit.edu,
       akpm@linux-foundation.org, trond.myklebust@fys.uio.no
Subject: Re: [PATCH 10/16] writeback: splice dirty inode entries to default
	bdi on bdi_destroy()
Message-ID: <20090916182932.GR23126@kernel.dk>
References: <1253107494-20160-1-git-send-email-jens.axboe@oracle.com> <1253107494-20160-11-git-send-email-jens.axboe@oracle.com> <20090916134346.GM26030@duck.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090916134346.GM26030@duck.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 16 2009, Jan Kara wrote:
> On Wed 16-09-09 15:24:48, Jens Axboe wrote:
> > We cannot safely ensure that the inodes are all gone at this point
> > in time, and we must not destroy this bdi with inodes having off it.
> > So just splice our entries to the default bdi since that one will
> > always persist.
>   I'd at least add a comment like
> "XXX: This is probably a bug but let's workaround it for now."
>   And either remove the code or update the comment when this gets resolved.

Thinking more about it - what if inodes happen to get requeued on the
final flush? bdi_destroy() likely can't wait for flushing to happen,
since (depending on the tear down cycle), part of the device may be gone
already.

And I did mean __sync_filesystem() -> __sync_blockdev(), since this is
what happen on last close. So it could also be that we need something
stronger to guarantee that things are really gone.

-- 
Jens Axboe

