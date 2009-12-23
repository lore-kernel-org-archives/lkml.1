Return-Path: <linux-kernel-owner+w=401wt.eu-S1757289AbZLWVXk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757289AbZLWVXk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Dec 2009 16:23:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757185AbZLWVXe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Dec 2009 16:23:34 -0500
Received: from mail.windriver.com ([147.11.1.11]:45322 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756595AbZLWVVu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Dec 2009 16:21:50 -0500
From: Jason Wessel <jason.wessel@windriver.com>
To: linux-kernel@vger.kernel.org
Cc: kgdb-bugreport@lists.sourceforge.net, kdb@oss.sgi.com, mingo@elte.hu,
       Jason Wessel <jason.wessel@windriver.com>,
       Mike Frysinger <vapier@gentoo.org>
Subject: [PATCH 09/37] kgdb,blackfin: Add in kgdb_arch_set_pc for blackfin
Date: Wed, 23 Dec 2009 15:19:22 -0600
Message-Id: <1261603190-5036-10-git-send-email-jason.wessel@windriver.com>
X-Mailer: git-send-email 1.6.4.rc1
In-Reply-To: <1261603190-5036-9-git-send-email-jason.wessel@windriver.com>
References: <1261603190-5036-1-git-send-email-jason.wessel@windriver.com>
 <1261603190-5036-2-git-send-email-jason.wessel@windriver.com>
 <1261603190-5036-3-git-send-email-jason.wessel@windriver.com>
 <1261603190-5036-4-git-send-email-jason.wessel@windriver.com>
 <1261603190-5036-5-git-send-email-jason.wessel@windriver.com>
 <1261603190-5036-6-git-send-email-jason.wessel@windriver.com>
 <1261603190-5036-7-git-send-email-jason.wessel@windriver.com>
 <1261603190-5036-8-git-send-email-jason.wessel@windriver.com>
 <1261603190-5036-9-git-send-email-jason.wessel@windriver.com>
X-OriginalArrivalTime: 23 Dec 2009 21:20:08.0129 (UTC) FILETIME=[B3ECA310:01CA8415]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The new debug core api requires all architectures that use to debug
core to implement a function to set the program counter.

CC: Mike Frysinger <vapier@gentoo.org>
Signed-off-by: Jason Wessel <jason.wessel@windriver.com>
---
 arch/blackfin/kernel/kgdb.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/arch/blackfin/kernel/kgdb.c b/arch/blackfin/kernel/kgdb.c
index f1036b6..5965188 100644
--- a/arch/blackfin/kernel/kgdb.c
+++ b/arch/blackfin/kernel/kgdb.c
@@ -644,6 +644,11 @@ int kgdb_arch_remove_breakpoint(unsigned long addr, char *bundle)
 	return bfin_probe_kernel_write((char *)addr, bundle, BREAK_INSTR_SIZE);
 }
 
+void kgdb_arch_set_pc(struct pt_regs *regs, unsigned long ip)
+{
+	regs->retx = ip;
+}
+
 int kgdb_arch_init(void)
 {
 	kgdb_single_step = 0;
-- 
1.6.4.rc1

