Return-Path: <linux-kernel-owner+w=401wt.eu-S934783AbZDHRFs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934783AbZDHRFs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 13:05:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934585AbZDHRDY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 13:03:24 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:51623 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933731AbZDHRDW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 13:03:22 -0400
Subject: [PATCH 6.5/9] perf_counter: fix track task-comm data
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>,
       Corey Ashford <cjashfor@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20090408130409.127422406@chello.nl>
References: <20090408130124.715559390@chello.nl>
	 <20090408130409.127422406@chello.nl>
Content-Type: text/plain
Date: Wed, 08 Apr 2009 19:03:17 +0200
Message-Id: <1239210197.4557.2691.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.0 
Content-Transfer-Encoding: 7bit
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-04-08 at 15:01 +0200, Peter Zijlstra wrote:
> plain text document attachment (perf_counter-comm.patch)
> Similar to the mmap data stream, add one that tracks the task COMM field,
> so that the userspace reporting knows what to call a task.

Seems I forgot the !PERF_COUNTER case.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 include/linux/perf_counter.h |    1 +
 1 file changed, 1 insertion(+)

Index: linux-2.6/include/linux/perf_counter.h
===================================================================
--- linux-2.6.orig/include/linux/perf_counter.h
+++ linux-2.6/include/linux/perf_counter.h
@@ -597,6 +597,7 @@ static inline void
 perf_counter_munmap(unsigned long addr, unsigned long len,
 		    unsigned long pgoff, struct file *file) 		{ }
 
+static inline void perf_counter_comm(struct task_struct *tsk)		{ }
 #endif
 
 #endif /* __KERNEL__ */


