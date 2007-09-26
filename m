Return-Path: <linux-kernel-owner+w=401wt.eu-S1754613AbXIZXWy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754613AbXIZXWy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2007 19:22:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751845AbXIZXWr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Sep 2007 19:22:47 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:16637 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750831AbXIZXWq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2007 19:22:46 -0400
Date: Wed, 26 Sep 2007 16:20:59 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Jonathan Campbell <jon@nerdgrounds.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Patches for tiny 386 kernels, again. Linux kernel
 2.6.22.7
Message-Id: <20070926162059.e6eb5e93.randy.dunlap@oracle.com>
In-Reply-To: <46FAA808.90004@nerdgrounds.com>
References: <46F77A85.6020202@nerdgrounds.com>
	<20070924104940.50a52cf3.randy.dunlap@oracle.com>
	<46FAA808.90004@nerdgrounds.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.6 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 26 Sep 2007 11:42:16 -0700 Jonathan Campbell wrote:

> Here is the DMI patch again, written against linux-2.6.23-rc8,
> with some of the #ifdef CONFIG_DMI's removed and moved
> to include/linux/dmi.h. Putting them there in the way I've done
> ensures that you don't have to put #ifdef CONFIG_DMI
> around each dmi_check_machine() and that you don't
> have to apply little patches to so many device drivers.

Damaged as the patch is, I was able to apply it by using
'patch -l' (ignore whitespace) + some fuzz.  Not something that
Linus or Andrew would or should do.

I built and booted the kernel, it's running fine (x86_32 notebook).



> diff -u -r linux-2.6.23-rc8-old/init/Kconfig linux-2.6.23-rc8/init/Kconfig
> --- linux-2.6.23-rc8-old/init/Kconfig    2007-09-21 22:38:23.000000000 +0000
> +++ linux-2.6.23-rc8/init/Kconfig    2007-09-26 00:03:05.000000000 +0000
> @@ -542,6 +542,18 @@
>        on EMBEDDED systems.  /proc/vmstat will only show page counts
>        if VM event counters are disabled.
>  
> +config DMI
> +    default y
> +    bool "Enable DMI support" if EMBEDDED
> +    depends on X86
> +    help
> +      This enables support for processing the Desktop Management
> +      Interface structures present in most modern BIOSes. If you are
> +      building a kernel for an older Pentium, 486, or 386 system and
> +      memory is tight, you can disable this to help reduce the size
> +      of your kernel by about 6K.
> +      If unsure, say Y.
> +

This is in the General setup menu.  How about putting it into the
EMBEDDED menu instead?  [Configure standard kernel features (for
small systems)]

>  config SLUB_DEBUG
>      default y
>      bool "Enable SLUB debugging support" if EMBEDDED


There are still several build warnings that need attention:

drivers/acpi/sleep/main.c:223: warning: 'acpisleep_dmi_table' defined but not used
drivers/pnp/pnpbios/core.c:509: warning: 'pnpbios_dmi_table' defined but not used
arch/i386/pci/irq.c:1035: warning: 'pciirq_dmi_table' defined but not used
arch/i386/pci/common.c:148: warning: 'pciprobe_dmi_table' defined but not used


+#endif // CONFIG_DMI

Use /* ... */ style comments instead of // comments.

---
~Randy
Phaedrus says that Quality is about caring.
