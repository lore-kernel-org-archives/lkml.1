Return-Path: <linux-kernel-owner+w=401wt.eu-S1758394AbYCCO41@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758394AbYCCO41 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 09:56:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753788AbYCCO4P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 09:56:15 -0500
Received: from pasmtpb.tele.dk ([80.160.77.98]:55697 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755479AbYCCO4N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 09:56:13 -0500
Date: Mon, 3 Mar 2008 15:56:23 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Adrian Bunk <bunk@kernel.org>, Alexey Starikovskiy <aystarik@gmail.com>,
       lenb@kernel.org, astarikovskiy@suse.de, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org, Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [patch] x86: phase out forced inlining
Message-ID: <20080303145623.GA25697@uranus.ravnborg.org>
References: <47C99FE1.8080206@gmail.com> <20080301183550.GC25835@cs181133002.pp.htv.fi> <20080303085720.GD15943@elte.hu> <20080303091314.GC4457@cs181133002.pp.htv.fi> <20080303091714.GA18250@elte.hu> <20080303093103.GA23651@uranus.ravnborg.org> <20080303103933.GC21190@elte.hu> <20080303113451.GF4457@cs181133002.pp.htv.fi> <20080303114533.GA4183@elte.hu> <20080303121335.GA15381@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080303121335.GA15381@elte.hu>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo.

> Subject: x86: phase out forced inlining

Any particular reason you made the patch x86 specific?

It is preferred to gain this size decrease for other arch too
and having a single definiton of OPTIMIZE_FOR_SIZE
would help here.

We have this for other gcc options already.



> +config OPTIMIZE_INLINING

Other (not all) config options that deal with gcc behaviour are
named CC_*. But they mostly impact gcc options.
CC_OPTIMIZE_INLINING would match the naming of CC_OPTIMIZE_SIZE,
except in the latter OPTIMIZE refer to the -O option.

CC_DEFAULT_INLINE may give the right associations?


> +	bool "Allow gcc to uninline functions marked 'inline'"
> +	default y
> +	help
> +	  This option determines if the kernel forces gcc to inline the functions
> +	  developers have marked 'inline'. Doing so takes away freedom from gcc to
> +	  do what it thinks is best, which is desirable for the gcc 3.x series of
> +	  compilers. The gcc 4.x series have a rewritten inlining algorithm and
> +	  disabling this option will generate a smaller kernel there. Hopefully
> +	  this algorithm is so good that allowing gcc4 to make the decision can
> +	  become the default in the future, until then this option is there to
> +	  test gcc for this.

Would it be worth here to mention that stuff that really
needs inlining should use __always_inle and not inline?

> + */
> +#ifndef CONFIG_OPTIMIZE_INLINING
> +# define inline		inline		__attribute__((always_inline))
> +# define __inline__	__inline__	__attribute__((always_inline))
> +# define __inline	__inline	__attribute__((always_inline))
> +#endif

A quick google did not tell me the difference between inline, __inline, __inline__.
But it turned out the december 2005 thread where there was a lenghty discussion about
trusting gcc with respect to inlining.
It is not the subject of this patch but I just wondered why we need all these variants.

	Sam
