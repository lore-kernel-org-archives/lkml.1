Return-Path: <linux-kernel-owner+w=401wt.eu-S1756149AbXLSUxt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756149AbXLSUxt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2007 15:53:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752922AbXLSUxl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Dec 2007 15:53:41 -0500
Received: from rgminet01.oracle.com ([148.87.113.118]:57689 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752765AbXLSUxk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2007 15:53:40 -0500
Date: Wed, 19 Dec 2007 12:51:45 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Remy Bohmer <linux@bohmer.net>
Cc: Steven Rostedt <rostedt@goodmis.org>,
       Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
       Ingo Molnar <mingo@elte.hu>, Juergen Beisert <jbe@pengutronix.de>,
       Darren Hart <dvhltc@us.ibm.com>, linux-rt-users@vger.kernel.org,
       Sven-Thorsten Dietrich <sdietrich@novell.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [patch 2/3] Enable setting of IRQ-thread priorities from kernel
 cmdline (repost:CC to LKML)
Message-Id: <20071219125145.f4061fcb.randy.dunlap@oracle.com>
In-Reply-To: <47697882.2275420a.3951.ffff92ed@mx.google.com>
References: <20071219194551.315868746@bohmer.net>
	<47697882.2275420a.3951.ffff92ed@mx.google.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 19 Dec 2007 20:45:53 +0100 Remy Bohmer wrote:

>  Documentation/kernel-parameters.txt |    7 ++
>  include/linux/irq.h                 |    1 
>  kernel/irq/manage.c                 |  101 ++++++++++++++++++++++++++++++++----
>  3 files changed, 98 insertions(+), 11 deletions(-)
> 
> Index: linux-2.6.24-rc5-rt1/Documentation/kernel-parameters.txt
> ===================================================================
> --- linux-2.6.24-rc5-rt1.orig/Documentation/kernel-parameters.txt	2007-12-18 22:09:13.000000000 +0100
> +++ linux-2.6.24-rc5-rt1/Documentation/kernel-parameters.txt	2007-12-18 22:09:16.000000000 +0100
> @@ -799,6 +799,13 @@ and is between 256 and 4096 characters. 
>  	ips=		[HW,SCSI] Adaptec / IBM ServeRAID controller
>  			See header of drivers/scsi/ips.c.
>  
> +	irq_pmap=	[IRQ-threading] List of priorities each interrupt
> +			thread must have.
> +			Format: irq_pmap=megasas:90,eth0:40,50
> +			The first field without ':', is the default prio.

	Drop comma.

> +			If this cmdline argument is ommitted, every thread

                                                    omitted,

> +			runs at prio 50.
> +
>  	ports=		[IP_VS_FTP] IPVS ftp helper module
>  			Default is 21.
>  			Up to 8 (IP_VS_APP_MAX_PORTS) ports

> Index: linux-2.6.24-rc5-rt1/kernel/irq/manage.c
> ===================================================================
> --- linux-2.6.24-rc5-rt1.orig/kernel/irq/manage.c	2007-12-18 22:09:13.000000000 +0100
> +++ linux-2.6.24-rc5-rt1/kernel/irq/manage.c	2007-12-18 22:15:43.000000000 +0100

> @@ -901,3 +918,65 @@ void __init early_init_hardirqs(void)
>  	for (i = 0; i < NR_IRQS; i++)
>  		init_waitqueue_head(&irq_desc[i].wait_for_handler);
>  }
> +
> +#ifdef CONFIG_PREEMPT_HARDIRQS
> +
> +/*
> + * Lookup the interrupt thread priority
> + * A map for the priorities can be given on the kernel commandline.
> + * if name is NULL, or no kernel commandline options is given, the default

      If ...................................... option is given,

> + * prio is used, which is either MAX_PRIO/2, or the default given on the
> + * kernel commandline.
> + */
> +static int get_irq_prio(const char *name)
> +{


---
~Randy
