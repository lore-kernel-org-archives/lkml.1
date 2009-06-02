Return-Path: <linux-kernel-owner+w=401wt.eu-S1759089AbZFBEvS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759089AbZFBEvS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jun 2009 00:51:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758997AbZFBEvE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Jun 2009 00:51:04 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54274 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758051AbZFBEvC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jun 2009 00:51:02 -0400
Date: Mon, 1 Jun 2009 21:50:34 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Florian Fainelli <florian@openwrt.org>
Cc: linux-kernel@vger.kernel.org, Takashi Iwai <tiwai@suse.de>,
       linux-mips@linux-mips.org, Ralf Baechle <ralf@linux-mips.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH 1/9] kernel: export sound/core/pcm_timer.c gcd
 implementation
Message-Id: <20090601215034.7352ddca.akpm@linux-foundation.org>
In-Reply-To: <200906011357.09966.florian@openwrt.org>
References: <200906011357.09966.florian@openwrt.org>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 1 Jun 2009 13:57:09 +0200 Florian Fainelli <florian@openwrt.org> wrote:

> This patch exports the gcd implementation from
> sound/core/pcm_timer.c into include/linux/kernel.h.
> AR7 uses it in its clock routines.
> 
> ...
>
> diff --git a/include/linux/kernel.h b/include/linux/kernel.h
> index 883cd44..878a27a 100644
> --- a/include/linux/kernel.h
> +++ b/include/linux/kernel.h
> @@ -147,6 +147,22 @@ extern int _cond_resched(void);
>  		(__x < 0) ? -__x : __x;		\
>  	})
>  
> +/* Greatest common divisor */
> +static inline unsigned long gcd(unsigned long a, unsigned long b)
> +{
> +        unsigned long r;
> +        if (a < b) {
> +                r = a;
> +                a = b;
> +                b = r;
> +        }
> +        while ((r = a % b) != 0) {
> +                a = b;
> +                b = r;
> +        }
> +        return b;
> +}

a) the name's a bit sucky.   Is there some convention for this name?

b) It looks too large to be inlined.  lib/gdc.c?

b) there's an implementation of gcd() in
   net/netfilter/ipvs/ip_vs_wrr.c.  I expect that this patch broke the
   build.


