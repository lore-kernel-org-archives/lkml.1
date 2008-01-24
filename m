Return-Path: <linux-kernel-owner+w=401wt.eu-S1758941AbYAXV26@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758941AbYAXV26 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2008 16:28:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756146AbYAXV2u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jan 2008 16:28:50 -0500
Received: from tomts36-srv.bellnexxia.net ([209.226.175.93]:54054 "EHLO
	tomts36-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757010AbYAXV2t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2008 16:28:49 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ah4FAPiRmEdMQWYq/2dsb2JhbACBV61k
Date: Thu, 24 Jan 2008 16:23:43 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Russell King <rmk+lkml@arm.linux.org.uk>
Cc: akpm@linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>, ananth@in.ibm.com,
       dhowells@redhat.com, jdike@addtoit.com, sam@ravnborg.org,
       Adrian Bunk <adrian.bunk@movial.fi>,
       Randy Dunlap <randy.dunlap@oracle.com>, phil.el@wanadoo.fr,
       oprofile-list@lists.sourceforge.net
Subject: Re: [patch 02/26] Fix ARM to play nicely with generic
	Instrumentation menu
Message-ID: <20080124212343.GB2181@Krystal>
References: <20080124202706.250598537@polymtl.ca> <20080124203333.128025422@polymtl.ca> <20080124211259.GA10388@flint.arm.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20080124211259.GA10388@flint.arm.linux.org.uk>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 16:22:50 up 82 days,  2:28,  6 users,  load average: 0.04, 0.32,
	0.62
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Russell King (rmk+lkml@arm.linux.org.uk) wrote:
> On Thu, Jan 24, 2008 at 03:27:08PM -0500, Mathieu Desnoyers wrote:
> > The conflicting commit for 
> > move-kconfiginstrumentation-to-arch-kconfig-and-init-kconfig.patch
> > is the ARM fix from Linus :
> > 
> > commit 38ad9aebe70dc72df08851bbd1620d89329129ba
> 
> Since we have changes which depend on the location of these options,
> please hold off until the ARM tree merges in the next window:
> 

Can you add me to the CC list of this patch please ?

> ----------------------- arch/arm/Kconfig.instrumentation -----------------------
> index 63b8c6d..453ad8e 100644
> @@ -43,6 +43,16 @@ config OPROFILE_MPCORE
>  config OPROFILE_ARM11_CORE
>  	bool
>  
> +config KPROBES
> +	bool "Kprobes"
> +	depends on KALLSYMS && MODULES && !UML && !XIP_KERNEL
> +	help
> +	  Kprobes allows you to trap at almost any kernel address and
> +	  execute a callback function.  register_kprobe() establishes
> +	  a probepoint and specifies the callback.  Kprobes is useful
> +	  for kernel debugging, non-intrusive instrumentation and testing.
> +	  If in doubt, say "N".
> +
>  config MARKERS
>  	bool "Activate markers"
>  	help
> 
> 
> -- 
> Russell King
>  Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
>  maintainer of:

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
