Return-Path: <linux-kernel-owner+w=401wt.eu-S1754731AbYKDIWQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754731AbYKDIWQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2008 03:22:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753487AbYKDIWD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Nov 2008 03:22:03 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:55304 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753481AbYKDIWB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2008 03:22:01 -0500
Message-ID: <49100581.1030602@cn.fujitsu.com>
Date: Tue, 04 Nov 2008 16:19:13 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: LKML <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH] sched: remove redundant call to unregister_sched_domain_sysctl()
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The sysctl has been unregistered by partition_sched_domains().

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 kernel/sched.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index e8819bc..bf75a5e 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -7734,8 +7734,6 @@ static void detach_destroy_domains(const cpumask_t *cpu_map)
 	cpumask_t tmpmask;
 	int i;
 
-	unregister_sched_domain_sysctl();
-
 	for_each_cpu_mask_nr(i, *cpu_map)
 		cpu_attach_domain(NULL, &def_root_domain, i);
 	synchronize_sched();
-- 
1.5.4.rc3
