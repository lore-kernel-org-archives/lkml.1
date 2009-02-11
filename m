Return-Path: <linux-kernel-owner+w=401wt.eu-S1757970AbZBKPY5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757970AbZBKPY5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Feb 2009 10:24:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756035AbZBKPXa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Feb 2009 10:23:30 -0500
Received: from mailhost.igel.co.jp ([219.106.231.130]:41199 "EHLO
	mailhost.igel.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754249AbZBKPXY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Feb 2009 10:23:24 -0500
From: Katsuya Matsubara <matsu@igel.co.jp>
To: linux-rt-users <linux-rt-users@vger.kernel.org>
Cc: Steven Rostedt <srostedt@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, Paul Mundt <lethal@linux-sh.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Katsuya Matsubara <matsu@igel.co.jp>
Subject: [PATCH RT 2/4] sh: enable interrupts in signal handling
Date: Thu, 12 Feb 2009 00:01:41 +0900
Message-Id: <1234364503-857-3-git-send-email-matsu@igel.co.jp>
X-Mailer: git-send-email 1.6.1
In-Reply-To: <1234364503-857-2-git-send-email-matsu@igel.co.jp>
References: <1234364503-857-1-git-send-email-matsu@igel.co.jp>
 <1234364503-857-2-git-send-email-matsu@igel.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fully-preemptible kernel does not need interrupts disabled in signal
handling. The same treatment can be found in x86 and arm code.

Signed-off-by: Katsuya Matsubara <matsu@igel.co.jp>
---
 arch/sh/kernel/signal_32.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/arch/sh/kernel/signal_32.c b/arch/sh/kernel/signal_32.c
index 6d6e408..9f633b5 100644
--- a/arch/sh/kernel/signal_32.c
+++ b/arch/sh/kernel/signal_32.c
@@ -571,6 +571,13 @@ static void do_signal(struct pt_regs *regs, unsigned int save_r0)
 	struct k_sigaction ka;
 	sigset_t *oldset;
 
+#ifdef CONFIG_PREEMPT_RT
+	/*
+	* Fully-preemptible kernel does not need interrupts disabled:
+	*/
+	local_irq_enable();
+	preempt_check_resched();
+#endif
 	/*
 	 * We want the common case to go fast, which
 	 * is why we may in certain cases get here from
-- 
1.6.1

