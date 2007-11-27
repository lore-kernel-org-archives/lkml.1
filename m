Return-Path: <linux-kernel-owner+w=401wt.eu-S1757733AbXK0A6R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757733AbXK0A6R (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2007 19:58:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753954AbXK0A6H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Nov 2007 19:58:07 -0500
Received: from agminet01.oracle.com ([141.146.126.228]:48778 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753238AbXK0A6G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2007 19:58:06 -0500
Date: Mon, 26 Nov 2007 16:57:09 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: rusty@rustcorp.com.au, akpm <akpm@linux-foundation.org>
Subject: [PATCH] lguest: prevent VISWS or VOYAGER randconfigs
Message-Id: <20071126165709.721bec4f.randy.dunlap@oracle.com>
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
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Keep lguest from being enabled on VISWS or VOYAGER configs, just as is
already done for VMI and XEN.  Otherwise randconfigs with VISWS and
LGUEST have this problem:

In file included from arch/x86/kernel/setup_32.c:61:
include/asm-x86/mach-visws/setup_arch.h:8:1: warning: "ARCH_SETUP" redefined
In file included from include/asm/msr.h:80,
                 from include/asm/processor_32.h:17,
                 from include/asm/processor.h:2,
                 from include/asm/thread_info_32.h:16,
                 from include/asm/thread_info.h:2,
                 from include/linux/thread_info.h:21,
                 from include/linux/preempt.h:9,
                 from include/linux/spinlock.h:49,
                 from include/linux/seqlock.h:29,
                 from include/linux/time.h:8,
                 from include/linux/timex.h:57,
                 from include/linux/sched.h:53,
                 from arch/x86/kernel/setup_32.c:24:
include/asm/paravirt.h:458:1: warning: this is the location of the previous definition

(and of course, this happens because kconfig does not follow dependencies
when [evil] select is used...)

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 arch/x86/lguest/Kconfig |    1 +
 1 file changed, 1 insertion(+)

--- linux-2.6.24-rc3-git1.orig/arch/x86/lguest/Kconfig
+++ linux-2.6.24-rc3-git1/arch/x86/lguest/Kconfig
@@ -2,6 +2,7 @@ config LGUEST_GUEST
 	bool "Lguest guest support"
 	select PARAVIRT
 	depends on !X86_PAE
+	depends on !(X86_VISWS || X86_VOYAGER)
 	select VIRTIO
 	select VIRTIO_RING
 	select VIRTIO_CONSOLE
