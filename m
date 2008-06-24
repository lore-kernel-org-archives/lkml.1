Return-Path: <linux-kernel-owner+w=401wt.eu-S1757390AbYFZIUu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757390AbYFZIUu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 04:20:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757250AbYFZIT2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 04:19:28 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:2612 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756833AbYFZITV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 04:19:21 -0400
Date: Tue, 24 Jun 2008 19:57:53 +0200
From: Pavel Machek <pavel@suse.cz>
To: Alok Kataria <akataria@vmware.com>
Cc: Ingo Molnar <mingo@elte.hu>, Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>, Daniel Hecht <dhecht@vmware.com>,
       Tim Mann <mann@vmware.com>, Zach Amsden <zach@vmware.com>,
       Sahil Rihan <srihan@vmware.com>
Subject: Re: [RFC PATCH] x86:Use cpu_khz for loops_per_jiffy calculation
Message-ID: <20080624175753.GG5642@ucw.cz>
References: <1212540069.19290.57.camel@promb-2n-dhcp368.eng.vmware.com> <20080603182014.79a38d03@infradead.org> <35f686220806032101h103152dat841818982aaa5052@mail.gmail.com> <20080604061637.6bab3f67@infradead.org> <1213924953.27983.52.camel@promb-2n-dhcp368.eng.vmware.com> <20080620113922.GG7439@elte.hu> <1213999593.31598.52.camel@promb-2n-dhcp368.eng.vmware.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1213999593.31598.52.camel@promb-2n-dhcp368.eng.vmware.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> On X86 platform we can use the value of tsc_khz computed during tsc calibration
> to calculate the loops_per_jiffy value. Its very important to keep the error in
> lpj values to minimum as any error in that may result in kernel panic in
> check_timer. 
> In virtualization environment, On a highly overloaded host the guest delay
> calibration may sometimes result in errors beyond the ~50% that timer_irq_works
> can handle, resulting in the guest panicking.

How did you adress 'khz has nothing to do with loops per jiffie'
comment?

Some cpus can do loop in cycle , some need two cycles, some need half.

								Pavel

> @@ -421,6 +422,10 @@
>  		return;
>  	}
>  
> +	lpj = ((u64)tsc_khz * 1000);
> +	do_div(lpj, HZ);
> +	lpj_tsc = lpj;
> +
>  	printk("Detected %lu.%03lu MHz processor.\n",
>  				(unsigned long)cpu_khz / 1000,
>  				(unsigned long)cpu_khz % 1000);
> 


-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
