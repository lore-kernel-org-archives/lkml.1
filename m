Return-Path: <linux-kernel-owner+w=401wt.eu-S1751971AbZHHPWP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751971AbZHHPWP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Aug 2009 11:22:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751899AbZHHPWN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Aug 2009 11:22:13 -0400
Received: from hera.kernel.org ([140.211.167.34]:49942 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751802AbZHHPWL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Aug 2009 11:22:11 -0400
Date: Sat, 8 Aug 2009 15:21:48 GMT
From: tip-bot for Yinghai Lu <yinghai@kernel.org>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       yinghai@kernel.org, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       yinghai@kernel.org, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <4A785B5D.4070702@kernel.org>
References: <4A785B5D.4070702@kernel.org>
Subject: [tip:irq/urgent] x86/irq: Fix move_irq_desc() for nodes without ram
Message-ID: <tip-ad7d6c7a0654a4bbda3e109f56af713267e96274@git.kernel.org>
Git-Commit-ID: ad7d6c7a0654a4bbda3e109f56af713267e96274
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sat, 08 Aug 2009 15:21:48 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  ad7d6c7a0654a4bbda3e109f56af713267e96274
Gitweb:     http://git.kernel.org/tip/ad7d6c7a0654a4bbda3e109f56af713267e96274
Author:     Yinghai Lu <yinghai@kernel.org>
AuthorDate: Tue, 4 Aug 2009 09:01:33 -0700
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sat, 8 Aug 2009 17:06:03 +0200

x86/irq: Fix move_irq_desc() for nodes without ram

Don't move it if target node is -1.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
LKML-Reference: <4A785B5D.4070702@kernel.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 kernel/irq/numa_migrate.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/irq/numa_migrate.c b/kernel/irq/numa_migrate.c
index 2f69bee..3fd3019 100644
--- a/kernel/irq/numa_migrate.c
+++ b/kernel/irq/numa_migrate.c
@@ -107,8 +107,8 @@ out_unlock:
 
 struct irq_desc *move_irq_desc(struct irq_desc *desc, int node)
 {
-	/* those all static, do move them */
-	if (desc->irq < NR_IRQS_LEGACY)
+	/* those static or target node is -1, do not move them */
+	if (desc->irq < NR_IRQS_LEGACY || node == -1)
 		return desc;
 
 	if (desc->node != node)
