Return-Path: <linux-kernel-owner+w=401wt.eu-S1759372AbYLPUdw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759372AbYLPUdw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2008 15:33:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751190AbYLPUdm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 15:33:42 -0500
Received: from gw.goop.org ([64.81.55.164]:58018 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750879AbYLPUdm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 15:33:42 -0500
Message-ID: <494810A4.2060503@goop.org>
Date: Tue, 16 Dec 2008 12:33:40 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.18 (X11/20081119)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86: make apic_* operations inline functions
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mainly to get proper type-checking and consistency.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/include/asm/apic.h |   35 +++++++++++++++++++++++++++++------
 1 file changed, 29 insertions(+), 6 deletions(-)

===================================================================
--- a/arch/x86/include/asm/apic.h
+++ b/arch/x86/include/asm/apic.h
@@ -125,12 +125,35 @@
 
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
 


