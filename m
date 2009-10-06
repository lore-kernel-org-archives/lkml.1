Return-Path: <linux-kernel-owner+w=401wt.eu-S933282AbZJFUle@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933282AbZJFUle (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 16:41:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933273AbZJFUld
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 16:41:33 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53836 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933239AbZJFUld (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 16:41:33 -0400
Date: Tue, 6 Oct 2009 13:39:37 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: airlied@linux.ie, dri-devel@lists.sourceforge.net, JBeulich@novell.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drm: make sure page protections are updated after
 changing vm_flags.
Message-Id: <20091006133937.246a4f33.akpm@linux-foundation.org>
In-Reply-To: <4AC3E1EB.4020903@goop.org>
References: <4AC3E1EB.4020903@goop.org>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 30 Sep 2009 15:55:39 -0700
Jeremy Fitzhardinge <jeremy@goop.org> wrote:

> Some architectures compute ->vm_page_prot depending on ->vm_flags, so
> we need to update the protections after adjusting the flags.
> 
> Reported-by: Jan Beulich <JBeulich@novell.com>
> Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
> 
> diff --git a/drivers/gpu/drm/drm_gem.c b/drivers/gpu/drm/drm_gem.c
> index 8104eca..9d3e39f 100644
> --- a/drivers/gpu/drm/drm_gem.c
> +++ b/drivers/gpu/drm/drm_gem.c
> @@ -537,7 +537,7 @@ int drm_gem_mmap(struct file *filp, struct vm_area_struct *vma)
>  	vma->vm_ops = obj->dev->driver->gem_vm_ops;
>  	vma->vm_private_data = map->handle;
>  	/* FIXME: use pgprot_writecombine when available */
> -	vma->vm_page_prot = pgprot_writecombine(vma->vm_page_prot);
> +	vma->vm_page_prot = pgprot_writecombine(vm_get_page_prot(vma->vm_flags));
>  
>  	/* Take a ref for this mapping of the object, so that the fault
>  	 * handler can dereference the mmap offset's pointer to the object.

u fail changelogology.

What were the consequences of the bug which you just fixed?
