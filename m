Return-Path: <linux-kernel-owner+w=401wt.eu-S932934AbZHDQC2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932934AbZHDQC2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Aug 2009 12:02:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932787AbZHDQC2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Aug 2009 12:02:28 -0400
Received: from hera.kernel.org ([140.211.167.34]:58694 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932724AbZHDQC1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Aug 2009 12:02:27 -0400
Message-ID: <4A785B5D.4070702@kernel.org>
Date: Tue, 04 Aug 2009 09:01:33 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.22 (X11/20090605)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86/irq: fix move_irq_desc for node without ram
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


don't move it if target node is -1

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 kernel/irq/numa_migrate.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: linux-2.6/kernel/irq/numa_migrate.c
===================================================================
--- linux-2.6.orig/kernel/irq/numa_migrate.c
+++ linux-2.6/kernel/irq/numa_migrate.c
@@ -107,8 +107,8 @@ out_unlock:
 
 struct irq_desc *move_irq_desc(struct irq_desc *desc, int node)
 {
-	/* those all static, do move them */
-	if (desc->irq < NR_IRQS_LEGACY)
+	/* those static or target node is -1, do not move them */
+	if (desc->irq < NR_IRQS_LEGACY || node == -1)
 		return desc;
 
 	if (desc->node != node)
