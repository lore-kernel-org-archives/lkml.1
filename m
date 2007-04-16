Return-Path: <linux-kernel-owner+w=401wt.eu-S1030911AbXDPTVK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030911AbXDPTVK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2007 15:21:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030910AbXDPTVK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Apr 2007 15:21:10 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:50113 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030908AbXDPTVG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2007 15:21:06 -0400
Date: Mon, 16 Apr 2007 14:20:50 -0500
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: akpm@linux-foundation.org, viro@ftp.linux.org.uk, linuxram@us.ibm.com,
       ebiederm@xmission.com, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, containers@lists.osdl.org
Subject: Re: [patch 05/10] Add "permit user submounts" flag to vfsmount
Message-ID: <20070416192050.GB30435@sergelap.austin.ibm.com>
References: <20070416110308.739051445@szeredi.hu> <20070416110414.591968270@szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070416110414.591968270@szeredi.hu>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Miklos Szeredi (miklos@szeredi.hu):
> From: Miklos Szeredi <mszeredi@suse.cz>
> 
> If MNT_USERMNT flag is not set in the target vfsmount, then

MNT_USER and MNT_USERMNT?  I claim no way will people keep those
straight.  How about MNT_ALLOWUSER and MNT_USER?

-serge

> unprivileged mounts will be denied.
> 
> By default this flag is cleared, and can be set on new mounts, on
> remounts or with the MS_SETFLAGS option.
> 
> Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
> ---
> 
> Index: linux/fs/namespace.c
> ===================================================================
> --- linux.orig/fs/namespace.c	2007-04-13 13:20:12.000000000 +0200
> +++ linux/fs/namespace.c	2007-04-13 13:35:40.000000000 +0200
> @@ -411,6 +411,7 @@ static int show_vfsmnt(struct seq_file *
>  		{ MNT_NOATIME, ",noatime" },
>  		{ MNT_NODIRATIME, ",nodiratime" },
>  		{ MNT_RELATIME, ",relatime" },
> +		{ MNT_USERMNT, ",usermnt" },
>  		{ 0, NULL }
>  	};
>  	struct proc_fs_info *fs_infop;
> @@ -1505,9 +1506,11 @@ long do_mount(char *dev_name, char *dir_
>  		mnt_flags |= MNT_NODIRATIME;
>  	if (flags & MS_RELATIME)
>  		mnt_flags |= MNT_RELATIME;
> +	if (flags & MS_USERMNT)
> +		mnt_flags |= MNT_USERMNT;
> 
>  	flags &= ~(MS_NOSUID | MS_NOEXEC | MS_NODEV | MS_ACTIVE |
> -		   MS_NOATIME | MS_NODIRATIME | MS_RELATIME);
> +		   MS_NOATIME | MS_NODIRATIME | MS_RELATIME | MS_USERMNT);
> 
>  	/* ... and get the mountpoint */
>  	retval = path_lookup(dir_name, LOOKUP_FOLLOW, &nd);
> Index: linux/include/linux/mount.h
> ===================================================================
> --- linux.orig/include/linux/mount.h	2007-04-13 13:17:08.000000000 +0200
> +++ linux/include/linux/mount.h	2007-04-13 13:22:17.000000000 +0200
> @@ -28,6 +28,7 @@ struct mnt_namespace;
>  #define MNT_NOATIME	0x08
>  #define MNT_NODIRATIME	0x10
>  #define MNT_RELATIME	0x20
> +#define MNT_USERMNT	0x40
> 
>  #define MNT_SHRINKABLE	0x100
>  #define MNT_USER	0x200
> Index: linux/include/linux/fs.h
> ===================================================================
> --- linux.orig/include/linux/fs.h	2007-04-13 13:23:05.000000000 +0200
> +++ linux/include/linux/fs.h	2007-04-13 13:35:34.000000000 +0200
> @@ -130,6 +130,7 @@ extern int dir_notify_enable;
>  #define MS_SETFLAGS	(1<<23) /* set specified mount flags */
>  #define MS_CLEARFLAGS	(1<<24) /* clear specified mount flags */
>  /* MS_SETFLAGS | MS_CLEARFLAGS: change mount flags to specified */
> +#define MS_USERMNT	(1<<25) /* permit unpriv. submounts under this mount */
>  #define MS_ACTIVE	(1<<30)
>  #define MS_NOUSER	(1<<31)
> 
> 
> --
