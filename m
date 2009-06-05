Return-Path: <linux-kernel-owner+w=401wt.eu-S1757603AbZFEITc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757603AbZFEITc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 04:19:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755714AbZFEIGs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 04:06:48 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:37498 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755717AbZFEIGE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 04:06:04 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: linux-kernel@vger.kernel.org
Cc: uclinux-dist-devel@blackfin.uclinux.org,
       Robin Getz <robin.getz@analog.com>
Subject: [PATCH 40/62] Blackfin: add workaround for anomaly 05000461
Date: Fri,  5 Jun 2009 04:04:49 -0400
Message-Id: <1244189111-19639-41-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.3.1
In-Reply-To: <1244189111-19639-1-git-send-email-vapier@gentoo.org>
References: <1244189111-19639-1-git-send-email-vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Robin Getz <robin.getz@analog.com>

Returning too fast with a bad RETI can trigger false errors.

Signed-off-by: Robin Getz <robin.getz@analog.com>
Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 arch/blackfin/kernel/traps.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/arch/blackfin/kernel/traps.c b/arch/blackfin/kernel/traps.c
index 0d04a47..778a756 100644
--- a/arch/blackfin/kernel/traps.c
+++ b/arch/blackfin/kernel/traps.c
@@ -594,6 +594,9 @@ asmlinkage void trap_c(struct pt_regs *fp)
 		force_sig_info(sig, &info, current);
 	}
 
+	if (ANOMALY_05000461 && trapnr == VEC_HWERR && !access_ok(VERIFY_READ, fp->pc, 8))
+		fp->pc = SAFE_USER_INSTRUCTION;
+
 	trace_buffer_restore(j);
 	return;
 }
-- 
1.6.3.1

