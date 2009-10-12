Return-Path: <linux-kernel-owner+w=401wt.eu-S1756058AbZJLLLi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756058AbZJLLLi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 07:11:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754383AbZJLLLh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 07:11:37 -0400
Received: from hera.kernel.org ([140.211.167.34]:41370 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750983AbZJLLLg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 07:11:36 -0400
Date: Mon, 12 Oct 2009 11:10:22 GMT
From: tip-bot for Arjan van de Ven <arjan@infradead.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       torvalds@linux-foundation.org, arjan@linux.intel.com,
       arjan@infradead.org, hmh@hmh.eng.br, rdreier@cisco.com,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       arjan@linux.intel.com, torvalds@linux-foundation.org,
       arjan@infradead.org, hmh@hmh.eng.br, rdreier@cisco.com,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20091011103302.62bded41@infradead.org>
References: <20091011103302.62bded41@infradead.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/pat] x86: Relegate CONFIG_PAT and CONFIG_MTRR configurability to EMBEDDED
Message-ID: <tip-c03cb3149daed3e411657e3212d05ae27cf1a874@git.kernel.org>
Git-Commit-ID: c03cb3149daed3e411657e3212d05ae27cf1a874
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Mon, 12 Oct 2009 11:10:23 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  c03cb3149daed3e411657e3212d05ae27cf1a874
Gitweb:     http://git.kernel.org/tip/c03cb3149daed3e411657e3212d05ae27cf1a874
Author:     Arjan van de Ven <arjan@infradead.org>
AuthorDate: Sun, 11 Oct 2009 10:33:02 -0700
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 12 Oct 2009 13:06:57 +0200

x86: Relegate CONFIG_PAT and CONFIG_MTRR configurability to EMBEDDED

MTRR and PAT support (which got added to CPUs over 10 years ago)
are no longer really optional in that more and more things are
depending on PAT just working, including various drivers and newer
versions of X.  (to not even speak of MTRR)

Having this as a regular config option just no longer makes sense.

This patch relegates CONFIG_X86_PAT to the EMBEDDED category so
ultra-embedded can still disable it if they really need to.

Also-Suggested-by: Roland Dreier <rdreier@cisco.com>
Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
LKML-Reference: <20091011103302.62bded41@infradead.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/Kconfig |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index c876bac..a67363b 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -1321,7 +1321,9 @@ config MATH_EMULATION
 	  kernel, it won't hurt.
 
 config MTRR
-	bool "MTRR (Memory Type Range Register) support"
+	bool
+	default y
+	prompt "MTRR (Memory Type Range Register) support" if EMBEDDED
 	---help---
 	  On Intel P6 family processors (Pentium Pro, Pentium II and later)
 	  the Memory Type Range Registers (MTRRs) may be used to control
@@ -1387,7 +1389,8 @@ config MTRR_SANITIZER_SPARE_REG_NR_DEFAULT
 
 config X86_PAT
 	bool
-	prompt "x86 PAT support"
+	default y
+	prompt "x86 PAT support" if EMBEDDED
 	depends on MTRR
 	---help---
 	  Use PAT attributes to setup page level cache control.
