Return-Path: <linux-kernel-owner+w=401wt.eu-S1751981AbZJUFSq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751981AbZJUFSq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Oct 2009 01:18:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751582AbZJUFSp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Oct 2009 01:18:45 -0400
Received: from qw-out-2122.google.com ([74.125.92.27]:48187 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750749AbZJUFSo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Oct 2009 01:18:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=QMRP6y9puAtuMdS+8V3mTuwp928okDlXuP0M8FWU5UljLtjSuh0ZWnEmdNxnvmibv7
         ywoqd0DgIqjmvGwZz0TVVpNdRnwlDOVbZ1KYav1pq6gGa0A1XFIVbHddSF6pSTJ02yO+
         UC1+L3SSvvpZyGwgaVYZy72kRtf8+HrBmt+J8=
MIME-Version: 1.0
In-Reply-To: <20091018113908.GR4808@kryten>
References: <20091018113908.GR4808@kryten>
Date: Wed, 21 Oct 2009 12:47:47 +0800
Message-ID: <2375c9f90910202147p5af0eb86oe2cad800a74ce40a@mail.gmail.com>
Subject: Re: [PATCH] exec: setup_arg_pages fails to return errors
From: =?UTF-8?Q?Am=C3=A9rico_Wang?= <xiyou.wangcong@gmail.com>
To: Anton Blanchard <anton@samba.org>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 18, 2009 at 7:39 PM, Anton Blanchard <anton@samba.org> wrote:
>
> In setup_arg_pages we work hard to assign a value to ret, but on exit
> we always return 0.
>
> Also remove a now duplicated exit path and branch to out_unlock instead.
>
> Signed-off-by: Anton Blanchard <anton@samba.org>
> ---


Reviewed-by: WANG Cong <xiyou.wangcong@gmail.com>

>
> Index: linux.trees.git/fs/exec.c
> ===================================================================
> --- linux.trees.git.orig/fs/exec.c      2009-09-28 12:17:10.000000000 +1000
> +++ linux.trees.git/fs/exec.c   2009-09-28 12:17:58.000000000 +1000
> @@ -624,10 +624,8 @@ int setup_arg_pages(struct linux_binprm
>        /* Move stack pages down in memory. */
>        if (stack_shift) {
>                ret = shift_arg_pages(vma, stack_shift);
> -               if (ret) {
> -                       up_write(&mm->mmap_sem);
> -                       return ret;
> -               }
> +               if (ret)
> +                       goto out_unlock;
>        }
>
>  #ifdef CONFIG_STACK_GROWSUP
> @@ -641,7 +639,7 @@ int setup_arg_pages(struct linux_binprm
>
>  out_unlock:
>        up_write(&mm->mmap_sem);
> -       return 0;
> +       return ret;
>  }
>  EXPORT_SYMBOL(setup_arg_pages);
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
