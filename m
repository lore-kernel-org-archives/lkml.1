Return-Path: <linux-kernel-owner+w=401wt.eu-S1757602AbYEWNVS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757602AbYEWNVS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2008 09:21:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756884AbYEWNUp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 May 2008 09:20:45 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:4565 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756553AbYEWNUo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2008 09:20:44 -0400
Date: Fri, 23 May 2008 15:15:07 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Dave Jones <davej@redhat.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, hpa@zytor.com
Subject: Re: [X86] Move the 64-bit Intel specific parts out of setup_64.c
Message-ID: <20080523131506.GG9245@ucw.cz>
References: <200805221944.m4MJiA9g029838@gelk.kernelslacker.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200805221944.m4MJiA9g029838@gelk.kernelslacker.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> Create a separate intel_64.c file in the cpu/ dir for
> the useful parts to live in.
> 
> Signed-off-by: Dave Jones <davej@redhat.com>

> +/*
> + * find out the number of processor cores on the die
> + */
> +static int __cpuinit intel_num_cpu_cores(struct cpuinfo_x86 *c)
> +{
> +	unsigned int eax, t;
> +
> +	if (c->cpuid_level < 4)
> +		return 1;
> +
> +	cpuid_count(4, 0, &eax, &t, &t, &t);
> +
> +	if (eax & 0x1f)
> +		return ((eax >> 26) + 1);
> +	else
> +		return 1;
> +}

I don't get it. Original Core duo is not 64 bit capable... so this
should go into common code?
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
