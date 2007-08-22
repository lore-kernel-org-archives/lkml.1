Return-Path: <linux-kernel-owner+w=401wt.eu-S933873AbXHVVNA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933873AbXHVVNA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 17:13:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762053AbXHVVMw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 17:12:52 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:48965 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758557AbXHVVMv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 17:12:51 -0400
Date: Thu, 23 Aug 2007 02:55:44 +0530 (IST)
From: Satyam Sharma <satyam@infradead.org>
X-X-Sender: satyam@enigma.security.iitk.ac.in
To: Andrew Morton <akpm@linux-foundation.org>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH] ll_rw_blk: blk_cpu_notifier should be __cpuinitdata
Message-ID: <alpine.LFD.0.999.0708230248330.2049@enigma.security.iitk.ac.in>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 20 Aug 2007, Andrew Morton wrote:
> 
> <looks at blk_cpu_notifier>
> 
> There are a few things to clear up here...

Patch below:


blk_cpu_notifier is marked as __devinitdata, but __devinitdata need not
be __init even if HOTPLUG_CPU=n, which wastes space. It should be marked
__cpuinitdata, and the callback itself as __cpuinit.

Signed-off-by: Satyam Sharma <satyam@infradead.org>

---

 block/ll_rw_blk.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/block/ll_rw_blk.c b/block/ll_rw_blk.c
index a15845c..91ec907 100644
--- a/block/ll_rw_blk.c
+++ b/block/ll_rw_blk.c
@@ -3563,7 +3563,7 @@ static void blk_done_softirq(struct softirq_action *h)
 	}
 }
 
-static int blk_cpu_notify(struct notifier_block *self, unsigned long action,
+static int __cpuinit blk_cpu_notify(struct notifier_block *self, unsigned long action,
 			  void *hcpu)
 {
 	/*
@@ -3584,7 +3584,7 @@ static int blk_cpu_notify(struct notifier_block *self, unsigned long action,
 }
 
 
-static struct notifier_block __devinitdata blk_cpu_notifier = {
+static struct notifier_block blk_cpu_notifier __cpuinitdata = {
 	.notifier_call	= blk_cpu_notify,
 };
 
