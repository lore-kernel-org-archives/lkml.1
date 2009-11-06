Return-Path: <linux-kernel-owner+w=401wt.eu-S1757085AbZKFLnr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757085AbZKFLnr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Nov 2009 06:43:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756190AbZKFLnq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Nov 2009 06:43:46 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:46099 "EHLO
	bob.linux.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756175AbZKFLnp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Nov 2009 06:43:45 -0500
From: Alan Cox <alan@linux.intel.com>
Subject: [PATCH] slqb: A not quite so trivial warning
To: mel@csn.ul.fi, penberg@cs.helsinki.fi, linux-kernel@vger.kernel.org
Date: Fri, 06 Nov 2009 11:29:57 +0000
Message-ID: <20091106112942.14595.29799.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

mm/slqb.c:2773: warning: initialization from incompatible pointer type

Variable scope...

Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 mm/slqb.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)


diff --git a/mm/slqb.c b/mm/slqb.c
index e745d9a..fddcf85 100644
--- a/mm/slqb.c
+++ b/mm/slqb.c
@@ -2770,16 +2770,16 @@ static DEFINE_PER_CPU(struct delayed_work, cache_trim_work);
 
 static void __cpuinit start_cpu_timer(int cpu)
 {
-	struct delayed_work *cache_trim_work = &per_cpu(cache_trim_work, cpu);
+	struct delayed_work *lcache_trim_work = &per_cpu(cache_trim_work, cpu);
 
 	/*
 	 * When this gets called from do_initcalls via cpucache_init(),
 	 * init_workqueues() has already run, so keventd will be setup
 	 * at that time.
 	 */
-	if (keventd_up() && cache_trim_work->work.func == NULL) {
-		INIT_DELAYED_WORK(cache_trim_work, cache_trim_worker);
-		schedule_delayed_work_on(cpu, cache_trim_work,
+	if (keventd_up() && lcache_trim_work->work.func == NULL) {
+		INIT_DELAYED_WORK(lcache_trim_work, cache_trim_worker);
+		schedule_delayed_work_on(cpu, lcache_trim_work,
 					__round_jiffies_relative(HZ, cpu));
 	}
 }

