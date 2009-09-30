Return-Path: <linux-kernel-owner+w=401wt.eu-S1754974AbZI3WmK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754974AbZI3WmK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Sep 2009 18:42:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754530AbZI3WmI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Sep 2009 18:42:08 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37946 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754258AbZI3WmH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Sep 2009 18:42:07 -0400
Date: Wed, 30 Sep 2009 15:40:44 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Samuel Thibault <samuel.thibault@ens-lyon.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       "David S. Miller" <davem@davemloft.net>,
       Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH,TRIVIAL] Fix csum_ipv6_magic asm memory clobber
Message-Id: <20090930154044.0c7ace16.akpm@linux-foundation.org>
In-Reply-To: <20090926192748.GX7681@const.famille.thibault.fr>
References: <20090926192748.GX7681@const.famille.thibault.fr>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 26 Sep 2009 21:27:48 +0200
Samuel Thibault <samuel.thibault@ens-lyon.org> wrote:

> Just like ip_fast_csum, the assembly snippet in csum_ipv6_magic needs a
> memory clobber, as it is only passed the address of the buffer, not a
> memory reference to the buffer itself.
> 
> Signed-Off-By: Samuel Thibault <samuel.thibault@ens-lyon.org>
> Cc: stable@kernel.org
> 
> diff --git a/arch/x86/include/asm/checksum_32.h b/arch/x86/include/asm/checksum_32.h
> index 7c5ef8b..46fc474 100644
> --- a/arch/x86/include/asm/checksum_32.h
> +++ b/arch/x86/include/asm/checksum_32.h
> @@ -161,7 +161,8 @@ static inline __sum16 csum_ipv6_magic(const struct in6_addr *saddr,
>  	    "adcl $0, %0	;\n"
>  	    : "=&r" (sum)
>  	    : "r" (saddr), "r" (daddr),
> -	      "r" (htonl(len)), "r" (htonl(proto)), "0" (sum));
> +	      "r" (htonl(len)), "r" (htonl(proto)), "0" (sum)
> +	    : "memory");
>  
>  	return csum_fold(sum);
>  }

You describe it as "trivial" and also cc stable@kernel.org.  These things
are contradictory!

Maybe backporting it is a good idea from a sleep-soundly-at-night POV. 
I don't know..

