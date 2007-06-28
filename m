Return-Path: <linux-kernel-owner+w=401wt.eu-S1764407AbXF1Ipc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764407AbXF1Ipc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2007 04:45:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761964AbXF1IpZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jun 2007 04:45:25 -0400
Received: from mailhub.sw.ru ([195.214.233.200]:44291 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761582AbXF1IpY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2007 04:45:24 -0400
Date: Thu, 28 Jun 2007 12:45:05 +0400
From: Alexey Dobriyan <adobriyan@sw.ru>
To: ak@suse.de
Cc: linux-kernel@vger.kernel.org, devel@openvz.org
Subject: [PATCH] x86_64: arch_pick_mmap_layout() fixlet
Message-ID: <20070628084505.GA11055@localhost.sw.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

sparse now warns about
arch/x86_64/mm/mmap.c:15:3: warning: returning void-valued expression

Generated code looks correct: there is jump to the end of
arch_pick_mmap_layout() after ia32_pick_mmap_layout(), but this should be fixed
regardless.

Signed-off-by: Alexey Dobriyan <adobriyan@sw.ru>
---

 arch/x86_64/mm/mmap.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/arch/x86_64/mm/mmap.c
+++ b/arch/x86_64/mm/mmap.c
@@ -11,8 +11,10 @@
 void arch_pick_mmap_layout(struct mm_struct *mm)
 {
 #ifdef CONFIG_IA32_EMULATION
-	if (current_thread_info()->flags & _TIF_IA32)
-		return ia32_pick_mmap_layout(mm);
+	if (current_thread_info()->flags & _TIF_IA32) {
+		ia32_pick_mmap_layout(mm);
+		return;
+	}
 #endif
 	mm->mmap_base = TASK_UNMAPPED_BASE;
 	if (current->flags & PF_RANDOMIZE) {

