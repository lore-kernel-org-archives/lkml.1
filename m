Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756248Ab0BXJyh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Feb 2010 04:54:37 -0500
Received: from mail-fx0-f219.google.com ([209.85.220.219]:65005 "EHLO
	mail-fx0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755578Ab0BXJyd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Feb 2010 04:54:33 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=wp6Mq1/7tDVUtP8Jx+KCE/MZ/5OBEwL9CqtAgGbzocD0UOUugip8T9FSoE4b71eU/e
         Hgv7UquR8X5lg9h9mCKy+RZp6qaM34cdclA9dhzPGpiqNldAJXYmyGGKGzmcAkoFxwFz
         7VCgbtBpH60tY1A8dhQGj9wKZeW54K/0iuDqA=
From: Luca Barbieri <luca@luca-barbieri.com>
To: hpa@zytor.com
Cc: mingo@elte.hu, a.p.zijlstra@chello.nl, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, Luca Barbieri <luca@luca-barbieri.com>
Subject: [PATCH 2/4] x86-32: allow UP/SMP lock replacement in cmpxchg64 (v2)
Date: Wed, 24 Feb 2010 10:54:23 +0100
Message-Id: <1267005265-27958-3-git-send-email-luca@luca-barbieri.com>
X-Mailer: git-send-email 1.6.6.1.476.g01ddb
In-Reply-To: <1267005265-27958-1-git-send-email-luca@luca-barbieri.com>
References: <1267005265-27958-1-git-send-email-luca@luca-barbieri.com>
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

