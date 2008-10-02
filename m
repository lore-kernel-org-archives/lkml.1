Return-Path: <linux-kernel-owner+w=401wt.eu-S1755120AbYJBPMT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755120AbYJBPMT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2008 11:12:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754894AbYJBPLN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Oct 2008 11:11:13 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:38809 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754839AbYJBPLL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2008 11:11:11 -0400
Message-Id: <20081002151104.440158972@goodmis.org>
References: <20081002150529.087488257@goodmis.org>
User-Agent: quilt/0.46-1
Date: Thu, 02 Oct 2008 11:05:31 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Jeremy Fitzhardinge <jeremy@xensource.com>,
       Chris Wright <chrisw@sous-sol.org>,
       Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH 2/5] xen: remove unused function warnings
Content-Disposition: inline; filename=xen-clean-up-enlight-unused.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The compiler is complaining that there are unused static functions
in the Xen code. Looking into this, it seems that they are used
but only within #if statements.

This patch matches the functions with the #if statements that they
are referenced by.

CC: Jeremy Fitzhardinge <jeremy@xensource.com>
CC: Chris Wright <chrisw@sous-sol.org>
Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 arch/x86/xen/enlighten.c |    4 ++++
 1 file changed, 4 insertions(+)

Index: linux-compile.git/arch/x86/xen/enlighten.c
===================================================================
--- linux-compile.git.orig/arch/x86/xen/enlighten.c	2008-10-02 10:34:13.000000000 -0400
+++ linux-compile.git/arch/x86/xen/enlighten.c	2008-10-02 10:57:52.000000000 -0400
@@ -704,10 +704,12 @@ static unsigned long xen_read_cr2(void)
 	return x86_read_percpu(xen_vcpu)->arch.cr2;
 }
 
+#ifdef CONFIG_X86_32
 static unsigned long xen_read_cr2_direct(void)
 {
 	return x86_read_percpu(xen_vcpu_info.arch.cr2);
 }
+#endif
 
 static void xen_write_cr4(unsigned long cr4)
 {
@@ -962,6 +964,7 @@ static void *xen_kmap_atomic_pte(struct 
 }
 #endif
 
+#ifndef CONFIG_X86_64
 static __init pte_t mask_rw_pte(pte_t *ptep, pte_t pte)
 {
 	/* If there's an existing pte, then don't allow _PAGE_RW to be set */
@@ -980,6 +983,7 @@ static __init void xen_set_pte_init(pte_
 
 	xen_set_pte(ptep, pte);
 }
+#endif
 
 static __init void xen_pagetable_setup_start(pgd_t *base)
 {

-- 
