Return-Path: <linux-kernel-owner+w=401wt.eu-S1752601AbYJ0EsA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752601AbYJ0EsA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2008 00:48:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750967AbYJ0Erv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Oct 2008 00:47:51 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33666 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750735AbYJ0Eru (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2008 00:47:50 -0400
Date: Sun, 26 Oct 2008 21:47:41 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Dmitri Monakhov <dmonakhov@openvz.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] kill suid bit only for regular files
Message-Id: <20081026214741.332c7656.akpm@linux-foundation.org>
In-Reply-To: <1224424839-3892-1-git-send-email-dmonakhov@openvz.org>
References: <1224424839-3892-1-git-send-email-dmonakhov@openvz.org>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 19 Oct 2008 18:00:39 +0400 Dmitri Monakhov <dmonakhov@openvz.org> wrote:

> We don't have to do it because it is useless for non regular files.

Are we sure that should_remove_suid() is not and never will used for
directories?

> In fact block device may trigger this path without dentry->d_inode->i_mutex.

What's wrong with blockdevs triggering this path?

Better changelogs, please.

> Signed-off-by: Dmitri Monakhov <dmonakhov@openvz.org>
> ---
>  mm/filemap.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/mm/filemap.c b/mm/filemap.c
> index a2907d5..3d5a2e7 100644
> --- a/mm/filemap.c
> +++ b/mm/filemap.c
> @@ -1767,7 +1767,7 @@ int should_remove_suid(struct dentry *dentry)
>  	if (unlikely((mode & S_ISGID) && (mode & S_IXGRP)))
>  		kill |= ATTR_KILL_SGID;
>  
> -	if (unlikely(kill && !capable(CAP_FSETID)))
> +	if (unlikely(kill && !capable(CAP_FSETID) && S_ISREG(mode)))
>  		return kill;
>  
>  	return 0;



