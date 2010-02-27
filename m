Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030608Ab0B0S0A (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Feb 2010 13:26:00 -0500
Received: from mail-ew0-f220.google.com ([209.85.219.220]:42919 "EHLO
	mail-ew0-f220.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030416Ab0B0SZp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Feb 2010 13:25:45 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=qYaFz48v5mn0Z5kdyw1R6HywRXkqMz0Ky9n6eS9JYJ7GeFMv+cOhUTkKa4zZD3wx4j
         hvzTBX3Vw7GtUsCnYkL77ZpAJu5PhAG1ubGljbhQOsIM5xUZjA0HM0c+Vgi+CbEIqu3v
         bfVd0B80n4qzNx7ATUux2QgD6kGr86hU1h5OY=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       "K.Prasad" <prasad@linux.vnet.ibm.com>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5/5] x86/hw-breakpoints: Remove the name field
Date: Sat, 27 Feb 2010 19:25:33 +0100
Message-Id: <1267295133-6320-6-git-send-regression-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <1267295133-6320-1-git-send-regression-fweisbec@gmail.com>
References: <1267295133-6320-1-git-send-regression-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the name field from the arch_hw_breakpoint. We never deal
with target symbols in the arch level, neither do we need to ever
store it. It's a legacy for the previous version of the x86
breakpoint backend.

Let's remove it.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: K.Prasad <prasad@linux.vnet.ibm.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
---
 arch/x86/include/asm/hw_breakpoint.h |    1 -
 arch/x86/kernel/hw_breakpoint.c      |    7 -------
 2 files changed, 0 insertions(+), 8 deletions(-)

diff --git a/arch/x86/include/asm/hw_breakpoint.h b/arch/x86/include/asm/hw_breakpoint.h
index 0675a7c..2a1bd8f 100644
--- a/arch/x86/include/asm/hw_breakpoint.h
+++ b/arch/x86/include/asm/hw_breakpoint.h
@@ -10,7 +10,6 @@
  * (display/resolving)
  */
 struct arch_hw_breakpoint {
-	char		*name; /* Contains name of the symbol to set bkpt */
 	unsigned long	address;
 	u8		len;
 	u8		type;
diff --git a/arch/x86/kernel/hw_breakpoint.c b/arch/x86/kernel/hw_breakpoint.c
index dca2802..41e08df 100644
--- a/arch/x86/kernel/hw_breakpoint.c
+++ b/arch/x86/kernel/hw_breakpoint.c
@@ -344,13 +344,6 @@ int arch_validate_hwbkpt_settings(struct perf_event *bp,
 	}
 
 	/*
-	 * For kernel-addresses, either the address or symbol name can be
-	 * specified.
-	 */
-	if (info->name)
-		info->address = (unsigned long)
-				kallsyms_lookup_name(info->name);
-	/*
 	 * Check that the low-order bits of the address are appropriate
 	 * for the alignment implied by len.
 	 */
-- 
1.6.2.3

