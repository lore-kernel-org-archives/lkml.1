Return-Path: <linux-kernel-owner+w=401wt.eu-S1758517AbYEPRZa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758517AbYEPRZa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2008 13:25:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752318AbYEPRZO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 May 2008 13:25:14 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:44975 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751613AbYEPRZN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2008 13:25:13 -0400
Date: Fri, 16 May 2008 19:25:49 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: hooanon05@yahoo.co.jp
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/67] aufs Makefile
Message-ID: <20080516172549.GA1915@uranus.ravnborg.org>
References: <12109484013324-git-send-email-hooanon05@yahoo.co.jp> <12109484012532-git-send-email-hooanon05@yahoo.co.jp> <12109484012997-git-send-email-hooanon05@yahoo.co.jp> <12109484013051-git-send-email-hooanon05@yahoo.co.jp> <12109484013436-git-send-email-hooanon05@yahoo.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <12109484013436-git-send-email-hooanon05@yahoo.co.jp>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Junjiro.

A few comments to your Makefile.

On Fri, May 16, 2008 at 11:32:19PM +0900, hooanon05@yahoo.co.jp wrote:
> From: Junjiro Okajima <hooanon05@yahoo.co.jp>
> 
> 	initial commit
> 	aufs Makefile
> 
> Signed-off-by: Junjiro Okajima <hooanon05@yahoo.co.jp>
> ---
>  fs/aufs/Makefile |   57 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
>  1 files changed, 57 insertions(+), 0 deletions(-)
> 
> diff --git a/fs/aufs/Makefile b/fs/aufs/Makefile
> new file mode 100644
> index 0000000..05e0864
> --- /dev/null
> +++ b/fs/aufs/Makefile
> @@ -0,0 +1,57 @@
> +# AUFS Makefile for the Linux 2.6.25 and later
> +# $Id: Makefile,v 1.3 2008/04/28 03:03:10 sfjro Exp $
Please drop these two lines

> +
> +# the environment variables are not inherited since 2.6.23
> +ifdef AUFS_EXTRA_CFLAGS
> +EXTRA_CFLAGS += ${AUFS_EXTRA_CFLAGS}
> +endif
And this as well. If this is needed do like the others do.

> +
> +########################################
> +
> +ifdef CONFIG_AUFS_WORKAROUND_FUSE
> +# defined in ${srctree}/fs/fuse/inode.c
> +EXTRA_CFLAGS += -DFUSE_SUPER_MAGIC=0x65735546
> +endif
Use:
ccflags-$(CONFIG_AUFS_WORKAROUND_FUSE) += -DFUSE_SUPER_MAGIC=0x65735546

> +
> +ifdef CONFIG_XFS_FS
> +# defined in ${srctree}/fs/xfs/xfs_sb.h
> +EXTRA_CFLAGS += -DXFS_SB_MAGIC=0x58465342
> +endif
ccflags-$(CONFIG_XFS_FS) += -DXFS_SB_MAGIC=0x58465342

> +
> +ifdef CONFIG_TMPFS
> +# defined in ${srctree}/mm/shmem.c
> +EXTRA_CFLAGS += -DTMPFS_MAGIC=0x01021994
> +endif
ccflags-$(CONFIG_TMPFS) += -DTMPFS_MAGIC=0x01021994

> +
> +-include $(dir $(lastword ${MAKEFILE_LIST}))priv.mk

Please drop this.

> +#$(warning ${EXTRA_CFLAGS})
Not used - drop it.

> +
> +########################################
> +
> +obj-$(CONFIG_AUFS) += aufs.o
> +aufs-y := module.o super.o sbinfo.o branch.o xino.o sysaufs.o opts.o \
> +	wkq.o vfsub.o dcsub.o \
> +	cpup.o whout.o plink.o wbr_policy.o \
> +	dentry.o dinfo.o \
> +	file.o f_op.o finfo.o \
> +	dir.o vdir.o \
> +	inode.o i_op.o i_op_add.o i_op_del.o i_op_ren.o iinfo.o \
> +	misc.o
> +
> +#xattr.o
> +aufs-$(CONFIG_SYSFS) += sysfs.o
> +aufs-$(CONFIG_AUFS_BR_NFS) += br_nfs.o
> +aufs-$(CONFIG_AUFS_BR_XFS) += br_xfs.o
> +aufs-$(CONFIG_AUFS_WORKAROUND_FUSE) += br_fuse.o
> +
> +aufs-$(CONFIG_AUFS_DLGT) += dlgt.o
> +aufs-$(CONFIG_AUFS_HINOTIFY) += hinotify.o hin_or_dlgt.o

> +# dirty
> +ifndef CONFIG_AUFS_HINOTIFY
> +aufs-$(CONFIG_AUFS_DLGT) += hin_or_dlgt.o
> +endif
Can we have this dependency expressed in your Kconfig file?

> +
> +aufs-$(CONFIG_AUFS_EXPORT) += export.o
> +aufs-$(CONFIG_AUFS_ROBR) += robr.o
> +aufs-$(CONFIG_AUFS_DEBUG) += debug.o
> +aufs-$(CONFIG_AUFS_MAGIC_SYSRQ) += sysrq.o


	Sam
