Return-Path: <linux-kernel-owner+w=401wt.eu-S1756240Ab0ANPAc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756240Ab0ANPAc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jan 2010 10:00:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756026Ab0ANPA2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jan 2010 10:00:28 -0500
Received: from mail.windriver.com ([147.11.1.11]:47448 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754810Ab0ANPA0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jan 2010 10:00:26 -0500
From: Jason Wessel <jason.wessel@windriver.com>
To: linux-kernel@vger.kernel.org
Cc: kgdb-bugreport@lists.sourceforge.net, mingo@elte.hu,
       Jason Wessel <jason.wessel@windriver.com>,
       Mike Frysinger <vapier@gentoo.org>
Subject: [PATCH 08/40] kgdb,blackfin: Add in kgdb_arch_set_pc for blackfin
Date: Thu, 14 Jan 2010 08:59:04 -0600
Message-Id: <1263481176-1897-9-git-send-email-jason.wessel@windriver.com>
X-Mailer: git-send-email 1.6.3.1.9.g95405b
In-Reply-To: <1263481176-1897-1-git-send-email-jason.wessel@windriver.com>
References: <1263481176-1897-1-git-send-email-jason.wessel@windriver.com>
X-OriginalArrivalTime: 14 Jan 2010 15:00:08.0287 (UTC) FILETIME=[433F56F0:01CA952A]
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
1.6.3.1.9.g95405b

