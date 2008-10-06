Return-Path: <linux-kernel-owner+w=401wt.eu-S1754549AbYJFQwO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754549AbYJFQwO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2008 12:52:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753177AbYJFQv7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Oct 2008 12:51:59 -0400
Received: from www.tglx.de ([62.245.132.106]:41618 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753164AbYJFQv7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2008 12:51:59 -0400
Date: Mon, 6 Oct 2008 18:51:50 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: "Randy.Dunlap" <rdunlap@xenotime.net>
cc: George Nychis <gnychis@cmu.edu>, linux-kernel@vger.kernel.org
Subject: Re: [patch] Re: how to link to hrtimers in the kernel
In-Reply-To: <Pine.LNX.4.64.0810060931140.4121@shark.he.net>
Message-ID: <alpine.LFD.2.00.0810061849090.3166@apollo>
References: <48EA31A4.6080903@cmu.edu> <Pine.LNX.4.64.0810060931140.4121@shark.he.net>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 6 Oct 2008, Randy.Dunlap wrote:
> On Mon, 6 Oct 2008, George Nychis wrote:
> 
> > Hi all,
> > 
> > I have modified drivers/usb/core/devio.c to use hrtimer_nanosleep(), and have
> > included linux/hrtimer.h with it.

Please do not use hrtimer_nanosleep() in drivers. That's
wrong.

What do you want to achieve ?
 
> Export hrtimer_nanosleep() for module use.

NAK, hrtimer_nanosleep is part of the user space interfaces.

> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
> ---
>  kernel/hrtimer.c |    1 +
>  1 file changed, 1 insertion(+)
> 
> --- linux-2.6.27-rc8-git5.orig/kernel/hrtimer.c
> +++ linux-2.6.27-rc8-git5/kernel/hrtimer.c
> @@ -1559,6 +1559,7 @@ out:
>  	destroy_hrtimer_on_stack(&t.timer);
>  	return ret;
>  }
> +EXPORT_SYMBOL_GPL(hrtimer_nanosleep);
>  
>  asmlinkage long
>  sys_nanosleep(struct timespec __user *rqtp, struct timespec __user *rmtp)
> 
