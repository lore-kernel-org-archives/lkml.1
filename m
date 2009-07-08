Return-Path: <linux-kernel-owner+w=401wt.eu-S1757017AbZGHR6I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757017AbZGHR6I (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jul 2009 13:58:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755982AbZGHR57
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Jul 2009 13:57:59 -0400
Received: from mail-bw0-f225.google.com ([209.85.218.225]:45990 "EHLO
	mail-bw0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753782AbZGHR56 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jul 2009 13:57:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=EzM8YpYrPh+cj3lAld91IB4SqYn+TkY2YvxEu2E0JLxckUMwEhdJ+amKsEBwczcMOe
         mGVZ5uN7BuxAWNWhRcky5cdLYC8G9FOxhO5XntjRDM2labwtaniRnmER8Ji+DxlHGBzU
         i7r3LtykQe6DWDoK7k4HQQHjCkeIhuI1+z7bw=
From: Alexander Beregalov <a.beregalov@gmail.com>
To: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org
Cc: mathieu.desnoyers@polymtl.ca, davej@redhat.com,
       Alexander Beregalov <a.beregalov@gmail.com>
Subject: [PATCH] cpufreq: fix UP build
Date: Wed,  8 Jul 2009 21:57:47 +0400
Message-Id: <1247075867-11355-1-git-send-email-a.beregalov@gmail.com>
X-Mailer: git-send-email 1.6.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alexander Beregalov <a.beregalov@gmail.com> 

Fix this build error when CONFIG_SMP is not set:
drivers/cpufreq/cpufreq.c:941: 'managed_policy' undeclared

Signed-off-by: Alexander Beregalov <a.beregalov@gmail.com>
---

Tested on AthlonXP/NForce2


 drivers/cpufreq/cpufreq.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
index c668ac8..287872f 100644
--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -773,11 +773,11 @@ static int cpufreq_add_dev(struct sys_device *sys_dev)
 	struct cpufreq_policy new_policy;
 	struct cpufreq_policy *policy;
 	struct freq_attr **drv_attr;
-	struct sys_device *cpu_sys_dev;
 	unsigned long flags;
 	unsigned int j;
 #ifdef CONFIG_SMP
 	struct cpufreq_policy *managed_policy;
+	struct sys_device *cpu_sys_dev;
 #endif
 
 	if (cpu_is_offline(cpu))
@@ -930,6 +930,7 @@ static int cpufreq_add_dev(struct sys_device *sys_dev)
 	}
 	spin_unlock_irqrestore(&cpufreq_driver_lock, flags);
 
+#ifdef CONFIG_SMP
 	/* symlink affected CPUs */
 	for_each_cpu(j, policy->cpus) {
 		if (j == cpu)
@@ -947,6 +948,7 @@ static int cpufreq_add_dev(struct sys_device *sys_dev)
 			goto err_out_unregister;
 		}
 	}
+#endif
 
 	policy->governor = NULL; /* to assure that the starting sequence is
 				  * run in cpufreq_set_policy */
-- 
1.6.3.3

