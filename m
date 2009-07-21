Return-Path: <linux-kernel-owner+w=401wt.eu-S1755188AbZGUPKy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755188AbZGUPKy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jul 2009 11:10:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754911AbZGUPKx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Jul 2009 11:10:53 -0400
Received: from cmpxchg.org ([85.214.51.133]:38662 "EHLO cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753107AbZGUPKw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jul 2009 11:10:52 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghua.yu@intel.com>
Cc: linux-ia64@vger.kernel.org, <linux-kernel@vger.kernel.org>
Subject: [patch] ia64: boolean __test_and_clear_bit
Date: Tue, 21 Jul 2009 17:09:44 +0200
Message-Id: <1248188984-10148-1-git-send-email-hannes@cmpxchg.org>
X-Mailer: git-send-email 1.6.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

__test_and_clear_bit() returns a bitfield with the tested-for bit set.
Make it consistent with the other bitops - of ia64 but also every
other architecture - and return a boolean value.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
---
 arch/ia64/include/asm/bitops.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/ia64/include/asm/bitops.h b/arch/ia64/include/asm/bitops.h
index e2ca800..57a2787 100644
--- a/arch/ia64/include/asm/bitops.h
+++ b/arch/ia64/include/asm/bitops.h
@@ -286,7 +286,7 @@ __test_and_clear_bit(int nr, volatile void * addr)
 {
 	__u32 *p = (__u32 *) addr + (nr >> 5);
 	__u32 m = 1 << (nr & 31);
-	int oldbitset = *p & m;
+	int oldbitset = (*p & m) != 0;
 
 	*p &= ~m;
 	return oldbitset;
-- 
1.6.3

