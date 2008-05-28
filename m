Return-Path: <linux-kernel-owner+w=401wt.eu-S1755327AbYE1Fin@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755327AbYE1Fin (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2008 01:38:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752219AbYE1Fig
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 May 2008 01:38:36 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48333 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751342AbYE1Fif (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2008 01:38:35 -0400
Date: Tue, 27 May 2008 22:38:32 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Guillaume Chazarain <guichaz@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fs-writeback: handle errors in sync_sb_inodes()
Message-Id: <20080527223832.f7131761.akpm@linux-foundation.org>
In-Reply-To: <20080523203429.11846.84137.stgit@localhost.localdomain>
References: <20080523203429.11846.84137.stgit@localhost.localdomain>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 23 May 2008 22:34:29 +0200 Guillaume Chazarain <guichaz@gmail.com> wrote:

> diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
> index 495214d..0e6881e 100644
> --- a/fs/fs-writeback.c
> +++ b/fs/fs-writeback.c
> @@ -454,6 +454,7 @@ void generic_sync_sb_inodes(struct super_block *sb,
>  		struct address_space *mapping = inode->i_mapping;
>  		struct backing_dev_info *bdi = mapping->backing_dev_info;
>  		long pages_skipped;
> +		int err;
>  
>  		if (!bdi_cap_writeback_dirty(bdi)) {
>  			redirty_tail(inode);
> @@ -498,7 +499,8 @@ void generic_sync_sb_inodes(struct super_block *sb,
>  		BUG_ON(inode->i_state & I_FREEING);
>  		__iget(inode);
>  		pages_skipped = wbc->pages_skipped;
> -		__writeback_single_inode(inode, wbc);
> +		err = __writeback_single_inode(inode, wbc);
> +		mapping_set_error(mapping, err);
>  		if (wbc->sync_mode == WB_SYNC_HOLD) {
>  			inode->dirtied_when = jiffies;
>  			list_move(&inode->i_list, &sb->s_dirty);

ho hum, I've forgotten why I didn't like this.  Let's give it a run.

