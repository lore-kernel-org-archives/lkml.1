Return-Path: <linux-kernel-owner+w=401wt.eu-S1754175AbZALFod@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754175AbZALFod (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 00:44:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751261AbZALFoZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 00:44:25 -0500
Received: from hera.kernel.org ([140.211.167.34]:44457 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750695AbZALFoZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 00:44:25 -0500
Message-ID: <496AD895.10701@kernel.org>
Date: Sun, 11 Jan 2009 21:43:49 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Mike Travis <travis@sgi.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86: use nr_cpus in max_nr_irqs()
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Impact: get more small nr_irqs

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 arch/x86/include/asm/apicdef.h     |    7 +------
 arch/x86/include/asm/irq_vectors.h |    4 ++--
 2 files changed, 3 insertions(+), 8 deletions(-)

Index: linux-2.6/arch/x86/include/asm/irq_vectors.h
===================================================================
--- linux-2.6.orig/arch/x86/include/asm/irq_vectors.h
+++ linux-2.6/arch/x86/include/asm/irq_vectors.h
@@ -122,8 +122,8 @@
 
 /* defined as a macro so nr_irqs = max_nr_irqs(nr_cpu_ids) can be used */
 # define max_nr_irqs(nr_cpus)				\
-	((8 * nr_cpus) > (32 * MAX_IO_APICS) ?		\
-		(NR_VECTORS + (8 * NR_CPUS)) :		\
+	((8 * (nr_cpus)) > (32 * MAX_IO_APICS) ?		\
+		(NR_VECTORS + (8 * (nr_cpus)) :		\
 		(NR_VECTORS + (32 * MAX_IO_APICS)))	\
 
 # define NR_IRQS max_nr_irqs(NR_CPUS)
