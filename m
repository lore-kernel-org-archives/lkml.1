Return-Path: <linux-kernel-owner+w=401wt.eu-S1758051AbYASVnU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758051AbYASVnU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jan 2008 16:43:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751416AbYASVnM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Jan 2008 16:43:12 -0500
Received: from pasmtpb.tele.dk ([80.160.77.98]:33480 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751379AbYASVnL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jan 2008 16:43:11 -0500
Date: Sat, 19 Jan 2008 22:43:19 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: lkml <linux-kernel@vger.kernel.org>, tglx <tglx@linutronix.de>,
       akpm <akpm@linux-foundation.org>
Subject: Re: [PATCH] timer: fix section mismatch
Message-ID: <20080119214319.GG29070@uranus.ravnborg.org>
References: <20080119115715.7efac363.randy.dunlap@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080119115715.7efac363.randy.dunlap@oracle.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 19, 2008 at 11:57:15AM -0800, Randy Dunlap wrote:
> From: Randy Dunlap <randy.dunlap@oracle.com>
> 
> The caller is __cpuinit.
> Also, this code block and its caller are inside #ifdef CONFIG_HOTPLUG_CPU
> blocks, so this code should reflect that config symbol's usage.
> 
> WARNING: vmlinux.o(.text+0x4252f): Section mismatch: reference to .init.text: (between 'timer_cpu_notify' and 'msleep')
> 
> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Acked-by: Sam Ravnborg <sam@ravnborg.org>

Andrew - another 2.6.24 candidate.

With
CONFIG_HOTPLUG=n
CONFIG_HOTPLUG_CPU=y

if the CPU_DEAD, CPU_DEAD_FROZEN happens then we will
call migrate_timers which is _devinit and we just triggered
a nice oops.

	Sam
> ---
>  kernel/timer.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> --- linux-2.6.24-rc8-git2.orig/kernel/timer.c
> +++ linux-2.6.24-rc8-git2/kernel/timer.c
> @@ -1289,7 +1289,7 @@ static void migrate_timer_list(tvec_base
>  	}
>  }
>  
> -static void __devinit migrate_timers(int cpu)
> +static void __cpuinit migrate_timers(int cpu)
>  {
>  	tvec_base_t *old_base;
>  	tvec_base_t *new_base;
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
