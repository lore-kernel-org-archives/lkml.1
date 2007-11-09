Return-Path: <linux-kernel-owner+w=401wt.eu-S1760001AbXKIVbP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760001AbXKIVbP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2007 16:31:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758421AbXKIV27
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Nov 2007 16:28:59 -0500
Received: from mx1.redhat.com ([66.187.233.31]:52183 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758365AbXKIV26 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2007 16:28:58 -0500
From: Glauber de Oliveira Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, glommer@gmail.com, tglx@linutronix.de,
       mingo@elte.hu, rusty@rustcorp.com.au, ak@suse.de, chrisw@sous-sol.org,
       avi@qumranet.com, anthony@codemonkey.ws,
       virtualization@lists.linux-foundation.org, lguest@ozlabs.org,
       kvm-devel@lists.sourceforge.net, zach@vmware.com,
       jun.nakajima@intel.com, Glauber de Oliveira Costa <gcosta@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 11/24] read/write_crX, clts and wbinvd for 64-bit paravirt
Date: Fri,  9 Nov 2007 16:42:52 -0200
Message-Id: <11946338473652-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.4.4.2
In-Reply-To: <11946338413283-git-send-email-gcosta@redhat.com>
References: <11946337851964-git-send-email-gcosta@redhat.com> <11946337933104-git-send-email-gcosta@redhat.com> <11946337991750-git-send-email-gcosta@redhat.com> <11946338053158-git-send-email-gcosta@redhat.com> <11946338103068-git-send-email-gcosta@redhat.com> <1194633815833-git-send-email-gcosta@redhat.com> <11946338212915-git-send-email-gcosta@redhat.com> <11946338263902-git-send-email-gcosta@redhat.com> <1194633831882-git-send-email-gcosta@redhat.com> <11946338361369-git-send-email-gcosta@redhat.com> <11946338413283-git-send-email-gcosta@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch introduces, and patch callers when needed, native
versions for read/write_crX functions, clts and wbinvd.

Signed-off-by: Glauber de Oliveira Costa <gcosta@redhat.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Acked-by: Jeremy Fitzhardinge <jeremy@xensource.com>
---
 arch/x86/mm/pageattr_64.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/arch/x86/mm/pageattr_64.c b/arch/x86/mm/pageattr_64.c
index 14ab327..3a483a8 100644
--- a/arch/x86/mm/pageattr_64.c
+++ b/arch/x86/mm/pageattr_64.c
@@ -13,6 +13,7 @@
 #include <asm/tlbflush.h>
 #include <asm/uaccess.h>
 #include <asm/io.h>
+#include <asm/paravirt.h>
 
 pte_t *lookup_address(unsigned long address)
 {
@@ -84,7 +85,7 @@ static void flush_kernel_map(void *arg)
 	   much cheaper than WBINVD. */
 	/* clflush is still broken. Disable for now. */
 	if (1 || !cpu_has_clflush) {
-		asm volatile("wbinvd" ::: "memory");
+		wbinvd();
 	} else {
 		list_for_each_entry(pg, l, lru) {
 			void *addr = page_address(pg);
-- 
1.4.4.2

