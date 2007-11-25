Return-Path: <linux-kernel-owner+w=401wt.eu-S1758880AbXKYWIe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758880AbXKYWIe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Nov 2007 17:08:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758693AbXKYWIJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Nov 2007 17:08:09 -0500
Received: from mx1.redhat.com ([66.187.233.31]:57006 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758738AbXKYWIG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Nov 2007 17:08:06 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
X-Fcc: ~/Mail/linus
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH 23/27] x86: debugctlmsr kconfig
In-Reply-To: Roland McGrath's message of  Sunday, 25 November 2007 13:55:07 -0800 <20071125215507.4B89226F8C5@magilla.localdomain>
References: <20071125215507.4B89226F8C5@magilla.localdomain>
X-Shopping-List: (1) Litigious approval accusers
   (2) Indecent furious cancer
   (3) Garden-variety persuasion inquisitions
Message-Id: <20071125220802.76C2F26F8C5@magilla.localdomain>
Date: Sun, 25 Nov 2007 14:08:02 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


This adds the (internal) Kconfig macro CONFIG_X86_DEBUGCTLMSR,
to be defined when configuring to support only hardware that
definitely supports MSR_IA32_DEBUGCTLMSR with the BTF flag.

The Intel documentation says "P6 family" and later processors all have it.
I think the Kconfig dependencies are right to have it set for those and
unset for others (i.e., when 586 and earlier are supported).

Signed-off-by: Roland McGrath <roland@redhat.com>
---
 arch/x86/Kconfig.cpu |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/arch/x86/Kconfig.cpu b/arch/x86/Kconfig.cpu
index c301622..69e2ee4 100644
--- a/arch/x86/Kconfig.cpu
+++ b/arch/x86/Kconfig.cpu
@@ -399,3 +399,7 @@ config X86_MINIMUM_CPU_FAMILY
 	default "4" if X86_32 && (X86_XADD || X86_CMPXCHG || X86_BSWAP || X86_WP_WORKS_OK)
 	default "3"
 
+config X86_DEBUGCTLMSR
+	bool
+	depends on !(M586MMX || M586TSC || M586 || M486 || M386)
+	default y
