Return-Path: <linux-kernel-owner+w=401wt.eu-S1753194AbXJWKH2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753194AbXJWKH2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 06:07:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751817AbXJWKHS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 06:07:18 -0400
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:64712 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751605AbXJWKHQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 06:07:16 -0400
Date: Tue, 23 Oct 2007 03:07:04 -0700
From: Yinghai Lu <Yinghai.Lu@Sun.COM>
Subject: [PATCH] x86_64: do not clear cpu_index set by store_cpu_info
To: Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>
Message-id: <200710230307.04953.yinghai.lu@sun.com>
Organization: Sun
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7BIT
Content-disposition: inline
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

[PATCH] x86_64: do not clear cpu_index set by store_cpu_info

early_indentify_cpu is called after store_cpu_info.
So don't clear the assigned cpu_index

Signed-off-by: Yinghai Lu <yinghai.lu@sun.com>

diff --git a/arch/x86/kernel/setup_64.c b/arch/x86/kernel/setup_64.c
index e7a9e36..80ce096 100644
--- a/arch/x86/kernel/setup_64.c
+++ b/arch/x86/kernel/setup_64.c
@@ -892,7 +892,6 @@ void __cpuinit early_identify_cpu(struct cpuinfo_x86 *c)
 
 #ifdef CONFIG_SMP
 	c->phys_proc_id = (cpuid_ebx(1) >> 24) & 0xff;
-	c->cpu_index = 0;
 #endif
 }
 
