Return-Path: <linux-kernel-owner+w=401wt.eu-S1757530AbZBKPYk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757530AbZBKPYk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Feb 2009 10:24:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755820AbZBKPX3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Feb 2009 10:23:29 -0500
Received: from mailhost.igel.co.jp ([219.106.231.130]:41201 "EHLO
	mailhost.igel.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753193AbZBKPXY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Feb 2009 10:23:24 -0500
From: Katsuya Matsubara <matsu@igel.co.jp>
To: linux-rt-users <linux-rt-users@vger.kernel.org>
Cc: Steven Rostedt <srostedt@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, Paul Mundt <lethal@linux-sh.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Katsuya Matsubara <matsu@igel.co.jp>
Subject: [PATCH RT 1/4] sh: use __preempt_enable_no_resched in cpu_idle()
Date: Thu, 12 Feb 2009 00:01:40 +0900
Message-Id: <1234364503-857-2-git-send-email-matsu@igel.co.jp>
X-Mailer: git-send-email 1.6.1
In-Reply-To: <1234364503-857-1-git-send-email-matsu@igel.co.jp>
References: <1234364503-857-1-git-send-email-matsu@igel.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

__preempt_enable_no_resched skips preempt_count check. However it is
of no matter since schedule is called afterwards in this case.
The same was done for arm in <http://lkml.org/lkml/2009/2/2/291>.

Signed-off-by: Katsuya Matsubara <matsu@igel.co.jp>
---
 arch/sh/kernel/process_32.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/sh/kernel/process_32.c b/arch/sh/kernel/process_32.c
index b965f02..483fe78 100644
--- a/arch/sh/kernel/process_32.c
+++ b/arch/sh/kernel/process_32.c
@@ -84,7 +84,7 @@ void cpu_idle(void)
 			idle();
 		tick_nohz_restart_sched_tick();
 
-		preempt_enable_no_resched();
+		__preempt_enable_no_resched();
 		schedule();
 		preempt_disable();
 		check_pgt_cache();
-- 
1.6.1

