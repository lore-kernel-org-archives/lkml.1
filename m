Return-Path: <linux-kernel-owner+w=401wt.eu-S1758262AbYHUHcZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758262AbYHUHcZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 03:32:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754986AbYHUHcP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 03:32:15 -0400
Received: from 81-7-68-229.static.zebra.lt ([81.7.68.229]:58742 "EHLO
	teltonika.lt" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755037AbYHUHcN (ORCPT <rfc822;Linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 03:32:13 -0400
X-Greylist: delayed 397 seconds by postgrey-1.27 at vger.kernel.org; Thu, 21 Aug 2008 03:32:13 EDT
Message-ID: <48AD1860.4040001@teltonika.lt>
Date: Thu, 21 Aug 2008 10:25:20 +0300
From: Paulius Zaleckas <paulius.zaleckas@teltonika.lt>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: jaredeh@gmail.com
CC: Linux-kernel@vger.kernel.org, linux-embedded@vger.kernel.org,
       linux-mtd <linux-mtd@lists.infradead.org>,
       =?ISO-8859-1?Q?J=F6rn_Engel?= <joern@logfs.org>, tim.bird@AM.SONY.COM
Subject: Re: [PATCH 01/10] AXFS: exporting xip_file_fault() for use with AXFS
References: <48AD00D5.5010904@gmail.com>
In-Reply-To: <48AD00D5.5010904@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jared Hulbert wrote:
> We'll need this for AXFS.  The equivalent function in filemap.c is exported.
> 
> Signed-off-by: Jared Hulbert <jaredeh@gmail.com>
> ---
>  include/linux/mm.h |    4 ++++
>  mm/filemap_xip.c   |    3 ++-
>  2 files changed, 6 insertions(+), 1 deletion(-)
> 
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index 72a15dc..2be5c22 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -161,6 +161,10 @@ struct vm_fault {
>  					 */
>  };
>  
> +#ifdef CONFIG_FS_XIP
> +extern int xip_file_fault(struct vm_area_struct *vma, struct vm_fault *vmf);
> +#endif
> +

No need for #ifdef here as this function is compiled and exported in .c
regardless of CONFIG_FS_XIP

>  /*
>   * These are the virtual MM functions - opening of an area, closing and
>   * unmapping it (needed to keep files on disk up-to-date etc), pointer
> diff --git a/mm/filemap_xip.c b/mm/filemap_xip.c
> index 380ab40..ab2f174 100644
> --- a/mm/filemap_xip.c
> +++ b/mm/filemap_xip.c
> @@ -206,7 +206,7 @@ __xip_unmap (struct address_space * mapping,
>   *
>   * This function is derived from filemap_fault, but used for execute in place
>   */
> -static int xip_file_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
> +int xip_file_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
>  {
>  	struct file *file = vma->vm_file;
>  	struct address_space *mapping = file->f_mapping;
> @@ -262,6 +262,7 @@ found:
>  		return 0;
>  	}
>  }
> +EXPORT_SYMBOL_GPL(xip_file_fault);
>  
>  static struct vm_operations_struct xip_file_vm_ops = {
>  	.fault	= xip_file_fault,
> 
