Return-Path: <linux-kernel-owner+w=401wt.eu-S1756444AbYFAJaS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756444AbYFAJaS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jun 2008 05:30:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752489AbYFAJaF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Jun 2008 05:30:05 -0400
Received: from nf-out-0910.google.com ([64.233.182.191]:56411 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752535AbYFAJaC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jun 2008 05:30:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=WtmnyErzCEcPo0CCLGPdET8fQbACagzYzg9NlIqpdTR0dbyqDydvGma1IZ6auzVgRSpvOZCAZw+aZrUQR0vkw9tWtTtEI7ONwEYurpVh5+0jcCptTjzE8A1jFJWWdmNVHxTVXHJboZI2PxAMCohltT8YBoXR7cjwkyzLSpB3NYQ=
Date: Sun, 1 Jun 2008 13:25:46 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Arjan van de Ven <arjan@infradead.org>
Cc: airlied@linux.ie, linux-kernel@vger.kernel.org,
       Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [PATCH] drm: make drm use create_proc_read_entry() instead
Message-ID: <20080601092546.GA4967@martell.zuzino.mipt.ru>
References: <20080531203940.40536c9a@infradead.org> <20080531214821.19218b6b@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080531214821.19218b6b@infradead.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 31, 2008 at 09:48:21PM -0700, Arjan van de Ven wrote:
> Subject: [PATCH] drm: make drm use create_proc_read_entry() instead
> 
> Al Viro points out that DRM should have used create_proc_read_entry(),
> and although that is still racey right now, it at least has a chance
> of getting fixed on the api level.

Fix on API level is proc_create_data(), so this patch is pointless.

> --- a/drivers/char/drm/drm_proc.c
> +++ b/drivers/char/drm/drm_proc.c
> @@ -102,8 +102,9 @@ int drm_proc_init(struct drm_minor *minor, int minor_id,
>  	}
>  
>  	for (i = 0; i < DRM_PROC_ENTRIES; i++) {
> -		ent = create_proc_entry(drm_proc_list[i].name,
> -					S_IFREG | S_IRUGO, minor->dev_root);
> +		ent = create_proc_read_entry(drm_proc_list[i].name,
> +					S_IFREG | S_IRUGO, minor->dev_root,
> +					drm_proc_list[i].f, minor);
>  		if (!ent) {
>  			DRM_ERROR("Cannot create /proc/dri/%s/%s\n",
>  				  name, drm_proc_list[i].name);
> @@ -114,8 +115,6 @@ int drm_proc_init(struct drm_minor *minor, int minor_id,
>  			minor->dev_root = NULL;
>  			return -1;
>  		}
> -		ent->read_proc = drm_proc_list[i].f;
> -		ent->data = minor;
>  	}

