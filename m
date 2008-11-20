Return-Path: <linux-kernel-owner+w=401wt.eu-S1756219AbYKTSpa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756219AbYKTSpa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2008 13:45:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753456AbYKTSpW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Nov 2008 13:45:22 -0500
Received: from yw-out-2324.google.com ([74.125.46.30]:6077 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752470AbYKTSpV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2008 13:45:21 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=dCyZRQ5k6klVIZOt/GeZICIgWxyzDADPeRtqmdXYoBVt/BN5iw8Y60WueZdTtVeClj
         lfWxkxd4EbUtET7HIJh3haEZggYM1+6zTp/FLBbS0Op/H9ZXAeo2WpwF9mBVBXulwPRi
         NcYwElI0eKV9qo3dpBBlUUxQZSDdbmaAxDL7E=
Message-ID: <84144f020811201045w27d4d751h771276eb5fd8beda@mail.gmail.com>
Date: Thu, 20 Nov 2008 20:45:19 +0200
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Catalin Marinas" <catalin.marinas@arm.com>
Subject: Re: Possible memory leak via slub kmem_cache_create
Cc: "Christoph Lameter" <cl@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       "Arnaldo Carvalho de Melo" <acme@ghostprotocols.net>
In-Reply-To: <1227174711.5784.9.camel@pc1117.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1227111954.27162.28.camel@pc1117.cambridge.arm.com>
	 <Pine.LNX.4.64.0811191319360.23084@quilx.com>
	 <1227174711.5784.9.camel@pc1117.cambridge.arm.com>
X-Google-Sender-Auth: f387002be7ea2589
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Catalin,

On Thu, Nov 20, 2008 at 11:51 AM, Catalin Marinas
<catalin.marinas@arm.com> wrote:
> My point is that the API is slightly different when slub is used since
> kmem_cache_name is no longer guaranteed to return the same pointer
> passed to kmem_cache_create. Maybe a documentation update:
>
> diff --git a/mm/slab.c b/mm/slab.c
> index ea76bcb..9723a72 100644
> --- a/mm/slab.c
> +++ b/mm/slab.c
> @@ -2124,6 +2124,8 @@ static int __init_refok setup_cpu_cache(struct kmem_cache
>  *
>  * @name must be valid until the cache is destroyed. This implies that
>  * the module calling this has to destroy the cache before getting unloaded.
> + * Note that kmem_cache_name() is not guaranteed to return the same pointer,
> + * therefore applications must manage it themselves.

Yes, makes sense. Care to send a patch I can apply?

                         Pekka
