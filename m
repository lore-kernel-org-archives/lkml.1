Return-Path: <linux-kernel-owner+w=401wt.eu-S932330AbZJ3PAy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932330AbZJ3PAy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Oct 2009 11:00:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932298AbZJ3PAx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Oct 2009 11:00:53 -0400
Received: from rs1.rw-gmbh.net ([213.239.201.58]:44425 "EHLO rs1.rw-gmbh.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932294AbZJ3PAw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Oct 2009 11:00:52 -0400
X-Greylist: delayed 1553 seconds by postgrey-1.27 at vger.kernel.org; Fri, 30 Oct 2009 11:00:52 EDT
Message-ID: <4AEAF987.2080809@rw-gmbh.de>
Date: Fri, 30 Oct 2009 15:34:47 +0100
From: =?UTF-8?B?UmFsZiBSw7ZzY2g=?= <ralf.roesch@rw-gmbh.de>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: a.p.zijlstra@chello.nl
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       Thomas Gleixner <tglx@linutronix.de>, mingo@elte.hu
Subject: [PATCH] x86: sched: fix for non SMP systems in sched.h
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit d65d153bc23b84e4709a49137a9a03ae139d51a0 introduced
two new prototypes: default_scale_freq_power and default_scale_smt_power.
Both of them use struct sched_domain which is not defined on non SMP 
systems.
Just moved the prototypes to the correct place.

Signed-off-by: Ralf Roesch <ralf.roesch@rw-gmbh.de>
---
 include/linux/sched.h |    7 +++----
 1 files changed, 3 insertions(+), 4 deletions(-)
 mode change 100644 => 100755 include/linux/sched.h

diff --git a/include/linux/sched.h b/include/linux/sched.h
old mode 100644
new mode 100755
index c231a24..b633308
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1036,6 +1036,9 @@ static inline int test_sd_parent(struct 
sched_domain *sd, int flag)
     return 0;
 }
 
+unsigned long default_scale_freq_power(struct sched_domain *sd, int cpu);
+unsigned long default_scale_smt_power(struct sched_domain *sd, int cpu);
+
 #else /* CONFIG_SMP */
 
 struct sched_domain_attr;
@@ -1047,10 +1050,6 @@ partition_sched_domains(int ndoms_new, struct 
cpumask *doms_new,
 }
 #endif    /* !CONFIG_SMP */
 
-
-unsigned long default_scale_freq_power(struct sched_domain *sd, int cpu);
-unsigned long default_scale_smt_power(struct sched_domain *sd, int cpu);
-
 struct io_context;            /* See blkdev.h */
 
 
-- 
1.6.5

