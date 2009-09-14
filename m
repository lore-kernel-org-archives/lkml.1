Return-Path: <linux-kernel-owner+w=401wt.eu-S933735AbZINUM3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933735AbZINUM3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 16:12:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933657AbZINUJE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 16:09:04 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:54140 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933620AbZINUIz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 16:08:55 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: linux-kernel@vger.kernel.org
Cc: uclinux-dist-devel@blackfin.uclinux.org, Yi Li <yi.li@analog.com>
Subject: [PATCH 50/72] Blackfin: do not trace the exception handler
Date: Mon, 14 Sep 2009 16:07:54 -0400
Message-Id: <1252958896-25150-51-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1252958896-25150-1-git-send-email-vapier@gentoo.org>
References: <1252958896-25150-1-git-send-email-vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Yi Li <yi.li@analog.com>

Since the exception handler cannot cause exceptions, we cannot trace it
without easily causing double faults and crashing the system.

Signed-off-by: Yi Li <yi.li@analog.com>
Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 arch/blackfin/kernel/traps.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/blackfin/kernel/traps.c b/arch/blackfin/kernel/traps.c
index 0904430..7b3ba06 100644
--- a/arch/blackfin/kernel/traps.c
+++ b/arch/blackfin/kernel/traps.c
@@ -257,7 +257,7 @@ static int kernel_mode_regs(struct pt_regs *regs)
 	return regs->ipend & 0xffc0;
 }
 
-asmlinkage void trap_c(struct pt_regs *fp)
+asmlinkage notrace void trap_c(struct pt_regs *fp)
 {
 #ifdef CONFIG_DEBUG_BFIN_HWTRACE_ON
 	int j;
-- 
1.6.4.2

