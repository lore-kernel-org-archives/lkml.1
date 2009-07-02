Return-Path: <linux-kernel-owner+w=401wt.eu-S1752791AbZGBRE0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752791AbZGBRE0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jul 2009 13:04:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751838AbZGBRES
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Jul 2009 13:04:18 -0400
Received: from hera.kernel.org ([140.211.167.34]:58544 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751783AbZGBRES (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jul 2009 13:04:18 -0400
Subject: [PATCH -tip] x86: Remove useless variable disable_x2apic
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Ingo Molnar <mingo@elte.hu>, Yinghai Lu <yinghai@kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Cyrill Gorcunov <gorcunov@gmail.com>, x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Thu, 02 Jul 2009 22:33:59 +0530
Message-Id: <1246554239.2242.27.camel@jaswinder.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 (2.26.1-2.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


setup_nox2apic() is writing 1 to disable_x2apic but no one is reading it.

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
---
 arch/x86/kernel/apic/apic.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
index 8c7c042..0a1c283 100644
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -140,7 +140,6 @@ int x2apic_mode;
 #ifdef CONFIG_X86_X2APIC
 /* x2apic enabled before OS handover */
 static int x2apic_preenabled;
-static int disable_x2apic;
 static __init int setup_nox2apic(char *str)
 {
 	if (x2apic_enabled()) {
@@ -149,7 +148,6 @@ static __init int setup_nox2apic(char *str)
 		return 0;
 	}
 
-	disable_x2apic = 1;
 	setup_clear_cpu_cap(X86_FEATURE_X2APIC);
 	return 0;
 }
-- 
1.6.2.5



