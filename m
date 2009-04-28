Return-Path: <linux-kernel-owner+w=401wt.eu-S932692AbZD1QON@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932692AbZD1QON (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 12:14:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753024AbZD1QNz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 12:13:55 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:53859 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751294AbZD1QNy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 12:13:54 -0400
Date: Tue, 28 Apr 2009 18:13:53 +0200
From: Jan Kara <jack@suse.cz>
To: "Theodore Ts'o" <tytso@mit.edu>
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
       Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
       Al Viro <viro@ZenIV.linux.org.uk>,
       Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2/5] ext4: Remove outdated comment about lock_super()
Message-ID: <20090428161353.GJ21950@atrey.karlin.mff.cuni.cz>
References: <1240717765-16572-1-git-send-email-tytso@mit.edu> <1240717765-16572-2-git-send-email-tytso@mit.edu> <1240717765-16572-3-git-send-email-tytso@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1240717765-16572-3-git-send-email-tytso@mit.edu>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> ext4_fill_super() is no longer called by read_super(), and it is no
> longer called with the superblock locked.  The
> unlock_super()/lock_super() is no longer present, so this comment is
> entirely superfluous.
  Yes, the comment seems to be out of date.

Acked-by: Jan Kara <jack@suse.cz>

									Honza
> 
> Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
> ---
>  fs/ext4/super.c |    8 --------
>  1 files changed, 0 insertions(+), 8 deletions(-)
> 
> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
> index e20ff9c..e0b0c9f 100644
> --- a/fs/ext4/super.c
> +++ b/fs/ext4/super.c
> @@ -2806,14 +2806,6 @@ no_journal:
>  		goto failed_mount4;
>  	};
>  
> -	/*
> -	 * akpm: core read_super() calls in here with the superblock locked.
> -	 * That deadlocks, because orphan cleanup needs to lock the superblock
> -	 * in numerous places.  Here we just pop the lock - it's relatively
> -	 * harmless, because we are now ready to accept write_super() requests,
> -	 * and aviro says that's the only reason for hanging onto the
> -	 * superblock lock.
> -	 */
>  	EXT4_SB(sb)->s_mount_state |= EXT4_ORPHAN_FS;
>  	ext4_orphan_cleanup(sb, es);
>  	EXT4_SB(sb)->s_mount_state &= ~EXT4_ORPHAN_FS;
> -- 
> 1.5.6.3
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
