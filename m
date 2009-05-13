Return-Path: <linux-kernel-owner+w=401wt.eu-S1761922AbZEMWCc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761922AbZEMWCc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 May 2009 18:02:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751088AbZEMWCX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 May 2009 18:02:23 -0400
Received: from hera.kernel.org ([140.211.167.34]:56656 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750760AbZEMWCW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 May 2009 18:02:22 -0400
Subject: [PATCH 1/2] x86: apic/apic.c declare default_init_apic_ldr()
 before it get used
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Ingo Molnar <mingo@elte.hu>, x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Thu, 14 May 2009 03:27:21 +0530
Message-Id: <1242251841.3364.17.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


default_init_apic_ldr() is also required for 64 bit so moving it out
from CONFIG_X86_32.

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
---
 arch/x86/include/asm/apic.h |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/x86/include/asm/apic.h b/arch/x86/include/asm/apic.h
index 229d0be..d1acc60 100644
--- a/arch/x86/include/asm/apic.h
+++ b/arch/x86/include/asm/apic.h
@@ -469,10 +469,6 @@ static inline unsigned int read_apic_id(void)
 
 extern void default_setup_apic_routing(void);
 
-#ifdef CONFIG_X86_32
-
-extern struct apic apic_default;
-
 /*
  * Set up the logical destination ID.
  *
@@ -482,6 +478,10 @@ extern struct apic apic_default;
  */
 extern void default_init_apic_ldr(void);
 
+#ifdef CONFIG_X86_32
+
+extern struct apic apic_default;
+
 static inline int default_apic_id_registered(void)
 {
 	return physid_isset(read_apic_id(), phys_cpu_present_map);
-- 
1.6.0.6



