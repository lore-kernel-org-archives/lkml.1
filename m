Return-Path: <linux-kernel-owner+w=401wt.eu-S1756571AbZBKNDK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756571AbZBKNDK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Feb 2009 08:03:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755922AbZBKNCs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Feb 2009 08:02:48 -0500
Received: from mx2.suse.de ([195.135.220.15]:55449 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755755AbZBKNCr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Feb 2009 08:02:47 -0500
Date: Wed, 11 Feb 2009 14:02:42 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Luca Bigliardi <shammash@artha.org>, jdike@addtoit.com
Cc: trivial@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix vde network backend in user mode linux
In-Reply-To: <20090202172822.GA2801@pintsize>
Message-ID: <alpine.LNX.1.10.0902111402000.31014@jikos.suse.cz>
References: <20090202172822.GA2801@pintsize>
User-Agent: Alpine 1.10 (LNX 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2 Feb 2009, Luca Bigliardi wrote:

> * Replace kmalloc() with uml_kmalloc()
>   (fix build failure)
> * Remove unnecessary UM_KERN_INFO in printk()
>   (don't display '<6>' while printing info)
> 
> Signed-off-by: Luca Bigliardi <shammash@artha.org>
> ---
>  arch/um/drivers/vde_user.c |    6 +++---
>  1 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/um/drivers/vde_user.c b/arch/um/drivers/vde_user.c
> index 56533db..c5c4325 100644
> --- a/arch/um/drivers/vde_user.c
> +++ b/arch/um/drivers/vde_user.c
> @@ -78,7 +78,7 @@ void vde_init_libstuff(struct vde_data *vpri, struct vde_init *init)
>  {
>  	struct vde_open_args *args;
>  
> -	vpri->args = kmalloc(sizeof(struct vde_open_args), UM_GFP_KERNEL);
> +	vpri->args = uml_kmalloc(sizeof(struct vde_open_args), UM_GFP_KERNEL);
>  	if (vpri->args == NULL) {
>  		printk(UM_KERN_ERR "vde_init_libstuff - vde_open_args "
>  		       "allocation failed");
> @@ -91,8 +91,8 @@ void vde_init_libstuff(struct vde_data *vpri, struct vde_init *init)
>  	args->group = init->group;
>  	args->mode = init->mode ? init->mode : 0700;
>  
> -	args->port ?  printk(UM_KERN_INFO "port %d", args->port) :
> -		printk(UM_KERN_INFO "undefined port");
> +	args->port ?  printk("port %d", args->port) :
> +		printk("undefined port");
>  }
>  
>  int vde_user_read(void *conn, void *buf, int len)

Jeff, I don't see this in linux-next as of today. Are you going to take it 
through your tree?

-- 
Jiri Kosina
SUSE Labs
