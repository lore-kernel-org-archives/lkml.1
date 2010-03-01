Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751934Ab0CAT6F (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Mar 2010 14:58:05 -0500
Received: from hera.kernel.org ([140.211.167.34]:40057 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751762Ab0CAT6D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Mar 2010 14:58:03 -0500
Date: Mon, 1 Mar 2010 19:57:36 GMT
From: tip-bot for Luca Barbieri <luca@luca-barbieri.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       luca@luca-barbieri.com, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       luca@luca-barbieri.com, tglx@linutronix.de
In-Reply-To: <1267183361-20775-1-git-send-email-luca@luca-barbieri.com>
References: <1267183361-20775-1-git-send-email-luca@luca-barbieri.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/atomic] lib: Only test atomic64_dec_if_positive on archs having it
Message-ID: <tip-8f4f202b335144bf5be5c9e5b1bc9477ecdae958@git.kernel.org>
Git-Commit-ID: 8f4f202b335144bf5be5c9e5b1bc9477ecdae958
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 01 Mar 2010 19:57:38 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  8f4f202b335144bf5be5c9e5b1bc9477ecdae958
Gitweb:     http://git.kernel.org/tip/8f4f202b335144bf5be5c9e5b1bc9477ecdae958
Author:     Luca Barbieri <luca@luca-barbieri.com>
AuthorDate: Fri, 26 Feb 2010 12:22:40 +0100
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Mon, 1 Mar 2010 11:37:55 -0800

lib: Only test atomic64_dec_if_positive on archs having it

Currently atomic64_dec_if_positive() is only supported by PowerPC,
MIPS and x86-32.

Signed-off-by: Luca Barbieri <luca@luca-barbieri.com>
LKML-Reference: <1267183361-20775-1-git-send-email-luca@luca-barbieri.com>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
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
