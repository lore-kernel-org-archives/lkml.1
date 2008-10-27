Return-Path: <linux-kernel-owner+w=401wt.eu-S1752113AbYJ0Dhx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752113AbYJ0Dhx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Oct 2008 23:37:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751328AbYJ0Dhq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Oct 2008 23:37:46 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46747 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751321AbYJ0Dhq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Oct 2008 23:37:46 -0400
Date: Sun, 26 Oct 2008 20:37:13 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Dmitri Monakhov <dmonakhov@openvz.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] vfs: Fix possible chmod/truncate race condition.
Message-Id: <20081026203713.c00e69db.akpm@linux-foundation.org>
In-Reply-To: <m33aixy7ls.fsf@dmon-lap.sw.ru>
References: <m33aixy7ls.fsf@dmon-lap.sw.ru>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 15 Oct 2008 23:35:27 +0400 Dmitri Monakhov <dmonakhov@openvz.org> wrote:

> 
> Signed-off-by: Dmitri Monakhov <dmonakhov@openvz.org>
> ---
>  fs/open.c |    3 +--
>  1 files changed, 1 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/open.c b/fs/open.c
> index 07da935..3423b94 100644
> --- a/fs/open.c
> +++ b/fs/open.c
> @@ -214,10 +214,9 @@ int do_truncate(struct dentry *dentry, loff_t length, unsigned int time_attrs,
>  		newattrs.ia_valid |= ATTR_FILE;
>  	}
>  
> +	mutex_lock(&dentry->d_inode->i_mutex);
>  	/* Remove suid/sgid on truncate too */
>  	newattrs.ia_valid |= should_remove_suid(dentry);
> -
> -	mutex_lock(&dentry->d_inode->i_mutex);
>  	err = notify_change(dentry, &newattrs);
>  	mutex_unlock(&dentry->d_inode->i_mutex);
>  	return err;

OK, I give up.  What race?
