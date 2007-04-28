Return-Path: <linux-kernel-owner+w=401wt.eu-S1161209AbXD1TXt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161209AbXD1TXt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2007 15:23:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030657AbXD1TTu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Apr 2007 15:19:50 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:37501 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1030772AbXD1TTh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2007 15:19:37 -0400
Date: Sat, 28 Apr 2007 21:19:48 +0200
From: Adrian Bunk <bunk@stusta.de>
To: linux-kernel@vger.kernel.org
Subject: [2.6 patch] mm/slab.c: start_cpu_timer() should be __cpuinit
Message-ID: <20070428191948.GR3468@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

start_cpu_timer() should be __cpuinit (which also matches what it's 
callers are).

__devinit didn't cause problems, it simply wasted a few bytes of memory 
for the common CONFIG_HOTPLUG_CPU=n case.

Signed-off-by: Adrian Bunk <bunk@stusta.de>

---
--- linux-2.6.21-rc7-mm2/mm/slab.c.old	2007-04-28 14:26:44.000000000 +0200
+++ linux-2.6.21-rc7-mm2/mm/slab.c	2007-04-28 14:26:54.000000000 +0200
@@ -948,7 +948,7 @@
  * the CPUs getting into lockstep and contending for the global cache chain
  * lock.
  */
-static void __devinit start_cpu_timer(int cpu)
+static void __cpuinit start_cpu_timer(int cpu)
 {
 	struct delayed_work *reap_work = &per_cpu(reap_work, cpu);
 

