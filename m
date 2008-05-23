Return-Path: <linux-kernel-owner+w=401wt.eu-S1757755AbYEWNVu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757755AbYEWNVu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2008 09:21:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757217AbYEWNUy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 May 2008 09:20:54 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:4572 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756919AbYEWNUx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2008 09:20:53 -0400
Date: Fri, 23 May 2008 15:16:36 +0200
From: Pavel Machek <pavel@suse.cz>
To: Dave Jones <davej@redhat.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, hpa@zytor.com
Subject: Re: [X86] Move the AMD64 specific parts out of setup_64.c
Message-ID: <20080523131636.GH9245@ucw.cz>
References: <200805221944.m4MJiAC6029820@gelk.kernelslacker.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200805221944.m4MJiAC6029820@gelk.kernelslacker.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> Create a separate amd_64.c file in the cpu/ dir for
> the useful parts to live in.
> 

> +#define ENABLE_C1E_MASK		0x18000000
> +#define CPUID_PROCESSOR_SIGNATURE	1
> +#define CPUID_XFAM		0x0ff00000
> +#define CPUID_XFAM_K8		0x00000000
> +#define CPUID_XFAM_10H		0x00100000
> +#define CPUID_XFAM_11H		0x00200000
> +#define CPUID_XMOD		0x000f0000
> +#define CPUID_XMOD_REV_F	0x00040000
> +
> +/* AMD systems with C1E don't have a working lAPIC timer. Check for that. */
> +static __cpuinit int amd_apic_timer_broken(void)
> +{
> +	u32 lo, hi, eax = cpuid_eax(CPUID_PROCESSOR_SIGNATURE);
> +
> +	switch (eax & CPUID_XFAM) {
> +	case CPUID_XFAM_K8:
> +		if ((eax & CPUID_XMOD) < CPUID_XMOD_REV_F)
> +			break;
> +	case CPUID_XFAM_10H:
> +	case CPUID_XFAM_11H:
> +		rdmsr(MSR_K8_ENABLE_C1E, lo, hi);
> +		if (lo & ENABLE_C1E_MASK)
> +			return 1;
> +		break;
> +	default:
> +		/* err on the side of caution */
> +		return 1;
> +	}
> +	return 0;
> +}

This needs to be done in 32-bit kernel, too, right?

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
