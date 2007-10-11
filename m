Return-Path: <linux-kernel-owner+w=401wt.eu-S1756746AbXJKGXs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756746AbXJKGXs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2007 02:23:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754272AbXJKGXk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Oct 2007 02:23:40 -0400
Received: from mu-out-0910.google.com ([209.85.134.184]:29805 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753698AbXJKGXj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2007 02:23:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=elVaKM6YyOzslgdf/KXdHZg0WIm9+R27zKj2vwbuF8ZeXlfKCWQcKHJ5YFT22/Vwb0lqks/vVq4yIeFV1TdpFjCaeTGoHGCYj2c0O05GY+DtV/4xwG29kbM/9S93gtdPFrnzzoFwt8AZ3ZcJjiFkzZ9uP0e2OfdVUvicghE05lU=
Subject: [PATCH] Fix printk format strings
From: Vegard Nossum <vegard.nossum@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain
Date: Thu, 11 Oct 2007 08:23:34 +0200
Message-Id: <1192083814.26648.24.camel@grianne>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 (2.10.3-4.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This makes sure printk format strings contain no more than a single
line.

Signed-off-by: Vegard Nossum <vegard.nossum@gmail.com>
---
 kernel/time/timer_list.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/kernel/time/timer_list.c b/kernel/time/timer_list.c
index fdb2e03..12c5f4c 100644
--- a/kernel/time/timer_list.c
+++ b/kernel/time/timer_list.c
@@ -129,7 +129,8 @@ static void print_cpu(struct seq_file *m, int cpu, u64 now)
 	struct hrtimer_cpu_base *cpu_base = &per_cpu(hrtimer_bases, cpu);
 	int i;
 
-	SEQ_printf(m, "\ncpu: %d\n", cpu);
+	SEQ_printf(m, "\n");
+	SEQ_printf(m, "cpu: %d\n", cpu);
 	for (i = 0; i < HRTIMER_MAX_CLOCK_BASES; i++) {
 		SEQ_printf(m, " clock %d:\n", i);
 		print_base(m, cpu_base->clock_base + i, now);
@@ -184,7 +185,8 @@ print_tickdevice(struct seq_file *m, struct tick_device *td)
 {
 	struct clock_event_device *dev = td->evtdev;
 
-	SEQ_printf(m, "\nTick Device: mode:     %d\n", td->mode);
+	SEQ_printf(m, "\n");
+	SEQ_printf(m, "Tick Device: mode:     %d\n", td->mode);
 
 	SEQ_printf(m, "Clock Event Device: ");
 	if (!dev) {
-- 
1.5.2.4



