Return-Path: <linux-kernel-owner+w=401wt.eu-S1757848AbXI1OvA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757848AbXI1OvA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2007 10:51:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752227AbXI1Ouw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Sep 2007 10:50:52 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:47000 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752188AbXI1Ouw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2007 10:50:52 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Mark Lord <lkml@rtr.ca>
Subject: Re: [PATCH] disable non-boot CPUs before poweroff
Date: Fri, 28 Sep 2007 17:05:17 +0200
User-Agent: KMail/1.9.5
Cc: Len Brown <lenb@kernel.org>, Linux Kernel <linux-kernel@vger.kernel.org>,
       simon.derr@bull.net
References: <46FC20B7.4000606@rtr.ca> <46FD05B8.2040302@rtr.ca> <46FD0724.5060009@rtr.ca>
In-Reply-To: <46FD0724.5060009@rtr.ca>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709281705.18304.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, 28 September 2007 15:52, Mark Lord wrote:
> 
> We need to disable all CPUs other than the boot CPU (usually 0)
> before attempting to power-off modern SMP machines.
> This seems to fix the hang-on-poweroff issue
> that one of my SMP boxes exhibits.  More testing required.
> 
> Signed-off-by: Mark Lord <mlord@pobox.com>
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

Before sysdev_shutdown(), please.

sysdev_shutdown() may touch things that belong to CPU0.

>  	printk(KERN_EMERG "Power down.\n");
>  	machine_power_off();
>  }

Greetings,
Rafael
