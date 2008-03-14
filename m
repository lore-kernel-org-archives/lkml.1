Return-Path: <linux-kernel-owner+w=401wt.eu-S1758195AbYCNRqk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758195AbYCNRqk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2008 13:46:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754729AbYCNRqc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Mar 2008 13:46:32 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:10113 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754673AbYCNRqb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2008 13:46:31 -0400
Date: Fri, 14 Mar 2008 10:44:44 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>, linux-next@vger.kernel.org
Cc: kvm-devel@lists.sourceforge.net, avi@qumranet.com,
       tglx <tglx@linutronix.de>, mingo <mingo@redhat.com>,
       hpa <hpa@zytor.com>
Subject: [PATCH] x86: don't allow KVM_CLOCK without HAVE_KVM
Message-Id: <20080314104444.ca80e434.randy.dunlap@oracle.com>
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

From: Randy Dunlap <randy.dunlap@oracle.com>

Make KVM_CLOCK depend on HAVE_KVM.  Otherwise a Voyager build can
fail with:

  CC      arch/x86/kernel/asm-offsets.s
In file included from include2/asm/irqflags.h:59,
                 from /local/linsrc/next-20080314/include/linux/irqflags.h:46,
                 from include2/asm/system.h:11,
                 from include2/asm/processor.h:21,
                 from include2/asm/atomic_32.h:5,
                 from include2/asm/atomic.h:2,
                 from /local/linsrc/next-20080314/include/linux/crypto.h:20,
                 from /local/linsrc/next-20080314/arch/x86/kernel/asm-offsets_32.c:7,
                 from /local/linsrc/next-20080314/arch/x86/kernel/asm-offsets.c:2:
include2/asm/paravirt.h: In function 'startup_ipi_hook':
include2/asm/paravirt.h:856: error: 'struct pv_apic_ops' has no member named 'startup_ipi_hook'
include2/asm/paravirt.h:856: error: 'struct pv_apic_ops' has no member named 'startup_ipi_hook'
include2/asm/paravirt.h:856: error: memory input 4 is not directly addressable
make[2]: *** [arch/x86/kernel/asm-offsets.s] Error 1
make[1]: *** [prepare0] Error 2
make: *** [sub-make] Error 2

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 arch/x86/Kconfig |    1 +
 1 file changed, 1 insertion(+)

--- next-20080314.orig/arch/x86/Kconfig
+++ next-20080314/arch/x86/Kconfig
@@ -370,6 +370,7 @@ config VMI
 config KVM_CLOCK
 	bool "KVM paravirtualized clock"
 	select PARAVIRT
+	depends on HAVE_KVM
 	help
 	  Turning on this option will allow you to run a paravirtualized clock
 	  when running over the KVM hypervisor. Instead of relying on a PIT
