Return-Path: <linux-kernel-owner+w=401wt.eu-S1757336AbYAZWM5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757336AbYAZWM5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jan 2008 17:12:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755299AbYAZWLr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Jan 2008 17:11:47 -0500
Received: from pasmtpa.tele.dk ([80.160.77.114]:41242 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754816AbYAZWLn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jan 2008 17:11:43 -0500
From: Sam Ravnborg <sam@ravnborg.org>
To: Ingo Molnar <mingo@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>, Sam Ravnborg <sam@ravnborg.org>
Subject: [PATCH] x86: fix section mismatch warning in early-quirks.c
Date: Sat, 26 Jan 2008 23:11:52 +0100
Message-Id: <1201385513-26885-7-git-send-email-sam@ravnborg.org>
X-Mailer: git-send-email 1.5.3.5.628.ga1309
In-Reply-To: <20080126215917.GB26651@uranus.ravnborg.org>
References: <20080126215917.GB26651@uranus.ravnborg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix following warnings:
WARNING: arch/x86/kernel/built-in.o(.text+0x139e1): Section mismatch: reference to .init.data:early_qrk in 'check_dev_quirk'
WARNING: arch/x86/kernel/built-in.o(.text+0x139f5): Section mismatch: reference to .init.data:early_qrk in 'check_dev_quirk'
WARNING: arch/x86/kernel/built-in.o(.text+0x13a0c): Section mismatch: reference to .init.data:early_qrk in 'check_dev_quirk'
WARNING: arch/x86/kernel/built-in.o(.text+0x13a12): Section mismatch: reference to .init.data:early_qrk in 'check_dev_quirk'
WARNING: arch/x86/kernel/built-in.o(.text+0x13a1a): Section mismatch: reference to .init.data:early_qrk in 'check_dev_quirk'
WARNING: arch/x86/kernel/built-in.o(.text+0x13a36): Section mismatch: reference to .init.data:early_qrk in 'check_dev_quirk'
WARNING: arch/x86/kernel/built-in.o(.text+0x13a42): Section mismatch: reference to .init.data:

Warning was caused by access to the __initdata annotated variable
from the non-annotated static function check_dev_quirk().
check_dev_quirk() were only used from a function annotated
__init so add __init annotation to check_dev_quirk() to fix it.

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
---
 arch/x86/kernel/early-quirks.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/early-quirks.c b/arch/x86/kernel/early-quirks.c
index 3f88e43..9f51e1e 100644
--- a/arch/x86/kernel/early-quirks.c
+++ b/arch/x86/kernel/early-quirks.c
@@ -133,7 +133,7 @@ static struct chipset early_qrk[] __initdata = {
 	{}
 };
 
-static void check_dev_quirk(int num, int slot, int func)
+static void __init check_dev_quirk(int num, int slot, int func)
 {
 	u16 class;
 	u16 vendor;
-- 
1.5.4.rc3.14.g44397

