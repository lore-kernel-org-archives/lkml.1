Return-Path: <linux-kernel-owner+w=401wt.eu-S1758632AbYAZWNr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758632AbYAZWNr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jan 2008 17:13:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755596AbYAZWLt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Jan 2008 17:11:49 -0500
Received: from pasmtpb.tele.dk ([80.160.77.98]:41519 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754841AbYAZWLn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jan 2008 17:11:43 -0500
From: Sam Ravnborg <sam@ravnborg.org>
To: Ingo Molnar <mingo@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>, Sam Ravnborg <sam@ravnborg.org>
Subject: [PATCH] x86: fix section mismatch warning in setup_64.c
Date: Sat, 26 Jan 2008 23:11:53 +0100
Message-Id: <1201385513-26885-8-git-send-email-sam@ravnborg.org>
X-Mailer: git-send-email 1.5.3.5.628.ga1309
In-Reply-To: <20080126215917.GB26651@uranus.ravnborg.org>
References: <20080126215917.GB26651@uranus.ravnborg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix the following warning:
WARNING: arch/x86/kernel/built-in.o(.cpuinit.text+0x7a3): Section mismatch: reference to .init.text:amd_detect_cmp in 'init_amd'

The function amd_detect_cmp were annotated __init and
was only used from init_amd() which are annotated __cpuinit.

Annotate amd_detect_cmp() with _cpuinit to fix it.

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
---
 arch/x86/kernel/setup_64.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/setup_64.c b/arch/x86/kernel/setup_64.c
index 0619d8f..c68376a 100644
--- a/arch/x86/kernel/setup_64.c
+++ b/arch/x86/kernel/setup_64.c
@@ -539,7 +539,7 @@ static int nearby_node(int apicid)
  * On a AMD dual core setup the lower bits of the APIC id distingush the cores.
  * Assumes number of cores is a power of two.
  */
-static void __init amd_detect_cmp(struct cpuinfo_x86 *c)
+static void __cpuinit amd_detect_cmp(struct cpuinfo_x86 *c)
 {
 #ifdef CONFIG_SMP
 	unsigned bits;
-- 
1.5.4.rc3.14.g44397

