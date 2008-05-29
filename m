Return-Path: <linux-kernel-owner+w=401wt.eu-S1755603AbYE2PQ7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755603AbYE2PQ7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2008 11:16:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754980AbYE2PQQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 May 2008 11:16:16 -0400
Received: from smtp.movial.fi ([62.236.91.34]:35036 "EHLO smtp.movial.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754470AbYE2PQO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2008 11:16:14 -0400
From: Dmitri Vorobiev <dmitri.vorobiev@movial.fi>
To: linux-mips@linux-mips.org, ralf@linux-mips.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH 2/5] [MIPS] Make two functions static
Date: Thu, 29 May 2008 17:57:09 +0300
Message-Id: <12120730323421-git-send-email-dmitri.vorobiev@movial.fi>
X-Mailer: git-send-email 1.4.4.3
In-Reply-To: <12120730323761-git-send-email-dmitri.vorobiev@movial.fi>
References: <12120730323761-git-send-email-dmitri.vorobiev@movial.fi>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following routines

uasm_rel_highest()
uasm_rel_higher()

are needlessly defined global. This patch makes them static.

Compile-tested using a customized config for the Malta board. Booting
the same board up to the shell prompt was also successful with this
patch applied.

Spotted by sparse.

Signed-off-by: Dmitri Vorobiev <dmitri.vorobiev@movial.fi>
---
 arch/mips/mm/uasm.c |    4 ++--
 arch/mips/mm/uasm.h |    2 --
 2 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/arch/mips/mm/uasm.c b/arch/mips/mm/uasm.c
index 1655aa6..f467199 100644
--- a/arch/mips/mm/uasm.c
+++ b/arch/mips/mm/uasm.c
@@ -396,7 +396,7 @@ int __cpuinit uasm_in_compat_space_p(long addr)
 #endif
 }
 
-int __cpuinit uasm_rel_highest(long val)
+static int __cpuinit uasm_rel_highest(long val)
 {
 #ifdef CONFIG_64BIT
 	return ((((val + 0x800080008000L) >> 48) & 0xffff) ^ 0x8000) - 0x8000;
@@ -405,7 +405,7 @@ int __cpuinit uasm_rel_highest(long val)
 #endif
 }
 
-int __cpuinit uasm_rel_higher(long val)
+static int __cpuinit uasm_rel_higher(long val)
 {
 #ifdef CONFIG_64BIT
 	return ((((val + 0x80008000L) >> 32) & 0xffff) ^ 0x8000) - 0x8000;
diff --git a/arch/mips/mm/uasm.h b/arch/mips/mm/uasm.h
index 0d6a66f..c6d1e3d 100644
--- a/arch/mips/mm/uasm.h
+++ b/arch/mips/mm/uasm.h
@@ -103,8 +103,6 @@ struct uasm_label {
 void __cpuinit uasm_build_label(struct uasm_label **lab, u32 *addr, int lid);
 #ifdef CONFIG_64BIT
 int uasm_in_compat_space_p(long addr);
-int uasm_rel_highest(long val);
-int uasm_rel_higher(long val);
 #endif
 int uasm_rel_hi(long val);
 int uasm_rel_lo(long val);
-- 
1.4.4.3

