Return-Path: <linux-kernel-owner+w=401wt.eu-S1756598AbYLADEc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756598AbYLADEc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Nov 2008 22:04:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752963AbYLADEW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Nov 2008 22:04:22 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:47935 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752473AbYLADEV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Nov 2008 22:04:21 -0500
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Rusty Russell <rusty@rustcorp.com.au>, Mike Travis <travis@sgi.com>,
       "Luck, Tony" <tony.luck@intel.com>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-ia64 <linux-ia64@vger.kernel.org>
Subject: [mmotm][PATCH] fix arch/ia64/kernel/msi_ia64.c warning
Cc: kosaki.motohiro@jp.fujitsu.com
Message-Id: <20081201115811.817E.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Date: Mon,  1 Dec 2008 12:04:18 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fix following warning.

  arch/ia64/kernel/msi_ia64.c:145: warning: initialization from incompatible pointer type

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
CC: Rusty Russell <rusty@rustcorp.com.au>
CC: Mike Travis <travis@sgi.com>
CC: "Luck, Tony" <tony.luck@intel.com>
---
 arch/ia64/kernel/msi_ia64.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

Index: b/arch/ia64/kernel/msi_ia64.c
===================================================================
--- a/arch/ia64/kernel/msi_ia64.c
+++ b/arch/ia64/kernel/msi_ia64.c
@@ -49,11 +49,12 @@
 static struct irq_chip	ia64_msi_chip;
 
 #ifdef CONFIG_SMP
-static void ia64_set_msi_irq_affinity(unsigned int irq, cpumask_t cpu_mask)
+static void ia64_set_msi_irq_affinity(unsigned int irq,
+				      const cpumask_t *cpu_mask)
 {
 	struct msi_msg msg;
 	u32 addr, data;
-	int cpu = first_cpu(cpu_mask);
+	int cpu = first_cpu(*cpu_mask);
 
 	if (!cpu_online(cpu))
 		return;



