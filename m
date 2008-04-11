Return-Path: <linux-kernel-owner+w=401wt.eu-S1760746AbYDKPn0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760746AbYDKPn0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2008 11:43:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759521AbYDKPnT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Apr 2008 11:43:19 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:3046 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1759113AbYDKPnS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2008 11:43:18 -0400
Date: Fri, 11 Apr 2008 17:43:10 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Andi Kleen <ak@suse.de>,
       "H. Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, lguest <lguest@ozlabs.org>
Subject: Re: [PATCH] Fix booting pentium+ with dodgy TSC
Message-ID: <20080411154310.GA4492@ucw.cz>
References: <200804061723.38766.rusty@rustcorp.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200804061723.38766.rusty@rustcorp.com.au>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun 2008-04-06 17:23:38, Rusty Russell wrote:
> Linus please apply.  Almost by definition this patch can't make things worse.
> 
> We handle a broken tsc these days, so no need to panic.  We clear the TSC bit
> when tsc_init decides it's unreliable (eg. under lguest w/ bad host TSC),
> leading to bogus panic.
> 
> Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
> 
> diff -r 5e0a39f4d07b arch/x86/kernel/cpu/bugs.c
> --- a/arch/x86/kernel/cpu/bugs.c	Sun Apr 06 13:40:39 2008 +1000
> +++ b/arch/x86/kernel/cpu/bugs.c	Sun Apr 06 17:14:12 2008 +1000
> @@ -143,14 +143,6 @@ static void __init check_config(void)
>  #endif
>  
>  /*
> - * If we configured ourselves for a TSC, we'd better have one!
> - */
> -#ifdef CONFIG_X86_TSC
> -	if (!cpu_has_tsc)
> -		panic("Kernel compiled for Pentium+, requires TSC feature!");
> -#endif
> -

CONFIG_X86_TSC means 'cpu has _some_ tsc, rdmsr will work'. If you are
confident noone will read broken tsc, please also remove the config
option. It is meaningless after your patch.
							Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
