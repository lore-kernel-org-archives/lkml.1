Return-Path: <linux-kernel-owner+w=401wt.eu-S1757342AbYDYBW3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757342AbYDYBW3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2008 21:22:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754424AbYDYBWW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Apr 2008 21:22:22 -0400
Received: from smtp5.pp.htv.fi ([213.243.153.39]:47603 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754369AbYDYBWV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2008 21:22:21 -0400
Date: Fri, 25 Apr 2008 04:21:33 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Mike Travis <travis@sgi.com>, Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org
Subject: [2.6 patch] show_schedstat(): fix memleak
Message-ID: <20080425012133.GG18854@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Coverity checker spotted a memleak introduced by
commit 39106dcf85285e78f3b290022122c76f851379b8
(cpumask: use new cpus_scnprintf function).

It seems the kfree() got lost between v2 and v3 of this patch...

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---
acbecac5e146985135635ea992df9a9d83280256 diff --git a/kernel/sched_stats.h b/kernel/sched_stats.h
index 5bae2e0..a38878e 100644
--- a/kernel/sched_stats.h
+++ b/kernel/sched_stats.h
@@ -67,6 +67,7 @@ static int show_schedstat(struct seq_file *seq, void *v)
 		preempt_enable();
 #endif
 	}
+	kfree(mask_str);
 	return 0;
 }
 
