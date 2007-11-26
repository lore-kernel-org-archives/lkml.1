Return-Path: <linux-kernel-owner+w=401wt.eu-S1753920AbXKZHkV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753920AbXKZHkV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2007 02:40:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752806AbXKZHkH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Nov 2007 02:40:07 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:44833 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752810AbXKZHkG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2007 02:40:06 -0500
Date: Sun, 25 Nov 2007 23:39:49 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Udo van den Heuvel <udovdh@xs4all.nl>
Cc: linux-kernel@vger.kernel.org, Michael Buesch <mb@bu3sch.de>
Subject: Re: enable dual rng on VIA C7
Message-Id: <20071125233949.f64b2ecd.akpm@linux-foundation.org>
In-Reply-To: <47374EA4.1060009@xs4all.nl>
References: <47374EA4.1060009@xs4all.nl>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 11 Nov 2007 19:49:08 +0100 Udo van den Heuvel <udovdh@xs4all.nl> wrote:

> Any reason why the second rng on the VIA C7 CPU is not enabled?
> 
> Kind regards,
> Udo
> 
> 
> [via-rng.patch  text/plain (634B)]
> --- old/drivers/char/hw_random/via-rng.c	2007-11-11 19:39:49.000000000 +0100
> +++ new/drivers/char/hw_random/via-rng.c	2007-11-11 19:40:41.000000000 +0100
> @@ -41,6 +41,7 @@
>  	VIA_STRFILT_ENABLE	= (1 << 14),
>  	VIA_RAWBITS_ENABLE	= (1 << 13),
>  	VIA_RNG_ENABLE		= (1 << 6),
> +	VIA_RNG_DUAL            = (1 << 9),
>  	VIA_XSTORE_CNT_MASK	= 0x0F,
>  
>  	VIA_RNG_CHUNK_8		= 0x00,	/* 64 rand bits, 64 stored bits */
> @@ -128,6 +129,7 @@
>  	lo &= ~(0x7f << VIA_STRFILT_CNT_SHIFT);
>  	lo &= ~VIA_XSTORE_CNT_MASK;
>  	lo &= ~(VIA_STRFILT_ENABLE | VIA_STRFILT_FAIL | VIA_RAWBITS_ENABLE);
> +	lo |= VIA_RNG_DUAL;
>  	lo |= VIA_RNG_ENABLE;
>  
>  	if (lo != old_lo)
> 

Does the patch work?

It's missing a signed-off-by:, btw
