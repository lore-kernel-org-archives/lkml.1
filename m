Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934808Ab0BZLW5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Feb 2010 06:22:57 -0500
Received: from mail-fx0-f219.google.com ([209.85.220.219]:37561 "EHLO
	mail-fx0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934303Ab0BZLWz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Feb 2010 06:22:55 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer;
        b=ZZuIkAFiikp1FkF+a/jU3oO9VQhWEzkirffb90tazAcmbaXX2MQ/2/MEj2zcxrBL/X
         YJSkOx0YQBfIqLUGk32/D/iEjd4H0pw19K3Ye6igW63g8SvW8Sk5RS238vsEg0XU03ce
         Ef8nm4gXUALWil64Vh1ZbCZKdIlYmrRw2Mexw=
From: Luca Barbieri <luca@luca-barbieri.com>
To: mingo@elte.hu
Cc: hpa@zytor.com, a.p.zijlstra@chello.nl, linux-kernel@vger.kernel.org,
       Luca Barbieri <luca@luca-barbieri.com>
Subject: [PATCH 1/2] lib: only test atomic64_dec_if_positive on archs having it
Date: Fri, 26 Feb 2010 12:22:40 +0100
Message-Id: <1267183361-20775-1-git-send-email-luca@luca-barbieri.com>
X-Mailer: git-send-email 1.6.6.1.476.g01ddb
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Only supported by ppc, mips and x86-32 with my patchset.

Signed-off-by: Luca Barbieri <luca@luca-barbieri.com>
---
 lib/atomic64_test.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/lib/atomic64_test.c b/lib/atomic64_test.c
index 4ff649e..0effcac 100644
--- a/lib/atomic64_test.c
+++ b/lib/atomic64_test.c
@@ -112,6 +112,7 @@ static __init int test_atomic64(void)
 	r += one;
 	BUG_ON(v.counter != r);
 
+#if defined(CONFIG_X86_32) || defined(CONFIG_MIPS) || defined(CONFIG_PPC) || defined(_ASM_GENERIC_ATOMIC64_H)
 	INIT(onestwos);
 	BUG_ON(atomic64_dec_if_positive(&v) != (onestwos - 1));
 	r -= one;
@@ -124,6 +125,9 @@ static __init int test_atomic64(void)
 	INIT(-one);
 	BUG_ON(atomic64_dec_if_positive(&v) != (-one - one));
 	BUG_ON(v.counter != r);
+#else
+#warning Please implement atomic64_dec_if_positive for your architecture, and add it to the IF above
+#endif
 
 	INIT(onestwos);
 	BUG_ON(atomic64_inc_not_zero(&v));
-- 
1.6.6.1.476.g01ddb

