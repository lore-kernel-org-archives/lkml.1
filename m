Return-Path: <linux-kernel-owner+w=401wt.eu-S1755324AbYAUWQH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755324AbYAUWQH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2008 17:16:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756000AbYAUWPt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jan 2008 17:15:49 -0500
Received: from mtaout01-winn.ispmail.ntl.com ([81.103.221.47]:18630 "EHLO
	mtaout01-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755662AbYAUWPr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2008 17:15:47 -0500
From: Ian Campbell <ijc@hellion.org.uk>
To: linux-kernel@vger.kernel.org
Cc: Ian Campbell <ijc@hellion.org.uk>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <andi@firstfloor.org>,
       =?utf-8?q?Mika=20Penttil=C3=A4?= <mika.penttila@kolumbus.fi>
Date: Mon, 21 Jan 2008 22:15:20 +0000
Message-Id: <1200953721-3815-3-git-send-email-ijc@hellion.org.uk>
X-Mailer: git-send-email 1.5.3.8
In-Reply-To: 479510CE.7010706@zytor.com
References: 479510CE.7010706@zytor.com
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 192.168.1.223
X-SA-Exim-Mail-From: ijc@hellion.org.uk
Subject: [PATCH] x86_32: Always run the full set of paging state.
X-SA-Exim-Version: 4.2.1 (built Tue, 09 Jan 2007 17:23:22 +0000)
X-SA-Exim-Scanned: Yes (on hopkins.hellion.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I am preparing to convert the boot time page table to the kernels
native format.  To achieve that I need to enable PAE. Enabling PSE
and the no execute bit would not hurt.  So this patch modifies
the boot cpu path to execute all of the kernels enable code
if and only if we have the proper bits set in mmu_cr4_features.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
Signed-off-by: Ian Campbell <ijc@hellion.org.uk>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Mika Penttilä <mika.penttila@kolumbus.fi>
---
 arch/x86/kernel/head_32.S |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/head_32.S b/arch/x86/kernel/head_32.S
index 7b9b256..a2b6331 100644
--- a/arch/x86/kernel/head_32.S
+++ b/arch/x86/kernel/head_32.S
@@ -221,6 +221,8 @@ ENTRY(startup_32_smp)
 	movl %eax,%es
 	movl %eax,%fs
 	movl %eax,%gs
+#endif /* CONFIG_SMP */
+3:
 
 /*
  *	New page tables may be in 4Mbyte page mode and may
@@ -267,8 +269,6 @@ ENTRY(startup_32_smp)
 	wrmsr
 
 6:
-#endif /* CONFIG_SMP */
-3:
 
 /*
  * Enable paging
-- 
1.5.3.8

