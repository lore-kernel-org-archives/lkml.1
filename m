Return-Path: <linux-kernel-owner+w=401wt.eu-S1757208AbXKGGze@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757208AbXKGGze (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2007 01:55:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750826AbXKGGz0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Nov 2007 01:55:26 -0500
Received: from rv-out-0910.google.com ([209.85.198.184]:23210 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750695AbXKGGzY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2007 01:55:24 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=LRidFqp/HfzsXE4umEJTVkXxQYGeevKiJC1yD0AFsDNZk7GlCeRQLW6wcKZ/XjDC2u3PID4NnPYzkviMncd2JMPLboQLLGFhdKV22vJDuAWxsc3kkFeXdu6zr8z1e72jYqyCH0LOr3/6OTVf9cNfDRXdZNEbpmgSgF3xxkne1Z8=
Message-ID: <3877989d0711062255r45bdd437ic115fc52d064c59b@mail.gmail.com>
Date: Wed, 7 Nov 2007 14:55:24 +0800
From: "Luming Yu" <luming.yu@gmail.com>
To: "Simon Horman" <horms@verge.net.au>
Subject: Re: [patch] ia64: remove per_cpu_offset()
Cc: linux-ia64@vger.kernel.org, linux-kernel@vger.kernel.org,
       "Yu Luming" <luming.yu@intel.com>, "David Miller" <davem@davemloft.net>,
       "Ingo Molnar" <mingo@elte.hu>,
       "Arjan van de Ven" <arjan@linux.intel.com>,
       "Rusty Russell" <rusty@rustcorp.com.au>,
       "Andrew Morton" <akpm@osdl.org>
In-Reply-To: <20071107064627.GD3571@verge.net.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20071107064627.GD3571@verge.net.au>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

NAK for now.

I'm trying to add lockdep , so please don't delete it until it could
be proved really useless...
Please don't hurry...

On 11/7/07, Simon Horman <horms@verge.net.au> wrote:
> per_cpu_offset() was added as part of a lockdep patch,
> "[PATCH] lockdep: add per_cpu_offset()"
> (a875a69f8b00a38b4f40d9632a4fc71a159f0e0d),
> but ia64 doesn't have lockdep, nor does it use per_cpu_offset()
> anywhere else.
>
> This came up because Yu Lumming noticed that the ia64 version
> of per_cpu_offset() actually has a syntax error. Amusing as it seems
> to have been in the tree for months.
>
> > -#define per_cpu_offset(x) (__per_cpu_offset(x))
> > +#define per_cpu_offset(x) (__per_cpu_offset[x])
>
> Dave Miller suggested that rather than fixing the unused code it would be
> better to just remove it all together.
>
> Signed-off-by: Simon Horman <horms@verge.net.au>
>
> diff --git a/include/asm-ia64/percpu.h b/include/asm-ia64/percpu.h
> index c4f1e32..2870f8d 100644
> --- a/include/asm-ia64/percpu.h
> +++ b/include/asm-ia64/percpu.h
> @@ -46,7 +46,6 @@
>  #ifdef CONFIG_SMP
>
>  extern unsigned long __per_cpu_offset[NR_CPUS];
> -#define per_cpu_offset(x) (__per_cpu_offset[x])
>
>  /* Equal to __per_cpu_offset[smp_processor_id()], but faster to access: */
>  DECLARE_PER_CPU(unsigned long, local_per_cpu_offset);
> -
> To unsubscribe from this list: send the line "unsubscribe linux-ia64" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
