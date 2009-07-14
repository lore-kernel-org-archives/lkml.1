Return-Path: <linux-kernel-owner+w=401wt.eu-S1754870AbZGNO22@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754870AbZGNO22 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jul 2009 10:28:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754846AbZGNO21
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Jul 2009 10:28:27 -0400
Received: from hera.kernel.org ([140.211.167.34]:45852 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754800AbZGNO2Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jul 2009 10:28:25 -0400
Date: Tue, 14 Jul 2009 14:28:01 GMT
From: tip-bot for Dave Jones <davej@redhat.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       davej@redhat.com, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, davej@redhat.com
In-Reply-To: <20090713201437.GA12165@redhat.com>
References: <20090713201437.GA12165@redhat.com>
Subject: [tip:x86/urgent] x86: Fix warning in pvclock.c
Message-ID: <tip-2ad76643ff58bb8841f391ea8327c14abe273ea3@git.kernel.org>
Git-Commit-ID: 2ad76643ff58bb8841f391ea8327c14abe273ea3
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 14 Jul 2009 14:28:02 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  2ad76643ff58bb8841f391ea8327c14abe273ea3
Gitweb:     http://git.kernel.org/tip/2ad76643ff58bb8841f391ea8327c14abe273ea3
Author:     Dave Jones <davej@redhat.com>
AuthorDate: Mon, 13 Jul 2009 16:14:37 -0400
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Tue, 14 Jul 2009 16:25:05 +0200

x86: Fix warning in pvclock.c

when building 32-bit, I see this ..
arch/x86/kernel/pvclock.c:63:7: warning: "__x86_64__" is not defined

Signed-off-by: Dave Jones <davej@redhat.com>
LKML-Reference: <20090713201437.GA12165@redhat.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>



---
 arch/x86/kernel/pvclock.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/pvclock.c b/arch/x86/kernel/pvclock.c
index 4f9c55f..03801f2 100644
--- a/arch/x86/kernel/pvclock.c
+++ b/arch/x86/kernel/pvclock.c
@@ -60,7 +60,7 @@ static inline u64 scale_delta(u64 delta, u32 mul_frac, int shift)
 		"adc  %5,%%edx ; "
 		: "=A" (product), "=r" (tmp1), "=r" (tmp2)
 		: "a" ((u32)delta), "1" ((u32)(delta >> 32)), "2" (mul_frac) );
-#elif __x86_64__
+#elif defined(__x86_64__)
 	__asm__ (
 		"mul %%rdx ; shrd $32,%%rdx,%%rax"
 		: "=a" (product) : "0" (delta), "d" ((u64)mul_frac) );
