Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757356Ab0BCPw7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Feb 2010 10:52:59 -0500
Received: from mail-yw0-f198.google.com ([209.85.211.198]:62360 "EHLO
	mail-yw0-f198.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756050Ab0BCPwz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Feb 2010 10:52:55 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=sX7Iq1RC+f08bc1i3IBxa+zonZa94dmFVOwXiKJ8v8sXvLAuIH7M1OoYgtrPcWOm4c
         KvybZBZJeEIhYEcYXdS+mqLALMjFrLtzBaLICxxkUgxEKw9VzAqz3hp+CvcOfp8DM8PN
         XKYUKo4mOym+QtxHjYlHehmKXJvNVwGrsJO2k=
MIME-Version: 1.0
In-Reply-To: <4B699B06.2040202@gmail.com>
References: <4B699B06.2040202@gmail.com>
Date: Wed, 3 Feb 2010 10:52:54 -0500
Message-ID: <b4198de61002030752u24ae20bbt2c09dc9d1c141503@mail.gmail.com>
Subject: Re: [PATCH] alpha: PTR_ERR overwrites -EINVAL in syscall osf_mount
From: Matt Turner <mattst88@gmail.com>
To: Roel Kluin <roel.kluin@gmail.com>
Cc: Richard Henderson <rth@twiddle.net>,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>, linux-alpha@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 3, 2010 at 10:49 AM, Roel Kluin <roel.kluin@gmail.com> wrote:
> The initial -EINVAL value is overwritten by `retval = PTR_ERR(name)'.
> If this isn't an error pointer and typenr is not 1, 6 or 9, then
> this retval, a pointer cast to a long, is returned.
>
> Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
> ---
> Was this intended? Not sure whether this can occur, found by code
> analysis.
>
> diff --git a/arch/alpha/kernel/osf_sys.c b/arch/alpha/kernel/osf_sys.c
> index 62619f2..53c213f 100644
> --- a/arch/alpha/kernel/osf_sys.c
> +++ b/arch/alpha/kernel/osf_sys.c
> @@ -361,7 +361,7 @@ osf_procfs_mount(char *dirname, struct procfs_args __user *args, int flags)
>  SYSCALL_DEFINE4(osf_mount, unsigned long, typenr, char __user *, path,
>                int, flag, void __user *, data)
>  {
> -       int retval = -EINVAL;
> +       int retval;
>        char *name;
>
>        name = getname(path);
> @@ -379,6 +379,7 @@ SYSCALL_DEFINE4(osf_mount, unsigned long, typenr, char __user *, path,
>                retval = osf_procfs_mount(name, data, flag);
>                break;
>        default:
> +               retval = -EINVAL;
>                printk("osf_mount(%ld, %x)\n", typenr, flag);
>        }
>        putname(name);
>

Looks like a bug to me as well. Can anyone else confirm?

Matt Turner
