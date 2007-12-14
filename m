Return-Path: <linux-kernel-owner+w=401wt.eu-S932763AbXLNPtt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932763AbXLNPtt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2007 10:49:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761403AbXLNPtH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Dec 2007 10:49:07 -0500
Received: from e1.ny.us.ibm.com ([32.97.182.141]:57129 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761378AbXLNPtF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2007 10:49:05 -0500
Date: Fri, 14 Dec 2007 09:43:43 -0600
From: Michael Halcrow <mhalcrow@us.ibm.com>
To: Eric Sandeen <sandeen@redhat.com>
Cc: linux-kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] ecryptfs: set s_blocksize from lower fs in sb
Message-ID: <20071214154343.GA10989@localhost.austin.ibm.com>
Reply-To: Michael Halcrow <mhalcrow@us.ibm.com>
References: <4762A192.3020600@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4762A192.3020600@redhat.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 14, 2007 at 09:30:26AM -0600, Eric Sandeen wrote:
> eCryptfs wasn't setting s_blocksize in it's superblock; just pick
> it up from the lower FS.  Having an s_blocksize of 0 made things
> like "filefrag" which call FIGETBSZ unhappy.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Acked-by: Mike Halcrow <mhalcrow@us.ibm.com>

> 
> ---
> 
> Index: linux-2.6.24-rc3/fs/ecryptfs/main.c
> ===================================================================
> --- linux-2.6.24-rc3.orig/fs/ecryptfs/main.c
> +++ linux-2.6.24-rc3/fs/ecryptfs/main.c
> @@ -523,6 +523,7 @@ static int ecryptfs_read_super(struct su
>  	lower_mnt = nd.mnt;
>  	ecryptfs_set_superblock_lower(sb, lower_root->d_sb);
>  	sb->s_maxbytes = lower_root->d_sb->s_maxbytes;
> +	sb->s_blocksize = lower_root->d_sb->s_blocksize;
>  	ecryptfs_set_dentry_lower(sb->s_root, lower_root);
>  	ecryptfs_set_dentry_lower_mnt(sb->s_root, lower_mnt);
>  	rc = ecryptfs_interpose(lower_root, sb->s_root, sb, 0);
> 
