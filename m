Return-Path: <linux-kernel-owner+w=401wt.eu-S1759775AbYBOR4r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759775AbYBOR4r (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2008 12:56:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756614AbYBOR4j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Feb 2008 12:56:39 -0500
Received: from rv-out-0910.google.com ([209.85.198.184]:53247 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756511AbYBOR4i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2008 12:56:38 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=RftFNgrJMm5UDQkDE12xTVcixOgS3N+9OQocoBmk5ezvmVWzqLUAigB0R+2UfAvYNHvL5mG47o+bxfmiMa0PHl8DdWoW5TW3mD6pYW5RDesa+GfXdSwF32bS9CpA+juG4exYKBUKh4ipnLxM57EG93LTtWWviD3dNZdoS3slp5M=
Subject: [PATCH 3/3] sched: fix signedness warnings in sched.c
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Fri, 15 Feb 2008 09:56:36 -0800
Message-Id: <1203098196.15275.7.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Unsigned long values are always assigned to switch_count,
make it unsigned long.

kernel/sched.c:3897:15: warning: incorrect type in assignment (different signedness)
kernel/sched.c:3897:15:    expected long *switch_count
kernel/sched.c:3897:15:    got unsigned long *<noident>
kernel/sched.c:3921:16: warning: incorrect type in assignment (different signedness)
kernel/sched.c:3921:16:    expected long *switch_count
kernel/sched.c:3921:16:    got unsigned long *<noident>

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 kernel/sched.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 824d5a9..0ddef83 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -3886,7 +3886,7 @@ pick_next_task(struct rq *rq, struct task_struct *prev)
 asmlinkage void __sched schedule(void)
 {
 	struct task_struct *prev, *next;
-	long *switch_count;
+	unsigned long *switch_count;
 	struct rq *rq;
 	int cpu;
 
-- 
1.5.4.1.1278.gc75be

