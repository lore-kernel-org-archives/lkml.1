Return-Path: <linux-kernel-owner+w=401wt.eu-S1757447AbZBPMi6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757447AbZBPMi6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Feb 2009 07:38:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755249AbZBPMit
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Feb 2009 07:38:49 -0500
Received: from cantor2.suse.de ([195.135.220.15]:46084 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755162AbZBPMit (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Feb 2009 07:38:49 -0500
Date: Mon, 16 Feb 2009 13:38:46 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Luca Bigliardi <shammash@artha.org>
Cc: trivial@kernel.org, linux-kernel@vger.kernel.org, jdike@addtoit.com,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] Fix vde network backend in user mode linux
In-Reply-To: <20090202172822.GA2801@pintsize>
Message-ID: <alpine.LNX.1.10.0902161334250.18110@jikos.suse.cz>
References: <20090202172822.GA2801@pintsize>
User-Agent: Alpine 1.10 (LNX 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


[ doesn't seem to be picked up by anyone into current -next nor -mmotm, 
  but isn't appropriate for trivial; adding akpm to cc ]

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
> -- 
> 1.5.6.5
> 
> 

-- 
Jiri Kosina
SUSE Labs
