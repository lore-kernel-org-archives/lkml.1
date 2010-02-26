Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751321Ab0BZFNY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Feb 2010 00:13:24 -0500
Received: from hera.kernel.org ([140.211.167.34]:51469 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751207Ab0BZFNP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Feb 2010 00:13:15 -0500
Date: Fri, 26 Feb 2010 05:12:52 GMT
From: tip-bot for Luca Barbieri <luca@luca-barbieri.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       luca@luca-barbieri.com, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       luca@luca-barbieri.com, tglx@linutronix.de
In-Reply-To: <1267005265-27958-3-git-send-email-luca@luca-barbieri.com>
References: <1267005265-27958-3-git-send-email-luca@luca-barbieri.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/atomic] x86-32: Allow UP/SMP lock replacement in cmpxchg64
Message-ID: <tip-9c76b38476b18c45f97098a10b0176b321eba3ea@git.kernel.org>
Git-Commit-ID: 9c76b38476b18c45f97098a10b0176b321eba3ea
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 26 Feb 2010 05:12:53 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  9c76b38476b18c45f97098a10b0176b321eba3ea
Gitweb:     http://git.kernel.org/tip/9c76b38476b18c45f97098a10b0176b321eba3ea
Author:     Luca Barbieri <luca@luca-barbieri.com>
AuthorDate: Wed, 24 Feb 2010 10:54:23 +0100
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Thu, 25 Feb 2010 20:47:03 -0800

x86-32: Allow UP/SMP lock replacement in cmpxchg64

Use the functionality just introduced in the previous patch: mark the
lock prefixes in cmpxchg64 alternatives for UP removal.

Changes in v2:
- Naming change

Signed-off-by: Luca Barbieri <luca@luca-barbieri.com>
LKML-Reference: <1267005265-27958-3-git-send-email-luca@luca-barbieri.com>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
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
