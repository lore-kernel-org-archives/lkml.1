Return-Path: <linux-kernel-owner+w=401wt.eu-S1763084AbYHHWAf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763084AbYHHWAf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2008 18:00:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761860AbYHHVyR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Aug 2008 17:54:17 -0400
Received: from rv-out-0506.google.com ([209.85.198.232]:59965 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760262AbYHHVyO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2008 17:54:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=Q5vR6uEWd3eFemMpknMMQ3QsHgxSAljVjPV80zUsuca7RyRvwWGZQdcCD4E4tcvZjE
         ciekipATp2WCVdzRyzRPwO+o5DcRiBfVrsgXfSapEaZ+nSCsgQSByYNR9j6zZN8T6Djl
         cdKJCyQfbq1cqUaq6Mk8WfkGNiwQN7x9vncuI=
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>, Mike Travis <travis@sgi.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Yinghai Lu <yhlu.kernel@gmail.com>
Subject: [PATCH 17/42] drivers proc to use nr_irqs
Date: Fri,  8 Aug 2008 14:52:23 -0700
Message-Id: <1218232368-31228-18-git-send-email-yhlu.kernel@gmail.com>
X-Mailer: git-send-email 1.5.4.5
In-Reply-To: <1218232368-31228-17-git-send-email-yhlu.kernel@gmail.com>
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
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>
---
 fs/proc/proc_misc.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/fs/proc/proc_misc.c b/fs/proc/proc_misc.c
index ded9698..1968251 100644
--- a/fs/proc/proc_misc.c
+++ b/fs/proc/proc_misc.c
@@ -503,7 +503,7 @@ static int show_stat(struct seq_file *p, void *v)
 	struct timespec boottime;
 	unsigned int *per_irq_sum;
 
-	per_irq_sum = kzalloc(sizeof(unsigned int)*NR_IRQS, GFP_KERNEL);
+	per_irq_sum = kzalloc(sizeof(unsigned int)*nr_irqs, GFP_KERNEL);
 	if (!per_irq_sum)
 		return -ENOMEM;
 
@@ -525,7 +525,7 @@ static int show_stat(struct seq_file *p, void *v)
 		softirq = cputime64_add(softirq, kstat_cpu(i).cpustat.softirq);
 		steal = cputime64_add(steal, kstat_cpu(i).cpustat.steal);
 		guest = cputime64_add(guest, kstat_cpu(i).cpustat.guest);
-		for (j = 0; j < NR_IRQS; j++) {
+		for (j = 0; j < nr_irqs; j++) {
 			unsigned int temp = kstat_cpu(i).irqs[j];
 			sum += temp;
 			per_irq_sum[j] += temp;
@@ -571,7 +571,7 @@ static int show_stat(struct seq_file *p, void *v)
 	}
 	seq_printf(p, "intr %llu", (unsigned long long)sum);
 
-	for (i = 0; i < NR_IRQS; i++)
+	for (i = 0; i < nr_irqs; i++)
 		seq_printf(p, " %u", per_irq_sum[i]);
 
 	seq_printf(p,
@@ -625,13 +625,13 @@ static const struct file_operations proc_stat_operations = {
  */
 static void *int_seq_start(struct seq_file *f, loff_t *pos)
 {
-	return (*pos <= NR_IRQS) ? pos : NULL;
+	return (*pos <= nr_irqs) ? pos : NULL;
 }
 
 static void *int_seq_next(struct seq_file *f, void *v, loff_t *pos)
 {
 	(*pos)++;
-	if (*pos > NR_IRQS)
+	if (*pos > nr_irqs)
 		return NULL;
 	return pos;
 }
-- 
1.5.4.5

