Return-Path: <linux-kernel-owner+w=401wt.eu-S1754922Ab0A0UZL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754922Ab0A0UZL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jan 2010 15:25:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754639Ab0A0UYn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jan 2010 15:24:43 -0500
Received: from mail-fx0-f215.google.com ([209.85.220.215]:52868 "EHLO
	mail-fx0-f215.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754632Ab0A0UYl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jan 2010 15:24:41 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=F6NMlYFR+d6BDXkY2XIkikoEfdgU3WoyDOWzYIIDLqy81rKQ0AZL5kyEQmgAvrs+bY
         RySkLkPyEArTKqGZDasTjLPBzrBUj4flawiONh4MJoAxfv1AbL0bufi1SU71V3SM83vG
         /Od6xRbvaUHU/e+gXhvrRiCToE6qD3LxwpuwI=
From: John Kacur <jkacur@redhat.com>
To: Clark Williams <williams@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, lkml <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Carsten Emde <C.Emde@osadl.org>,
       rt-users <linux-rt-users@vger.kernel.org>,
       John Kacur <jkacur@redhat.com>
Subject: [PATCH 3/5] rt-tests: Remove the ret variable, the end label and the goto.
Date: Wed, 27 Jan 2010 21:24:26 +0100
Message-Id: <1264623868-23595-4-git-send-email-jkacur@redhat.com>
X-Mailer: git-send-email 1.6.6
In-Reply-To: <1264623868-23595-1-git-send-email-jkacur@redhat.com>
References: <1264623868-23595-1-git-send-email-jkacur@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the ret variable, the end lable and the goto. We already have
inconsistent exit points for the function, and the end lable wasn't strictly
for errors. Directly returning simplifies and shortens the code.

Signed-off-by: John Kacur <jkacur@redhat.com>
---
 src/cyclictest/rt_numa.h |   14 +++++---------
 1 files changed, 5 insertions(+), 9 deletions(-)

diff --git a/src/cyclictest/rt_numa.h b/src/cyclictest/rt_numa.h
index 8d44097..ac2aca2 100644
--- a/src/cyclictest/rt_numa.h
+++ b/src/cyclictest/rt_numa.h
@@ -73,7 +73,7 @@ static int rt_numa_numa_node_of_cpu(int cpu)
 static int rt_numa_numa_node_of_cpu(int cpu)
 {
 	unsigned char cpumask[16];
-        int node, ret, idx, bit;
+        int node, idx, bit;
 	int max_node, max_cpus;
 
 	max_node = numa_max_node();
@@ -88,19 +88,15 @@ static int rt_numa_numa_node_of_cpu(int cpu)
 	idx = cpu / 8;
 	bit = cpu % 8;
 
-        for (node = 0; node <= max_node; node++){
+        for (node = 0; node <= max_node; node++) {
 		if (numa_node_to_cpus(node, (void *) cpumask, sizeof(cpumask)))
 			return -1;
 
-		if (cpumask[idx] & (1<<bit)) {
-			ret = node;
-			goto end;
-		}
+		if (cpumask[idx] & (1<<bit))
+			return node;
         }
-        ret = -1;
         errno = EINVAL;
-end:
-        return ret;
+	return -1;
 }
 
 #endif	/* LIBNUMA_API_VERSION */
-- 
1.6.6

