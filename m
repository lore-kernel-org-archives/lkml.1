Return-Path: <linux-kernel-owner+w=401wt.eu-S1761460AbYCYXKj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761460AbYCYXKj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2008 19:10:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756602AbYCYXK0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Mar 2008 19:10:26 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:35510 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757383AbYCYXKY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2008 19:10:24 -0400
Date: Tue, 25 Mar 2008 16:08:46 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: linux-next@vger.kernel.org, kvm-devel@lists.sourceforge.net,
       avi@qumranet.com, tglx <tglx@linutronix.de>, mingo <mingo@redhat.com>,
       hpa <hpa@zytor.com>
Subject: [PATCH v2] x86: don't allow KVM_CLOCK on Voyager or Visual WS
Message-Id: <20080325160846.d02b0209.randy.dunlap@oracle.com>
In-Reply-To: <20080314104444.ca80e434.randy.dunlap@oracle.com>
References: <20080314104444.ca80e434.randy.dunlap@oracle.com>
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

Prevent failed randconfig builds with KVM_CLOCK being enabled
on Voyager or VISWS.

build-rand9.out:  Using /local/linsrc/next-20080325 as source for kernel
build-rand9.out:                 from /local/linsrc/next-20080325/include/linux/irqflags.h:46,
build-rand9.out:                 from include2/asm/system.h:11,
build-rand9.out:                 from include2/asm/processor.h:21,
build-rand9.out:                 from include2/asm/atomic_32.h:5,
build-rand9.out:                 from include2/asm/atomic.h:2,
build-rand9.out:                 from /local/linsrc/next-20080325/include/linux/crypto.h:20,
build-rand9.out:                 from /local/linsrc/next-20080325/arch/x86/kernel/asm-offsets_32.c:7,
build-rand9.out:                 from /local/linsrc/next-20080325/arch/x86/kernel/asm-offsets.c:2:
build-rand9.out:include2/asm/paravirt.h:856: error: 'struct pv_apic_ops' has no member named 'startup_ipi_hook'
build-rand9.out:include2/asm/paravirt.h:856: error: 'struct pv_apic_ops' has no member named 'startup_ipi_hook'
build-rand9.out:include2/asm/paravirt.h:856: error: memory input 4 is not directly addressable
build-rand9.out:make[2]: *** [arch/x86/kernel/asm-offsets.s] Error 1

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 arch/x86/Kconfig |    1 +
 1 file changed, 1 insertion(+)

--- next-20080325.orig/arch/x86/Kconfig
+++ next-20080325/arch/x86/Kconfig
@@ -370,6 +370,7 @@ config VMI
 config KVM_CLOCK
 	bool "KVM paravirtualized clock"
 	select PARAVIRT
+	depends on !(X86_VISWS || X86_VOYAGER)
 	help
 	  Turning on this option will allow you to run a paravirtualized clock
 	  when running over the KVM hypervisor. Instead of relying on a PIT
