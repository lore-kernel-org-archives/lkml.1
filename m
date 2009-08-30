Return-Path: <linux-kernel-owner+w=401wt.eu-S1753972AbZH3Sn7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753972AbZH3Sn7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Aug 2009 14:43:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753948AbZH3Sn7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Aug 2009 14:43:59 -0400
Received: from hera.kernel.org ([140.211.167.34]:56665 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753937AbZH3Sn6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Aug 2009 14:43:58 -0400
Date: Sun, 30 Aug 2009 18:43:07 GMT
From: tip-bot for Michal Schmidt <mschmidt@redhat.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       mschmidt@redhat.com, jeremy@goop.org, arjan@infradead.org,
       tj@kernel.org, tglx@linutronix.de, mingo@elte.hu
Reply-To: arjan@infradead.org, jeremy@goop.org, mschmidt@redhat.com,
       mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       tj@kernel.org, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20090829182718.10f566b1@leela>
References: <20090829182718.10f566b1@leela>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/asm] x86: Detect stack protector for i386 builds on x86_64
Message-ID: <tip-23386d63bbb3199cf247313ec088878d72debcfd@git.kernel.org>
Git-Commit-ID: 23386d63bbb3199cf247313ec088878d72debcfd
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sun, 30 Aug 2009 18:43:22 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  23386d63bbb3199cf247313ec088878d72debcfd
Gitweb:     http://git.kernel.org/tip/23386d63bbb3199cf247313ec088878d72debcfd
Author:     Michal Schmidt <mschmidt@redhat.com>
AuthorDate: Sat, 29 Aug 2009 18:27:18 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sun, 30 Aug 2009 20:39:48 +0200

x86: Detect stack protector for i386 builds on x86_64

Stack protector support was not detected when building with
ARCH=i386 on x86_64 systems:

  arch/x86/Makefile:80: stack protector enabled but no compiler support

The "-m32" argument needs to be passed to the detection script.

Signed-off-by: Michal Schmidt <mschmidt@redhat.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Arjan van de Ven <arjan@infradead.org>
LKML-Reference: <20090829182718.10f566b1@leela>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
--


---
 arch/x86/Makefile |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/Makefile b/arch/x86/Makefile
index 1b68659..5e7db44 100644
--- a/arch/x86/Makefile
+++ b/arch/x86/Makefile
@@ -72,7 +72,7 @@ endif
 
 ifdef CONFIG_CC_STACKPROTECTOR
 	cc_has_sp := $(srctree)/scripts/gcc-x86_$(BITS)-has-stack-protector.sh
-        ifeq ($(shell $(CONFIG_SHELL) $(cc_has_sp) $(CC)),y)
+        ifeq ($(shell $(CONFIG_SHELL) $(cc_has_sp) $(CC) $(biarch)),y)
                 stackp-y := -fstack-protector
                 stackp-$(CONFIG_CC_STACKPROTECTOR_ALL) += -fstack-protector-all
                 KBUILD_CFLAGS += $(stackp-y)
