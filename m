Return-Path: <linux-kernel-owner+w=401wt.eu-S1754393AbYEOGdj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754393AbYEOGdj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2008 02:33:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752157AbYEOGd3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 May 2008 02:33:29 -0400
Received: from yw-out-2324.google.com ([74.125.46.30]:23931 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751815AbYEOGd3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2008 02:33:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=BA0gP5SujIAgmCc0QK7YK4vM+hDiAS4FlJ/TXOyLDbP/zaZq5UezQILeFq4qK+CIGU5A+hCoGEBGdgGkyaXoNQNKBL1JVcK9p1BHDXwLEkAw0K7Xu0Z5Crnlt/sMxM8WXfPl7ucChH+mh1CRmZcfuD/ZOTre1V2diRZICy62k4g=
Message-ID: <386072610805142333vfc07709xe7a78b2a68cff2dd@mail.gmail.com>
Date: Thu, 15 May 2008 14:33:26 +0800
From: "Bryan Wu" <cooloney@kernel.org>
To: linux-kernel@vger.kernel.org, linux-mm@kvack.org, dwmw2@infradead.org
Subject: Re: [PATCH 2/4] [NOMMU]: include the problematic mapping in the munmap warning
Cc: "Mike Frysinger" <vapier.adi@gmail.com>, "Bryan Wu" <cooloney@kernel.org>
In-Reply-To: <1210588325-11027-3-git-send-email-cooloney@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1210588325-11027-1-git-send-email-cooloney@kernel.org>
	 <1210588325-11027-3-git-send-email-cooloney@kernel.org>
X-Google-Sender-Auth: 1810e26e7ea6e95a
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

IMO, this is useful for nommu stuff.
Is there any chance to merge this?

-Bryan

On Mon, May 12, 2008 at 6:32 PM, Bryan Wu <cooloney@kernel.org> wrote:
> From: Mike Frysinger <vapier.adi@gmail.com>
>
> Signed-off-by: Mike Frysinger <vapier.adi@gmail.com>
> Signed-off-by: Bryan Wu <cooloney@kernel.org>
> ---
>  mm/nommu.c |    5 +++--
>  1 files changed, 3 insertions(+), 2 deletions(-)
>
> diff --git a/mm/nommu.c b/mm/nommu.c
> index ef8c62c..c11e5cc 100644
> --- a/mm/nommu.c
> +++ b/mm/nommu.c
> @@ -1117,8 +1117,9 @@ int do_munmap(struct mm_struct *mm, unsigned long addr, size_t len)
>                        goto found;
>        }
>
> -       printk("munmap of non-mmaped memory by process %d (%s): %p\n",
> -              current->pid, current->comm, (void *) addr);
> +       printk(KERN_NOTICE "munmap of non-mmaped memory [%p-%p] by process %d (%s)\n",
> +              (void *)addr, (void *)addr+len, current->pid, current->comm);
> +
>        return -EINVAL;
>
>  found:
> --
> 1.5.5
>
>
