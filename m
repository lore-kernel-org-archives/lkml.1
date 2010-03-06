Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753576Ab0CFVah (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Mar 2010 16:30:37 -0500
Received: from mail-fx0-f219.google.com ([209.85.220.219]:50859 "EHLO
	mail-fx0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751377Ab0CFVaf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Mar 2010 16:30:35 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type:content-transfer-encoding;
        b=D6JmU5j1fMnblYaQS3yw/kk7OTxgEpGk4PDHM5ymvjrm55OubDBVZTjlSIuZXz5rg9
         DzHx+C8wkNrbLA7oQEz6mwCmHXm6U+PzBKk84N9FrVJ1BjW6XMpDHCpk7n+jGyHYKClc
         wWtuyQs+V/S+u2qPEzhV3Qle2xT1Ihh6gu29w=
MIME-Version: 1.0
In-Reply-To: <20100306112125.GN4958@bicker>
References: <20100306112125.GN4958@bicker>
Date: Sat, 6 Mar 2010 16:30:33 -0500
Message-ID: <ea6602021003061330j56132f8er73e27f017e6b9d09@mail.gmail.com>
Subject: Re: [patch] security: ima_file_mmap() don't just return zero
From: Vikram Dhillon <dhillonv10@gmail.com>
To: Dan Carpenter <error27@gmail.com>, Mimi Zohar <zohar@us.ibm.com>,
       James Morris <jmorris@namei.org>, Eric Paris <eparis@redhat.com>,
       Al Viro <viro@zeniv.linux.org.uk>,
       "J.R. Okajima" <hooanon05@yahoo.co.jp>,
       linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 6, 2010 at 6:21 AM, Dan Carpenter <error27@gmail.com> wrote:
> It seems like we should return an error here.  That's what the comment
> says we should do.
>
> I also removed an out of date comment.  It wasn't needed and seemed likely
> to get out of date again.
>
> Signed-off-by: Dan Carpenter <error27@gmail.com>
> ---
> This was found with a static checker and I have only compile tested it.
> The callers all seem to use the return code, but please review carefully.
> The code has been like this since the module was merged.
>
> diff --git a/security/integrity/ima/ima_main.c b/security/integrity/ima/ima_main.c
> index 294b005..90d5314 100644
> --- a/security/integrity/ima/ima_main.c
> +++ b/security/integrity/ima/ima_main.c
> @@ -260,18 +260,17 @@ out:
>  * policy decision.
>  *
>  * Return 0 on success, an error code on failure.
> - * (Based on the results of appraise_measurement().)
>  */
>  int ima_file_mmap(struct file *file, unsigned long prot)
>  {
> -       int rc;
> +       int rc = 0;
>
>        if (!file)
>                return 0;
>        if (prot & PROT_EXEC)
>                rc = process_measurement(file, file->f_dentry->d_name.name,
>                                         MAY_EXEC, FILE_MMAP);
> -       return 0;
> +       return rc;
>  }
>
>  /**
> --
> To unsubscribe from this list: send the line "unsubscribe linux-security-module" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

Looks good, and nice work here :)

Acked-by: Vikram Dhillon <dhillonv10@gmail.com>

-- 
Regards,
Vikram Dhillon

~~~
There are lots of Linux users who don't care how the kernel works, but
only want to use it. That is a tribute to how good Linux is.
-- Linus Torvalds
