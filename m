Return-Path: <linux-kernel-owner+w=401wt.eu-S1753185AbYL3RSs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753185AbYL3RSs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Dec 2008 12:18:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751923AbYL3RSj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Dec 2008 12:18:39 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:32832 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751853AbYL3RSj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Dec 2008 12:18:39 -0500
Subject: [PATCH] x86: apic.c: xapic_icr_read and x2apic_icr_read should be
	static
From: Jaswinder Singh Rajput <jaswinder@infradead.org>
To: Ingo Molnar <mingo@elte.hu>, x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Tue, 30 Dec 2008 22:46:36 +0530
Message-Id: <1230657396.3469.1.camel@jaswinder.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: cleanup, reduce kernel size a bit, avoid sparse warning

Fixes sparse warning:
arch/x86/kernel/apic.c:270:5: warning: symbol 'x2apic_icr_read' was not declared. Should it be static?

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
---
 arch/x86/include/asm/apic.h |    1 -
 arch/x86/kernel/apic.c      |    4 ++--
 2 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/arch/x86/include/asm/apic.h b/arch/x86/include/asm/apic.h
index e644bf6..ab1d51a 100644
--- a/arch/x86/include/asm/apic.h
+++ b/arch/x86/include/asm/apic.h
@@ -54,7 +54,6 @@ extern int disable_apic;
 extern int is_vsmp_box(void);
 extern void xapic_wait_icr_idle(void);
 extern u32 safe_xapic_wait_icr_idle(void);
-extern u64 xapic_icr_read(void);
 extern void xapic_icr_write(u32, u32);
 extern int setup_profiling_timer(unsigned int);
 
diff --git a/arch/x86/kernel/apic.c b/arch/x86/kernel/apic.c
index cf1cc87..f53a057 100644
--- a/arch/x86/kernel/apic.c
+++ b/arch/x86/kernel/apic.c
@@ -227,7 +227,7 @@ void xapic_icr_write(u32 low, u32 id)
 	apic_write(APIC_ICR, low);
 }
 
-u64 xapic_icr_read(void)
+static u64 xapic_icr_read(void)
 {
 	u32 icr1, icr2;
 
@@ -267,7 +267,7 @@ void x2apic_icr_write(u32 low, u32 id)
 	wrmsrl(APIC_BASE_MSR + (APIC_ICR >> 4), ((__u64) id) << 32 | low);
 }
 
-u64 x2apic_icr_read(void)
+static u64 x2apic_icr_read(void)
 {
 	unsigned long val;
 
-- 
1.6.0.4



