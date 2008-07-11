Return-Path: <linux-kernel-owner+w=401wt.eu-S1758237AbYGKBOD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758237AbYGKBOD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2008 21:14:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755749AbYGKBNv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jul 2008 21:13:51 -0400
Received: from gw.goop.org ([64.81.55.164]:35493 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755363AbYGKBNu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2008 21:13:50 -0400
Message-ID: <4876B3C0.1070903@goop.org>
Date: Thu, 10 Jul 2008 18:13:36 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH 1a/2] x86_64: vdso32 cleanup using feature flags
References: <487699D0.4030508@goop.org>
In-Reply-To: <487699D0.4030508@goop.org>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the X86_FEATURE_SYSENTER32 to remove hard-coded CPU vendor check.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/vdso/vdso32-setup.c |   11 +----------
 1 file changed, 1 insertion(+), 10 deletions(-)

===================================================================
--- a/arch/x86/vdso/vdso32-setup.c
+++ b/arch/x86/vdso/vdso32-setup.c
@@ -203,20 +203,11 @@ static struct page *vdso32_pages[1];
 
 #ifdef CONFIG_X86_64
 
-static int use_sysenter __read_mostly = -1;
-
-#define	vdso32_sysenter()	(use_sysenter > 0)
+#define	vdso32_sysenter()	(boot_cpu_has(X86_FEATURE_SYSENTER32))
 
 /* May not be __init: called during resume */
 void syscall32_cpu_init(void)
 {
-	if (use_sysenter < 0) {
-		if (boot_cpu_data.x86_vendor == X86_VENDOR_INTEL)
-			use_sysenter = 1;
-		if (boot_cpu_data.x86_vendor == X86_VENDOR_CENTAUR)
-			use_sysenter = 1;
-	}
-
 	/* Load these always in case some future AMD CPU supports
 	   SYSENTER from compat mode too. */
 	checking_wrmsrl(MSR_IA32_SYSENTER_CS, (u64)__KERNEL_CS);


