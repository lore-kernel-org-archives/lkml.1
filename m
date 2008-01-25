Return-Path: <linux-kernel-owner+w=401wt.eu-S1760198AbYAYKTD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760198AbYAYKTD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 05:19:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754090AbYAYKSv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 05:18:51 -0500
Received: from mx2.suse.de ([195.135.220.15]:45470 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752996AbYAYKSu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 05:18:50 -0500
Date: Fri, 25 Jan 2008 11:18:48 +0100
From: Karsten Keil <kkeil@suse.de>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, Karsten Keil <kkeil@suse.de>
Subject: Re: [patch 09/26] mount options: fix capifs
Message-ID: <20080125101848.GA7812@pingi.kke.suse.de>
Mail-Followup-To: Miklos Szeredi <miklos@szeredi.hu>,
	akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org, Karsten Keil <kkeil@suse.de>
References: <20080124193341.166753833@szeredi.hu> <20080124193427.808900246@szeredi.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080124193427.808900246@szeredi.hu>
Organization: SuSE Linux AG
X-Operating-System: Linux 2.6.16.53-0.16-smp x86_64
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 24, 2008 at 08:33:50PM +0100, Miklos Szeredi wrote:
> From: Miklos Szeredi <mszeredi@suse.cz>
> 
> Add a .show_options super operation to capifs.
> 
> Use generic_show_options() and save the complete option string in
> capifs_remount().
> 
> Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
Acked-by: Karsten Keil <kkeil@suse.de>
> ---
> 
> Index: linux/drivers/isdn/capi/capifs.c
> ===================================================================
> --- linux.orig/drivers/isdn/capi/capifs.c	2007-10-09 22:31:38.000000000 +0200
> +++ linux/drivers/isdn/capi/capifs.c	2008-01-24 11:37:42.000000000 +0100
> @@ -52,6 +52,7 @@ static int capifs_remount(struct super_b
>  	gid_t gid = 0;
>  	umode_t mode = 0600;
>  	char *this_char;
> +	char *new_opt = kstrdup(data, GFP_KERNEL);
>  
>  	this_char = NULL;
>  	while ((this_char = strsep(&data, ",")) != NULL) {
> @@ -72,11 +73,16 @@ static int capifs_remount(struct super_b
>  			return -EINVAL;
>  		}
>  	}
> +
> +	kfree(s->s_options);
> +	s->s_options = new_opt;
> +
>  	config.setuid  = setuid;
>  	config.setgid  = setgid;
>  	config.uid     = uid;
>  	config.gid     = gid;
>  	config.mode    = mode;
> +
>  	return 0;
>  }
>  
> @@ -84,6 +90,7 @@ static struct super_operations capifs_so
>  {
>  	.statfs		= simple_statfs,
>  	.remount_fs	= capifs_remount,
> +	.show_options	= generic_show_options,
>  };
>  
>  
> 
> --

-- 
Karsten Keil
SuSE Labs
ISDN and VOIP development
SUSE LINUX Products GmbH, Maxfeldstr.5 90409 Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
