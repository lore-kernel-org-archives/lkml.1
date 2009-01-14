Return-Path: <linux-kernel-owner+w=401wt.eu-S1762987AbZANPK7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762987AbZANPK7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 10:10:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758084AbZANPKj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 10:10:39 -0500
Received: from casper.infradead.org ([85.118.1.10]:56624 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757593AbZANPKi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 10:10:38 -0500
Subject: [PATCH -tip] time-sched.c: tick_nohz_update_jiffies should be
	static
From: Jaswinder Singh Rajput <jaswinder@infradead.org>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Wed, 14 Jan 2009 20:38:17 +0530
Message-Id: <1231945697.3970.1.camel@jaswinder.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: cleanup, reduce kernel size a bit, avoid sparse warning

Fixes sparse warning:
 kernel/time/tick-sched.c:137:6: warning: symbol 'tick_nohz_update_jiffies' was not declared. Should it be static?

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
---
 kernel/time/tick-sched.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index 1b6c05b..d3f1ef4 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -134,7 +134,7 @@ __setup("nohz=", setup_tick_nohz);
  * value. We do this unconditionally on any cpu, as we don't know whether the
  * cpu, which has the update task assigned is in a long sleep.
  */
-void tick_nohz_update_jiffies(void)
+static void tick_nohz_update_jiffies(void)
 {
 	int cpu = smp_processor_id();
 	struct tick_sched *ts = &per_cpu(tick_cpu_sched, cpu);
-- 
1.6.0.6



