Return-Path: <linux-kernel-owner+w=401wt.eu-S1754680AbXLSVE3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754680AbXLSVE3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2007 16:04:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752733AbXLSVEU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Dec 2007 16:04:20 -0500
Received: from agminet01.oracle.com ([141.146.126.228]:56898 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752723AbXLSVET (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2007 16:04:19 -0500
Date: Wed, 19 Dec 2007 12:55:43 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Remy Bohmer <linux@bohmer.net>
Cc: Steven Rostedt <rostedt@goodmis.org>,
       Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
       Ingo Molnar <mingo@elte.hu>, Juergen Beisert <jbe@pengutronix.de>,
       Darren Hart <dvhltc@us.ibm.com>, linux-rt-users@vger.kernel.org,
       Sven-Thorsten Dietrich <sdietrich@novell.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [patch 3/3] Enable setting of IRQ-thread priorities from kernel
 cmdline. (repost:CC to LKML)
Message-Id: <20071219125543.16a9fb70.randy.dunlap@oracle.com>
In-Reply-To: <47697888.143f420a.5466.ffff89ba@mx.google.com>
References: <20071219194551.315868746@bohmer.net>
	<47697888.143f420a.5466.ffff89ba@mx.google.com>
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

On Wed, 19 Dec 2007 20:45:54 +0100 Remy Bohmer wrote:

>  Documentation/kernel-parameters.txt |   11 +++
>  kernel/softirq.c                    |  105 ++++++++++++++++++++++++++++++------
>  2 files changed, 99 insertions(+), 17 deletions(-)
> 
> Index: linux-2.6.24-rc5-rt1/Documentation/kernel-parameters.txt
> ===================================================================
> --- linux-2.6.24-rc5-rt1.orig/Documentation/kernel-parameters.txt	2007-12-18 22:06:11.000000000 +0100
> +++ linux-2.6.24-rc5-rt1/Documentation/kernel-parameters.txt	2007-12-18 22:07:19.000000000 +0100
> @@ -806,6 +806,17 @@ and is between 256 and 4096 characters. 
>  			If this cmdline argument is ommitted, every thread
>  			runs at prio 50.
>  
> +	sirq_pmap=	[IRQ-threading] List of priorities each softirq
> +			thread must have.
> +			Format: sirq_pmap=block/0:90,sched/0:75,50
> +			The priorities have to be specified per-cpu.
> +			The first field without ':', is the default prio.

	Drop comma.

> +			The names have to match the softirq_names[] table in
> +			kernel/softirq.c, (thus without 'softirq-' prefix) to
> +			keep the cmd-line short.
> +			If this cmdline argument is ommitted, every softirq

                                                    omitted,

> +			runs at prio 50.
> +
>  	ports=		[IP_VS_FTP] IPVS ftp helper module
>  			Default is 21.
>  			Up to 8 (IP_VS_APP_MAX_PORTS) ports
> Index: linux-2.6.24-rc5-rt1/kernel/softirq.c
> ===================================================================
> --- linux-2.6.24-rc5-rt1.orig/kernel/softirq.c	2007-12-18 22:06:11.000000000 +0100
> +++ linux-2.6.24-rc5-rt1/kernel/softirq.c	2007-12-18 22:08:54.000000000 +0100
> @@ -1051,3 +1062,63 @@ int on_each_cpu(void (*func) (void *info
>  }
>  EXPORT_SYMBOL(on_each_cpu);
>  #endif
> +
> +/*
> + * Lookup the softirq thread priority.
> + * A map for the priorities can be given on the kernel commandline.
> + * if name is NULL, or no kernel commandline options is given, the default

      If ...................................... option is given,

> + * prio is returned, which is either MAX_PRIO/2, or the default given on the
> + * kernel commandline.
> + */
> +static int get_softirq_prio(const char *name)
> +{
...
> +}

---
~Randy
