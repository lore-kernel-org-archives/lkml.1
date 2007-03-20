Return-Path: <linux-kernel-owner+w=401wt.eu-S1753895AbXCTUvM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753895AbXCTUvM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2007 16:51:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753891AbXCTUvM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Mar 2007 16:51:12 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:61801 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753897AbXCTUvK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2007 16:51:10 -0400
Date: Tue, 20 Mar 2007 13:50:03 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Kees Cook <kees@outflux.net>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.21-rc4-mm1
Message-Id: <20070320135003.a3007e75.randy.dunlap@oracle.com>
In-Reply-To: <20070320192016.GC22797@outflux.net>
References: <20070319205623.299d0378.akpm@linux-foundation.org>
	<20070320103151.f65c81b6.randy.dunlap@oracle.com>
	<20070320192016.GC22797@outflux.net>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Whitelist: TRUE
X-Whitelist: TRUE
X-Brightmail-Tracker: AAAAAQAAAAI=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 20 Mar 2007 12:20:16 -0700 Kees Cook wrote:

> On Tue, Mar 20, 2007 at 10:31:51AM -0700, Randy Dunlap wrote:
> >   LD      .tmp_vmlinux1
> > kernel/built-in.o:(.data+0xfc0): undefined reference to `maps_protect'
> > make: *** [.tmp_vmlinux1] Error 1
> > 
> > with CONFIG_PROC_FS=n
> 
> Gah!  Apologies.  This should fix it, but I can't test it since I can't 
> get 2.6.21-rc4-mm1 to compile (with or without this fix):
> 
>   GEN     .version
> init/.missing_syscalls.h.cmd:2: *** missing separator.  Stop.
> make: *** [.tmp_vmlinux1] Error 2
> 
> 
> Signed-off-by: Kees Cook <kees@outflux.net>

Yes, that works_for_me.

Acked-by: Randy Dunlap <randy.dunlap@oracle.com>

> ---
> diff -uNrp linux-2.6.21-rc4-mm1/kernel/sysctl.c linux-2.6.21-rc4-mm1-kees/kernel/sysctl.c
> --- linux-2.6.21-rc4-mm1/kernel/sysctl.c	2007-03-20 10:45:06.000000000 -0700
> +++ linux-2.6.21-rc4-mm1-kees/kernel/sysctl.c	2007-03-20 11:36:06.000000000 -0700
> @@ -77,9 +77,12 @@ extern int pid_max_min, pid_max_max;
>  extern int sysctl_drop_caches;
>  extern int percpu_pagelist_fraction;
>  extern int compat_log;
> -extern int maps_protect;
>  extern int print_fatal_signals;
>  
> +#ifdef CONFIG_PROC_FS
> +extern int maps_protect;
> +#endif
> +
>  #if defined(CONFIG_ADAPTIVE_READAHEAD)
>  extern int readahead_ratio;
>  extern int readahead_hit_rate;
> @@ -619,6 +622,7 @@ static ctl_table kern_table[] = {
>  		.proc_handler	= &proc_dointvec,
>  	},
>  #endif
> +#ifdef CONFIG_PROC_FS
>  	{
>  		.ctl_name       = CTL_UNNUMBERED,
>  		.procname       = "maps_protect",
> @@ -627,6 +631,7 @@ static ctl_table kern_table[] = {
>  		.mode           = 0644,
>  		.proc_handler   = &proc_dointvec,
>  	},
> +#endif
>  
>  	{ .ctl_name = 0 }
>  };


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
