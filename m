Return-Path: <linux-kernel-owner+w=401wt.eu-S932185AbXCELkr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932185AbXCELkr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2007 06:40:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933168AbXCELkq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Mar 2007 06:40:46 -0500
Received: from www.osadl.org ([213.239.205.134]:36695 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932185AbXCELkq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2007 06:40:46 -0500
Subject: Re: [patch] paravirt: allow NO_HZ, remove NO_IDLE_HZ dependency
From: Thomas Gleixner <tglx@linutronix.de>
Reply-To: tglx@linutronix.de
To: Ingo Molnar <mingo@elte.hu>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Andi Kleen <ak@suse.de>
In-Reply-To: <20070305112928.GA27042@elte.hu>
References: <20070305112928.GA27042@elte.hu>
Content-Type: text/plain
Date: Mon, 05 Mar 2007 12:46:45 +0100
Message-Id: <1173095205.24738.203.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-03-05 at 12:29 +0100, Ingo Molnar wrote:
> Subject: [patch] paravirt: remove NO_IDLE_HZ dependency
> From: Ingo Molnar <mingo@elte.hu>
> 
> PARAVIRT forces CONFIG_NO_HZ off - this is bad and prevents sane 
> paravirtual guests like KVM from being able to use dynticks-enabled 
> Linux guests. Remove this. Vmi-timer needs to be updated properly to 
> make use of dynticks.
> 
> furthermore, remove the mistaken turning on of NO_IDLE_HZ on 
> x86+PARAVIRT kernels, it's an obsolete, limited form of dynticks.
> 
> must-have for v2.6.21.
> 
> Signed-off-by: Ingo Molnar <mingo@elte.hu>

Acked-by: Thomas Gleixner <tglx@linutronix.de>

> ---
>  arch/i386/Kconfig |   11 +----------
>  1 file changed, 1 insertion(+), 10 deletions(-)
> 
> Index: linux/arch/i386/Kconfig
> ===================================================================
> --- linux.orig/arch/i386/Kconfig
> +++ linux/arch/i386/Kconfig
> @@ -224,7 +224,7 @@ config PARAVIRT
>  
>  config VMI
>  	bool "VMI Paravirt-ops support"
> -	depends on PARAVIRT && !NO_HZ
> +	depends on PARAVIRT
>  	default y
>  	help
>  	  VMI provides a paravirtualized interface to multiple hypervisors
> @@ -1291,12 +1291,3 @@ config X86_TRAMPOLINE
>  config KTIME_SCALAR
>  	bool
>  	default y
> -
> -config NO_IDLE_HZ
> -	bool
> -	depends on PARAVIRT
> -	default y
> -	help
> -	  Switches the regular HZ timer off when the system is going idle.
> -	  This helps a hypervisor detect that the Linux system is idle,
> -	  reducing the overhead of idle systems.

