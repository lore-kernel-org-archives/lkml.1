Return-Path: <linux-kernel-owner+w=401wt.eu-S1755871AbYGWUhI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755871AbYGWUhI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2008 16:37:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755098AbYGWUg4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jul 2008 16:36:56 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44157 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754402AbYGWUgz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2008 16:36:55 -0400
Date: Wed, 23 Jul 2008 13:36:01 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Yinghai Lu" <yhlu.kernel@gmail.com>
Cc: mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com, andi@firstfloor.org,
       arjan@infradead.org, ebiederm@xmission.com, greg@kroah.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: usb debug port early console
Message-Id: <20080723133601.5a7bc494.akpm@linux-foundation.org>
In-Reply-To: <86802c440807231318h76ec9465td0c179668cfe4473@mail.gmail.com>
References: <200807231252.20371.yhlu.kernel@gmail.com>
	<20080723131218.f03ed672.akpm@linux-foundation.org>
	<86802c440807231318h76ec9465td0c179668cfe4473@mail.gmail.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 23 Jul 2008 13:18:12 -0700
"Yinghai Lu" <yhlu.kernel@gmail.com> wrote:

> > Please always pass all patches through scripts/checkpatch.pl.

What I meant was to use checkpatch and then to actually read its
output ;)

> yhlu@linux-zpir:~/xx/xx/kernel/tip/linux-2.6> ./scripts/checkpatch.pl
> patches/9xxx.patch
> WARNING: line over 80 characters
> #319: FILE: arch/x86/kernel/early_printk.c:420:
> +       if (!(read_pci_config_16(num, slot, func, PCI_STATUS) &
> PCI_STATUS_CAP_LIST))
> 
> WARNING: line over 80 characters
> #330: FILE: arch/x86/kernel/early_printk.c:431:
> +               pos = read_pci_config_byte(num, slot, func,
> pos+PCI_CAP_LIST_NEXT);
> 
> WARNING: line over 80 characters
> #335: FILE: arch/x86/kernel/early_printk.c:436:
> +static __u32 __init find_dbgp(int ehci_num, unsigned *rbus, unsigned
> *rslot, unsigned *rfunc)
> 
> WARNING: line over 80 characters
> #344: FILE: arch/x86/kernel/early_printk.c:445:
> +                               class = read_pci_config(bus, slot,
> func, PCI_CLASS_REVISION);
> 
> WARNING: line over 80 characters
> #347: FILE: arch/x86/kernel/early_printk.c:448:
> +                               cap = find_cap(bus, slot, func,
> PCI_CAP_ID_EHCI_DEBUG);
> 
> WARNING: line over 80 characters
> #386: FILE: arch/x86/kernel/early_printk.c:487:
> +                               portsc =
> readl(&ehci_regs->port_status[port - 1]);

I don't think the 80-col warnigns should necessarily all be fixed.  But
one should take a look at the code and ask "did I really need to do it
that way?".

> WARNING: externs should be avoided in .c files
> #425: FILE: arch/x86/kernel/early_printk.c:526:
> +void early_printk(const char *fmt, ...);

This one is a must-fix.

> WARNING: consider using strict_strtoul in preference to simple_strtoul
> #518: FILE: arch/x86/kernel/early_printk.c:619:
> +               dbgp_num = simple_strtoul(s, &e, 10);

simple_strtoul() is sometimes OK for kernel parameters, sometimes
strict_strtoul() is better.

> WARNING: externs should be avoided in .c files
> #722: FILE: arch/x86/kernel/head64.c:75:
> +extern void __init enable_debug_console(char *buf);

This one also should be fixed.

