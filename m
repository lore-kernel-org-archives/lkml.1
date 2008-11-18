Return-Path: <linux-kernel-owner+w=401wt.eu-S1752585AbYKRHCa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752585AbYKRHCa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2008 02:02:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751201AbYKRHCX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Nov 2008 02:02:23 -0500
Received: from nwd2mail11.analog.com ([137.71.25.57]:26586 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751058AbYKRHCW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2008 02:02:22 -0500
X-IronPort-AV: E=Sophos;i="4.33,623,1220241600"; 
   d="scan'208";a="62688412"
From: Bryan Wu <cooloney@kernel.org>
To: viro@zeniv.linux.org.uk, akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Mike Frysinger <vapier.adi@gmail.com>,
       Bryan Wu <cooloney@kernel.org>
Subject: [PATCH] asm/generic: fix bug - kernel fails to build when enable some common audit code on Blackfin
Date: Tue, 18 Nov 2008 15:03:49 +0800
Message-Id: <1226991829-30641-1-git-send-email-cooloney@kernel.org>
X-Mailer: git-send-email 1.5.6.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mike Frysinger <vapier.adi@gmail.com>

If you enable some common audit code, the kernel fails to build.

In file included from lib/audit.c:17:
include/asm-generic/audit_write.h:3: error: '__NR_swapon' undeclared here (not in a function)
make[1]: *** [lib/audit.o] Error 1
make: *** [lib] Error 2

So do not use __NR_swapon if it isnt defined for a port.

Signed-off-by: Mike Frysinger <vapier.adi@gmail.com>
Signed-off-by: Bryan Wu <cooloney@kernel.org>
---
 include/asm-generic/audit_write.h |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/include/asm-generic/audit_write.h b/include/asm-generic/audit_write.h
index f10d367..c5f1c2c 100644
--- a/include/asm-generic/audit_write.h
+++ b/include/asm-generic/audit_write.h
@@ -1,6 +1,8 @@
 #include <asm-generic/audit_dir_write.h>
 __NR_acct,
+#ifdef __NR_swapon
 __NR_swapon,
+#endif
 __NR_quotactl,
 __NR_truncate,
 #ifdef __NR_truncate64
-- 
1.5.6.3
