Return-Path: <linux-kernel-owner+w=401wt.eu-S1753541AbYFDEJg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753541AbYFDEJg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2008 00:09:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750769AbYFDEJ2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jun 2008 00:09:28 -0400
Received: from mx1.redhat.com ([66.187.233.31]:59733 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750770AbYFDEJ1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2008 00:09:27 -0400
From: Glauber Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, tglx@linutronix.de, mingo@elte.hu,
       Yinghai Lu <yhlu.kernel@gmail.com>
Subject: [PATCH] Make x86 latest boot with non-discontig boxes
Date: Wed,  4 Jun 2008 01:08:27 -0300
Message-Id: <1212552507-15134-1-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.5.4.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 0596152388e234efebce464355186ad9e16c8cb6
broke my box, since it removes completely the call to
memory_present() at e820 setup.

It seems to be really not needed with discontig memory,
but with flat and sparse, I get an early crash. The proposed patch
moves the call memory_present() to setup_memory, the one
present in setup_32.c.

Signed-off-by: Glauber Costa <gcosta@redhat.com>
CC: Yinghai Lu <yhlu.kernel@gmail.com>
---
 arch/x86/kernel/setup_32.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/setup_32.c b/arch/x86/kernel/setup_32.c
index 2901042..841eb2f 100644
--- a/arch/x86/kernel/setup_32.c
+++ b/arch/x86/kernel/setup_32.c
@@ -388,6 +388,8 @@ static unsigned long __init setup_memory(void)
 #ifdef CONFIG_FLATMEM
 	max_mapnr = num_physpages;
 #endif
+	memory_present(0, 0, max_pfn);
+
 	printk(KERN_NOTICE "%ldMB LOWMEM available.\n",
 			pages_to_mb(max_low_pfn));
 
-- 
1.5.4.5

