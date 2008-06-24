Return-Path: <linux-kernel-owner+w=401wt.eu-S1756538AbYFXVdP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756538AbYFXVdP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2008 17:33:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751406AbYFXVdA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jun 2008 17:33:00 -0400
Received: from gw.goop.org ([64.81.55.164]:33103 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751132AbYFXVc7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2008 17:32:59 -0400
Message-ID: <48616800.8030603@goop.org>
Date: Tue, 24 Jun 2008 17:32:48 -0400
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Yinghai Lu <yhlu.kernel@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86: fix pte allocation in "x86: introduce init_memory_mapping
 for 32bit"
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch "x86: introduce init_memory_mapping for 32bit" does not allocate 
enough space for PTEs if the CPU does not implement PSE.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Cc: Yinghai Lu <yhlu.kernel@gmail.com>
---
 arch/x86/mm/init_32.c |    5 +++++
 1 file changed, 5 insertions(+)

===================================================================
--- a/arch/x86/mm/init_32.c
+++ b/arch/x86/mm/init_32.c
@@ -733,6 +733,11 @@
 	pmds = (end + PMD_SIZE - 1) >> PMD_SHIFT;
 	tables += PAGE_ALIGN(pmds * sizeof(pmd_t));
 
+	if (!cpu_has_pse) {
+		int ptes = (end + PAGE_SIZE - 1) >> PAGE_SHIFT;
+		tables += PAGE_ALIGN(ptes * sizeof(pte_t));
+	}
+
 	/*
 	 * RED-PEN putting page tables only on node 0 could
 	 * cause a hotspot and fill up ZONE_DMA. The page tables


