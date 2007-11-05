Return-Path: <linux-kernel-owner+w=401wt.eu-S1756160AbXKECR1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756160AbXKECR1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Nov 2007 21:17:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753393AbXKECRH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Nov 2007 21:17:07 -0500
Received: from [222.73.24.84] ([222.73.24.84]:54871 "EHLO song.cn.fujitsu.com"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753425AbXKECRE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Nov 2007 21:17:04 -0500
Message-ID: <472E7CB4.5020301@cn.fujitsu.com>
Date: Mon, 05 Nov 2007 10:15:16 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: LKML <linux-kernel@vger.kernel.org>, buytenh@wantstofly.org
Subject: [PATCH 1/6] ARM: fix memset size error
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The size passing to memset is wrong. And here we can replace
kmalloc with kzalloc.

Signed-off-by Li Zefan <lizf@cn.fujitsu.com>

---
 arch/arm/common/uengine.c |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/arch/arm/common/uengine.c b/arch/arm/common/uengine.c
index 95c8508..117cab3 100644
--- a/arch/arm/common/uengine.c
+++ b/arch/arm/common/uengine.c
@@ -374,8 +374,8 @@ static int set_initial_registers(int uengine, struct ixp2000_uengine_code *c)
 	u8 *ucode;
 	int i;
 
-	gpr_a = kmalloc(128 * sizeof(u32), GFP_KERNEL);
-	gpr_b = kmalloc(128 * sizeof(u32), GFP_KERNEL);
+	gpr_a = kzalloc(128 * sizeof(u32), GFP_KERNEL);
+	gpr_b = kzalloc(128 * sizeof(u32), GFP_KERNEL);
 	ucode = kmalloc(513 * 5, GFP_KERNEL);
 	if (gpr_a == NULL || gpr_b == NULL || ucode == NULL) {
 		kfree(ucode);
@@ -388,8 +388,6 @@ static int set_initial_registers(int uengine, struct ixp2000_uengine_code *c)
 	if (c->uengine_parameters & IXP2000_UENGINE_4_CONTEXTS)
 		per_ctx_regs = 32;
 
-	memset(gpr_a, 0, sizeof(gpr_a));
-	memset(gpr_b, 0, sizeof(gpr_b));
 	for (i = 0; i < 256; i++) {
 		struct ixp2000_reg_value *r = c->initial_reg_values + i;
 		u32 *bank;
-- 
1.5.3.rc7

