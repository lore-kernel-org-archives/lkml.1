Return-Path: <linux-kernel-owner+w=401wt.eu-S1753445AbYLCOQe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753445AbYLCOQe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 09:16:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751283AbYLCOQN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 09:16:13 -0500
Received: from E23SMTP06.au.ibm.com ([202.81.18.175]:53736 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751078AbYLCOQJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 09:16:09 -0500
Date: Wed, 3 Dec 2008 19:45:55 +0530
From: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com
Subject: Re: next-20081203 build failure, when building xfs_file.o
Message-ID: <20081203141555.GB5400@linux.vnet.ibm.com>
Reply-To: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
References: <20081203183602.c06f8c39.sfr@canb.auug.org.au> <20081203124104.GA5400@linux.vnet.ibm.com> <20081203125534.GA8007@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20081203125534.GA8007@infradead.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Christoph Hellwig <hch@infradead.org> [2008-12-03 07:55:34]:

> On Wed, Dec 03, 2008 at 06:11:04PM +0530, Kamalesh Babulal wrote:
> > Hi Stephen,
> > 
> > 	next-20081203 kernel build fails on x86 with build failure
> > 
> > In file included from fs/xfs/linux-2.6/xfs_file.c:39:
> 
> This is the fix I submitted for it yesterday:
> 
> -- 
> 
> fix compile on 32 bit systems
> 
> The recent compat patches make xfs_file.c include xfs_ioctl32.h unconditional,
> which breaks the build on 32 bit systems which don't have the various compat
> defintions.
> 
> Remove the include and move the defintion of xfs_file_compat_ioctl to
> xfs_ioctl.h so that we can avoid including all the compat defintions in
> xfs_file.c
> 


Hi Chirstoph,

	Thanks, the patch fixes the build failure.

  Tested-by: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> Index: xfs-master/fs/xfs/linux-2.6/xfs_file.c
> ===================================================================
> --- xfs-master.orig/fs/xfs/linux-2.6/xfs_file.c	2008-12-02 11:43:38.000000000 +0100
> +++ xfs-master/fs/xfs/linux-2.6/xfs_file.c	2008-12-02 11:44:06.000000000 +0100
> @@ -36,9 +36,9 @@
>  #include "xfs_inode.h"
>  #include "xfs_error.h"
>  #include "xfs_rw.h"
> -#include "xfs_ioctl32.h"
>  #include "xfs_vnodeops.h"
>  #include "xfs_da_btree.h"
> +#include "xfs_ioctl.h"
> 
>  #include <linux/dcache.h>
>  #include <linux/smp_lock.h>
> Index: xfs-master/fs/xfs/linux-2.6/xfs_ioctl.h
> ===================================================================
> --- xfs-master.orig/fs/xfs/linux-2.6/xfs_ioctl.h	2008-12-02 11:44:10.000000000 +0100
> +++ xfs-master/fs/xfs/linux-2.6/xfs_ioctl.h	2008-12-02 11:44:52.000000000 +0100
> @@ -67,4 +67,16 @@ xfs_attrmulti_attr_remove(
>  	char			*name,
>  	__uint32_t		flags);
> 
> +extern long
> +xfs_file_compat_ioctl(
> +	struct file		*file,
> +	unsigned int		cmd,
> +	unsigned long		arg);
> +
> +extern long
> +xfs_file_compat_ioctl_invis(
> +	struct file		*file,
> +	unsigned int		cmd,
> +	unsigned long		arg);
> +
>  #endif
> Index: xfs-master/fs/xfs/linux-2.6/xfs_ioctl32.h
> ===================================================================
> --- xfs-master.orig/fs/xfs/linux-2.6/xfs_ioctl32.h	2008-12-02 11:44:10.000000000 +0100
> +++ xfs-master/fs/xfs/linux-2.6/xfs_ioctl32.h	2008-12-02 11:44:18.000000000 +0100
> @@ -20,9 +20,6 @@
> 
>  #include <linux/compat.h>
> 
> -extern long xfs_file_compat_ioctl(struct file *, unsigned, unsigned long);
> -extern long xfs_file_compat_invis_ioctl(struct file *, unsigned, unsigned long);
> -
>  /*
>   * on 32-bit arches, ioctl argument structures may have different sizes
>   * and/or alignment.  We define compat structures which match the
> --
> To unsubscribe from this list: send the line "unsubscribe linux-next" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
Thanks & Regards,
Kamalesh Babulal,
Linux Technology Center,
IBM, ISTL.
