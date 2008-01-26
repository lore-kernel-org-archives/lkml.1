Return-Path: <linux-kernel-owner+w=401wt.eu-S1755388AbYAZWMO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755388AbYAZWMO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jan 2008 17:12:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754920AbYAZWLo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Jan 2008 17:11:44 -0500
Received: from pasmtpb.tele.dk ([80.160.77.98]:41510 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754738AbYAZWLm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jan 2008 17:11:42 -0500
From: Sam Ravnborg <sam@ravnborg.org>
To: Ingo Molnar <mingo@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>, Sam Ravnborg <sam@ravnborg.org>
Subject: [PATCH] x86: fix section mismatch warning in mcheck/mce_amd_64.c
Date: Sat, 26 Jan 2008 23:11:48 +0100
Message-Id: <1201385513-26885-3-git-send-email-sam@ravnborg.org>
X-Mailer: git-send-email 1.5.3.5.628.ga1309
In-Reply-To: <20080126215917.GB26651@uranus.ravnborg.org>
References: <20080126215917.GB26651@uranus.ravnborg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix following warning:
WARNING: arch/x86/kernel/cpu/mcheck/built-in.o(.text+0x1584): Section mismatch: reference to .cpuinit.text:threshold_create_device in 'threshold_cpu_callback'

threshold_cpu_callback() is only used by threshold_cpu_notifier.
threshold_cpu_notifier is only used for cpu hot plug as it is registered
using register_hotcpu_notifier().

Mark them both __cpuinit to fix the warning.

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
---
 arch/x86/kernel/cpu/mcheck/mce_amd_64.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/cpu/mcheck/mce_amd_64.c b/arch/x86/kernel/cpu/mcheck/mce_amd_64.c
index 65621fd..99efacd 100644
--- a/arch/x86/kernel/cpu/mcheck/mce_amd_64.c
+++ b/arch/x86/kernel/cpu/mcheck/mce_amd_64.c
@@ -644,7 +644,7 @@ static void threshold_remove_device(unsigned int cpu)
 }
 
 /* get notified when a cpu comes on/off */
-static int threshold_cpu_callback(struct notifier_block *nfb,
+static int __cpuinit threshold_cpu_callback(struct notifier_block *nfb,
 					    unsigned long action, void *hcpu)
 {
 	/* cpu was unsigned int to begin with */
@@ -669,7 +669,7 @@ static int threshold_cpu_callback(struct notifier_block *nfb,
 	return NOTIFY_OK;
 }
 
-static struct notifier_block threshold_cpu_notifier = {
+static struct notifier_block threshold_cpu_notifier __cpuinitdata = {
 	.notifier_call = threshold_cpu_callback,
 };
 
-- 
1.5.4.rc3.14.g44397

