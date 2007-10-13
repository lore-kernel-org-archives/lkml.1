Return-Path: <linux-kernel-owner+w=401wt.eu-S1762443AbXJMOpx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762443AbXJMOpx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Oct 2007 10:45:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761590AbXJMOmS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Oct 2007 10:42:18 -0400
Received: from 1wt.eu ([62.212.114.60]:2946 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761451AbXJMOmR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Oct 2007 10:42:17 -0400
From: Willy Tarreau <w@1wt.eu>
Message-Id: <20071013143441.%N@1wt.eu>
References: <20071013142822.%N@1wt.eu>
User-Agent: quilt/0.46-1
Date: Sat, 13 Oct 2007 17:28:26 +0200
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Jan Beulich <jbeulich@novell.com>, Andi Kleen <ak@suse.de>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [2.6.20.21 review 04/35] i386: allow debuggers to access the vsyscall page with compat vDSO
Content-Disposition: inline; filename=0015-i386-allow-debuggers-to-access-the-vsyscall-page-wi.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jan Beulich <jbeulich@novell.com>
Signed-off-by: Jan Beulich <jbeulich@novell.com>
Signed-off-by: Andi Kleen <ak@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 arch/i386/kernel/sysenter.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

Index: 2.6/arch/i386/kernel/sysenter.c
===================================================================
--- 2.6.orig/arch/i386/kernel/sysenter.c
+++ 2.6/arch/i386/kernel/sysenter.c
@@ -183,7 +183,9 @@ struct vm_area_struct *get_gate_vma(stru
 
 int in_gate_area(struct task_struct *task, unsigned long addr)
 {
-	return 0;
+	const struct vm_area_struct *vma = get_gate_vma(task);
+
+	return vma && addr >= vma->vm_start && addr < vma->vm_end;
 }
 
 int in_gate_area_no_task(unsigned long addr)

-- 
