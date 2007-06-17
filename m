Return-Path: <linux-kernel-owner+w=401wt.eu-S1762076AbXFQXoZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762076AbXFQXoZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2007 19:44:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762007AbXFQXmv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jun 2007 19:42:51 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:37902 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756166AbXFQXmu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2007 19:42:50 -0400
Date: Mon, 18 Jun 2007 01:43:06 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [2.6 patch] mm/slab.c: start_cpu_timer() should be __cpuinit
Message-ID: <20070617234306.GH3588@stusta.de>
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

This patch has been sent on:
- 28 Apr 2007

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
 

