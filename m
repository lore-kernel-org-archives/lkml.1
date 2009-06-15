Return-Path: <linux-kernel-owner+w=401wt.eu-S1754573AbZFOFl3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754573AbZFOFl3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 01:41:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751591AbZFOFlU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 01:41:20 -0400
Received: from mail-fx0-f206.google.com ([209.85.220.206]:57160 "EHLO
	mail-fx0-f206.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751155AbZFOFlT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 01:41:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=LGGdDcdh/RUbaPMuIxvoxudzyFSsMTowLQbs8VtWnIBIK8AkGzv1xZR1l1P92bG2Wf
         ZqMeRsYBNDNlVFNjbOQOFVOW8gjGC2zQYF/5e44TW7uJimLgmf9OR/nXHZQsHapr4Had
         TBXMxh/F32WaLMe+mzAArF7XNLmlpYWiqe67Y=
MIME-Version: 1.0
In-Reply-To: <4A35DD5B.9050106@cn.fujitsu.com>
References: <4A35DD5B.9050106@cn.fujitsu.com>
Date: Mon, 15 Jun 2009 08:41:20 +0300
X-Google-Sender-Auth: 0af35616ab564e4c
Message-ID: <84144f020906142241w6be3dd75i4343c226f639246e@mail.gmail.com>
Subject: Re: [PATCH] sched: remove unneeded __ref tag
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 15, 2009 at 8:34 AM, Li Zefan<lizf@cn.fujitsu.com> wrote:
> Those two functions no longer call alloc_bootmmem_cpumask_var(), so
> no need to tag them with __init_refok.
>
> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>

Acked-by: Pekka Enberg <penberg@cs.helsinki.fi>

Thanks Li!

> ---
>  kernel/sched.c        |    2 +-
>  kernel/sched_cpupri.c |    2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/kernel/sched.c b/kernel/sched.c
> index 6032f51..54e47bc 100644
> --- a/kernel/sched.c
> +++ b/kernel/sched.c
> @@ -7828,7 +7828,7 @@ static void rq_attach_root(struct rq *rq, struct root_domain *rd)
>                free_rootdomain(old_rd);
>  }
>
> -static int __init_refok init_rootdomain(struct root_domain *rd, bool bootmem)
> +static int init_rootdomain(struct root_domain *rd, bool bootmem)
>  {
>        gfp_t gfp = GFP_KERNEL;
>
> diff --git a/kernel/sched_cpupri.c b/kernel/sched_cpupri.c
> index 7deffc9..e6c2517 100644
> --- a/kernel/sched_cpupri.c
> +++ b/kernel/sched_cpupri.c
> @@ -152,7 +152,7 @@ void cpupri_set(struct cpupri *cp, int cpu, int newpri)
>  *
>  * Returns: -ENOMEM if memory fails.
>  */
> -int __init_refok cpupri_init(struct cpupri *cp, bool bootmem)
> +int cpupri_init(struct cpupri *cp, bool bootmem)
>  {
>        gfp_t gfp = GFP_KERNEL;
>        int i;
> --
> 1.5.4.rc3
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
