Return-Path: <linux-kernel-owner+w=401wt.eu-S1754165AbYGSLa0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754165AbYGSLa0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jul 2008 07:30:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752513AbYGSLaO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Jul 2008 07:30:14 -0400
Received: from rv-out-0506.google.com ([209.85.198.227]:17430 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751988AbYGSLaM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jul 2008 07:30:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=pZrpGq3u8UbJSOxjnTqSEdwvmDJvj45RfzyvDlXFkIBgIycOFmJAOZJ4YpceEIVcPj
         1/tsZqgoOviW9CktELDg/OzFP25NOKmYLesPGM8U0y6dVLM5XD4RlOk7oMFxxd2gwQ2l
         DNcZsOmOpbyKjcBiEIM5+OcvelbwzRz63n71g=
Message-ID: <84144f020807190430r680b2fc4kf8be4d3ebc3c019c@mail.gmail.com>
Date: Sat, 19 Jul 2008 14:30:11 +0300
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Li Zefan" <lizf@cn.fujitsu.com>
Subject: Re: [PATCH] vfs: use kstrdup()
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       "Al Viro" <viro@zeniv.linux.org.uk>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <4881BEF4.2020201@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <4881BEF4.2020201@cn.fujitsu.com>
X-Google-Sender-Auth: 47e691e06c15a4d8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 19, 2008 at 1:16 PM, Li Zefan <lizf@cn.fujitsu.com> wrote:
> This piece of code can be replaced by a kstrdup().
>
> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>

Looks good to me.

Reviewed-by: Pekka Enberg <penberg@cs.helsinki.fi>

> ---
>  fs/namespace.c |    9 +--------
>  1 files changed, 1 insertions(+), 8 deletions(-)
>
> diff --git a/fs/namespace.c b/fs/namespace.c
> index 4f6f763..08c3b2d 100644
> --- a/fs/namespace.c
> +++ b/fs/namespace.c
> @@ -127,14 +127,7 @@ struct vfsmount *alloc_vfsmnt(const char *name)
>                INIT_LIST_HEAD(&mnt->mnt_slave_list);
>                INIT_LIST_HEAD(&mnt->mnt_slave);
>                atomic_set(&mnt->__mnt_writers, 0);
> -               if (name) {
> -                       int size = strlen(name) + 1;
> -                       char *newname = kmalloc(size, GFP_KERNEL);
> -                       if (newname) {
> -                               memcpy(newname, name, size);
> -                               mnt->mnt_devname = newname;
> -                       }
> -               }
> +               mnt->mnt_devname = kstrdup(name, GFP_KERNEL);
>        }
>        return mnt;
>  }
> --
> 1.5.4.rc3
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
