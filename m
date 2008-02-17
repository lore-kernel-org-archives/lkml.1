Return-Path: <linux-kernel-owner+w=401wt.eu-S1760338AbYBQMbA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760338AbYBQMbA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2008 07:31:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757611AbYBQMXZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Feb 2008 07:23:25 -0500
Received: from pasmtpa.tele.dk ([80.160.77.114]:38364 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754971AbYBQMW6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2008 07:22:58 -0500
From: Sam Ravnborg <sam@ravnborg.org>
To: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: Sam Ravnborg <sam@ravnborg.org>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH 10/27] x86: fix section mismatch in setup_64.c:srat_detect_node
Date: Sun, 17 Feb 2008 13:22:47 +0100
Message-Id: <1203250984-11285-10-git-send-email-sam@ravnborg.org>
X-Mailer: git-send-email 1.5.4.1.143.ge7e51
In-Reply-To: <20080217121255.GA10519@uranus.ravnborg.org>
References: <20080217121255.GA10519@uranus.ravnborg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix following warnings:
WARNING: vmlinux.o(.text+0x1bb40): Section mismatch in reference from the function srat_detect_node() to the variable .cpuinit.data:apicid_to_node
WARNING: vmlinux.o(.text+0x1bb70): Section mismatch in reference from the function srat_detect_node() to the function .cpuinit.text:numa_set_node()

srat_detect_node() is only used by __cpuinit init_intel().
So the trivial fix is to annotate srat_detect_node() with __cpuinit.

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: H. Peter Anvin <hpa@zytor.com>
---
 arch/x86/kernel/setup_64.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/setup_64.c b/arch/x86/kernel/setup_64.c
index ff9029d..e186617 100644
--- a/arch/x86/kernel/setup_64.c
+++ b/arch/x86/kernel/setup_64.c
@@ -791,7 +791,7 @@ static int __cpuinit intel_num_cpu_cores(struct cpuinfo_x86 *c)
 		return 1;
 }
 
-static void srat_detect_node(void)
+static void __cpuinit srat_detect_node(void)
 {
 #ifdef CONFIG_NUMA
 	unsigned node;
-- 
1.5.4.rc3.14.g44397

