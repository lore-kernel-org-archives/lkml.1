Return-Path: <linux-kernel-owner+w=401wt.eu-S1757824AbYEPNt0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757824AbYEPNt0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2008 09:49:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756126AbYEPNtS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 May 2008 09:49:18 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:33165 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756072AbYEPNtR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2008 09:49:17 -0400
Date: Fri, 16 May 2008 15:48:58 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Miklos Vajna <vmiklos@frugalware.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] x86: janitor work in bugs.c
Message-ID: <20080516134858.GC28910@elte.hu>
References: <20080513124454.GF14973@elte.hu> <1210695109-31727-1-git-send-email-vmiklos@frugalware.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1210695109-31727-1-git-send-email-vmiklos@frugalware.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Miklos Vajna <vmiklos@frugalware.org> wrote:

> -/* trap_init() enabled FXSR and company _before_ testing for FP problems here. */
> +/* 
> + * trap_init() enabled FXSR and company _before_ testing for FP problems
> + * here.
> + */
>  	/* Test for the divl bug.. */
>  	__asm__("fninit\n\t"
>  		"fldl %1\n\t"

the two comments should be merged, somehow like this:

> +	/* 
> +	 * trap_init() enabled FXSR and company _before_ testing for FP 
> +	 * problems here.
> +	 *
> +	 * Test for the divl bug:
> +	 */
>  	__asm__("fninit\n\t"

>  	check_popad();
> -	init_utsname()->machine[1] = '0' + (boot_cpu_data.x86 > 6 ? 6 : boot_cpu_data.x86);
> +	init_utsname()->machine[1] = '0' + (boot_cpu_data.x86 > 6 ? 6 :
> +	    boot_cpu_data.x86);

hm, that looks a bit ugly. It's nicer to have something like:

> +	init_utsname()->machine[1] = '0' + (boot_cpu_data.x86 > 6 ? 6 :
> +							boot_cpu_data.x86);

i.e. have a continuation of the right side of the expression, and have 
it close to where it was broken from.

or just do:

> +	init_utsname()->machine[1] =
> +		 '0' + (boot_cpu_data.x86 > 6 ? 6 : boot_cpu_data.x86);

	Ingo
