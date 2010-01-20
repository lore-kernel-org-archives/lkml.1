Return-Path: <linux-kernel-owner+w=401wt.eu-S1753565Ab0ATNu1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753565Ab0ATNu1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jan 2010 08:50:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752588Ab0ATNu0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jan 2010 08:50:26 -0500
Received: from fg-out-1718.google.com ([72.14.220.155]:17145 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751478Ab0ATNuT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jan 2010 08:50:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=frgC3gUrEweCuS1RkmQR7S0wobY1H4MryxzRSGCnGo82g3d1YKoiZggd6ZqPWujaVz
         6q57fMVw8cZhRRL/yqvvEd1TMW8XLcic7SeVGEJsftem5AOx/oHFlZphvrBc5OhbXHAK
         tM87IMNl1bGv6s+dOb2nbspxGIY4ya9mt/jl0=
Message-ID: <4B570A15.8040601@gmail.com>
Date: Wed, 20 Jan 2010 14:50:13 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-17.1 Thunderbird/3.0
MIME-Version: 1.0
To: Johannes Weiner <hannes@cmpxchg.org>
CC: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       Ralf Baechle <ralf@linux-mips.org>, x86@kernel.org
Subject: Re: [RFC 1/1] bootmem: move big allocations behing 4G
References: <1263855390-32497-1-git-send-email-jslaby@suse.cz> <20100119143355.GB7932@cmpxchg.org>
In-Reply-To: <20100119143355.GB7932@cmpxchg.org>
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/19/2010 03:33 PM, Johannes Weiner wrote:
> --- a/include/linux/bootmem.h
> +++ b/include/linux/bootmem.h
> @@ -96,20 +96,26 @@ extern void *__alloc_bootmem_low_node(pg_data_t *pgdat,
>  				      unsigned long align,
>  				      unsigned long goal);
>  
> +#ifdef MAX_DMA32_PFN
> +#define BOOTMEM_DEFAULT_GOAL	(__pa(MAX_DMA32_PFN << PAGE_SHIFT))
> +#else
> +#define BOOTMEM_DEFAULT_GOAL	MAX_DMA_ADDRESS

I just noticed this should write:
#define BOOTMEM_DEFAULT_GOAL   __pa(MAX_DMA_ADDRESS)

> +#endif
> +
>  #define alloc_bootmem(x) \
> -	__alloc_bootmem(x, SMP_CACHE_BYTES, __pa(MAX_DMA_ADDRESS))
> +	__alloc_bootmem(x, SMP_CACHE_BYTES, BOOTMEM_DEFAULT_GOAL)


-- 
js
