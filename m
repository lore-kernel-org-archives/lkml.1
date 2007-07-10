Return-Path: <linux-kernel-owner+w=401wt.eu-S1761690AbXGJXag@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761690AbXGJXag (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2007 19:30:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756555AbXGJXaW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jul 2007 19:30:22 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50905 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754245AbXGJXaV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2007 19:30:21 -0400
Date: Tue, 10 Jul 2007 16:30:12 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: cmm@us.ibm.com
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-ext4@vger.kernel.org
Subject: Re: [EXT4 set 1][PATCH 1/2] Add noextents mount option
Message-Id: <20070710163012.6e0ded75.akpm@linux-foundation.org>
In-Reply-To: <1183275348.4010.118.camel@localhost.localdomain>
References: <1183275348.4010.118.camel@localhost.localdomain>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 01 Jul 2007 03:35:48 -0400
Mingming Cao <cmm@us.ibm.com> wrote:

> Add a mount option to turn off extents.

Please update the changelog to describe the reason for making this change.


> Signed-off-by: Mingming Cao <cmm@us.ibm.com>
> ---
> Index: linux-2.6.22-rc4/fs/ext4/super.c
> ===================================================================
> --- linux-2.6.22-rc4.orig/fs/ext4/super.c	2007-06-11 17:02:18.000000000 -0700
> +++ linux-2.6.22-rc4/fs/ext4/super.c	2007-06-11 17:02:22.000000000 -0700
> @@ -725,7 +725,7 @@
>  	Opt_usrjquota, Opt_grpjquota, Opt_offusrjquota, Opt_offgrpjquota,
>  	Opt_jqfmt_vfsold, Opt_jqfmt_vfsv0, Opt_quota, Opt_noquota,
>  	Opt_ignore, Opt_barrier, Opt_err, Opt_resize, Opt_usrquota,
> -	Opt_grpquota, Opt_extents,
> +	Opt_grpquota, Opt_extents, Opt_noextents,
>  };
>  
>  static match_table_t tokens = {
> @@ -776,6 +776,7 @@
>  	{Opt_usrquota, "usrquota"},
>  	{Opt_barrier, "barrier=%u"},
>  	{Opt_extents, "extents"},
> +	{Opt_noextents, "noextents"},
>  	{Opt_err, NULL},
>  	{Opt_resize, "resize"},
>  };
> @@ -1111,6 +1112,9 @@
>  		case Opt_extents:
>  			set_opt (sbi->s_mount_opt, EXTENTS);
>  			break;
> +		case Opt_noextents:
> +			clear_opt (sbi->s_mount_opt, EXTENTS);
> +			break;
>  		default:
>  			printk (KERN_ERR
>  				"EXT4-fs: Unrecognized mount option \"%s\" "
> 
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
