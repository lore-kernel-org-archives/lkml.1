Return-Path: <linux-kernel-owner+w=401wt.eu-S1761140AbXJaWDA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761140AbXJaWDA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2007 18:03:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760085AbXJaWAk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Oct 2007 18:00:40 -0400
Received: from mx1.redhat.com ([66.187.233.31]:32889 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760654AbXJaWAh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2007 18:00:37 -0400
From: Glauber de Oliveira Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, rusty@rustcorp.com.au, ak@suse.de,
       mingo@elte.hu, chrisw@sous-sol.org, jeremy@goop.org, avi@qumranet.com,
       anthony@codemonkey.ws, virtualization@lists.linux-foundation.org,
       lguest@ozlabs.org, kvm-devel@lists.sourceforge.net, zach@vmware.com,
       tglx@linutronix.de, jun.nakajima@intel.com, glommer@gmail.com,
       Glauber de Oliveira Costa <gcosta@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 5/16] report ring kernel is running without paravirt
Date: Wed, 31 Oct 2007 16:14:50 -0300
Message-Id: <1193858130443-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.4.4.2
In-Reply-To: <11938581242810-git-send-email-gcosta@redhat.com>
References: <1193858101367-git-send-email-gcosta@redhat.com> <11938581073775-git-send-email-gcosta@redhat.com> <11938581133479-git-send-email-gcosta@redhat.com> <1193858118284-git-send-email-gcosta@redhat.com> <11938581242810-git-send-email-gcosta@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

When paravirtualization is disabled, the kernel is always
running at ring 0. So report it in the appropriate macro

Signed-off-by: Glauber de Oliveira Costa <gcosta@redhat.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Acked-by: Jeremy Fitzhardinge <jeremy@xensource.com>
---
 include/asm-x86/segment_64.h |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/include/asm-x86/segment_64.h b/include/asm-x86/segment_64.h
index 04b8ab2..240c1bf 100644
--- a/include/asm-x86/segment_64.h
+++ b/include/asm-x86/segment_64.h
@@ -50,4 +50,8 @@
 #define GDT_SIZE (GDT_ENTRIES * 8)
 #define TLS_SIZE (GDT_ENTRY_TLS_ENTRIES * 8) 
 
+#ifndef CONFIG_PARAVIRT
+#define get_kernel_rpl()  0
+#endif
+
 #endif
-- 
1.4.4.2

