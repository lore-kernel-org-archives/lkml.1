Return-Path: <linux-kernel-owner+w=401wt.eu-S1757800AbYEDQWd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757800AbYEDQWd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2008 12:22:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753584AbYEDQWY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 May 2008 12:22:24 -0400
Received: from 178-47-31-89.wifiinternet.cz ([89.31.47.178]:59084 "EHLO
	seznam.cz" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753506AbYEDQWX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2008 12:22:23 -0400
From: monstr@seznam.cz
To: linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linux-arch@vger.kernel.org, stephen.neuendorffer@xilinx.com,
       John.Linn@xilinx.com, john.williams@petalogix.com, matthew@wil.cx,
       will.newton@gmail.com, drepper@redhat.com,
       microblaze-uclinux@itee.uq.edu.au, grant.likely@secretlab.ca,
       Michal Simek <monstr@monstr.eu>
Subject: [PATCH 38/56] microblaze_v2: atomic.h bitops.h byteorder.h
Date: Sun,  4 May 2008 13:41:27 +0200
Message-Id: <49eccf3408b90a5ebb42635493bbeef3b584acb9.1209897266.git.monstr@monstr.eu>
X-Mailer: git-send-email 1.5.4.GIT
In-Reply-To: <4e20213f5f296268a24955df8c951f7fba279816.1209897266.git.monstr@monstr.eu>
References: <1209901305-6404-1-git-send-email-monstr@seznam.cz>
 <a4a778e34c66d126f5c4bf1ca423cf32950ea5ab.1209897266.git.monstr@monstr.eu>
 <c805caeb1dd7f6d1349c4a463cb88a5342a170d2.1209897266.git.monstr@monstr.eu>
 <f120ababf2bade9aab7199bffb3014aa606e5a1c.1209897266.git.monstr@monstr.eu>
 <684c36e5ad3f598e5079e88ec195545c4a7150c2.1209897266.git.monstr@monstr.eu>
 <ed3695121faf485d491cecdd96d5d4dcc498411d.1209897266.git.monstr@monstr.eu>
 <0674b1f7abb9a3d564b68c95bc28adc2c2fe9551.1209897266.git.monstr@monstr.eu>
 <9a7c6646e5dd9724c1cf34767adec181481fa3ef.1209897266.git.monstr@monstr.eu>
 <932956128c9c655a218a940eaf02017a5dd0bdf9.1209897266.git.monstr@monstr.eu>
 <2f801c33caee22e112af51ae927c264ce99ead01.1209897266.git.monstr@monstr.eu>
 <2391e49379fb6639f57d9d6e5811f3d49a4c6fda.1209897266.git.monstr@monstr.eu>
 <0873f3a1f3b72591735c6461b51964693cac52e5.1209897266.git.monstr@monstr.eu>
 <0ba1f259d3c17eba54e334622493577493f5065f.1209897266.git.monstr@monstr.eu>
 <694451053534fea7b78fb9d618b53a2b5ebeb602.1209897266.git.monstr@monstr.eu>
 <f0c837df4106a31c1a81917596603918f722ea7b.1209897266.git.monstr@monstr.eu>
 <d883a8d8da812d77fefd47730d28d0bdb7b504e0.1209897266.git.monstr@monstr.eu>
 <625ef466cf121d655539eedc919dd39166087e0c.1209897266.git.monstr@monstr.eu>
 <b5067a1846075ddd1035966ea1edc908579e2e88.1209897266.git.monstr@monstr.eu>
 <378157891bac535dbc55e658d5f03fdd332e85cf.1209897266.git.monstr@monstr.eu>
 <eadcc6f4754df78b69d6d54c404624d0390c8558.1209897266.git.monstr@monstr.eu>
 <4df4022e06b9056202cc2fdf0b99deb01563a0fa.1209897266.git.monstr@monstr.eu>
 <6b0c9864dc80776ae48d6488a6892e5d698751b7.1209897266.git.monstr@monstr.eu>
 <ea5cbbca49c38c506960fddba29cbd8cb24e1a8d.1209897266.git.monstr@monstr.eu>
 <4f4d6ed3fce9b21cdd6dcacb2d72fff7e9830628.1209897266.git.monstr@monstr.eu>
 <35e662a81eb86c7ffb2aaa6141ca38a07789f382.1209897266.git.monstr@monstr.eu>
 <b41fcf3dd830f4ba82692a9bec2406ed0c290e7e.1209897266.git.monstr@monstr.eu>
 <14acb31da2794d2d5916da3db3d75fe2285ac055.1209897266.git.monstr@monstr.eu>
 <598221ce2159046614d7b158ea62d5af51907af3.1209897266.git.monstr@monstr.eu>
 <41c1f410eaafd875246362d10ef9866d8cc2a934.1209897266.git.monstr@monstr.eu>
 <09ce2baf0c8308d3fbca98e7eb36a6aab59112a7.1209897266.git.monstr@monstr.eu>
 <c9418c683be99ae12abb89575c362d586c026bad.1209897266.git.monstr@monstr.eu>
 <cfde3796e95bdd17c32e4fd7762d0aee55967707.1209897266.git.monstr@monstr.eu>
 <8aba2d82c85cd1d5b56de328c1fd080ee51f0211.1209897266.git.monstr@monstr.eu>
 <c4000ff625bd217f9bb683e3bf8c7193a82bd744.1209897266.git.monstr@monstr.eu>
 <491f823fac6c03cc36834ec569a45d30a03a72cf.1209897266.git.monstr@monstr.eu>
 <96f2004535c34a0c762bf2012c299cbf9f89ab32.1209897266.git.monstr@monstr.eu>
 <92cd3a27b393bb394d48902594152351a92c59bb.1209897266.git.monstr@monstr.eu>
 <4e20213f5f296268a24955df8c951f7fba279816.1209897266.git.monstr@monstr.eu>
In-Reply-To: <a4a778e34c66d126f5c4bf1ca423cf32950ea5ab.1209897266.git.monstr@monstr.eu>
References: <a4a778e34c66d126f5c4bf1ca423cf32950ea5ab.1209897266.git.monstr@monstr.eu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michal Simek <monstr@monstr.eu>


Signed-off-by: Michal Simek <monstr@monstr.eu>
---
 include/asm-microblaze/atomic.h    |  108 ++++++++++++++++++++++++++++++++++++
 include/asm-microblaze/bitops.h    |   29 ++++++++++
 include/asm-microblaze/byteorder.h |   23 ++++++++
 3 files changed, 160 insertions(+), 0 deletions(-)
 create mode 100644 include/asm-microblaze/atomic.h
 create mode 100644 include/asm-microblaze/bitops.h
 create mode 100644 include/asm-microblaze/byteorder.h

diff --git a/include/asm-microblaze/atomic.h b/include/asm-microblaze/atomic.h
new file mode 100644
index 0000000..d0afdc5
--- /dev/null
+++ b/include/asm-microblaze/atomic.h
@@ -0,0 +1,108 @@
+/*
+ * include/asm-microblaze/atomic.h
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License. See the file "COPYING" in the main directory of this archive
+ * for more details.
+ *
+ * Copyright (C) 2006 Atmark Techno, Inc.
+ */
+
+#ifndef _ASM_MICROBLAZE_ATOMIC_H
+#define _ASM_MICROBLAZE_ATOMIC_H
+
+#include <linux/compiler.h> /* likely */
+#include <asm/system.h> /* local_irq_XXX and friends */
+
+typedef struct { volatile int counter; } atomic_t;
+
+#define ATOMIC_INIT(i)		{ (i) }
+#define atomic_read(v)		((v)->counter)
+#define atomic_set(v, i)	(((v)->counter) = (i))
+
+#define atomic_inc(v)		(atomic_add_return(1, (v)))
+#define atomic_dec(v)		(atomic_sub_return(1, (v)))
+
+#define atomic_add(i, v)	(atomic_add_return(i, (v)))
+#define atomic_sub(i, v)	(atomic_sub_return(i, (v)))
+
+#define atomic_inc_return(v)	(atomic_add_return(1, (v)))
+#define atomic_dec_return(v)	(atomic_sub_return(1, (v)))
+
+#define atomic_inc_and_test(v)	(atomic_add_return(1, (v)) == 0)
+#define atomic_dec_and_test(v)	(atomic_sub_return(1, (v)) == 0)
+
+#define atomic_inc_not_zero(v)	(atomic_add_unless((v), 1, 0))
+
+#define atomic_sub_and_test(i, v) (atomic_sub_return((i), (v)) == 0)
+
+static inline int atomic_cmpxchg(atomic_t *v, int old, int new)
+{
+	int ret;
+	unsigned long flags;
+
+	local_irq_save(flags);
+	ret = v->counter;
+	if (likely(ret == old))
+		v->counter = new;
+	local_irq_restore(flags);
+
+	return ret;
+}
+
+static inline int atomic_add_unless(atomic_t *v, int a, int u)
+{
+	int c, old;
+
+	c = atomic_read(v);
+	while (c != u && (old = atomic_cmpxchg((v), c, c + a)) != c)
+		c = old;
+	return c != u;
+}
+
+static inline void atomic_clear_mask(unsigned long mask, unsigned long *addr)
+{
+	unsigned long flags;
+
+	local_irq_save(flags);
+	*addr &= ~mask;
+	local_irq_restore(flags);
+}
+
+/**
+ * atomic_add_return - add and return
+ * @i: integer value to add
+ * @v: pointer of type atomic_t
+ *
+ * Atomically adds @i to @v and returns @i + @v
+ */
+static inline int atomic_add_return(int i, atomic_t *v)
+{
+	unsigned long flags;
+	int val;
+
+	local_irq_save(flags);
+	val = v->counter;
+	v->counter = val += i;
+	local_irq_restore(flags);
+
+	return val;
+}
+
+static inline int atomic_sub_return(int i, atomic_t *v)
+{
+	return atomic_add_return(-i, v);
+}
+
+#define atomic_add_negative(a, v)	(atomic_add_return((a), (v)) < 0)
+#define atomic_xchg(v, new) (xchg(&((v)->counter), new))
+
+/* Atomic operations are already serializing */
+#define smp_mb__before_atomic_dec()	barrier()
+#define smp_mb__after_atomic_dec()	barrier()
+#define smp_mb__before_atomic_inc()	barrier()
+#define smp_mb__after_atomic_inc()	barrier()
+
+#include <asm-generic/atomic.h>
+
+#endif /* _ASM_MICROBLAZE_ATOMIC_H */
diff --git a/include/asm-microblaze/bitops.h b/include/asm-microblaze/bitops.h
new file mode 100644
index 0000000..6665561
--- /dev/null
+++ b/include/asm-microblaze/bitops.h
@@ -0,0 +1,29 @@
+/*
+ * include/asm-microblaze/bitops.h
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License. See the file "COPYING" in the main directory of this archive
+ * for more details.
+ *
+ * Copyright (C) 2006 Atmark Techno, Inc.
+ */
+
+#ifndef _ASM_MICROBLAZE_BITOPS_H
+#define _ASM_MICROBLAZE_BITOPS_H
+
+/*
+ * Copyright 1992, Linus Torvalds.
+ */
+
+#include <linux/autoconf.h>
+#include <asm/byteorder.h> /* swab32 */
+#include <asm/system.h> /* save_flags */
+
+/*
+ * clear_bit() doesn't provide any barrier for the compiler.
+ */
+#define smp_mb__before_clear_bit()	barrier()
+#define smp_mb__after_clear_bit()	barrier()
+#include <asm-generic/bitops.h>
+
+#endif /* _ASM_MICROBLAZE_BITOPS_H */
diff --git a/include/asm-microblaze/byteorder.h b/include/asm-microblaze/byteorder.h
new file mode 100644
index 0000000..83ce88a
--- /dev/null
+++ b/include/asm-microblaze/byteorder.h
@@ -0,0 +1,23 @@
+/*
+ * include/asm-microblaze/byteorder.h
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License. See the file "COPYING" in the main directory of this archive
+ * for more details.
+ *
+ * Copyright (C) 2006 Atmark Techno, Inc.
+ */
+
+#ifndef _ASM_MICROBLAZE_BYTEORDER_H
+#define _ASM_MICROBLAZE_BYTEORDER_H
+
+#include <asm/types.h>
+
+#if defined(__GNUC__) && !defined(__STRICT_ANSI__) || defined(__KERNEL__)
+#define __BYTEORDER_HAS_U64__
+#define __SWAB_64_THRU_32__
+#endif
+
+#include <linux/byteorder/big_endian.h>
+
+#endif /* _ASM_MICROBLAZE_BYTEORDER_H */
-- 
1.5.4.GIT

