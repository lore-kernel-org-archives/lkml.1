Return-Path: <linux-kernel-owner+w=401wt.eu-S1758023AbZBEJDA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758023AbZBEJDA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 04:03:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752605AbZBEJCl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 04:02:41 -0500
Received: from rv-out-0506.google.com ([209.85.198.236]:36194 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752472AbZBEJCj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 04:02:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=inEzusozNjeLdnPi6A7UVvwh5ilVSG3tJSoqCemYLa3BxNOlpOZsNtxjx8g9al77jU
         J+7nY/+wJ8m1KCOtGJ275PiX+AEoCA/HyAJFaoAJVNfSQDUmxbwpJIjhUhE04bEGbL3G
         /5vjPg8hfu9MdLjk3/R/viogco9PG3a8i61+o=
MIME-Version: 1.0
In-Reply-To: <1225962921-6424-1-git-send-email-cooloney@kernel.org>
References: <1225962921-6424-1-git-send-email-cooloney@kernel.org>
Date: Thu, 5 Feb 2009 17:02:37 +0800
X-Google-Sender-Auth: 79dfb874d0a50859
Message-ID: <386072610902050102r3c3e41a3yfbb424411f2f40dc@mail.gmail.com>
Subject: Re: [PATCH] nfs client: kill compile warning on NOMMU machine
From: Bryan Wu <cooloney@kernel.org>
To: Trond.Myklebust@netapp.com, linux-nfs@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Bryan Wu <cooloney@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi guys,

Is it possible to merge this patch?

Thanks
-Bryan

On Thu, Nov 6, 2008 at 5:15 PM, Bryan Wu <cooloney@kernel.org> wrote:
> On nommu machine such as Blackfin, when compling NFS we got an warning about
> nfs_file_mmap() function defined but not used.
>
> This patch kills this warning.
>
> Signed-off-by: Bryan Wu <cooloney@kernel.org>
> ---
>  fs/nfs/file.c |   16 ++++++++++++----
>  1 files changed, 12 insertions(+), 4 deletions(-)
>
> diff --git a/fs/nfs/file.c b/fs/nfs/file.c
> index d319b49..66b8b8e 100644
> --- a/fs/nfs/file.c
> +++ b/fs/nfs/file.c
> @@ -64,11 +64,7 @@ const struct file_operations nfs_file_operations = {
>        .write          = do_sync_write,
>        .aio_read       = nfs_file_read,
>        .aio_write      = nfs_file_write,
> -#ifdef CONFIG_MMU
>        .mmap           = nfs_file_mmap,
> -#else
> -       .mmap           = generic_file_mmap,
> -#endif
>        .open           = nfs_file_open,
>        .flush          = nfs_file_flush,
>        .release        = nfs_file_release,
> @@ -294,6 +290,7 @@ nfs_file_splice_read(struct file *filp, loff_t *ppos,
>        return res;
>  }
>
> +#ifdef CONFIG_MMU
>  static int
>  nfs_file_mmap(struct file * file, struct vm_area_struct * vma)
>  {
> @@ -312,6 +309,17 @@ nfs_file_mmap(struct file * file, struct vm_area_struct * vma)
>        }
>        return status;
>  }
> +#else
> +static int
> +nfs_file_mmap(struct file *file, struct vm_area_struct *vma)
> +{
> +       /* Kill warning: 'nfs_file_vm_ops' defined but not used */
> +       struct vm_operations_struct *vm_ops;
> +       vm_ops = &nfs_file_vm_ops;
> +
> +       return generic_file_mmap(file, vma);
> +}
> +#endif
>
>  /*
>  * Flush any dirty pages for this process, and check for write errors.
> --
> 1.5.6.3
>
