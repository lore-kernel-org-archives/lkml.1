Return-Path: <linux-kernel-owner+w=401wt.eu-S1756186AbZBJUHu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756186AbZBJUHu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Feb 2009 15:07:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755238AbZBJUH1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Feb 2009 15:07:27 -0500
Received: from gw.goop.org ([64.81.55.164]:50703 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754813AbZBJUH0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Feb 2009 15:07:26 -0500
Message-Id: <3c552ac8a747d6c26d13302c54d71dae9f56f4ac.1234296039.git.jeremy.fitzhardinge@citrix.com>
In-Reply-To: <cover.1234296039.git.jeremy.fitzhardinge@citrix.com>
References: <cover.1234296039.git.jeremy.fitzhardinge@citrix.com>
From: Jeremy Fitzhardinge <jeremy@goop.org>
Date: Mon, 9 Feb 2009 12:05:47 -0800
Subject: [PATCH] x86: make apic_* operations inline functions
Cc: Ingo Molnar <mingo@elte.hu>, x86@kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Yinghai Lu <yinghai@kernel.org>
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mainly to get proper type-checking and consistency.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/include/asm/apic.h |   35 +++++++++++++++++++++++++++++------
 1 files changed, 29 insertions(+), 6 deletions(-)

diff --git a/arch/x86/include/asm/apic.h b/arch/x86/include/asm/apic.h
index b03711d..f4835a1 100644
--- a/arch/x86/include/asm/apic.h
+++ b/arch/x86/include/asm/apic.h
@@ -139,12 +139,35 @@ struct apic_ops {
 
 extern struct apic_ops *apic_ops;
 
-#define apic_read (apic_ops->read)
-#define apic_write (apic_ops->write)
-#define apic_icr_read (apic_ops->icr_read)
-#define apic_icr_write (apic_ops->icr_write)
-#define apic_wait_icr_idle (apic_ops->wait_icr_idle)
-#define safe_apic_wait_icr_idle (apic_ops->safe_wait_icr_idle)
+static inline u32 apic_read(u32 reg)
+{
+	return apic_ops->read(reg);
+}
+
+static inline void apic_write(u32 reg, u32 val)
+{
+	apic_ops->write(reg, val);
+}
+
+static inline u64 apic_icr_read(void)
+{
+	return apic_ops->icr_read();
+}
+
+static inline void apic_icr_write(u32 low, u32 high)
+{
+	apic_ops->icr_write(low, high);
+}
+
+static inline void apic_wait_icr_idle(void)
+{
+	apic_ops->wait_icr_idle();
+}
+
+static inline u32 safe_apic_wait_icr_idle(void)
+{
+	return apic_ops->safe_wait_icr_idle();
+}
 
 extern int get_physical_broadcast(void);
 
-- 
1.6.0.6


