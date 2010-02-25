Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933985Ab0BYV1R (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Feb 2010 16:27:17 -0500
Received: from mail.windriver.com ([147.11.1.11]:63616 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933874Ab0BYVWk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Feb 2010 16:22:40 -0500
From: Jason Wessel <jason.wessel@windriver.com>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, kgdb-bugreport@lists.sourceforge.net,
       Jason Wessel <jason.wessel@windriver.com>
Subject: [PATCH 06/28] kgdb,blackfin: Add in kgdb_arch_set_pc for blackfin
Date: Thu, 25 Feb 2010 15:21:11 -0600
Message-Id: <1267132893-23624-7-git-send-email-jason.wessel@windriver.com>
X-Mailer: git-send-email 1.6.4.rc1
In-Reply-To: <1267132893-23624-1-git-send-email-jason.wessel@windriver.com>
References: <1267132893-23624-1-git-send-email-jason.wessel@windriver.com>
X-OriginalArrivalTime: 25 Feb 2010 21:21:44.0508 (UTC) FILETIME=[87CEE7C0:01CAB660]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The new debug core api requires all architectures that use to debug
core to implement a function to set the program counter.

Signed-off-by: Jason Wessel <jason.wessel@windriver.com>
Acked-by: Sonic Zhang <sonic.zhang@analog.com>
Acked-by: Mike Frysinger <vapier@gentoo.org>
---
 arch/blackfin/kernel/kgdb.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/arch/blackfin/kernel/kgdb.c b/arch/blackfin/kernel/kgdb.c
index 34c7c3e..8cb6204 100644
--- a/arch/blackfin/kernel/kgdb.c
+++ b/arch/blackfin/kernel/kgdb.c
@@ -439,6 +439,11 @@ int kgdb_validate_break_address(unsigned long addr)
 	return -EFAULT;
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

