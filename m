Return-Path: <linux-kernel-owner+w=401wt.eu-S933758AbZGQAGI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933758AbZGQAGI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jul 2009 20:06:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933751AbZGQAGH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Jul 2009 20:06:07 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:39140 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933734AbZGQAGD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jul 2009 20:06:03 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: linux-kernel@vger.kernel.org
Cc: uclinux-dist-devel@blackfin.uclinux.org,
       Robin Getz <robin.getz@analog.com>
Subject: [PATCH 18/21] Blackfin: work around anomaly 05000189
Date: Thu, 16 Jul 2009 20:05:43 -0400
Message-Id: <1247789146-18786-19-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1247789146-18786-1-git-send-email-vapier@gentoo.org>
References: <1247789146-18786-1-git-send-email-vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Robin Getz <robin.getz@analog.com>

Similar to anomaly 05000281 but not as bad, we cannot return to the
instruction causing a fault otherwise we'll trigger a second false
exception.  The system can still recover, but it isn't correct.

Signed-off-by: Robin Getz <robin.getz@analog.com>
Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 arch/blackfin/kernel/traps.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/arch/blackfin/kernel/traps.c b/arch/blackfin/kernel/traps.c
index 9efac0f..bf2b2d1 100644
--- a/arch/blackfin/kernel/traps.c
+++ b/arch/blackfin/kernel/traps.c
@@ -621,7 +621,8 @@ asmlinkage void trap_c(struct pt_regs *fp)
 	}
 
 	if ((ANOMALY_05000461 && trapnr == VEC_HWERR && !access_ok(VERIFY_READ, fp->pc, 8)) ||
-		(ANOMALY_05000281 && trapnr == VEC_HWERR))
+	    (ANOMALY_05000281 && trapnr == VEC_HWERR) ||
+	    (ANOMALY_05000189 && (trapnr == VEC_CPLB_I_VL || trapnr == VEC_CPLB_VL)))
 		fp->pc = SAFE_USER_INSTRUCTION;
 
  traps_done:
-- 
1.6.3.3

