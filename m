Return-Path: <linux-kernel-owner+w=401wt.eu-S1757414AbXHOKje@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757414AbXHOKje (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2007 06:39:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752551AbXHOKi4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Aug 2007 06:38:56 -0400
Received: from mx1.suse.de ([195.135.220.2]:45716 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752323AbXHOKiz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2007 06:38:55 -0400
From: Andi Kleen <ak@suse.de>
References: <200708151238.148026000@suse.de>
In-Reply-To: <200708151238.148026000@suse.de>
To: jbeulich@novell.com, patches@x86-64.org, linux-kernel@vger.kernel.org,
       stable@kernel.org
Subject: [PATCH 2.6.22] [1/5] i386: allow debuggers to access the vsyscall page with  compat vDSO
Message-Id: <20070815103854.450BB14F28@wotan.suse.de>
Date: Wed, 15 Aug 2007 12:38:54 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: "Jan Beulich" <jbeulich@novell.com>
Signed-off-by: Jan Beulich <jbeulich@novell.com>
Signed-off-by: Andi Kleen <ak@suse.de>

 arch/i386/kernel/sysenter.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

Index: linux-2.6.22-stable/arch/i386/kernel/sysenter.c
===================================================================
--- linux-2.6.22-stable.orig/arch/i386/kernel/sysenter.c
+++ linux-2.6.22-stable/arch/i386/kernel/sysenter.c
@@ -336,7 +336,9 @@ struct vm_area_struct *get_gate_vma(stru
 
 int in_gate_area(struct task_struct *task, unsigned long addr)
 {
-	return 0;
+	const struct vm_area_struct *vma = get_gate_vma(task);
+
+	return vma && addr >= vma->vm_start && addr < vma->vm_end;
 }
 
 int in_gate_area_no_task(unsigned long addr)
