Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755446Ab0BSR1W (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Feb 2010 12:27:22 -0500
Received: from fg-out-1718.google.com ([72.14.220.152]:25801 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753619Ab0BSR1R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Feb 2010 12:27:17 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=AnovDQ7IyiurdWoJQo7c2xH18qnszra41Q9NnrE9bXg613Rw1HwK9nSob7Wwfj2nS8
         ppW25BTtptLJPU/VPF2tn/NpQDUdTCFe9fTUKophpxcDdXi9Jy/yN5jnlUudYbpWd9s6
         oLj9fcwnhASWddaGA3O0FvOAGf6YB8rH2Ze/E=
From: Luca Barbieri <luca@luca-barbieri.com>
To: mingo@elte.hu
Cc: hpa@zytor.com, a.p.zijlstra@chello.nl, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, Luca Barbieri <luca@luca-barbieri.com>
Subject: [PATCH 3/5] x86-32: allow UP/SMP lock replacement in cmpxchg64 (v2)
Date: Fri, 19 Feb 2010 18:26:42 +0100
Message-Id: <1266600404-16402-4-git-send-email-luca@luca-barbieri.com>
X-Mailer: git-send-email 1.6.6.1.476.g01ddb
In-Reply-To: <1266600404-16402-1-git-send-email-luca@luca-barbieri.com>
References: <1266600404-16402-1-git-send-email-luca@luca-barbieri.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changes in v2:
- Naming change

Use the functionality just introduced in the previous patch.

Signed-off-by: Luca Barbieri <luca@luca-barbieri.com>
---
 arch/x86/include/asm/cmpxchg_32.h |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/arch/x86/include/asm/cmpxchg_32.h b/arch/x86/include/asm/cmpxchg_32.h
index ffb9bb6..8859e12 100644
--- a/arch/x86/include/asm/cmpxchg_32.h
+++ b/arch/x86/include/asm/cmpxchg_32.h
@@ -271,7 +271,8 @@ extern unsigned long long cmpxchg_486_u64(volatile void *, u64, u64);
 	__typeof__(*(ptr)) __ret;				\
 	__typeof__(*(ptr)) __old = (o);				\
 	__typeof__(*(ptr)) __new = (n);				\
-	alternative_io("call cmpxchg8b_emu",			\
+	alternative_io(LOCK_PREFIX_HERE				\
+			"call cmpxchg8b_emu",			\
 			"lock; cmpxchg8b (%%esi)" ,		\
 		       X86_FEATURE_CX8,				\
 		       "=A" (__ret),				\
-- 
1.6.6.1.476.g01ddb

