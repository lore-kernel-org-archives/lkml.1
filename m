Return-Path: <linux-kernel-owner+w=401wt.eu-S1760671AbZJIMRH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760671AbZJIMRH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Oct 2009 08:17:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760489AbZJIMRG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Oct 2009 08:17:06 -0400
Received: from mail-fx0-f227.google.com ([209.85.220.227]:35370 "EHLO
	mail-fx0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760194AbZJIMRF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Oct 2009 08:17:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=gJDkoBPjVCERFjWq3tY9NuQOszBPIfF32m56kSquFX+Mj8DdjYTKuyBdcphGzeYg38
         7/x/lQdSeEuMCcDlJWAQyp1zn0zjpuFtwUkrCVDpvNDTHE/S3ZR/TkkATLVGrxrFKlPh
         Hu65G1qwmZ0cN7biEyQgAzUt35VTi/+IQXjyY=
MIME-Version: 1.0
In-Reply-To: <20091009093034.4365.34259.stgit@pc1117.cambridge.arm.com>
References: <20091009093028.4365.4391.stgit@pc1117.cambridge.arm.com>
	 <20091009093034.4365.34259.stgit@pc1117.cambridge.arm.com>
Date: Fri, 9 Oct 2009 15:16:27 +0300
X-Google-Sender-Auth: ac67b10ae6f4a471
Message-ID: <84144f020910090516gac3d598rad20ea3ced063acf@mail.gmail.com>
Subject: Re: [PATCH 2/2] kmemleak: Check for NULL pointer returned by 
	create_object()
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 9, 2009 at 12:30 PM, Catalin Marinas
<catalin.marinas@arm.com> wrote:
> This patch adds NULL pointer checking in the early_alloc() function.
>
> Reported-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>

Acked-by: Pekka Enberg <penberg@cs.helsinki.fi>

> ---
>  mm/kmemleak.c |    3 +++
>  1 files changed, 3 insertions(+), 0 deletions(-)
>
> diff --git a/mm/kmemleak.c b/mm/kmemleak.c
> index a617518..8bf765c 100644
> --- a/mm/kmemleak.c
> +++ b/mm/kmemleak.c
> @@ -834,11 +834,14 @@ static void early_alloc(struct early_log *log)
>        rcu_read_lock();
>        object = create_object((unsigned long)log->ptr, log->size,
>                               log->min_count, GFP_ATOMIC);
> +       if (!object)
> +               goto out;
>        spin_lock_irqsave(&object->lock, flags);
>        for (i = 0; i < log->trace_len; i++)
>                object->trace[i] = log->trace[i];
>        object->trace_len = log->trace_len;
>        spin_unlock_irqrestore(&object->lock, flags);
> +out:
>        rcu_read_unlock();
>  }
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
