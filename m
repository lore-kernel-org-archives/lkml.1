Return-Path: <linux-kernel-owner+w=401wt.eu-S1758279AbYAQXsk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758279AbYAQXsk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2008 18:48:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755961AbYAQXsb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jan 2008 18:48:31 -0500
Received: from def92-3-81-56-114-101.fbx.proxad.net ([81.56.114.101]:38855
	"EHLO barad-dur.regala.cx" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756101AbYAQXsa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2008 18:48:30 -0500
To: linux-ext4@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, sct@redhat.com
Subject: Re: [PATCH] Convert ext3_ioctl() to an unlocked_ioctl
References: <1200573450-1246-1-git-send-email-mathieu.segaud@regala.cx>
	<1200573450-1246-2-git-send-email-mathieu.segaud@regala.cx>
From: Mathieu SEGAUD <mathieu.segaud@regala.cx>
Date: Fri, 18 Jan 2008 00:48:29 +0100
In-Reply-To: <1200573450-1246-2-git-send-email-mathieu.segaud@regala.cx> (Mathieu Segaud's message of "Thu\, 17 Jan 2008 13\:37\:29 +0100")
Message-ID: <87wsq89foy.fsf@barad-dur.regala.cx>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vous m'avez dit récemment :

> --- a/fs/ext3/ioctl.c
> +++ b/fs/ext3/ioctl.c
> @@ -17,12 +17,19 @@
>  #include <linux/smp_lock.h>
>  #include <asm/uaccess.h>
>  
> -int ext3_ioctl (struct inode * inode, struct file * filp, unsigned int cmd,
> +long ext3_ioctl(struct file *filp, unsigned int cmd,
>  		unsigned long arg)
>  {
> -	struct ext3_inode_info *ei = EXT3_I(inode);
> +	struct ext3_inode_info *ei;
> +	struct inode *inode;
>  	unsigned int flags;
>  	unsigned short rsv_window_size;
> +	long retval = 0;
> +
> +	lock_kernel();
> +
> +	inode = filp->f_dentry->d_inode;

I guess this should be
        inode = filp->f_path.dentry->d_inode;


I will repost a fixed patch
sorry for this one.


> +	ei = EXT3_I(inode);
>  
>  	ext3_debug ("cmd = %u, arg = %lu\n", cmd, arg);
>  

-- 
Mathieu
