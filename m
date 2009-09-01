Return-Path: <linux-kernel-owner+w=401wt.eu-S1754255AbZIAL4D@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754255AbZIAL4D (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Sep 2009 07:56:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754199AbZIAL4A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Sep 2009 07:56:00 -0400
Received: from thunk.org ([69.25.196.29]:46753 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753885AbZIALz7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Sep 2009 07:55:59 -0400
Date: Tue, 1 Sep 2009 07:55:51 -0400
From: Theodore Tso <tytso@mit.edu>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       chris.mason@oracle.com, david@fromorbit.com, hch@infradead.org,
       akpm@linux-foundation.org, jack@suse.cz
Subject: Re: [PATCH 1/8] writeback: move super_block argument to struct
	writeback_control
Message-ID: <20090901115551.GA727@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Jens Axboe <jens.axboe@oracle.com>, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, chris.mason@oracle.com,
	david@fromorbit.com, hch@infradead.org, akpm@linux-foundation.org,
	jack@suse.cz
References: <1251803946-9243-1-git-send-email-jens.axboe@oracle.com> <1251803946-9243-2-git-send-email-jens.axboe@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1251803946-9243-2-git-send-email-jens.axboe@oracle.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 01, 2009 at 01:18:59PM +0200, Jens Axboe wrote:
> Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
> ---
>  fs/ubifs/super.c                 |    3 ++-
>  include/linux/fs.h               |    3 +--
>
> diff --git a/fs/ubifs/super.c b/fs/ubifs/super.c
> @@ -462,7 +463,7 @@ static int ubifs_sync_fs(struct super_block *sb, int wait)
>  	 * the user be able to get more accurate results of 'statfs()' after
>  	 * they synchronize the file system.
>  	 */
> -	generic_sync_sb_inodes(sb, &wbc);
> +	generic_sync_sb_inodes(&wbc);
>  
>  	/*
>  	 * Synchronize write buffers, because 'ubifs_run_commit()' does not

I just tried compiling per-bdi v15 against the latest git HEAD, and
the compilation failed:

fs/ubifs/super.c: In function ‘ubifs_sync_fs’:
fs/ubifs/super.c:465: warning: passing argument 1 of ‘generic_sync_sb_inodes’ from incompatible pointer type
fs/ubifs/super.c:465: error: too many arguments to function ‘generic_sync_sb_inodes’

Looks like the latest version of fs/ubifs/super.c added a call to
generic_sync_sb_inodes that needs to be fixed up.  Line 465:

	generic_sync_sb_inodes(sb, &wbc);

						- Ted
