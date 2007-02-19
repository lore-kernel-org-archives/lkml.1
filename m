Return-Path: <linux-kernel-owner+w=401wt.eu-S1752596AbXBSAbU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752596AbXBSAbU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Feb 2007 19:31:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752597AbXBSAbT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Feb 2007 19:31:19 -0500
Received: from mail-gw1.sa.eol.hu ([212.108.200.67]:47568 "EHLO
	mail-gw1.sa.eol.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752596AbXBSAbS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Feb 2007 19:31:18 -0500
To: akpm@linux-foundation.org
CC: linux-kernel@vger.kernel.org, linux-mm@kvack.org
In-reply-to: <E1HIwLJ-0005N4-00@dorka.pomaz.szeredi.hu> (message from Miklos
	Szeredi on Mon, 19 Feb 2007 01:25:21 +0100)
Subject: Re: dirty balancing deadlock
References: <E1HIqlm-0004iZ-00@dorka.pomaz.szeredi.hu>
	<20070218125307.4103c04a.akpm@linux-foundation.org>
	<E1HIurG-0005Bw-00@dorka.pomaz.szeredi.hu>
	<20070218145929.547c21c7.akpm@linux-foundation.org>
	<E1HIvMB-0005Fd-00@dorka.pomaz.szeredi.hu> <20070218155916.0d3c73a9.akpm@linux-foundation.org> <E1HIwLJ-0005N4-00@dorka.pomaz.szeredi.hu>
Message-Id: <E1HIwQG-0005OS-00@dorka.pomaz.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Mon, 19 Feb 2007 01:30:28 +0100
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> --- a/fs/fs-writeback.c~a
> +++ a/fs/fs-writeback.c
> @@ -356,7 +356,7 @@ int generic_sync_sb_inodes(struct super_
>  			continue;		/* Skip a congested blockdev */
>  		}
>  
> -		if (wbc->bdi && bdi != wbc->bdi) {
> +		if (wbc->bdi && bdi != wbc->bdi && bdi_write_congested(bdi)) {
>  			if (!sb_is_blkdev_sb(sb))
>  				break;		/* fs has the wrong queue */
>  			list_move(&inode->i_list, &sb->s_dirty);

Checking bdi_write_congested(bdi) is not reliable, since the queue can
become congested _after_ the check is done.

Miklos
