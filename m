Return-Path: <linux-kernel-owner+w=401wt.eu-S1756509AbXJ2IsQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756509AbXJ2IsQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2007 04:48:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751691AbXJ2IsB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Oct 2007 04:48:01 -0400
Received: from www.tglx.de ([62.245.132.106]:60377 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751186AbXJ2IsA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2007 04:48:00 -0400
Date: Mon, 29 Oct 2007 09:47:49 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Michael Ellerman <michael@ellerman.id.au>
cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Quieten hrtimer printk: "Switched to high resolution
 mode .."
In-Reply-To: <ed0a9ee8c6bc2ac894924b24c22a221a07e66931.1193635831.git.michael@ellerman.id.au>
Message-ID: <alpine.LFD.0.9999.0710290946540.3186@localhost.localdomain>
References: <ed0a9ee8c6bc2ac894924b24c22a221a07e66931.1193635831.git.michael@ellerman.id.au>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 29 Oct 2007, Michael Ellerman wrote:

> Change the hrtimer printk "Switched to high resolution mode .." to
> be KERN_DEBUG, rather than KERN_INFO. If users need to see this they
> can pass "loglevel" or "debug" on the command line, or check dmesg.
> 
> Signed-off-by: Michael Ellerman <michael@ellerman.id.au>

Thanks, applied.

	tglx

> ---
> 
> Any objections? It gets a little repetitive, eg:
> 
> Switched to high resolution mode on CPU 0
> Switched to high resolution mode on CPU 17
> Switched to high resolution mode on CPU 10
> Switched to high resolution mode on CPU 2
> Switched to high resolution mode on CPU 7
> Switched to high resolution mode on CPU 11
> Switched to high resolution mode on CPU 3
> Switched to high resolution mode on CPU 8
> Switched to high resolution mode on CPU 12
> Switched to high resolution mode on CPU 1
> Switched to high resolution mode on CPU 4
> Switched to high resolution mode on CPU 5
> Switched to high resolution mode on CPU 13
> Switched to high resolution mode on CPU 14
> Switched to high resolution mode on CPU 15
> Switched to high resolution mode on CPU 9
> Switched to high resolution mode on CPU 6
> Switched to high resolution mode on CPU 16
> 
> cheers
> 
> 
>  kernel/hrtimer.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/kernel/hrtimer.c b/kernel/hrtimer.c
> index b6d2ff7..22a2514 100644
> --- a/kernel/hrtimer.c
> +++ b/kernel/hrtimer.c
> @@ -602,7 +602,7 @@ static int hrtimer_switch_to_hres(void)
>  	/* "Retrigger" the interrupt to get things going */
>  	retrigger_next_event(NULL);
>  	local_irq_restore(flags);
> -	printk(KERN_INFO "Switched to high resolution mode on CPU %d\n",
> +	printk(KERN_DEBUG "Switched to high resolution mode on CPU %d\n",
>  	       smp_processor_id());
>  	return 1;
>  }
> -- 
> 1.5.2.rc1.1884.g59b20
> 
