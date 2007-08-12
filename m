Return-Path: <linux-kernel-owner+w=401wt.eu-S936664AbXHLRhn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936664AbXHLRhn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Aug 2007 13:37:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760129AbXHLRhe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Aug 2007 13:37:34 -0400
Received: from ug-out-1314.google.com ([66.249.92.170]:56149 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756762AbXHLRhd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Aug 2007 13:37:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent;
        b=dowbHqBZcRNMA8fv4aBhOTKvQvSibKBVL/48DdC6C3G/F7Atx2QSzvEBs0GKMvL9fSQuFHfl9UB0eSPzYI5aM1MQhSH3Qotco/ssrKolUZe+n4LYLg7AzqxaP+5dLAutY9OVQj2gt3mStkYvCGOIqBLbXaAzbKU7y184Aafj0Nk=
Date: Sun, 12 Aug 2007 21:37:28 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: akpm@osdl.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] Shrink struct task_struct::oomkilladj
Message-ID: <20070812173728.GC5871@martell.zuzino.mipt.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

oomkilladj in int, but values which can be assigned to it are -17, [-16, 15],
thus fitting into s8.

While patch itself doesn't help in making task_struct smaller, because of
natural alignment of ->link_count, it will make picture clearer wrt futher
task_struct reduction patches. My plan is to move ->fpu_counter and
->oomkilladj after ->ioprio filling hole on i386 and x86_64. But that's for
later, because bloated distro configs need looking at as well.

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---

 include/linux/sched.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1052,7 +1052,7 @@ struct task_struct {
 	 * a short time
 	 */
 	unsigned char fpu_counter;
-	int oomkilladj; /* OOM kill score adjustment (bit shift). */
+	s8 oomkilladj; /* OOM kill score adjustment (bit shift). */
 	char comm[TASK_COMM_LEN]; /* executable name excluding path
 				     - access with [gs]et_task_comm (which lock
 				       it with task_lock())

