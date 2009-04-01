Return-Path: <linux-kernel-owner+w=401wt.eu-S934535AbZDAVyv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934535AbZDAVyv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Apr 2009 17:54:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754897AbZDAVyk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Apr 2009 17:54:40 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51533 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752909AbZDAVyk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Apr 2009 17:54:40 -0400
Date: Wed, 1 Apr 2009 14:50:41 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Manish Katiyar <mkatiyar@gmail.com>
Cc: trivial@kernel.org, adilger@sun.com, mkatiyar@gmail.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] : Add dev-id and inode number for debugging in 
 init_special_inode in fs/inode.c
Message-Id: <20090401145041.6681fc90.akpm@linux-foundation.org>
In-Reply-To: <ea11fea30903301941p3a5a71c2l816df9a3d8341183@mail.gmail.com>
References: <ea11fea30903222016j1d16372ct2dfd6004452e0531@mail.gmail.com>
	<20090330163317.a273a46a.akpm@linux-foundation.org>
	<ea11fea30903301941p3a5a71c2l816df9a3d8341183@mail.gmail.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 31 Mar 2009 08:11:00 +0530
Manish Katiyar <mkatiyar@gmail.com> wrote:

> --- a/fs/inode.c
> +++ b/fs/inode.c
> @@ -1540,7 +1540,8 @@ void init_special_inode(struct inode *inode, umode_t mode, dev_t rdev)
>  	else if (S_ISSOCK(mode))
>  		inode->i_fop = &bad_sock_fops;
>  	else
> -		printk(KERN_DEBUG "init_special_inode: bogus i_mode (%o)\n",
> -		       mode);
> +		printk(KERN_DEBUG "init_special_inode: bogus i_mode (%o) for"
> +				  " inode %s:%lu\n", mode, inode->i_sb->s_id,
> +				  inode->i_ino);
>  }

Is ther a guarantee that inode->i_sb and inode->i_ino have been initialised
at this time?
