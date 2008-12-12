Return-Path: <linux-kernel-owner+w=401wt.eu-S1759634AbYLLSI7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759634AbYLLSI7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2008 13:08:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757928AbYLLSIv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Dec 2008 13:08:51 -0500
Received: from outbound-wa4.frontbridge.com ([216.32.181.16]:49692 "EHLO
	WA4EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756249AbYLLSIv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2008 13:08:51 -0500
X-BigFish: VPS-7(z6c9R34a4jzzzzzz32i6bh61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0KBRZQB-01-K3L-01
Date: Fri, 12 Dec 2008 19:08:27 +0100
From: Andreas Herrmann <andreas.herrmann3@amd.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
CC: linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] x86: don't enable MCE after suspend/resume when system
	was booted with "nomce"
Message-ID: <20081212180827.GT19144@alberich.amd.com>
References: <20081212180650.GS19144@alberich.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20081212180650.GS19144@alberich.amd.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 12 Dec 2008 18:08:38.0366 (UTC) FILETIME=[A82BEFE0:01C95C84]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: fix suspend/resume bug with MCE

A suspend/resume cycle unconditionally enables MCE
for the boot CPU if MCE is compiled into the kernel.
I.e. even a system booted with "nomce" configures MCE for the boot CPU.

This patch ensures that MCE is not turned on for systems booted with
"nomce".

Signed-off-by: Andreas Herrmann <andreas.herrmann3@amd.com>
---
 arch/x86/kernel/cpu/mcheck/mce_64.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/cpu/mcheck/mce_64.c b/arch/x86/kernel/cpu/mcheck/mce_64.c
index 4b031a4..e2d9649 100644
--- a/arch/x86/kernel/cpu/mcheck/mce_64.c
+++ b/arch/x86/kernel/cpu/mcheck/mce_64.c
@@ -443,6 +443,9 @@ static void mce_init(void *dummy)
 	u64 cap;
 	int i;
 
+	if (mce_dont_init)
+		return;
+
 	rdmsrl(MSR_IA32_MCG_CAP, cap);
 	banks = cap & 0xff;
 	if (banks > MCE_EXTENDED_BANK) {
-- 
1.6.0.4



