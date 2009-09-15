Return-Path: <linux-kernel-owner+w=401wt.eu-S1753804AbZIONQv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753804AbZIONQv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Sep 2009 09:16:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753744AbZIONQs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Sep 2009 09:16:48 -0400
Received: from mail-out2.uio.no ([129.240.10.58]:44555 "EHLO mail-out2.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753728AbZIONQr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Sep 2009 09:16:47 -0400
Subject: Re: [PATCH 2/7] Assign bdi in super_block
From: Trond Myklebust <trond.myklebust@fys.uio.no>
To: Jan Kara <jack@suse.cz>
Cc: Jens Axboe <jens.axboe@oracle.com>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, chris.mason@oracle.com,
       hch@infradead.org, tytso@mit.edu, akpm@linux-foundation.org
In-Reply-To: <20090915101457.GE12169@duck.suse.cz>
References: <1252920994-11141-1-git-send-email-jens.axboe@oracle.com>
	 <1252920994-11141-3-git-send-email-jens.axboe@oracle.com>
	 <20090914130228.GG24075@duck.suse.cz>
	 <1252952724.6866.62.camel@heimdal.trondhjem.org>
	 <20090914183654.GJ14984@kernel.dk>  <20090915101457.GE12169@duck.suse.cz>
Content-Type: text/plain
Date: Tue, 15 Sep 2009 09:16:41 -0400
Message-Id: <1253020601.4456.1.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
X-UiO-Ratelimit-Test: rcpts/h 8 msgs/h 1 sum rcpts/h 17 sum msgs/h 2 total rcpts 1454 max rcpts/h 27 ratelimit 0
X-UiO-Spam-info: not spam, SpamAssassin (score=-5.0, required=5.0, autolearn=disabled, UIO_MAIL_IS_INTERNAL=-5, uiobl=NO, uiouri=NO)
X-UiO-Scanned: 9AD549F681A45692371992A3612E9BF059F49A75
X-UiO-SPAM-Test: remote_host: 68.40.207.222 spam_score: -49 maxlevel 80 minaction 2 bait 0 mail/h: 1 total 253 max/h 6 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-09-15 at 12:14 +0200, Jan Kara wrote:
> On Mon 14-09-09 20:36:54, Jens Axboe wrote:
> > No, that should work fine. NFS already works fine with the bdi flusher
> > threads, so you should just point it at that bdi.
>   But will it really work well? I mean if we sync the superblock on the
> client, it will sync only the private BDI. So it won't sync any directory
> inodes because they are on the default_backing_dev_info (NFS leaves
> sb->s_bdev at NULL).

All directory related operations (link, rename, create, ...) are fully
synchronous in NFS. There should be no need to set up anything to
synchronise directory inodes.

Cheers
  Trond

