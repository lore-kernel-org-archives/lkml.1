Return-Path: <linux-kernel-owner+w=401wt.eu-S1759262AbYBOR5D@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759262AbYBOR5D (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2008 12:57:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756745AbYBOR4k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Feb 2008 12:56:40 -0500
Received: from wx-out-0506.google.com ([66.249.82.228]:24090 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756544AbYBOR4i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2008 12:56:38 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=dwJWOQ1vRYuImThQQuvNE8sXqBnmxfs0IX7tBMcx7KxkT1hl7fP1hBCJdAiZ9UvMBIgPaSBC4uF6LMeAjL3+sqdcQnV+v2aNf6zjJuBCv0wltKMesyvLnGl+/XTecLwCOGEzTRQRQi24tKyFhg/wM1kEzAc1QJqQ2SNAfyyZhNM=
Subject: [PATCH 2/3] sched: trivial sparse warning in sched.c
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Fri, 15 Feb 2008 09:56:36 -0800
Message-Id: <1203098196.15275.5.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

kernel/sched.c:3680:3: warning: returning void-valued expression

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 kernel/sched.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index f28f19e..824d5a9 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -3676,8 +3676,10 @@ void account_system_time(struct task_struct *p, int hardirq_offset,
 	struct rq *rq = this_rq();
 	cputime64_t tmp;
 
-	if ((p->flags & PF_VCPU) && (irq_count() - hardirq_offset == 0))
-		return account_guest_time(p, cputime);
+	if ((p->flags & PF_VCPU) && (irq_count() - hardirq_offset == 0)) {
+		account_guest_time(p, cputime);
+		return;
+	}
 
 	p->stime = cputime_add(p->stime, cputime);
 
-- 
1.5.4.1.1278.gc75be


