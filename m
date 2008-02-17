Return-Path: <linux-kernel-owner+w=401wt.eu-S1759470AbYBQM0g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759470AbYBQM0g (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2008 07:26:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757377AbYBQMXJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Feb 2008 07:23:09 -0500
Received: from pasmtpa.tele.dk ([80.160.77.114]:38350 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755332AbYBQMW5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2008 07:22:57 -0500
From: Sam Ravnborg <sam@ravnborg.org>
To: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: Sam Ravnborg <sam@ravnborg.org>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH 09/27] x86: fix section mismatch warning in setup_64.c:nearby_node
Date: Sun, 17 Feb 2008 13:22:46 +0100
Message-Id: <1203250984-11285-9-git-send-email-sam@ravnborg.org>
X-Mailer: git-send-email 1.5.4.1.143.ge7e51
In-Reply-To: <20080217121255.GA10519@uranus.ravnborg.org>
References: <20080217121255.GA10519@uranus.ravnborg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix following warnings:
WARNING: vmlinux.o(.text+0x1baa2): Section mismatch in reference from the function nearby_node() to the variable .cpuinit.data:apicid_to_node
WARNING: vmlinux.o(.text+0x1bace): Section mismatch in reference from the function nearby_node() to the variable .cpuinit.data:apicid_to_node

nearby_node() were only used by __cpuinit amd_detect_cmp()
So annotating nearby_node() __cpuinit was the trivial fix.

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: H. Peter Anvin <hpa@zytor.com>
---
 arch/x86/kernel/setup_64.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/setup_64.c b/arch/x86/kernel/setup_64.c
index c0d8208..ff9029d 100644
--- a/arch/x86/kernel/setup_64.c
+++ b/arch/x86/kernel/setup_64.c
@@ -518,7 +518,7 @@ static void __cpuinit display_cacheinfo(struct cpuinfo_x86 *c)
 }
 
 #ifdef CONFIG_NUMA
-static int nearby_node(int apicid)
+static int __cpuinit nearby_node(int apicid)
 {
 	int i, node;
 
-- 
1.5.4.rc3.14.g44397

