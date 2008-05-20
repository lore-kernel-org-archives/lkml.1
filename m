Return-Path: <linux-kernel-owner+w=401wt.eu-S1765041AbYETMzR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765041AbYETMzR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 08:55:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754421AbYETMzE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 08:55:04 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:41231 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753913AbYETMzC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 08:55:02 -0400
Date: Tue, 20 May 2008 14:54:44 +0200
From: Pavel Machek <pavel@ucw.cz>
To: yhlu.kernel@gmail.com
Cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: process fam 10h like k8 with fixed mtrr setting
Message-ID: <20080520125443.GA4052@ucw.cz>
References: <200805051557.38556.yhlu.kernel@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200805051557.38556.yhlu.kernel@gmail.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 2008-05-05 15:57:38, Yinghai Lu wrote:
> 
> otherwise fixed MTRR for family 10h may not be changed
> 
> Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>
> 
> Index: linux-2.6/arch/x86/kernel/cpu/mtrr/generic.c
> ===================================================================
> --- linux-2.6.orig/arch/x86/kernel/cpu/mtrr/generic.c
> +++ linux-2.6/arch/x86/kernel/cpu/mtrr/generic.c
> @@ -342,7 +342,7 @@ static void set_fixed_range(int msr, boo
>  
>  	if (lo != msrwords[0] || hi != msrwords[1]) {
>  		if (boot_cpu_data.x86_vendor == X86_VENDOR_AMD &&
> -		    boot_cpu_data.x86 == 15 &&
> +		    (boot_cpu_data.x86 >= 0x0f && boot_cpu_data.x86 <= 0x11) &&
>  		    ((msrwords[0] | msrwords[1]) & K8_MTRR_RDMEM_WRMEM_MASK))
>  			k8_enable_fixed_iorrs();
>  		mtrr_wrmsr(msr, msrwords[0], msrwords[1]);

This also changes family 0x11. Is that ok?

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
