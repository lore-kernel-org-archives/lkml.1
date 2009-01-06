Return-Path: <linux-kernel-owner+w=401wt.eu-S1752542AbZAFJvS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752542AbZAFJvS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 04:51:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751707AbZAFJu7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 04:50:59 -0500
Received: from fg-out-1718.google.com ([72.14.220.155]:5376 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751619AbZAFJu6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 04:50:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=Uy0iSVcEPGM00SBqhM+2IwtLaH1f++7W5NGkufM3soazBDzRE5luRSeMdRUxndyzra
         qSUNiSVo+tYDR4lXalp6C6fzwIeE+ipnthS76w659XT6OM47uhPa+ts6DrgNy8I8IvjO
         yRsoJdLvxB0SClNUJmJVxkkvOOSZ8kwCVPcv0=
Message-ID: <84144f020901060150i524a4fatdc1c2ca86ab2adab@mail.gmail.com>
Date: Tue, 6 Jan 2009 11:50:56 +0200
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Li Zefan" <lizf@cn.fujitsu.com>
Subject: Re: [PATCH] sched: fix double kfree
Cc: "Ingo Molnar" <mingo@elte.hu>, "Rusty Russell" <rusty@rustcorp.com.au>,
       "Peter Zijlstra" <a.p.zijlstra@chello.nl>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <496326BA.60605@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <496326BA.60605@cn.fujitsu.com>
X-Google-Sender-Auth: 6c6f1fb813d02adb
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 6, 2009 at 11:39 AM, Li Zefan <lizf@cn.fujitsu.com> wrote:
> Impact: fix double kfree in failure path
>
> It's not the responsibility of init_rootdomain() to free root_domain
> allocated by alloc_rootdomain().
>
> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>

FWIW

Reviewed-by: Pekka Enberg <penberg@cs.helsinki.fi>

> ---
>  kernel/sched.c |    5 ++---
>  1 files changed, 2 insertions(+), 3 deletions(-)
>
> diff --git a/kernel/sched.c b/kernel/sched.c
> index 545c6fc..2bad712 100644
> --- a/kernel/sched.c
> +++ b/kernel/sched.c
> @@ -6970,7 +6970,7 @@ static int init_rootdomain(struct root_domain *rd, bool bootmem)
>        }
>
>        if (!alloc_cpumask_var(&rd->span, GFP_KERNEL))
> -               goto free_rd;
> +               goto out;
>        if (!alloc_cpumask_var(&rd->online, GFP_KERNEL))
>                goto free_span;
>        if (!alloc_cpumask_var(&rd->rto_mask, GFP_KERNEL))
> @@ -6986,8 +6986,7 @@ free_online:
>        free_cpumask_var(rd->online);
>  free_span:
>        free_cpumask_var(rd->span);
> -free_rd:
> -       kfree(rd);
> +out:
>        return -ENOMEM;
>  }
>
> --
> 1.5.4.rc3
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
