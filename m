Return-Path: <linux-kernel-owner+w=401wt.eu-S933712AbZGQAF5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933712AbZGQAF5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jul 2009 20:05:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933685AbZGQAFz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Jul 2009 20:05:55 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:39116 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933683AbZGQAFv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jul 2009 20:05:51 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: linux-kernel@vger.kernel.org
Cc: uclinux-dist-devel@blackfin.uclinux.org
Subject: [PATCH 05/21] Blackfin: restore exception banner when dumping crash info
Date: Thu, 16 Jul 2009 20:05:30 -0400
Message-Id: <1247789146-18786-6-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1247789146-18786-1-git-send-email-vapier@gentoo.org>
References: <1247789146-18786-1-git-send-email-vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Previous unification code put the exception banner behind the "is oops"
logic when it should have been printed all the time.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 arch/blackfin/kernel/traps.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/blackfin/kernel/traps.c b/arch/blackfin/kernel/traps.c
index 664de56..9efac0f 100644
--- a/arch/blackfin/kernel/traps.c
+++ b/arch/blackfin/kernel/traps.c
@@ -570,11 +570,12 @@ asmlinkage void trap_c(struct pt_regs *fp)
 	if (kernel_mode_regs(fp) || (current && !current->mm)) {
 		console_verbose();
 		oops_in_progress = 1;
-		if (strerror)
-			verbose_printk(strerror);
 	}
 
 	if (sig != SIGTRAP) {
+		if (strerror)
+			verbose_printk(strerror);
+
 		dump_bfin_process(fp);
 		dump_bfin_mem(fp);
 		show_regs(fp);
-- 
1.6.3.3

