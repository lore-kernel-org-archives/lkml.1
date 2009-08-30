Return-Path: <linux-kernel-owner+w=401wt.eu-S1753837AbZH3XiJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753837AbZH3XiJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Aug 2009 19:38:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753665AbZH3XiJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Aug 2009 19:38:09 -0400
Received: from gir.skynet.ie ([193.1.99.77]:37149 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752770AbZH3XiI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Aug 2009 19:38:08 -0400
Date: Mon, 31 Aug 2009 00:38:11 +0100 (IST)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: Alexey Dobriyan <adobriyan@gmail.com>
cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drm: use proc_create_data()
In-Reply-To: <20090828185806.GC14499@x200.localdomain>
Message-ID: <alpine.DEB.2.00.0908310037310.15117@skynet.skynet.ie>
References: <20090828185806.GC14499@x200.localdomain>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>

I pushed a slightly modified version to drm-next, it moves the
filling out of tmp before the data create.

Thanks,
Dave.

> ---
> 
>  drivers/gpu/drm/drm_proc.c |    5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)
> 
> --- a/drivers/gpu/drm/drm_proc.c
> +++ b/drivers/gpu/drm/drm_proc.c
> @@ -106,7 +106,8 @@ int drm_proc_create_files(struct drm_info_list *files, int count,
>  			continue;
>  
>  		tmp = kmalloc(sizeof(struct drm_info_node), GFP_KERNEL);
> -		ent = create_proc_entry(files[i].name, S_IFREG | S_IRUGO, root);
> +		ent = proc_create_data(files[i].name, S_IRUGO, root,
> +				       &drm_proc_fops, tmp);
>  		if (!ent) {
>  			DRM_ERROR("Cannot create /proc/dri/%s/%s\n",
>  				  name, files[i].name);
> @@ -115,8 +116,6 @@ int drm_proc_create_files(struct drm_info_list *files, int count,
>  			goto fail;
>  		}
>  
> -		ent->proc_fops = &drm_proc_fops;
> -		ent->data = tmp;
>  		tmp->minor = minor;
>  		tmp->info_ent = &files[i];
>  		list_add(&(tmp->list), &(minor->proc_nodes.list));
> 
> 
