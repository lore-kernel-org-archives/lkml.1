Return-Path: <linux-kernel-owner+w=401wt.eu-S1755013AbYKMTgm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755013AbYKMTgm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2008 14:36:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753714AbYKMTeL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Nov 2008 14:34:11 -0500
Received: from gw.goop.org ([64.81.55.164]:34391 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752306AbYKMTeE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2008 14:34:04 -0500
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 08 of 38] x86: make apic_* operations inline functions
X-Mercurial-Node: c1b35b7a9732b5a3a17c3444087231409c331b8e
Message-Id: <c1b35b7a9732b5a3a17c.1226603406@abulafia.goop.org>
In-Reply-To: <patchbomb.1226603398@abulafia.goop.org>
Date: Thu, 13 Nov 2008 11:10:06 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Xen-devel <xen-devel@lists.xensource.com>,
       the arch/x86 maintainers <x86@kernel.org>,
       Ian Campbell <ian.campbell@citrix.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mainly to get proper type-checking and consistency.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/include/asm/apic.h |   35 +++++++++++++++++++++++++++++------
 1 file changed, 29 insertions(+), 6 deletions(-)

diff --git a/arch/x86/include/asm/apic.h b/arch/x86/include/asm/apic.h
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
 


