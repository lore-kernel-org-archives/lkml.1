Return-Path: <linux-kernel-owner+w=401wt.eu-S932079AbXGSKSP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932079AbXGSKSP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 06:18:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761318AbXGSJzr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 05:55:47 -0400
Received: from mail.suse.de ([195.135.220.2]:35406 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759185AbXGSJz0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 05:55:26 -0400
From: Andi Kleen <ak@suse.de>
References: <200707191154.642492000@suse.de>
In-Reply-To: <200707191154.642492000@suse.de>
To: jbeulich@novell.com, patches@x86-64.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [35/58] i386: allow debuggers to access the vsyscall page with  compat vDSO
Message-Id: <20070719095521.2F41214E0A@wotan.suse.de>
Date: Thu, 19 Jul 2007 11:55:21 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: "Jan Beulich" <jbeulich@novell.com>
Signed-off-by: Jan Beulich <jbeulich@novell.com>
Signed-off-by: Andi Kleen <ak@suse.de>

 arch/i386/kernel/sysenter.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

Index: linux/arch/i386/kernel/sysenter.c
===================================================================
--- linux.orig/arch/i386/kernel/sysenter.c
+++ linux/arch/i386/kernel/sysenter.c
@@ -336,7 +336,9 @@ struct vm_area_struct *get_gate_vma(stru
 
 int in_gate_area(struct task_struct *task, unsigned long addr)
 {
-	return 0;
+	const struct vm_area_struct *vma = get_gate_vma(task);
+
+	return vma && addr >= vma->vm_start && addr < vma->vm_end;
 }
 
 int in_gate_area_no_task(unsigned long addr)
