Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752445Ab0BLWmZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Feb 2010 17:42:25 -0500
Received: from mail.windriver.com ([147.11.1.11]:44111 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932072Ab0BLWgb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Feb 2010 17:36:31 -0500
From: Jason Wessel <jason.wessel@windriver.com>
To: linux-kernel@vger.kernel.org
Cc: kgdb-bugreport@lists.sourceforge.net, mingo@elte.hu,
       Jason Wessel <jason.wessel@windriver.com>,
       Mike Frysinger <vapier@gentoo.org>
Subject: [PATCH 06/28] kgdb,blackfin: Add in kgdb_arch_set_pc for blackfin
Date: Fri, 12 Feb 2010 16:35:21 -0600
Message-Id: <1266014143-29444-7-git-send-email-jason.wessel@windriver.com>
X-Mailer: git-send-email 1.6.4.rc1
In-Reply-To: <1266014143-29444-1-git-send-email-jason.wessel@windriver.com>
References: <1266014143-29444-1-git-send-email-jason.wessel@windriver.com>
X-OriginalArrivalTime: 12 Feb 2010 22:36:08.0005 (UTC) FILETIME=[C4E3BF50:01CAAC33]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The new debug core api requires all architectures that use to debug
core to implement a function to set the program counter.

CC: Mike Frysinger <vapier@gentoo.org>
Signed-off-by: Jason Wessel <jason.wessel@windriver.com>
Acked-by: Sonic Zhang <sonic.zhang@analog.com>
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

