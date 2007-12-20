Return-Path: <linux-kernel-owner+w=401wt.eu-S1761629AbXLTNQ6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761629AbXLTNQ6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 08:16:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757489AbXLTNQu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 08:16:50 -0500
Received: from mga02.intel.com ([134.134.136.20]:48956 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760285AbXLTNQt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 08:16:49 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.24,189,1196668800"; 
   d="scan'208";a="243893143"
Date: Thu, 20 Dec 2007 14:16:36 +0100
From: Markus Metzger <markus.t.metzger@intel.com>
To: ak@suse.de, hpa@zytor.com, linux-kernel@vger.kernel.org, mingo@elte.hu,
       tglx@linutronix.de
Cc: markus.t.metzger@intel.com, markus.t.metzger@gmail.com,
       suresh.b.siddha@intel.com, roland@redhat.com, akpm@linux-foundation.org,
       mtk.manpages@gmail.com
Subject: [patch 2/5] x86, ptrace: support 32bit-cross-64bit BTS recording
Message-ID: <20071220141636.A29663@sedona.ch.intel.com>
Mime-Version: 1.0
Content-Disposition: inline
User-Agent: Mutt/1.2.5i
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Support BTS recording of 32bit and 64bit tasks from 32bit or 64bit tasks.


Signed-off-by: Markus Metzger <markus.t.metzger@intel.com>
---

Index: linux-2.6-x86/arch/x86/kernel/ds.c
===================================================================
--- linux-2.6-x86.orig/arch/x86/kernel/ds.c	2007-12-20 13:51:20.%N +0100
+++ linux-2.6-x86/arch/x86/kernel/ds.c	2007-12-20 13:52:01.%N +0100
@@ -111,53 +111,53 @@
  * Accessor functions for some DS and BTS fields using the above
  * global ptrace_bts_cfg.
  */
-static inline void *get_bts_buffer_base(char *base)
+static inline unsigned long get_bts_buffer_base(char *base)
 {
-	return *(void **)(base + ds_cfg.bts_buffer_base.offset);
+	return *(unsigned long *)(base + ds_cfg.bts_buffer_base.offset);
 }
-static inline void set_bts_buffer_base(char *base, void *value)
+static inline void set_bts_buffer_base(char *base, unsigned long value)
 {
-	(*(void **)(base + ds_cfg.bts_buffer_base.offset)) = value;
+	(*(unsigned long *)(base + ds_cfg.bts_buffer_base.offset)) = value;
 }
-static inline void *get_bts_index(char *base)
+static inline unsigned long get_bts_index(char *base)
 {
-	return *(void **)(base + ds_cfg.bts_index.offset);
+	return *(unsigned long *)(base + ds_cfg.bts_index.offset);
 }
-static inline void set_bts_index(char *base, void *value)
+static inline void set_bts_index(char *base, unsigned long value)
 {
-	(*(void **)(base + ds_cfg.bts_index.offset)) = value;
+	(*(unsigned long *)(base + ds_cfg.bts_index.offset)) = value;
 }
-static inline void *get_bts_absolute_maximum(char *base)
+static inline unsigned long get_bts_absolute_maximum(char *base)
 {
-	return *(void **)(base + ds_cfg.bts_absolute_maximum.offset);
+	return *(unsigned long *)(base + ds_cfg.bts_absolute_maximum.offset);
 }
-static inline void set_bts_absolute_maximum(char *base, void *value)
+static inline void set_bts_absolute_maximum(char *base, unsigned long value)
 {
-	(*(void **)(base + ds_cfg.bts_absolute_maximum.offset)) = value;
+	(*(unsigned long *)(base + ds_cfg.bts_absolute_maximum.offset)) = value;
 }
-static inline void *get_bts_interrupt_threshold(char *base)
+static inline unsigned long get_bts_interrupt_threshold(char *base)
 {
-	return *(void **)(base + ds_cfg.bts_interrupt_threshold.offset);
+	return *(unsigned long *)(base + ds_cfg.bts_interrupt_threshold.offset);
 }
-static inline void set_bts_interrupt_threshold(char *base, void *value)
+static inline void set_bts_interrupt_threshold(char *base, unsigned long value)
 {
-	(*(void **)(base + ds_cfg.bts_interrupt_threshold.offset)) = value;
+	(*(unsigned long *)(base + ds_cfg.bts_interrupt_threshold.offset)) = value;
 }
-static inline long get_from_ip(char *base)
+static inline unsigned long get_from_ip(char *base)
 {
-	return *(long *)(base + ds_cfg.from_ip.offset);
+	return *(unsigned long *)(base + ds_cfg.from_ip.offset);
 }
-static inline void set_from_ip(char *base, long value)
+static inline void set_from_ip(char *base, unsigned long value)
 {
-	(*(long *)(base + ds_cfg.from_ip.offset)) = value;
+	(*(unsigned long *)(base + ds_cfg.from_ip.offset)) = value;
 }
-static inline long get_to_ip(char *base)
+static inline unsigned long get_to_ip(char *base)
 {
-	return *(long *)(base + ds_cfg.to_ip.offset);
+	return *(unsigned long *)(base + ds_cfg.to_ip.offset);
 }
-static inline void set_to_ip(char *base, long value)
+static inline void set_to_ip(char *base, unsigned long value)
 {
-	(*(long *)(base + ds_cfg.to_ip.offset)) = value;
+	(*(unsigned long *)(base + ds_cfg.to_ip.offset)) = value;
 }
 static inline unsigned char get_info_type(char *base)
 {
@@ -180,7 +180,7 @@
 int ds_allocate(void **dsp, size_t bts_size_in_bytes)
 {
 	size_t bts_size_in_records;
-	void *bts;
+	unsigned long bts;
 	void *ds;
 
 	if (!ds_cfg.sizeof_ds || !ds_cfg.sizeof_bts)
@@ -197,7 +197,7 @@
 	if (bts_size_in_bytes <= 0)
 		return -EINVAL;
 
-	bts = kzalloc(bts_size_in_bytes, GFP_KERNEL);
+	bts = (unsigned long)kzalloc(bts_size_in_bytes, GFP_KERNEL);
 
 	if (!bts)
 		return -ENOMEM;
@@ -205,7 +205,7 @@
 	ds = kzalloc(ds_cfg.sizeof_ds, GFP_KERNEL);
 
 	if (!ds) {
-		kfree(bts);
+		kfree((void *)bts);
 		return -ENOMEM;
 	}
 
@@ -221,7 +221,7 @@
 int ds_free(void **dsp)
 {
 	if (*dsp)
-		kfree(get_bts_buffer_base(*dsp));
+		kfree((void *)get_bts_buffer_base(*dsp));
 	kfree(*dsp);
 	*dsp = 0;
 
@@ -230,7 +230,7 @@
 
 int ds_get_bts_size(void *ds)
 {
-	size_t size_in_bytes;
+	int size_in_bytes;
 
 	if (!ds_cfg.sizeof_ds || !ds_cfg.sizeof_bts)
 		return -EOPNOTSUPP;
@@ -246,7 +246,7 @@
 
 int ds_get_bts_end(void *ds)
 {
-	size_t size_in_bytes = ds_get_bts_size(ds);
+	int size_in_bytes = ds_get_bts_size(ds);
 
 	if (size_in_bytes <= 0)
 		return size_in_bytes;
@@ -256,7 +256,7 @@
 
 int ds_get_bts_index(void *ds)
 {
-	size_t index_offset_in_bytes;
+	int index_offset_in_bytes;
 
 	if (!ds_cfg.sizeof_ds || !ds_cfg.sizeof_bts)
 		return -EOPNOTSUPP;
@@ -288,19 +288,19 @@
 int ds_clear(void *ds)
 {
 	int bts_size = ds_get_bts_size(ds);
-	void *bts_base;
+	unsigned long bts_base;
 
 	if (bts_size <= 0)
 		return bts_size;
 
 	bts_base = get_bts_buffer_base(ds);
-	memset(bts_base, 0, bts_size);
+	memset((void *)bts_base, 0, bts_size);
 
 	set_bts_index(ds, bts_base);
 	return 0;
 }
 
-int ds_read_bts(void *ds, size_t index, struct bts_struct *out)
+int ds_read_bts(void *ds, int index, struct bts_struct *out)
 {
 	void *bts;
 
@@ -313,8 +313,7 @@
 	if (index >= ds_get_bts_size(ds))
 		return -EINVAL;
 
-	bts = get_bts_buffer_base(ds);
-	bts = (char *)bts + (index * ds_cfg.sizeof_bts);
+	bts = (void *)(get_bts_buffer_base(ds) + (index * ds_cfg.sizeof_bts));
 
 	memset(out, 0, sizeof(*out));
 	if (get_from_ip(bts) == BTS_ESCAPE_ADDRESS) {
@@ -326,12 +325,12 @@
 		out->variant.lbr.to_ip   = get_to_ip(bts);
 	}
 
-	return 0;
+	return sizeof(*out);;
 }
 
 int ds_write_bts(void *ds, const struct bts_struct *in)
 {
-	void *bts;
+	unsigned long bts;
 
 	if (!ds_cfg.sizeof_ds || !ds_cfg.sizeof_bts)
 		return -EOPNOTSUPP;
@@ -341,33 +340,33 @@
 
 	bts = get_bts_index(ds);
 
-	memset(bts, 0, ds_cfg.sizeof_bts);
+	memset((void *)bts, 0, ds_cfg.sizeof_bts);
 	switch (in->qualifier) {
 	case BTS_INVALID:
 		break;
 
 	case BTS_BRANCH:
-		set_from_ip(bts, in->variant.lbr.from_ip);
-		set_to_ip(bts, in->variant.lbr.to_ip);
+		set_from_ip((void *)bts, in->variant.lbr.from_ip);
+		set_to_ip((void *)bts, in->variant.lbr.to_ip);
 		break;
 
 	case BTS_TASK_ARRIVES:
 	case BTS_TASK_DEPARTS:
-		set_from_ip(bts, BTS_ESCAPE_ADDRESS);
-		set_info_type(bts, in->qualifier);
-		set_info_data(bts, in->variant.jiffies);
+		set_from_ip((void *)bts, BTS_ESCAPE_ADDRESS);
+		set_info_type((void *)bts, in->qualifier);
+		set_info_data((void *)bts, in->variant.jiffies);
 		break;
 
 	default:
 		return -EINVAL;
 	}
 
-	bts = (char *)bts + ds_cfg.sizeof_bts;
+	bts = bts + ds_cfg.sizeof_bts;
 	if (bts >= get_bts_absolute_maximum(ds))
 		bts = get_bts_buffer_base(ds);
 	set_bts_index(ds, bts);
 
-	return 0;
+	return ds_cfg.sizeof_bts;
 }
 
 unsigned long ds_debugctl_mask(void)
Index: linux-2.6-x86/include/asm-x86/ds.h
===================================================================
--- linux-2.6-x86.orig/include/asm-x86/ds.h	2007-12-20 13:51:21.%N +0100
+++ linux-2.6-x86/include/asm-x86/ds.h	2007-12-20 13:52:01.%N +0100
@@ -39,16 +39,16 @@
 };
 
 struct bts_struct {
-	enum bts_qualifier qualifier;
+	u64 qualifier;
 	union {
 		/* BTS_BRANCH */
 		struct {
-			long from_ip;
-			long to_ip;
+			u64 from_ip;
+			u64 to_ip;
 		} lbr;
 		/* BTS_TASK_ARRIVES or
 		   BTS_TASK_DEPARTS */
-		unsigned long jiffies;
+		u64 jiffies;
 	} variant;
 };
 
@@ -64,7 +64,7 @@
 extern int ds_set_overflow(void *, int);
 extern int ds_get_overflow(void *);
 extern int ds_clear(void *);
-extern int ds_read_bts(void *, size_t, struct bts_struct *);
+extern int ds_read_bts(void *, int, struct bts_struct *);
 extern int ds_write_bts(void *, const struct bts_struct *);
 extern unsigned long ds_debugctl_mask(void);
 extern void __cpuinit ds_init_intel(struct cpuinfo_x86 *c);
Index: linux-2.6-x86/include/asm-x86/ptrace-abi.h
===================================================================
--- linux-2.6-x86.orig/include/asm-x86/ptrace-abi.h	2007-12-20 13:51:22.%N +0100
+++ linux-2.6-x86/include/asm-x86/ptrace-abi.h	2007-12-20 13:52:01.%N +0100
@@ -85,9 +85,9 @@
 */
 struct ptrace_bts_config {
 	/* requested or actual size of BTS buffer in bytes */
-	unsigned long size;
+	unsigned int size;
 	/* bitmask of below flags */
-	unsigned long flags;
+	unsigned int flags;
 };
 
 #define PTRACE_BTS_O_TRACE	0x1 /* branch trace */
Index: linux-2.6-x86/arch/x86/kernel/ptrace.c
===================================================================
--- linux-2.6-x86.orig/arch/x86/kernel/ptrace.c	2007-12-20 13:51:45.%N +0100
+++ linux-2.6-x86/arch/x86/kernel/ptrace.c	2007-12-20 13:52:01.%N +0100
@@ -558,7 +558,7 @@
 
 	retval = ds_read_bts((void *)child->thread.ds_area_msr,
 			     bts_index, &ret);
-	if (retval)
+	if (retval < 0)
 		return retval;
 
 	if (copy_to_user(out, &ret, sizeof(ret)))
---------------------------------------------------------------------
Intel GmbH
Dornacher Strasse 1
85622 Feldkirchen/Muenchen Germany
Sitz der Gesellschaft: Feldkirchen bei Muenchen
Geschaeftsfuehrer: Douglas Lusk, Peter Gleissner, Hannes Schwaderer
Registergericht: Muenchen HRB 47456 Ust.-IdNr.
VAT Registration No.: DE129385895
Citibank Frankfurt (BLZ 502 109 00) 600119052

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.

