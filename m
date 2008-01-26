Return-Path: <linux-kernel-owner+w=401wt.eu-S1757774AbYAZWM1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757774AbYAZWM1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jan 2008 17:12:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755117AbYAZWLo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Jan 2008 17:11:44 -0500
Received: from pasmtpa.tele.dk ([80.160.77.114]:41240 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754773AbYAZWLm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jan 2008 17:11:42 -0500
From: Sam Ravnborg <sam@ravnborg.org>
To: Ingo Molnar <mingo@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>, Sam Ravnborg <sam@ravnborg.org>
Subject: [PATCH] x86: fix section mismatch warning in process_*.c
Date: Sat, 26 Jan 2008 23:11:50 +0100
Message-Id: <1201385513-26885-5-git-send-email-sam@ravnborg.org>
X-Mailer: git-send-email 1.5.3.5.628.ga1309
In-Reply-To: <20080126215917.GB26651@uranus.ravnborg.org>
References: <20080126215917.GB26651@uranus.ravnborg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix the following warning:
WARNING: arch/x86/kernel/built-in.o(.text+0x3): Section mismatch: reference to .cpuinit.data:force_mwait in 'mwait_usable'
[Seen on 64 bit only but similar pattern exist on 32 bit so fix it there too]

mwait_usable() were only used by a function annotated __cpuinit
so annotate mwait_usable() with __cpuinit to fix the warning.

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
---
 arch/x86/kernel/process_32.c |    2 +-
 arch/x86/kernel/process_64.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/process_32.c b/arch/x86/kernel/process_32.c
index b72d7d1..968371a 100644
--- a/arch/x86/kernel/process_32.c
+++ b/arch/x86/kernel/process_32.c
@@ -285,7 +285,7 @@ static void mwait_idle(void)
 	mwait_idle_with_hints(0, 0);
 }
 
-static int mwait_usable(const struct cpuinfo_x86 *c)
+static int __cpuinit mwait_usable(const struct cpuinfo_x86 *c)
 {
 	if (force_mwait)
 		return 1;
diff --git a/arch/x86/kernel/process_64.c b/arch/x86/kernel/process_64.c
index 861da57..35f1a0e 100644
--- a/arch/x86/kernel/process_64.c
+++ b/arch/x86/kernel/process_64.c
@@ -281,7 +281,7 @@ static void mwait_idle(void)
 }
 
 
-static int mwait_usable(const struct cpuinfo_x86 *c)
+static int __cpuinit mwait_usable(const struct cpuinfo_x86 *c)
 {
 	if (force_mwait)
 		return 1;
-- 
1.5.4.rc3.14.g44397

