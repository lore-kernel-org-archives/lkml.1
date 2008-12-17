Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1758832AbYLQCgV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758832AbYLQCgV (ORCPT <rfc822;akpm@linux-foundation.org>);
	Tue, 16 Dec 2008 21:36:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752595AbYLQCgE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 21:36:04 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41107 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752502AbYLQCgB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 21:36:01 -0500
Date: Tue, 16 Dec 2008 18:35:47 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Russell King <rmk+lkml@arm.linux.org.uk>, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org
Subject: Re: [RFC] remove linux/hardirq.h from asm-generic/local.h
Message-Id: <20081216183547.de79b7f0.akpm@linux-foundation.org>
In-Reply-To: <20081216184704.GA4976@x200.localdomain>
References: <20081214133941.GA18035@flint.arm.linux.org.uk>
	<20081214095803.9d16e85f.akpm@linux-foundation.org>
	<20081216184704.GA4976@x200.localdomain>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 16 Dec 2008 21:47:04 +0300 Alexey Dobriyan <adobriyan@gmail.com> wrote:

> On Sun, Dec 14, 2008 at 09:58:03AM -0800, Andrew Morton wrote:
> > On Sun, 14 Dec 2008 13:39:41 +0000 Russell King <rmk+lkml@arm.linux.org.uk> wrote:
> 
> > > Note that x86 does not include asm/irq.h nor linux/hardirq.h in its
> > > asm/local.h, so this patch can be viewed as bringing the generic version
> > > into line with the x86 version.
> > 
> > Sure.  Includes are easy to add and hard to remove.  I'll queue it up
> > and see if there's fallout.
> 
> Here is some (but not everything):
> 
> arch/avr32/kernel/traps.c:63: error: implicit declaration of function 'in_interrupt'
> arch/avr32/kernel/traps.c:113: error: implicit declaration of function 'nmi_enter'
> arch/avr32/kernel/traps.c:124: error: implicit declaration of function 'nmi_disable'
> arch/avr32/kernel/traps.c:127: error: implicit declaration of function 'nmi_exit'
> arch/sh/kernel/traps_32.c:104: error: implicit declaration of function 'in_interrupt'
> arch/sparc64/kernel/sysfs.c:201: error: 'cpuinfo_sparc' undeclared (first use in this function)
> arch/sparc64/kernel/mdesc.c:576: error: expected ')' before '*' token
> 
> 
> diff --git a/arch/avr32/kernel/traps.c b/arch/avr32/kernel/traps.c
> index 0d98737..d547c8d 100644
> --- a/arch/avr32/kernel/traps.c
> +++ b/arch/avr32/kernel/traps.c
> @@ -7,6 +7,7 @@
>   */
>  
>  #include <linux/bug.h>
> +#include <linux/hardirq.h>
>  #include <linux/init.h>
>  #include <linux/kallsyms.h>
>  #include <linux/kdebug.h>
> diff --git a/arch/sh/kernel/traps_32.c b/arch/sh/kernel/traps_32.c
> index 1e5c74e..7a2dc95 100644
> --- a/arch/sh/kernel/traps_32.c
> +++ b/arch/sh/kernel/traps_32.c
> @@ -13,6 +13,7 @@
>   */
>  #include <linux/kernel.h>
>  #include <linux/ptrace.h>
> +#include <linux/hardirq.h>
>  #include <linux/init.h>
>  #include <linux/spinlock.h>
>  #include <linux/module.h>
> diff --git a/arch/sparc64/kernel/mdesc.c b/arch/sparc64/kernel/mdesc.c
> index dde52bc..3c539a6 100644
> --- a/arch/sparc64/kernel/mdesc.c
> +++ b/arch/sparc64/kernel/mdesc.c
> @@ -11,6 +11,7 @@
>  #include <linux/mm.h>
>  #include <linux/miscdevice.h>
>  
> +#include <asm/cpudata.h>
>  #include <asm/hypervisor.h>
>  #include <asm/mdesc.h>
>  #include <asm/prom.h>
> diff --git a/arch/sparc64/kernel/sysfs.c b/arch/sparc64/kernel/sysfs.c
> index 84e5ce1..d28f496 100644
> --- a/arch/sparc64/kernel/sysfs.c
> +++ b/arch/sparc64/kernel/sysfs.c
> @@ -8,6 +8,7 @@
>  #include <linux/percpu.h>
>  #include <linux/init.h>
>  
> +#include <asm/cpudata.h>
>  #include <asm/hypervisor.h>
>  #include <asm/spitfire.h>

hm, the two sparc64 files have just magically disappeared from linux-next.

Oh well, I'll do sparc and sparc64 crossbuilds soon.
