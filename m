Return-Path: <linux-kernel-owner+w=401wt.eu-S1760394AbXHaDJS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760394AbXHaDJS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2007 23:09:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755309AbXHaDJE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Aug 2007 23:09:04 -0400
Received: from deeprooted.net ([216.254.16.51]:52758 "EHLO paris.hilman.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753865AbXHaDJD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2007 23:09:03 -0400
Message-Id: <20070831030841.799694742@mvista.com>
User-Agent: quilt/0.45-1
Date: Thu, 30 Aug 2007 20:08:41 -0700
From: Kevin Hilman <khilman@mvista.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
       RT-Users <linux-rt-users@vger.kernel.org>
Subject: [PATCH 2.6.23-rc2-rt2] ARM: use raw lock in __new_context
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The ARM CPU ASID lock should be raw as it's used by schedule() when
creating a new context.

Signed-off-by: Kevin Hilman <khilman@mvista.com>

--- dev.orig/arch/arm/mm/context.c
+++ dev/arch/arm/mm/context.c
@@ -14,7 +14,7 @@
 #include <asm/mmu_context.h>
 #include <asm/tlbflush.h>
 
-static DEFINE_SPINLOCK(cpu_asid_lock);
+static DEFINE_RAW_SPINLOCK(cpu_asid_lock);
 unsigned int cpu_last_asid = ASID_FIRST_VERSION;
 
 /*
--
