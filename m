Return-Path: <linux-kernel-owner+w=401wt.eu-S1751449AbXA2OIQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751449AbXA2OIQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jan 2007 09:08:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751462AbXA2OIQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jan 2007 09:08:16 -0500
Received: from build.arklinux.osuosl.org ([140.211.166.26]:60221 "EHLO
	mail.arklinux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751449AbXA2OIP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jan 2007 09:08:15 -0500
X-Greylist: delayed 2016 seconds by postgrey-1.27 at vger.kernel.org; Mon, 29 Jan 2007 09:08:15 EST
From: Bernhard Rosenkraenzer <bero@arklinux.org>
To: linux-kernel@vger.kernel.org, akpm@osdl.org
Subject: [PATCH] 2.6.20-rc6-mm1: Fix compile if PREEMPT_RCU is set, but RCU_TRACE isn't
Date: Sun, 28 Jan 2007 23:44:30 +0100
User-Agent: KMail/1.9.5
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200701282344.30539.bero@arklinux.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.20-rc6-mm1 fails to compile if CONFIG_PREEMPT_RCU is set and
CONFIG_RCU_TRACE isn' -- the fix is fairly obvious.

Signed-off-by: Bernhard Rosenkraenzer <bero@arklinux.org>

---

--- linux-2.6.19/kernel/rcupreempt.c.ark	2007-01-28 23:38:07.000000000 +0100
+++ linux-2.6.19/kernel/rcupreempt.c	2007-01-28 23:38:12.000000000 +0100
@@ -619,7 +619,7 @@
 	synchronize_rcu();
 }
 
-#ifdef RCU_TRACE
+#ifdef CONFIG_RCU_TRACE
 int *rcupreempt_flipctr(int cpu)
 {
 	return &per_cpu(rcu_flipctr, cpu)[0];
