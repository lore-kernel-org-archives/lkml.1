Return-Path: <linux-kernel-owner+w=401wt.eu-S1754752AbYKGBXU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754752AbYKGBXU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2008 20:23:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750860AbYKGBXL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Nov 2008 20:23:11 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48370 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750733AbYKGBXK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2008 20:23:10 -0500
Date: Thu, 6 Nov 2008 17:22:21 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: ebiederm@xmission.com (Eric W. Biederman)
Cc: linux-kernel@vger.kernel.org, adobriyan@gmail.com, viro@ZenIV.linux.org.uk,
       containers@lists.osdl.org
Subject: Re: [PATCH 1/7] vfs: Fix shrink_submounts
Message-Id: <20081106172221.dbeb5b12.akpm@linux-foundation.org>
In-Reply-To: <m1ej1p2l6u.fsf@frodo.ebiederm.org>
References: <m1ej1p2l6u.fsf@frodo.ebiederm.org>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 06 Nov 2008 02:38:49 -0800
ebiederm@xmission.com (Eric W. Biederman) wrote:

> 
> In the last refactoring of shrink_submounts a variable was
> not completely renamed.  So finish the renaming of mnt to m
> now.
> 
> Without this if you attempt to mount an nfs mount that has
> both automatic nfs sub mounts on it, and has normal mounts
> on it.  The unmount will succeed when it should not.
> 
> Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
> ---
>  fs/namespace.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/namespace.c b/fs/namespace.c
> index cce4670..65b3dc8 100644
> --- a/fs/namespace.c
> +++ b/fs/namespace.c
> @@ -1815,8 +1815,8 @@ static void shrink_submounts(struct vfsmount *mnt, struct list_head *umounts)
>  		while (!list_empty(&graveyard)) {
>  			m = list_first_entry(&graveyard, struct vfsmount,
>  						mnt_expire);
> -			touch_mnt_namespace(mnt->mnt_ns);
> -			umount_tree(mnt, 1, umounts);
> +			touch_mnt_namespace(m->mnt_ns);
> +			umount_tree(m, 1, umounts);
>  		}
>  	}
>  }

OK, so that's a for-2.6.28 bugfix, yes?

The other six patches will fall under Alexey's procfs tree.
