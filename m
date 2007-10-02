Return-Path: <linux-kernel-owner+w=401wt.eu-S1756718AbXJBT7S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756718AbXJBT7S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2007 15:59:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753700AbXJBT7L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Oct 2007 15:59:11 -0400
Received: from nf-out-0910.google.com ([64.233.182.190]:31320 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753358AbXJBT7K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2007 15:59:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=DCSDlG+Wx1qbTuZfFhAkSA10WGA8UvHygur+QAM9+ZjBfOKQHXi0BgUN2zwj8dD7A/W3H2OxW3fev21l7MVXN1Wyq4AVtu2P6khjWq0poSPpeZ956ceY7BLbWhUSD1y/eSgeXMTQtHeeyL+QzulkWg88bcr7Zr+TFI3/Y4yWQDI=
Subject: Re: [git] CFS-devel, latest code
From: Dmitry Adamushko <dmitry.adamushko@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org
In-Reply-To: <1191354556.5664.7.camel@earth>
References: <1191354556.5664.7.camel@earth>
Content-Type: text/plain
Date: Tue, 02 Oct 2007 21:59:04 +0200
Message-Id: <1191355144.5664.16.camel@earth>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


The following patch (sched: disable sleeper_fairness on SCHED_BATCH)
seems to break GROUP_SCHED. Although, it may be
'oops'-less due to the possibility of 'p' being always a valid
address.


Signed-off-by: Dmitry Adamushko <dmitry.adamushko@gmail.com>

---
diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index 8727d17..a379456 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -473,9 +473,8 @@ place_entity(struct cfs_rq *cfs_rq, struct sched_entity *se, int initial)
 		vruntime += sched_vslice_add(cfs_rq, se);
 
 	if (!initial) {
-		struct task_struct *p = container_of(se, struct task_struct, se);
-
-		if (sched_feat(NEW_FAIR_SLEEPERS) && p->policy != SCHED_BATCH)
+		if (sched_feat(NEW_FAIR_SLEEPERS) && entity_is_task(se) &&
+				task_of(se)->policy != SCHED_BATCH)
 			vruntime -= sysctl_sched_latency;
 
 		vruntime = max_t(s64, vruntime, se->vruntime);

---


