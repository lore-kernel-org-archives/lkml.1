Return-Path: <linux-kernel-owner+w=401wt.eu-S1753180AbYHAPPX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753180AbYHAPPX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2008 11:15:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751247AbYHAPPK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Aug 2008 11:15:10 -0400
Received: from wa-out-1112.google.com ([209.85.146.179]:55333 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750992AbYHAPPJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2008 11:15:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=FJz2z0k2LoAJQZGekTyCP+4Px0vDlsQpiwhWd7+Oo3SFUo3zhgt861j4ppeCbkGi26
         Or6h/y5kdTqSnYAZglrca6GLYQu+aIZFi9XxwGUqV5vRAwblsfeg90Ifn1d21GVhmlw+
         PHYuMOMiNODvJ0qy2wfI5o8+evZmahaZPIiiQ=
Message-ID: <48f7fe350808010815w319e6da9u77ec1613a13d95e1@mail.gmail.com>
Date: Fri, 1 Aug 2008 11:15:05 -0400
From: "Ryan Hope" <rmh3093@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>,
       "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: [PATCH][RESEND] mm: fix uninitialized variables for find_vma_prepare callers
In-Reply-To: <48f7fe350808010813u4e71c3e7h4d25127533a12726@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <48f7fe350808010813u4e71c3e7h4d25127533a12726@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I forgot to mention that this patch is for 2.6.27-rc1-mm1...

-Ryan

On Fri, Aug 1, 2008 at 11:13 AM, Ryan Hope <rmh3093@gmail.com> wrote:
> This was submitted for 2.6.26-rc8-mm1 but it must have gotten overlooked:
>
> diff --git a/mm/mmap.c b/mm/mmap.c
> index 4c5211b..3d65a03 100644
> --- a/mm/mmap.c
> +++ b/mm/mmap.c
> @@ -372,7 +372,7 @@ find_vma_prepare(struct mm_struct *mm, unsigned long addr,
>                if (vma_tmp->vm_end > addr) {
>                        vma = vma_tmp;
>                        if (vma_tmp->vm_start <= addr)
> -                               return vma;
> +                               break;
>                        __rb_link = &__rb_parent->rb_left;
>                } else {
>                        rb_prev = __rb_parent;
>
