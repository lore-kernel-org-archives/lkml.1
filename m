Return-Path: <linux-kernel-owner+w=401wt.eu-S1759388AbXH0RKR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759388AbXH0RKR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2007 13:10:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756518AbXH0RKF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Aug 2007 13:10:05 -0400
Received: from extu-mxob-1.symantec.com ([216.10.194.28]:53340 "EHLO
	extu-mxob-1.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750718AbXH0RKD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2007 13:10:03 -0400
Date: Mon, 27 Aug 2007 16:06:19 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.wat.veritas.com
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: [PATCH] fix bogus hotplug cpu warning
Message-ID: <Pine.LNX.4.64.0708271604440.21853@blonde.wat.veritas.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Brightmail-Tracker: AAAAAQAAAWE=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Fix bogus DEBUG_PREEMPT warning on x86_64, when cpu brought online after
bootup: current_is_keventd is right to note its use of smp_processor_id
is preempt-safe, but should use raw_smp_processor_id to avoid the warning.

Signed-off-by: Hugh Dickins <hugh@veritas.com>

--- 2.6.23-rc3-git10/kernel/workqueue.c	2007-07-26 19:49:58.000000000 +0100
+++ linux/kernel/workqueue.c	2007-08-26 18:59:16.000000000 +0100
@@ -635,7 +635,7 @@ int keventd_up(void)
 int current_is_keventd(void)
 {
 	struct cpu_workqueue_struct *cwq;
-	int cpu = smp_processor_id();	/* preempt-safe: keventd is per-cpu */
+	int cpu = raw_smp_processor_id(); /* preempt-safe: keventd is per-cpu */
 	int ret = 0;
 
 	BUG_ON(!keventd_wq);
