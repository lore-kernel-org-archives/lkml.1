Return-Path: <linux-kernel-owner+w=401wt.eu-S1765673AbYARUGA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765673AbYARUGA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 15:06:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765592AbYARUEi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 15:04:38 -0500
Received: from mx1.redhat.com ([66.187.233.31]:35946 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765588AbYARUEf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 15:04:35 -0500
From: Glauber de Oliveira Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, glommer@gmail.com, tglx@linutronix.de,
       mingo@elte.hu, ehabkost@redhat.com, jeremy@goop.org, avi@qumranet.com,
       anthony@codemonkey.ws, virtualization@lists.linux-foundation.org,
       rusty@rustcorp.com.au, ak@suse.de, chrisw@sous-sol.org,
       rostedt@goodmis.org, hpa@zytor.com, zach@vmware.com, roland@redhat.com,
       mtosatti@redhat.com, Glauber de Oliveira Costa <gcosta@redhat.com>
Subject: [PATCH 5/10] puts read and write cr8 into pv_cpu_ops
Date: Fri, 18 Jan 2008 15:20:20 -0200
Message-Id: <1200676857691-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.4.4.2
In-Reply-To: <12006768521391-git-send-email-gcosta@redhat.com>
References: <12006768251548-git-send-email-gcosta@redhat.com> <12006768362108-git-send-email-gcosta@redhat.com> <1200676842822-git-send-email-gcosta@redhat.com> <12006768473571-git-send-email-gcosta@redhat.com> <12006768521391-git-send-email-gcosta@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds room for read and write_cr8 functions back in
pv_cpu_ops struct

Signed-off-by: Glauber de Oliveira Costa <gcosta@redhat.com>
---
 include/asm-x86/paravirt.h |   15 +++++++++++++++
 1 files changed, 15 insertions(+), 0 deletions(-)

diff --git a/include/asm-x86/paravirt.h b/include/asm-x86/paravirt.h
index 7ff25c2..3e7ca42 100644
--- a/include/asm-x86/paravirt.h
+++ b/include/asm-x86/paravirt.h
@@ -101,6 +101,11 @@ struct pv_cpu_ops {
 	unsigned long (*read_cr4)(void);
 	void (*write_cr4)(unsigned long);
 
+#ifdef CONFIG_X86_64
+	unsigned long (*read_cr8)(void);
+	void (*write_cr8)(unsigned long);
+#endif
+
 	/* Segment descriptor handling */
 	void (*load_tr_desc)(void);
 	void (*load_gdt)(const struct desc_ptr *);
@@ -614,6 +619,16 @@ static inline void write_cr4(unsigned long x)
 	PVOP_VCALL1(pv_cpu_ops.write_cr4, x);
 }
 
+static inline unsigned long read_cr8(void)
+{
+	return PVOP_CALL0(unsigned long, pv_cpu_ops.read_cr8);
+}
+
+static inline void write_cr8(unsigned long x)
+{
+	PVOP_VCALL1(pv_cpu_ops.write_cr8, x);
+}
+
 static inline void raw_safe_halt(void)
 {
 	PVOP_VCALL0(pv_irq_ops.safe_halt);
-- 
1.4.4.2

