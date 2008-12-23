Return-Path: <linux-kernel-owner+w=401wt.eu-S1753203AbYLWQYb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753203AbYLWQYb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2008 11:24:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751188AbYLWQYV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Dec 2008 11:24:21 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:40736 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750903AbYLWQYU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2008 11:24:20 -0500
Subject: [PATCH] x86: apic.c x2apic_preenabled and disable_x2apic should be
	static
From: Jaswinder Singh <jaswinder@infradead.org>
To: Ingo Molnar <mingo@elte.hu>, x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Tue, 23 Dec 2008 21:52:33 +0530
Message-Id: <1230049353.14358.6.camel@jaswinder.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: cleanup, reduce kernel size a bit, avoid sparse warning

Fixes sparse warning:
arch/x86/kernel/apic.c:103:5: warning: symbol 'disable_x2apic' was not declared. Should it be static?

Signed-off-by: Jaswinder Singh <jaswinder@infradead.org>
---
 arch/x86/include/asm/apic.h |    2 +-
 arch/x86/kernel/apic.c      |    4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/include/asm/apic.h b/arch/x86/include/asm/apic.h
index 25caa07..e644bf6 100644
--- a/arch/x86/include/asm/apic.h
+++ b/arch/x86/include/asm/apic.h
@@ -93,7 +93,7 @@ static inline u32 native_apic_msr_read(u32 reg)
 }
 
 #ifndef CONFIG_X86_32
-extern int x2apic, x2apic_preenabled;
+extern int x2apic;
 extern void check_x2apic(void);
 extern void enable_x2apic(void);
 extern void enable_IR_x2apic(void);
diff --git a/arch/x86/kernel/apic.c b/arch/x86/kernel/apic.c
index a477c0f..cf1cc87 100644
--- a/arch/x86/kernel/apic.c
+++ b/arch/x86/kernel/apic.c
@@ -99,8 +99,8 @@ __setup("apicpmtimer", setup_apicpmtimer);
 #ifdef HAVE_X2APIC
 int x2apic;
 /* x2apic enabled before OS handover */
-int x2apic_preenabled;
-int disable_x2apic;
+static int x2apic_preenabled;
+static int disable_x2apic;
 static __init int setup_nox2apic(char *str)
 {
 	disable_x2apic = 1;
-- 
1.5.5.1



