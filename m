Return-Path: <linux-kernel-owner+w=401wt.eu-S1759941AbYAUVyd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759941AbYAUVyd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2008 16:54:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755576AbYAUVxV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jan 2008 16:53:21 -0500
Received: from mx1.redhat.com ([66.187.233.31]:49768 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755397AbYAUVxT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2008 16:53:19 -0500
From: Eduardo Habkost <ehabkost@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, glommer@gmail.com, tglx@linutronix.de,
       mingo@elte.hu, ehabkost@redhat.com, jeremy@goop.org, avi@qumranet.com,
       anthony@codemonkey.ws, virtualization@lists.linux-foundation.org,
       rusty@rustcorp.com.au, ak@suse.de, chrisw@sous-sol.org,
       rostedt@goodmis.org, hpa@zytor.com, zach@vmware.com, roland@redhat.com,
       mtosatti@redhat.com
Subject: [PATCH 3/4] Don't set pagetable_setup_{start,done} hooks on x86_64
Date: Mon, 21 Jan 2008 19:48:52 -0200
Message-Id: <1200952133-31581-4-git-send-email-ehabkost@redhat.com>
X-Mailer: git-send-email 1.5.4.rc3
In-Reply-To: <1200952133-31581-1-git-send-email-ehabkost@redhat.com>
References: <1200952133-31581-1-git-send-email-ehabkost@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

paravirt_pagetable_setup_{start,done}() are not used (yet) under x86_64,
and native_pagetable_setup_{start,done}() don't exist on x86_64. So they
don't need to be set.

Signed-off-by: Eduardo Habkost <ehabkost@redhat.com>
---
 arch/x86/kernel/paravirt.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/paravirt.c b/arch/x86/kernel/paravirt.c
index c67d331..37f38b7 100644
--- a/arch/x86/kernel/paravirt.c
+++ b/arch/x86/kernel/paravirt.c
@@ -367,8 +367,10 @@ struct pv_apic_ops pv_apic_ops = {
 };
 
 struct pv_mmu_ops pv_mmu_ops = {
+#ifndef CONFIG_X86_64
 	.pagetable_setup_start = native_pagetable_setup_start,
 	.pagetable_setup_done = native_pagetable_setup_done,
+#endif
 
 	.read_cr2 = native_read_cr2,
 	.write_cr2 = native_write_cr2,
-- 
1.5.3.4

