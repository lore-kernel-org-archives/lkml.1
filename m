Return-Path: <linux-kernel-owner+w=401wt.eu-S1761657AbXI1Ozw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761657AbXI1Ozw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2007 10:55:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754649AbXI1OzV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Sep 2007 10:55:21 -0400
Received: from www.osadl.org ([213.239.205.134]:33178 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1760130AbXI1OzT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2007 10:55:19 -0400
Subject: Re: [PATCH] disable non-boot CPUs before poweroff
From: Thomas Gleixner <tglx@linutronix.de>
To: Mark Lord <lkml@rtr.ca>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Len Brown <lenb@kernel.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>, simon.derr@bull.net,
       Andrew Morton <akpm@osdl.org>
In-Reply-To: <46FD0724.5060009@rtr.ca>
References: <46FC20B7.4000606@rtr.ca> <200709281455.29069.rjw@sisk.pl>
	 <46FD001A.3070309@rtr.ca> <200709281544.30497.rjw@sisk.pl>
	 <46FD05B8.2040302@rtr.ca>  <46FD0724.5060009@rtr.ca>
Content-Type: text/plain
Date: Fri, 28 Sep 2007 16:55:16 +0200
Message-Id: <1190991316.18681.38.camel@chaos>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 (2.12.0-3.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 2007-09-28 at 09:52 -0400, Mark Lord wrote:
> We need to disable all CPUs other than the boot CPU (usually 0)
> before attempting to power-off modern SMP machines.
> This seems to fix the hang-on-poweroff issue
> that one of my SMP boxes exhibits.  More testing required.
> 
> Signed-off-by: Mark Lord <mlord@pobox.com>

Fixes my new toybox as well. Thanks for tracking it down before I had to
dig in.

Acked-by: Thomas Gleixner <tglx@linutronix.de>

> ---
> 
> --- linux/kernel/sys.c.orig	2007-09-13 09:49:11.000000000 -0400
> +++ linux/kernel/sys.c	2007-09-28 09:48:54.000000000 -0400
> @@ -32,6 +32,7 @@
>  #include <linux/getcpu.h>
>  #include <linux/task_io_accounting_ops.h>
>  #include <linux/seccomp.h>
> +#include <linux/cpu.h>
>  
>  #include <linux/compat.h>
>  #include <linux/syscalls.h>
> @@ -879,6 +880,7 @@
>  	if (pm_power_off_prepare)
>  		pm_power_off_prepare();
>  	sysdev_shutdown();
> +	disable_nonboot_cpus();
>  	printk(KERN_EMERG "Power down.\n");
>  	machine_power_off();
>  }
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

