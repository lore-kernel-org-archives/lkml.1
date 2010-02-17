Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757206Ab0BQLoX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Feb 2010 06:44:23 -0500
Received: from mail-fx0-f215.google.com ([209.85.220.215]:61014 "EHLO
	mail-fx0-f215.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756202Ab0BQLm5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Feb 2010 06:42:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=DWys//+06+TMVcPuv1/WLld2nl383Le2pwmNj4XBisDbzE8xoHkPwJYiimqRWqTG8k
         Bv8hdrUUvWwfbMBw8Ti4Hk7a91rOmhlt/c5gtVUejCNZySWugZ8o8wejUAbJ9yq//YXc
         mVZ7lT/PxPkikyg4usP8rvg8j+VK4c4fyUHog=
From: Luca Barbieri <luca@luca-barbieri.com>
To: mingo@elte.hu
Cc: hpa@zytor.com, a.p.zijlstra@chello.nl, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, Luca Barbieri <luca@luca-barbieri.com>
Subject: [PATCH 04/10] x86-32: allow UP/SMP lock replacement in cmpxchg64
Date: Wed, 17 Feb 2010 12:42:36 +0100
Message-Id: <1266406962-17463-5-git-send-email-luca@luca-barbieri.com>
X-Mailer: git-send-email 1.6.6.1.476.g01ddb
In-Reply-To: <1266406962-17463-1-git-send-email-luca@luca-barbieri.com>
References: <1266406962-17463-1-git-send-email-luca@luca-barbieri.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the functionality just introduced in the previous patch.
---
 arch/x86/include/asm/cmpxchg_32.h |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/arch/x86/include/asm/cmpxchg_32.h b/arch/x86/include/asm/cmpxchg_32.h
index ffb9bb6..3c267e0 100644
--- a/arch/x86/include/asm/cmpxchg_32.h
+++ b/arch/x86/include/asm/cmpxchg_32.h
@@ -271,7 +271,8 @@ extern unsigned long long cmpxchg_486_u64(volatile void *, u64, u64);
 	__typeof__(*(ptr)) __ret;				\
 	__typeof__(*(ptr)) __old = (o);				\
 	__typeof__(*(ptr)) __new = (n);				\
-	alternative_io("call cmpxchg8b_emu",			\
+	alternative_io(LOCK_PREFIX_ALTERNATIVE_PATCH		\
+			"call cmpxchg8b_emu",			\
 			"lock; cmpxchg8b (%%esi)" ,		\
 		       X86_FEATURE_CX8,				\
 		       "=A" (__ret),				\
-- 
1.6.6.1.476.g01ddb

