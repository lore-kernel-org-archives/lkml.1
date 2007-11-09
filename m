Return-Path: <linux-kernel-owner+w=401wt.eu-S1758574AbXKIVcW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758574AbXKIVcW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2007 16:32:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757543AbXKIV3M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Nov 2007 16:29:12 -0500
Received: from mx1.redhat.com ([66.187.233.31]:52243 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757762AbXKIV3K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2007 16:29:10 -0500
From: Glauber de Oliveira Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, glommer@gmail.com, tglx@linutronix.de,
       mingo@elte.hu, rusty@rustcorp.com.au, ak@suse.de, chrisw@sous-sol.org,
       avi@qumranet.com, anthony@codemonkey.ws,
       virtualization@lists.linux-foundation.org, lguest@ozlabs.org,
       kvm-devel@lists.sourceforge.net, zach@vmware.com,
       jun.nakajima@intel.com, Glauber de Oliveira Costa <gcosta@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 13/24] report ring kernel is running without paravirt
Date: Fri,  9 Nov 2007 16:42:54 -0200
Message-Id: <1194633857930-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.4.4.2
In-Reply-To: <1194633852469-git-send-email-gcosta@redhat.com>
References: <11946337851964-git-send-email-gcosta@redhat.com> <11946337933104-git-send-email-gcosta@redhat.com> <11946337991750-git-send-email-gcosta@redhat.com> <11946338053158-git-send-email-gcosta@redhat.com> <11946338103068-git-send-email-gcosta@redhat.com> <1194633815833-git-send-email-gcosta@redhat.com> <11946338212915-git-send-email-gcosta@redhat.com> <11946338263902-git-send-email-gcosta@redhat.com> <1194633831882-git-send-email-gcosta@redhat.com> <11946338361369-git-send-email-gcosta@redhat.com> <11946338413283-git-send-email-gcosta@redhat.com> <11946338473652-git-send-email-gcosta@redhat.com> <1194633852469-git-send-email-gcosta@redhat.com>
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

