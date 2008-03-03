Return-Path: <linux-kernel-owner+w=401wt.eu-S1756648AbYCCTva@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756648AbYCCTva (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 14:51:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751597AbYCCTvU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 14:51:20 -0500
Received: from mail.gmx.net ([213.165.64.20]:43645 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751378AbYCCTvT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 14:51:19 -0500
Cc: airlied@linux.ie, linux-kernel@vger.kernel.org,
       dri-devel@lists.sourceforge.net, linuxppc-dev@ozlabs.org
Content-Type: text/plain; charset="iso-8859-1"
Date: Mon, 03 Mar 2008 20:51:17 +0100
From: "Gerhard Pircher" <gerhard_pircher@gmx.net>
In-Reply-To: <1204498569.15052.488.camel@pasglop>
Message-ID: <20080303195117.7040@gmx.net>
MIME-Version: 1.0
References: <20071125234254.B4405DDE49@ozlabs.org>	
 <20080302110505.175270@gmx.net> <1204490829.15052.482.camel@pasglop>	
 <20080302223012.90210@gmx.net> <1204498569.15052.488.camel@pasglop>
Subject: Re: [BUG/RFC/PATCH] drm: Fix for non-coherent DMA PowerPC
To: benh@kernel.crashing.org
X-Authenticated: #6097454
X-Flags: 0001
X-Mailer: WWW-Mail 6100 (Global Message Exchange)
X-Priority: 3
X-Provags-ID: V01U2FsdGVkX1+LeK0W2GGLUFp2B1emrxhkB/Pz4xVy+qNBHuFmlD
 jFe2Qfh8+qfcFqxWpPcqCC3W6cQ5+7LqxRfA== 
Content-Transfer-Encoding: 8bit
X-GMX-UID: h2D5drVqbUk7Chg5b2gndupsZ2hlN8r5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


-------- Original-Nachricht --------
> Datum: Mon, 03 Mar 2008 09:56:09 +1100
> Von: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> An: Gerhard Pircher <gerhard_pircher@gmx.net>
> CC: linuxppc-dev@ozlabs.org, dri-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org, airlied@linux.ie
> Betreff: Re: [BUG/RFC/PATCH] drm: Fix for non-coherent DMA PowerPC

> Bah, I think I found the problem:
> 
> +static inline void *drm_vmalloc_dma(unsigned long size)
> +{
> +#if defined(__powerpc__) && defined(CONFIG_NOT_COHERENT_CACHE)
> +       return __vmalloc(size, GFP_KERNEL | __GFP_HIGHMEM,
> +                        PAGE_KERNEL | _PAGE_NO_CACHE);
> +#else
> +       return vmalloc_32(size);
> +#endif
> +}
> +
> 
> Remove the GFP_HIGHMEM from the above. It looks like our cache
> flushing isn't going to work for highmem, it would need some
> kmap's for that.
Yes, it looks like this was the problem. No kernel oops anymore.
The machine locks up anyway (which is a well known hardware problem).
It doesn't lock up with CPPIOMode=true, but probably only because the
initialization of DRI fails with "BAD cp_mode (f0000000)!".

Gerhard
-- 
Psssst! Schon vom neuen GMX MultiMessenger gehört?
Der kann`s mit allen: http://www.gmx.net/de/go/multimessenger
