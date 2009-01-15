Return-Path: <linux-kernel-owner+w=401wt.eu-S1759283AbZAOKE3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759283AbZAOKE3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 05:04:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754209AbZAOKEV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 05:04:21 -0500
Received: from mail-bw0-f21.google.com ([209.85.218.21]:47100 "EHLO
	mail-bw0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752939AbZAOKEU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 05:04:20 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=qNNeDTfgXftU/lIIwnoMJJrcT1u4+XJXjpaR3jqs1Sk2D4kp+AhhQPz8ufFkTxq2lF
         HUAmrlVw/YVj5WXveOiu97KKc8it2krR+/GoJf8tsL7NHnKXL19bLfDOGXgflm5Bflym
         7LyMRBbyf4VtaZPCkJfHNWPlJMjHasG5winY0=
Message-ID: <25e057c00901150204x61c54d9fl91afe23477d1f12f@mail.gmail.com>
Date: Thu, 15 Jan 2009 11:04:17 +0100
From: "roel kluin" <roel.kluin@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [patch] add optimized generic percpu accessors
Cc: "H. Peter Anvin" <hpa@zytor.com>, "Tejun Heo" <tj@kernel.org>,
       "Brian Gerst" <brgerst@gmail.com>, ebiederm@xmission.com,
       cl@linux-foundation.org, rusty@rustcorp.com.au, travis@sgi.com,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       steiner@sgi.com, hugh@veritas.com
In-Reply-To: <20090114093834.GA19799@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1231843097-18003-1-git-send-email-tj@kernel.org>
	 <496C717F.70204@kernel.org>
	 <73c1f2160901130527s2d61f4ewf0725c3bf1b36a1a@mail.gmail.com>
	 <496C9FB7.9050907@kernel.org> <496D8CEB.5060402@zytor.com>
	 <20090114093834.GA19799@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Index: linux/include/asm-generic/percpu.h
> ===================================================================
> --- linux.orig/include/asm-generic/percpu.h
> +++ linux/include/asm-generic/percpu.h
> @@ -80,4 +80,32 @@ extern void setup_per_cpu_areas(void);
>  #define DECLARE_PER_CPU(type, name) extern PER_CPU_ATTRIBUTES \
>                                        __typeof__(type) per_cpu_var(name)
>
> +/*
> + * Optional methods for optimized non-lvalue per-cpu variable access:
> + */
> +
> +#ifndef percpu_read
> +# define percpu_read(var)              __get_cpu_var(var)
> +#endif
> +
> +#ifndef percpu_write
> +# define percpu_write(var, val)                ({ __get_cpu_var(var) = (val); })
> +#endif
> +
> +#ifndef percpu_add
> +# define percpu_add(var, val)          ({ __get_cpu_var(var) += (val); })
> +#endif
> +
> +#ifndef percpu_sub
> +# define percpu_add(var, val)          ({ __get_cpu_var(var) += (val); })

this should be:

define percpu_sub(var, val)          ({ __get_cpu_var(var) -= (val); })

> +#endif
> +
> +#ifndef percpu_or
> +# define percpu_or(var, val)           ({ __get_cpu_var(var) |= (val); })
> +#endif
> +
> +#ifndef percpu_xor
> +# define percpu_xor(var, val)          ({ __get_cpu_var(var) ^= (val); })
> +#endif
> +
>  #endif /* _ASM_GENERIC_PERCPU_H_ */
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
