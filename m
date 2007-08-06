Return-Path: <linux-kernel-owner+w=401wt.eu-S932168AbXHFGpv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932168AbXHFGpv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2007 02:45:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755862AbXHFGpM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Aug 2007 02:45:12 -0400
Received: from mail.cs.umn.edu ([128.101.34.202]:47810 "EHLO mail.cs.umn.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754063AbXHFGpI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2007 02:45:08 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18102.50001.544251.640632@gargle.gargle.HOWL>
Date: Mon, 6 Aug 2007 01:44:33 -0500
To: Matt Mackall <mpm@selenic.com>
CC: linux-kernel@vger.kernel.org, Dave Hansen <haveblue@us.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 2/3] Fix /proc/pid/pagemap header copy to userspace
X-Mailer: VM 7.19 under Emacs 21.4.1
In-Reply-To: <af12424c6e31474e5e7227e34854b29fa8a128db.1186382353.git.boutcher@cs.umn.edu>
References: <af12424c6e31474e5e7227e34854b29fa8a128db.1186382353.git.boutcher@cs.umn.edu> 
From: boutcher@cs.umn.edu (Dave Boutcher)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Earlier code relied on a broken length calculation copy
/proc/pid/pagemap header data to userspace.  This fix
correctly calls the add_to_pagemap routine after the header data is
set to copy results to userspace in a sane fashion.

Signed-off-by: Dave Boutcher <boutcher@cs.umn.edu>
---
 fs/proc/task_mmu.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
index b2baeab..1f78cb4 100644
--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -657,11 +657,11 @@ static ssize_t pagemap_read(struct file *file, char __user *buf,
 	pm.out = buf;
 
 	if (svpfn == -1) {
-		add_to_pagemap(pm.next, 0, &pm);
 		((char *)page)[0] = (ntohl(1) != 1);
 		((char *)page)[1] = PAGE_SHIFT;
 		((char *)page)[2] = sizeof(unsigned long);
 		((char *)page)[3] = sizeof(unsigned long);
+		add_to_pagemap(pm.next, page[0], &pm);
 	}
 
 	down_read(&mm->mmap_sem);
-- 
1.4.4.2

