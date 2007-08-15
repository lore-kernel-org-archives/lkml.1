Return-Path: <linux-kernel-owner+w=401wt.eu-S1763077AbXHOM7H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763077AbXHOM7H (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2007 08:59:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760573AbXHOMzA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Aug 2007 08:55:00 -0400
Received: from mx1.redhat.com ([66.187.233.31]:56278 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761937AbXHOMy6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2007 08:54:58 -0400
From: Glauber de Oliveira Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, rusty@rustcorp.com.au, ak@suse.de,
       mingo@elte.hu, chrisw@sous-sol.org, jeremy@goop.org, avi@qumranet.com,
       anthony@codemonkey.ws, virtualization@lists.linux-foundation.org,
       lguest@ozlabs.org, glommer@gmail.com,
       Glauber de Oliveira Costa <gcosta@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 21/25][V3] export cpu_gdt_descr
Date: Wed, 15 Aug 2007 09:49:41 -0300
Message-Id: <11871824292046-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.5.0.6
In-Reply-To: <11871824192375-git-send-email-gcosta@redhat.com>
References: <11871821854176-git-send-email-gcosta@redhat.com> <1187182197314-git-send-email-gcosta@redhat.com> <11871822062386-git-send-email-gcosta@redhat.com> <11871822163867-git-send-email-gcosta@redhat.com> <11871822244170-git-send-email-gcosta@redhat.com> <11871822342754-git-send-email-gcosta@redhat.com> <11871822421713-git-send-email-gcosta@redhat.com> <1187182253740-git-send-email-gcosta@redhat.com> <1187182268408-git-send-email-gcosta@redhat.com> <1187182282913-git-send-email-gcosta@redhat.com> <11871822951747-git-send-email-gcosta@redhat.com> <11871823042011-git-send-email-gcosta@redhat.com> <11871823151789-git-send-email-gcosta@redhat.com> <11871823273810-git-send-email-gcosta@redhat.com> <11871823373106-git-send-email-gcosta@redhat.com> <11871823673236-git-send-email-gcosta@redhat.com> <11871823782610-git-send-email-gcosta@redhat.com> <11871823892519-git-send-email-gcosta@redhat.com> <11871823991803-git-send-email-gcosta@redhat.com> <11871824081337-git-send-email-!
 gcosta@redhat.com> <11871824192375-git-send-email-gcosta@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

With paravirualization, hypervisors needs to handle the gdt,
that was right to this point only used at very early
inialization code. Hypervisors are commonly modules, so make
it an export

[  updates from v1
   * make it an EXPORT_SYMBOL_GPL.
   Suggested by Arjan van de Ven
]

Signed-off-by: Glauber de Oliveira Costa <gcosta@redhat.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 arch/x86_64/kernel/x8664_ksyms.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/arch/x86_64/kernel/x8664_ksyms.c b/arch/x86_64/kernel/x8664_ksyms.c
index 77c25b3..2d3932d 100644
--- a/arch/x86_64/kernel/x8664_ksyms.c
+++ b/arch/x86_64/kernel/x8664_ksyms.c
@@ -60,3 +60,9 @@ EXPORT_SYMBOL(init_level4_pgt);
 EXPORT_SYMBOL(load_gs_index);
 
 EXPORT_SYMBOL(_proxy_pda);
+
+#ifdef CONFIG_PARAVIRT
+extern unsigned long *cpu_gdt_descr;
+/* Virtualized guests may want to use it */
+EXPORT_SYMBOL_GPL(cpu_gdt_descr);
+#endif
-- 
1.4.4.2

