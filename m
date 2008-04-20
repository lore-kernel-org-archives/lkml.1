Return-Path: <linux-kernel-owner+w=401wt.eu-S1757630AbYDTKdu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757630AbYDTKdu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Apr 2008 06:33:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753715AbYDTKdn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Apr 2008 06:33:43 -0400
Received: from smtp01.mtu.ru ([62.5.255.48]:62727 "EHLO smtp01.mtu.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752688AbYDTKdm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Apr 2008 06:33:42 -0400
From: Dmitri Vorobiev <dmitri.vorobiev@gmail.com>
To: mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com,
       linux-kernel@vger.kernel.org
Subject: [PATCH 2/2 v2] x86: remove unused function, register the cpu vendor in nexgen.c
Date: Sun, 20 Apr 2008 14:33:40 +0400
Message-Id: <1208687620-25597-1-git-send-email-dmitri.vorobiev@gmail.com>
X-Mailer: git-send-email 1.5.3.6
In-Reply-To: <480AC505.1030301@zytor.com>
References: <480AC505.1030301@zytor.com>
X-DCC-STREAM-Metrics: smtp01.mtu.ru 10002; Body=0 Fuz1=0 Fuz2=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nobody calls the function nexgen_init_cpu(), which is defined
in arch/x86/kernel/cpu/nexgen.c. Therefore this routine can
be removed, and this patch does so.

Additionally, this patch adds the missing registration of the
NexGen CPUs by the cpu_vendor_dev_register() macro.

This patch was build-tested using the defconfig for i386. It
also survived a few randconfig instances. Runtime tests were
performed by booting an i386 box up to the shell prompt.

Signed-off-by: Dmitri Vorobiev <dmitri.vorobiev@gmail.com>
---
Peter,

Thanks for your review. Hopefully this version is OK.

 arch/x86/kernel/cpu/nexgen.c |    6 +-----
 1 files changed, 1 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kernel/cpu/nexgen.c b/arch/x86/kernel/cpu/nexgen.c
index 5d5e1c1..3117e96 100644
--- a/arch/x86/kernel/cpu/nexgen.c
+++ b/arch/x86/kernel/cpu/nexgen.c
@@ -52,8 +52,4 @@ static struct cpu_dev nexgen_cpu_dev __cpuinitdata = {
 	.c_identify	= nexgen_identify,
 };
 
-int __init nexgen_init_cpu(void)
-{
-	cpu_devs[X86_VENDOR_NEXGEN] = &nexgen_cpu_dev;
-	return 0;
-}
+cpu_vendor_dev_register(X86_VENDOR_NEXGEN, &nexgen_cpu_dev);
-- 
1.5.3

