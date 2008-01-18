Return-Path: <linux-kernel-owner+w=401wt.eu-S932208AbYARUGj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932208AbYARUGj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 15:06:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765629AbYARUEl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 15:04:41 -0500
Received: from mx1.redhat.com ([66.187.233.31]:35959 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765610AbYARUEj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 15:04:39 -0500
From: Glauber de Oliveira Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, glommer@gmail.com, tglx@linutronix.de,
       mingo@elte.hu, ehabkost@redhat.com, jeremy@goop.org, avi@qumranet.com,
       anthony@codemonkey.ws, virtualization@lists.linux-foundation.org,
       rusty@rustcorp.com.au, ak@suse.de, chrisw@sous-sol.org,
       rostedt@goodmis.org, hpa@zytor.com, zach@vmware.com, roland@redhat.com,
       mtosatti@redhat.com, Glauber de Oliveira Costa <gcosta@redhat.com>
Subject: [PATCH 7/10] fill pv_cpu_ops structure with cr8 fields
Date: Fri, 18 Jan 2008 15:20:22 -0200
Message-Id: <12006768683247-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.4.4.2
In-Reply-To: <12006768631010-git-send-email-gcosta@redhat.com>
References: <12006768251548-git-send-email-gcosta@redhat.com> <12006768362108-git-send-email-gcosta@redhat.com> <1200676842822-git-send-email-gcosta@redhat.com> <12006768473571-git-send-email-gcosta@redhat.com> <12006768521391-git-send-email-gcosta@redhat.com> <1200676857691-git-send-email-gcosta@redhat.com> <12006768631010-git-send-email-gcosta@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fills in the read and write cr8 fields with their
native version

Signed-off-by: Glauber de Oliveira Costa <gcosta@redhat.com>
---
 arch/x86/kernel/paravirt.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/paravirt.c b/arch/x86/kernel/paravirt.c
index c20b4f8..c67d331 100644
--- a/arch/x86/kernel/paravirt.c
+++ b/arch/x86/kernel/paravirt.c
@@ -319,6 +319,10 @@ struct pv_cpu_ops pv_cpu_ops = {
 	.read_cr4 = native_read_cr4,
 	.read_cr4_safe = native_read_cr4_safe,
 	.write_cr4 = native_write_cr4,
+#ifdef CONFIG_X86_64
+	.read_cr8 = native_read_cr8,
+	.write_cr8 = native_write_cr8,
+#endif
 	.wbinvd = native_wbinvd,
 	.read_msr = native_read_msr_safe,
 	.write_msr = native_write_msr_safe,
-- 
1.4.4.2

