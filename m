Return-Path: <linux-kernel-owner+w=401wt.eu-S1751387AbZG2Hzg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751387AbZG2Hzg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jul 2009 03:55:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751023AbZG2Hzf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Jul 2009 03:55:35 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:62880 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750745AbZG2Hzf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jul 2009 03:55:35 -0400
Message-ID: <4A70006D.8020401@cn.fujitsu.com>
Date: Wed, 29 Jul 2009 15:55:25 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Ingo Molnar <mingo@elte.hu>, Jens Axboe <jens.axboe@oracle.com>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       Peter Zijlstra <peterz@infradead.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/3 -mm] generic-ipi: cleanup for generic_smp_call_function_interrupt()
References: <4A6983D8.8090805@cn.fujitsu.com> <4A6FFFE9.5070204@cn.fujitsu.com>
In-Reply-To: <4A6FFFE9.5070204@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use smp_processor_id() instead of get_cpu() and put_cpu() in 
generic_smp_call_function_interrupt(), It's no need to disable preempt,
beacuse we must call generic_smp_call_function_interrupt() with interrupts
disabled

Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
---
 kernel/smp.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/kernel/smp.c b/kernel/smp.c
index 1b5fd2e..3035ab8 100644
--- a/kernel/smp.c
+++ b/kernel/smp.c
@@ -171,7 +171,7 @@ void generic_exec_single(int cpu, struct call_single_data *data, int wait)
 void generic_smp_call_function_interrupt(void)
 {
 	struct call_function_data *data;
-	int cpu = get_cpu();
+	int cpu = smp_processor_id();
 
 	/*
 	 * Ensure entry is visible on call_function_queue after we have
@@ -207,7 +207,6 @@ void generic_smp_call_function_interrupt(void)
 		csd_unlock(&data->csd);
 	}
 
-	put_cpu();
 }
 
 /*
-- 
1.6.1.2

