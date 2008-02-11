Return-Path: <linux-kernel-owner+w=401wt.eu-S1758221AbYBKW5i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758221AbYBKW5i (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2008 17:57:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753245AbYBKW5b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Feb 2008 17:57:31 -0500
Received: from waste.org ([66.93.16.53]:33328 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751247AbYBKW5a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2008 17:57:30 -0500
Subject: Re: [PATCH] x86 (Linux Tiny): configure out support for some
	processors
From: Matt Mackall <mpm@selenic.com>
To: Michael Opdenacker <michael-lists@free-electrons.com>
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Anvin" <hpa@zytor.com>,
       linux-kernel@vger.kernel.org, Linux-tiny@selenic.com
In-Reply-To: <200802112342.23493.michael-lists@free-electrons.com>
References: <200802082347.25364.michael-lists@free-electrons.com>
	 <20080208231130.GA10511@elte.hu>
	 <200802112342.23493.michael-lists@free-electrons.com>
Content-Type: text/plain
Date: Mon, 11 Feb 2008 16:56:06 -0600
Message-Id: <1202770566.12383.59.camel@cinder.waste.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 2008-02-11 at 23:42 +0100, Michael Opdenacker wrote:
>  /* Specific CPU type init functions */
> -int intel_cpu_init(void);
> -int amd_init_cpu(void);
> -int cyrix_init_cpu(void);
> -int nsc_init_cpu(void);
> -int centaur_init_cpu(void);
> -int transmeta_init_cpu(void);
> -int nexgen_init_cpu(void);
> -int umc_init_cpu(void);
> +
> +#ifdef CONFIG_CPU_SUP_INTEL
> +int __cpuinit __ppro_with_ram_bug(void);
> +static inline int __cpuinit ppro_with_ram_bug(void)
> +{
> +	return __ppro_with_ram_bug();
> +}

I know Ingo said to do this, but I think he was flat-out wrong. If the
tradeoff is between having a dozen ifdefs contained in a single function
in one .c file vs wrapping a dozen function in a .h file, I say stick
them in the .c file.

Best would be to have no ifdefs and do it all with linker magic, of
course. But that's trickier.

Now the patch is 90% fiddling with wrappers and it's impossible to find
the interesting bits anymore..

-- 
Mathematics is the supreme nostalgia of our time.

