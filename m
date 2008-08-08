Return-Path: <linux-kernel-owner+w=401wt.eu-S1765148AbYHHWKV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765148AbYHHWKV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2008 18:10:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761858AbYHHVz3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Aug 2008 17:55:29 -0400
Received: from rv-out-0506.google.com ([209.85.198.234]:58025 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761785AbYHHVzP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2008 17:55:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=X1zotKCliaVeEB5ZvSjvMyyWAZ3aO16dqV4zleblIlvOSB93g4ii9JYipk/nSe5sKm
         fe0nL89ajhA4Cg6r3qhnQ2hphhkas7DGM82mh2z4Nwk7gGmxXoUugaKrZKsqgvQgEPz3
         puLQG8BeFgJIAdqCUix6g3dlWKbSnNIaHhl8Y=
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>, Mike Travis <travis@sgi.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Yinghai Lu <yhlu.kernel@gmail.com>
Subject: [PATCH 41/42] x86_64: remove one nr_irqs in show_stat
Date: Fri,  8 Aug 2008 14:52:47 -0700
Message-Id: <1218232368-31228-42-git-send-email-yhlu.kernel@gmail.com>
X-Mailer: git-send-email 1.5.4.5
In-Reply-To: <1218232368-31228-41-git-send-email-yhlu.kernel@gmail.com>
References: <1218232368-31228-1-git-send-email-yhlu.kernel@gmail.com>
 <1218232368-31228-2-git-send-email-yhlu.kernel@gmail.com>
 <1218232368-31228-3-git-send-email-yhlu.kernel@gmail.com>
 <1218232368-31228-4-git-send-email-yhlu.kernel@gmail.com>
 <1218232368-31228-5-git-send-email-yhlu.kernel@gmail.com>
 <1218232368-31228-6-git-send-email-yhlu.kernel@gmail.com>
 <1218232368-31228-7-git-send-email-yhlu.kernel@gmail.com>
 <1218232368-31228-8-git-send-email-yhlu.kernel@gmail.com>
 <1218232368-31228-9-git-send-email-yhlu.kernel@gmail.com>
 <1218232368-31228-10-git-send-email-yhlu.kernel@gmail.com>
 <1218232368-31228-11-git-send-email-yhlu.kernel@gmail.com>
 <1218232368-31228-12-git-send-email-yhlu.kernel@gmail.com>
 <1218232368-31228-13-git-send-email-yhlu.kernel@gmail.com>
 <1218232368-31228-14-git-send-email-yhlu.kernel@gmail.com>
 <1218232368-31228-15-git-send-email-yhlu.kernel@gmail.com>
 <1218232368-31228-16-git-send-email-yhlu.kernel@gmail.com>
 <1218232368-31228-17-git-send-email-yhlu.kernel@gmail.com>
 <1218232368-31228-18-git-send-email-yhlu.kernel@gmail.com>
 <1218232368-31228-19-git-send-email-yhlu.kernel@gmail.com>
 <1218232368-31228-20-git-send-email-yhlu.kernel@gmail.com>
 <1218232368-31228-21-git-send-email-yhlu.kernel@gmail.com>
 <1218232368-31228-22-git-send-email-yhlu.kernel@gmail.com>
 <1218232368-31228-23-git-send-email-yhlu.kernel@gmail.com>
 <1218232368-31228-24-git-send-email-yhlu.kernel@gmail.com>
 <1218232368-31228-25-git-send-email-yhlu.kernel@gmail.com>
 <1218232368-31228-26-git-send-email-yhlu.kernel@gmail.com>
 <1218232368-31228-27-git-send-email-yhlu.kernel@gmail.com>
 <1218232368-31228-28-git-send-email-yhlu.kernel@gmail.com>
 <1218232368-31228-29-git-send-email-yhlu.kernel@gmail.com>
 <1218232368-31228-30-git-send-email-yhlu.kernel@gmail.com>
 <1218232368-31228-31-git-send-email-yhlu.kernel@gmail.com>
 <1218232368-31228-32-git-send-email-yhlu.kernel@gmail.com>
 <1218232368-31228-33-git-send-email-yhlu.kernel@gmail.com>
 <1218232368-31228-34-git-send-email-yhlu.kernel@gmail.com>
 <1218232368-31228-35-git-send-email-yhlu.kernel@gmail.com>
 <1218232368-31228-36-git-send-email-yhlu.kernel@gmail.com>
 <1218232368-31228-37-git-send-email-yhlu.kernel@gmail.com>
 <1218232368-31228-38-git-send-email-yhlu.kernel@gmail.com>
 <1218232368-31228-39-git-send-email-yhlu.kernel@gmail.com>
 <1218232368-31228-40-git-send-email-yhlu.kernel@gmail.com>
 <1218232368-31228-41-git-send-email-yhlu.kernel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

loop with irq_desc list

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>
---
 fs/proc/proc_misc.c |   18 ++++++++----------
 1 files changed, 8 insertions(+), 10 deletions(-)

diff --git a/fs/proc/proc_misc.c b/fs/proc/proc_misc.c
index 15901c7..c001d1a 100644
--- a/fs/proc/proc_misc.c
+++ b/fs/proc/proc_misc.c
@@ -567,20 +567,18 @@ static int show_stat(struct seq_file *p, void *v)
 	}
 	seq_printf(p, "intr %llu", (unsigned long long)sum);
 
-	/* sum again ? it could be updated? have another field in irq_desc?*/
-	for (j = 0; j < nr_irqs; j++) {
+	/* sum again ? it could be updated? */
+	for_each_irq_desc(j, desc) {
 		per_irq_sum = 0;
-		desc = irq_desc(j);
 
-		if (desc)
-			for_each_possible_cpu(i) {
-				unsigned int temp;
+		for_each_possible_cpu(i) {
+			unsigned int temp;
 
-				temp = kstat_irqs_cpu(j, i);
-				per_irq_sum += temp;
-			}
+			temp = kstat_irqs_cpu(j, i);
+			per_irq_sum += temp;
+		}
 
-		seq_printf(p, " %u", per_irq_sum);
+		seq_printf(p, " %u:%u", j, per_irq_sum);
 	}
 
 	seq_printf(p,
-- 
1.5.4.5

