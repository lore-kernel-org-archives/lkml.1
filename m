Return-Path: <linux-kernel-owner+w=401wt.eu-S1759613AbYGHX3s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759613AbYGHX3s (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2008 19:29:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757020AbYGHXPR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jul 2008 19:15:17 -0400
Received: from gw.goop.org ([64.81.55.164]:51208 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757417AbYGHXOq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2008 19:14:46 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 43 of 55] xen64: implement xen_load_gs_index()
X-Mercurial-Node: ad006170c23d0f8bc13db80f2bb0a982c5158488
Message-Id: <ad006170c23d0f8bc13d.1215554825@localhost>
In-Reply-To: <patchbomb.1215554782@localhost>
Date: Tue, 08 Jul 2008 15:07:05 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, x86@kernel.org,
       Stephen Tweedie <sct@redhat.com>, Eduardo Habkost <ehabkost@redhat.com>,
       Mark McLoughlin <markmc@redhat.com>, x86@kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eduardo Habkost <ehabkost@redhat.com>

xen-64: implement xen_load_gs_index()

Signed-off-by: Eduardo Habkost <ehabkost@redhat.com>
Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/xen/enlighten.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -384,6 +384,14 @@
 	if (paravirt_get_lazy_mode() == PARAVIRT_LAZY_CPU)
 		loadsegment(gs, 0);
 }
+
+#ifdef CONFIG_X86_64
+static void xen_load_gs_index(unsigned int idx)
+{
+	if (HYPERVISOR_set_segment_base(SEGBASE_GS_USER_SEL, idx))
+		BUG();
+}
+#endif
 
 static void xen_write_ldt_entry(struct desc_struct *dt, int entrynum,
 				const void *ptr)
@@ -1063,6 +1071,9 @@
 	.load_gdt = xen_load_gdt,
 	.load_idt = xen_load_idt,
 	.load_tls = xen_load_tls,
+#ifdef CONFIG_X86_64
+	.load_gs_index = xen_load_gs_index,
+#endif
 
 	.store_gdt = native_store_gdt,
 	.store_idt = native_store_idt,


