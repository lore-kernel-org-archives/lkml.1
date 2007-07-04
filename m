Return-Path: <linux-kernel-owner+w=401wt.eu-S1761574AbXGDMN1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761574AbXGDMN1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2007 08:13:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760166AbXGDMNH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jul 2007 08:13:07 -0400
Received: from public.id2-vpn.continvity.gns.novell.com ([195.33.99.129]:32542
	"EHLO public.id2-vpn.continvity.gns.novell.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759612AbXGDMNF convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2007 08:13:05 -0400
Message-Id: <468BAB30.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 7.0.2 HP
Date: Wed, 04 Jul 2007 13:14:08 +0100
From: "Jan Beulich" <jbeulich@novell.com>
To: "Andi Kleen" <ak@suse.de>
Cc: <linux-kernel@vger.kernel.org>
Subject: [PATCH] i386: allow debuggers to access the vsyscall page with
	compat vDSO
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Jan Beulich <jbeulich@novell.com>

 arch/i386/kernel/sysenter.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletion(-)

--- linux-2.6.22-rc7/arch/i386/kernel/sysenter.c	2007-07-03 10:57:29.000000000 +0200
+++ 2.6.22-rc7-i386-in-gate-area/arch/i386/kernel/sysenter.c	2007-07-04 11:39:35.000000000 +0200
@@ -336,7 +336,9 @@ struct vm_area_struct *get_gate_vma(stru
 
 int in_gate_area(struct task_struct *task, unsigned long addr)
 {
-	return 0;
+	const struct vm_area_struct *vma = get_gate_vma(task);
+
+	return vma && addr >= vma->vm_start && addr < vma->vm_end;
 }
 
 int in_gate_area_no_task(unsigned long addr)



