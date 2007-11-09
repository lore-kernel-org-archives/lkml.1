Return-Path: <linux-kernel-owner+w=401wt.eu-S1762963AbXKIVe5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762963AbXKIVe5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2007 16:34:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757823AbXKIV3j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Nov 2007 16:29:39 -0500
Received: from mx1.redhat.com ([66.187.233.31]:52358 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758946AbXKIV3i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2007 16:29:38 -0500
From: Glauber de Oliveira Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, glommer@gmail.com, tglx@linutronix.de,
       mingo@elte.hu, rusty@rustcorp.com.au, ak@suse.de, chrisw@sous-sol.org,
       avi@qumranet.com, anthony@codemonkey.ws,
       virtualization@lists.linux-foundation.org, lguest@ozlabs.org,
       kvm-devel@lists.sourceforge.net, zach@vmware.com,
       jun.nakajima@intel.com, Glauber de Oliveira Costa <gcosta@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 18/24] export cpu_gdt_descr
Date: Fri,  9 Nov 2007 16:42:59 -0200
Message-Id: <11946338832681-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.4.4.2
In-Reply-To: <1194633878886-git-send-email-gcosta@redhat.com>
References: <11946337851964-git-send-email-gcosta@redhat.com> <11946337933104-git-send-email-gcosta@redhat.com> <11946337991750-git-send-email-gcosta@redhat.com> <11946338053158-git-send-email-gcosta@redhat.com> <11946338103068-git-send-email-gcosta@redhat.com> <1194633815833-git-send-email-gcosta@redhat.com> <11946338212915-git-send-email-gcosta@redhat.com> <11946338263902-git-send-email-gcosta@redhat.com> <1194633831882-git-send-email-gcosta@redhat.com> <11946338361369-git-send-email-gcosta@redhat.com> <11946338413283-git-send-email-gcosta@redhat.com> <11946338473652-git-send-email-gcosta@redhat.com> <1194633852469-git-send-email-gcosta@redhat.com> <1194633857930-git-send-email-gcosta@redhat.com> <11946338621966-git-send-email-gcosta@redhat.com> <11946338683305-git-send-email-gcosta@redhat.com> <1194633873306-git-send-email-gcosta@redhat.com> <1194633878886-git-send-email-gcosta@redhat.com>
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
index 105712e..f97aed4 100644
--- a/arch/x86/kernel/x8664_ksyms_64.c
+++ b/arch/x86/kernel/x8664_ksyms_64.c
@@ -8,6 +8,7 @@
 #include <asm/processor.h>
 #include <asm/uaccess.h>
 #include <asm/pgtable.h>
+#include <asm/desc.h>
 
 EXPORT_SYMBOL(kernel_thread);
 
@@ -51,3 +52,8 @@ EXPORT_SYMBOL(__memcpy);
 EXPORT_SYMBOL(load_gs_index);
 
 EXPORT_SYMBOL(_proxy_pda);
+
+#ifdef CONFIG_PARAVIRT
+/* Virtualized guests may want to use it */
+EXPORT_SYMBOL_GPL(cpu_gdt_descr);
+#endif
-- 
1.4.4.2

