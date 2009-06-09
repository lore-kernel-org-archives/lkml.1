Return-Path: <linux-kernel-owner+w=401wt.eu-S1758024AbZFIG60@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758024AbZFIG60 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 02:58:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756271AbZFIG6R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 02:58:17 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:59035 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753146AbZFIG6R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 02:58:17 -0400
To: sfr@canb.auug.org.au
CC: viro@ZenIV.linux.org.uk, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, tj@kernel.org, miklos@szeredi.hu,
       vapier@gentoo.org
In-reply-to: <20090609110815.0abd1de0.sfr@canb.auug.org.au> (message from
	Stephen Rothwell on Tue, 9 Jun 2009 11:08:15 +1000)
Subject: Re: linux-next: manual merge of the vfs tree with the  tree
References: <20090609110815.0abd1de0.sfr@canb.auug.org.au>
Message-Id: <E1MDvHY-0006N1-06@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Tue, 09 Jun 2009 08:58:04 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 9 Jun 2009, Stephen Rothwell wrote:
> Today's linux-next merge of the vfs tree got a conflict in
> include/linux/magic.h between commit
> 81ebac1be35a2c2fe1f4d3810a8e57d315600a32 ("CUSE: implement CUSE -
> Character device in Userspace") from the fuse tree and commit
> 5b88aed76b5a1470ec9705c03cf3f0480c018513 ("linux/magic.h: move cramfs
> magic out of cramfs_fs.h") from the vfs tree.

Hmm, looks like that CUSE_SUPER_MAGIC is an unused remnant from an
earlier version of the CUSE patchset.  I'll fix that up in the fuse
tree.

Thanks,
Miklos

> 
> Just overlapping additions.  I fixed it up (see below) and can carry the
> fix as necessary.
> -- 
> Cheers,
> Stephen Rothwell                    sfr@canb.auug.org.au
> 
> diff --cc include/linux/magic.h
> index 4596c9e,192f980..0000000
> --- a/include/linux/magic.h
> +++ b/include/linux/magic.h
> @@@ -3,11 -3,12 +3,13 @@@
>   
>   #define ADFS_SUPER_MAGIC	0xadf5
>   #define AFFS_SUPER_MAGIC	0xadff
>  -#define AFS_SUPER_MAGIC                0x5346414F
>  +#define AFS_SUPER_MAGIC		0x5346414F
>   #define AUTOFS_SUPER_MAGIC	0x0187
>   #define CODA_SUPER_MAGIC	0x73757245
> + #define CRAMFS_MAGIC		0x28cd3d45	/* some random number */
> + #define CRAMFS_MAGIC_WEND	0x453dcd28	/* magic number with the wrong endianess */
>  -#define DEBUGFS_MAGIC          0x64626720
>  +#define CUSE_SUPER_MAGIC	0x43555345
>  +#define DEBUGFS_MAGIC		0x64626720
>   #define SYSFS_MAGIC		0x62656572
>   #define SECURITYFS_MAGIC	0x73636673
>   #define TMPFS_MAGIC		0x01021994
> 
