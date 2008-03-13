Return-Path: <linux-kernel-owner+w=401wt.eu-S1757341AbYCNABP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757341AbYCNABP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2008 20:01:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751815AbYCNABD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Mar 2008 20:01:03 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:37956 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751771AbYCNABC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2008 20:01:02 -0400
Date: Thu, 13 Mar 2008 16:59:12 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: mingo <mingo@redhat.com>, tglx <tglx@linutronix.de>, hpa <hpa@zytor.com>
Subject: [PATCH] x86: convert mtrr/generic.c to kernel-doc
Message-Id: <20080313165912.53d7f01b.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Convert function comment blocks to kernel-doc notation.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 arch/x86/kernel/cpu/mtrr/generic.c |   42 ++++++++++++++-------------
 1 file changed, 23 insertions(+), 19 deletions(-)

--- mmotm-2008-0312-2333.orig/arch/x86/kernel/cpu/mtrr/generic.c
+++ mmotm-2008-0312-2333/arch/x86/kernel/cpu/mtrr/generic.c
@@ -176,12 +176,13 @@ static inline void k8_enable_fixed_iorrs
 }
 
 /**
- * Checks and updates an fixed-range MTRR if it differs from the value it
- * should have. If K8 extentions are wanted, update the K8 SYSCFG MSR also.
- * see AMD publication no. 24593, chapter 7.8.1, page 233 for more information
- * \param msr MSR address of the MTTR which should be checked and updated
- * \param changed pointer which indicates whether the MTRR needed to be changed
- * \param msrwords pointer to the MSR values which the MSR should have
+ * set_fixed_range - checks & updates a fixed-range MTRR if it differs from the value it should have
+ * @msr: MSR address of the MTTR which should be checked and updated
+ * @changed: pointer which indicates whether the MTRR needed to be changed
+ * @msrwords: pointer to the MSR values which the MSR should have
+ *
+ * If K8 extentions are wanted, update the K8 SYSCFG MSR also.
+ * See AMD publication no. 24593, chapter 7.8.1, page 233 for more information.
  */
 static void set_fixed_range(int msr, bool *changed, unsigned int *msrwords)
 {
@@ -199,12 +200,15 @@ static void set_fixed_range(int msr, boo
 	}
 }
 
+/**
+ * generic_get_free_region - Get a free MTRR.
+ * @base: The starting (base) address of the region.
+ * @size: The size (in bytes) of the region.
+ * @replace_reg: mtrr index to be replaced; set to invalid value if none.
+ *
+ * Returns: The index of the region on success, else negative on error.
+ */
 int generic_get_free_region(unsigned long base, unsigned long size, int replace_reg)
-/*  [SUMMARY] Get a free MTRR.
-    <base> The starting (base) address of the region.
-    <size> The size (in bytes) of the region.
-    [RETURNS] The index of the region on success, else -1 on error.
-*/
 {
 	int i, max;
 	mtrr_type ltype;
@@ -249,8 +253,8 @@ static void generic_get_mtrr(unsigned in
 }
 
 /**
- * Checks and updates the fixed-range MTRRs if they differ from the saved set
- * \param frs pointer to fixed-range MTRR values, saved by get_fixed_ranges()
+ * set_fixed_ranges - checks & updates the fixed-range MTRRs if they differ from the saved set
+ * @frs: pointer to fixed-range MTRR values, saved by get_fixed_ranges()
  */
 static int set_fixed_ranges(mtrr_type * frs)
 {
@@ -294,13 +298,13 @@ static bool set_mtrr_var_ranges(unsigned
 
 static u32 deftype_lo, deftype_hi;
 
+/**
+ * set_mtrr_state - Set the MTRR state for this CPU.
+ *
+ * NOTE: The CPU must already be in a safe state for MTRR changes.
+ * RETURNS: 0 if no changes made, else a mask indicating what was changed.
+ */
 static unsigned long set_mtrr_state(void)
-/*  [SUMMARY] Set the MTRR state for this CPU.
-    <state> The MTRR state information to read.
-    <ctxt> Some relevant CPU context.
-    [NOTE] The CPU must already be in a safe state for MTRR changes.
-    [RETURNS] 0 if no changes made, else a mask indication what was changed.
-*/
 {
 	unsigned int i;
 	unsigned long change_mask = 0;
