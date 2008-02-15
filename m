Return-Path: <linux-kernel-owner+w=401wt.eu-S1760618AbYBOR5f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760618AbYBOR5f (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2008 12:57:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758214AbYBOR4m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Feb 2008 12:56:42 -0500
Received: from rv-out-0910.google.com ([209.85.198.184]:53200 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756010AbYBOR4l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2008 12:56:41 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=qk6MeIhd4svW6q3ZAnV3WKcFtwNMBHzJht2XzOLAcjduSnDz9/r/BgbFcnAK+QeC7uzbnI2AQpnchJfbMJsciLJ7D5G1t8pqkR48KKbw62HaydGWF1FDc5Kuh2k6W/e0K/WUsGP8u4G1Kw3EB6xelFb2qNcpctcyDzcaMTovmO8=
Subject: [PATCH 1/3] sched: add declaration of sched_tail to sched.h
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Jeff Dike <jdike@addtoit.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Fri, 15 Feb 2008 09:56:34 -0800
Message-Id: <1203098194.15275.3.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Avoids sparse warnings:
kernel/sched.c:2170:17: warning: symbol 'schedule_tail' was not declared. Should it be static?

Avoids the need for an external declaration in arch/um/process.c

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 arch/um/kernel/process.c |    2 --
 include/linux/sched.h    |    1 +
 2 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/arch/um/kernel/process.c b/arch/um/kernel/process.c
index fc50d2f..e8cb9ff 100644
--- a/arch/um/kernel/process.c
+++ b/arch/um/kernel/process.c
@@ -128,8 +128,6 @@ void *get_current(void)
 	return current;
 }
 
-extern void schedule_tail(struct task_struct *prev);
-
 /*
  * This is called magically, by its address being stuffed in a jmp_buf
  * and being longjmp-d to.
diff --git a/include/linux/sched.h b/include/linux/sched.h
index e217d18..f1d20c0 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -242,6 +242,7 @@ struct task_struct;
 
 extern void sched_init(void);
 extern void sched_init_smp(void);
+extern asmlinkage void schedule_tail(struct task_struct *prev);
 extern void init_idle(struct task_struct *idle, int cpu);
 extern void init_idle_bootup_task(struct task_struct *idle);
 
-- 
1.5.4.1.1278.gc75be


