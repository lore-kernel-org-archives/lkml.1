Return-Path: <linux-kernel-owner+w=401wt.eu-S1760514AbYBQM31@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760514AbYBQM31 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2008 07:29:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757517AbYBQMXT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Feb 2008 07:23:19 -0500
Received: from pasmtpb.tele.dk ([80.160.77.98]:55086 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755557AbYBQMW6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2008 07:22:58 -0500
From: Sam Ravnborg <sam@ravnborg.org>
To: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: Sam Ravnborg <sam@ravnborg.org>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH 22/27] x86: fix section mismatch in head_64.S:initial_code
Date: Sun, 17 Feb 2008 13:22:59 +0100
Message-Id: <1203250984-11285-22-git-send-email-sam@ravnborg.org>
X-Mailer: git-send-email 1.5.4.1.143.ge7e51
In-Reply-To: <20080217121255.GA10519@uranus.ravnborg.org>
References: <20080217121255.GA10519@uranus.ravnborg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix following warning:
WARNING: vmlinux.o(.cpuinit.data+0x0): Section mismatch in reference from the variable initial_code to the function .init.text:x86_64_start_kernel()

initial_code are initially used to hold a function pointer
from __init and later from __cpuinit. This confuses modpost
and changing initial_code to REFDATA silence the warning.
(But now we do not discard the variable anymore).

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: H. Peter Anvin <hpa@zytor.com>
---
 arch/x86/kernel/head_64.S |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/head_64.S b/arch/x86/kernel/head_64.S
index 09b38d5..220daaa 100644
--- a/arch/x86/kernel/head_64.S
+++ b/arch/x86/kernel/head_64.S
@@ -250,7 +250,7 @@ ENTRY(secondary_startup_64)
 	lretq
 
 	/* SMP bootup changes these two */
-	__CPUINITDATA
+	__REFDATA
 	.align	8
 	ENTRY(initial_code)
 	.quad	x86_64_start_kernel
-- 
1.5.4.rc3.14.g44397

