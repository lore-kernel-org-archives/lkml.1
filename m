Return-Path: <linux-kernel-owner+w=401wt.eu-S1755420AbYLHACv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755420AbYLHACv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Dec 2008 19:02:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752749AbYLHACn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Dec 2008 19:02:43 -0500
Received: from mail.fuw.edu.pl ([193.0.80.14]:57994 "EHLO mail.fuw.edu.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750919AbYLHACn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Dec 2008 19:02:43 -0500
X-Greylist: delayed 1405 seconds by postgrey-1.27 at vger.kernel.org; Sun, 07 Dec 2008 19:02:42 EST
From: "R. J. Wysocki" <Rafal.Wysocki@fuw.edu.pl>
Organization: FUW
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: Re: [PATCH] nohz: add missing handling of clocksource watchdog
Date: Mon, 8 Dec 2008 00:36:59 +0100
User-Agent: KMail/1.9.9
Cc: Thomas Gleixner <tglx@linutronix.de>,
       Sergei Shtylyov <sshtylyov@ru.mvista.com>,
       Lars Winterfeld <lars.winterfeld@tu-ilmenau.de>,
       linux-kernel@vger.kernel.org
References: <200812080015.22793.bzolnier@gmail.com>
In-Reply-To: <200812080015.22793.bzolnier@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812080036.59506.Rafal.Wysocki@fuw.edu.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, 8 of December 2008, Bartlomiej Zolnierkiewicz wrote:
> 
> Fixes "Clocksource tsc unstable (delta = -974982308 ns)" problem.

Where can I find the description of the problem?

Rafael

> [ IDE was unlucky to be initialized at the same time that
>   clocksource watchdog triggers and was blamed for the issue. ]
> 
> Cc: Sergei Shtylyov <sshtylyov@ru.mvista.com>
> Cc: Lars Winterfeld <lars.winterfeld@tu-ilmenau.de>
> Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> ---
>  kernel/time/tick-sched.c |    2 ++
>  1 file changed, 2 insertions(+)
> 
> Index: b/kernel/time/tick-sched.c
> ===================================================================
> --- a/kernel/time/tick-sched.c
> +++ b/kernel/time/tick-sched.c
> @@ -21,6 +21,7 @@
>  #include <linux/sched.h>
>  #include <linux/tick.h>
>  #include <linux/module.h>
> +#include <linux/clocksource.h>
>  
>  #include <asm/irq_regs.h>
>  
> @@ -153,6 +154,7 @@ void tick_nohz_update_jiffies(void)
>  	local_irq_restore(flags);
>  
>  	touch_softlockup_watchdog();
> +	clocksource_touch_watchdog();
>  }
>  
>  static void tick_nohz_stop_idle(int cpu)
> 



-- 
Rafael J. Wysocki, Ph.D.
Institute of Theoretical Physics
Faculty of Physics of Warsaw University
ul. Hoza 69, 00-681 Warsaw
[tel: +48 22 55 32 263]
[mob: +48 60 50 53 693]
----------------------------
One should not increase, beyond what is necessary,
the number of entities required to explain anything.
			-- William of Ockham
