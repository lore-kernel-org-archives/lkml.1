Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932703Ab0CLL2N (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Mar 2010 06:28:13 -0500
Received: from isrv.corpit.ru ([81.13.33.159]:53604 "EHLO isrv.corpit.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932538Ab0CLL2L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Mar 2010 06:28:11 -0500
Message-ID: <4B9A2548.7050401@msgid.tls.msk.ru>
Date: Fri, 12 Mar 2010 14:28:08 +0300
From: Michael Tokarev <mjt@tls.msk.ru>
User-Agent: Mozilla-Thunderbird 2.0.0.22 (X11/20090706)
MIME-Version: 1.0
To: Peter Korsgaard <jacmet@sunsite.dk>
CC: kay.sievers@vrfy.org, gregkh@suse.de, linux-kernel@vger.kernel.org,
       linux-embedded@vger.kernel.org
Subject: Re: [PATCH] devtmpfs: support !CONFIG_TMPFS
References: <1268389504-22179-1-git-send-email-jacmet@sunsite.dk>
In-Reply-To: <1268389504-22179-1-git-send-email-jacmet@sunsite.dk>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Korsgaard wrote:
> Make devtmpfs available on (embedded) configurations without SHMEM/TMPFS,
> using ramfs instead.
> 
> Saves ~15KB.
> 
> Signed-off-by: Peter Korsgaard <jacmet@sunsite.dk>
[]> --- a/drivers/base/devtmpfs.c
> +++ b/drivers/base/devtmpfs.c
> @@ -44,7 +45,11 @@ __setup("devtmpfs.mount=", mount_param);
>  static int dev_get_sb(struct file_system_type *fs_type, int flags,
>  		      const char *dev_name, void *data, struct vfsmount *mnt)
>  {
> +#ifdef CONFIG_TMPFS
>  	return get_sb_single(fs_type, flags, data, shmem_fill_super, mnt);
> +#else
> +	return get_sb_single(fs_type, flags, data, ramfs_fill_super, mnt);
> +#endif
>  }

May be completely not to the point or even wrong, but I were
starring at this change for quite some time trying to understand
what's the difference.  Can we do it like this:

#ifdef CONFIG_TMPFS
# define devtmpfs_fill_super shmem_fill_super
#else
# define devtmpfs_fill_super ramfs_fill_super
#endif
  	return get_sb_single(fs_type, flags, data, devtmpfs_fill_super, mnt);

?

Or maybe it's just me... ;)

/mjt
