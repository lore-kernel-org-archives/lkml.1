Return-Path: <linux-kernel-owner+w=401wt.eu-S1762271AbXJaXBl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762271AbXJaXBl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2007 19:01:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761793AbXJaXBG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Oct 2007 19:01:06 -0400
Received: from mx1.redhat.com ([66.187.233.31]:32915 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756175AbXJaXBE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2007 19:01:04 -0400
From: Glauber de Oliveira Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, rusty@rustcorp.com.au, ak@suse.de,
       mingo@elte.hu, chrisw@sous-sol.org, jeremy@goop.org, avi@qumranet.com,
       anthony@codemonkey.ws, virtualization@lists.linux-foundation.org,
       lguest@ozlabs.org, kvm-devel@lists.sourceforge.net, zach@vmware.com,
       tglx@linutronix.de, jun.nakajima@intel.com, glommer@gmail.com,
       Glauber de Oliveira Costa <gcosta@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 10/16] export cpu_gdt_descr
Date: Wed, 31 Oct 2007 16:14:55 -0300
Message-Id: <11938581562552-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.4.4.2
In-Reply-To: <11938581512730-git-send-email-gcosta@redhat.com>
References: <1193858101367-git-send-email-gcosta@redhat.com> <11938581073775-git-send-email-gcosta@redhat.com> <11938581133479-git-send-email-gcosta@redhat.com> <1193858118284-git-send-email-gcosta@redhat.com> <11938581242810-git-send-email-gcosta@redhat.com> <1193858130443-git-send-email-gcosta@redhat.com> <11938581351064-git-send-email-gcosta@redhat.com> <11938581403478-git-send-email-gcosta@redhat.com> <11938581451804-git-send-email-gcosta@redhat.com> <11938581512730-git-send-email-gcosta@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

With paravirualization, hypervisors needs to handle the gdt,
that was right to this point only used at very early
inialization code. Hypervisors (lguest being the current case)
are commonly modules, so make it an export

Signed-off-by: Glauber de Oliveira Costa <gcosta@redhat.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Acked-by: Jeremy Fitzhardinge <jeremy@xensource.com>
---
 arch/x86/kernel/x8664_ksyms_64.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/x8664_ksyms_64.c b/arch/x86/kernel/x8664_ksyms_64.c
index 77c25b3..a005d67 100644
--- a/arch/x86/kernel/x8664_ksyms_64.c
+++ b/arch/x86/kernel/x8664_ksyms_64.c
@@ -8,6 +8,7 @@
 #include <asm/processor.h>
 #include <asm/uaccess.h>
 #include <asm/pgtable.h>
+#include <asm/desc.h>
 
 EXPORT_SYMBOL(kernel_thread);
 
@@ -60,3 +61,8 @@ EXPORT_SYMBOL(init_level4_pgt);
 EXPORT_SYMBOL(load_gs_index);
 
 EXPORT_SYMBOL(_proxy_pda);
+
+#ifdef CONFIG_PARAVIRT
+/* Virtualized guests may want to use it */
+EXPORT_SYMBOL_GPL(cpu_gdt_descr);
+#endif
-- 
1.4.4.2

