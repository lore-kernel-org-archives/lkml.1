Return-Path: <linux-kernel-owner+w=401wt.eu-S1763987AbXHHHOM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763987AbXHHHOM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 03:14:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760115AbXHHHIc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 03:08:32 -0400
Received: from mx1.redhat.com ([66.187.233.31]:43869 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760049AbXHHHIb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 03:08:31 -0400
From: Glauber de Oliveira Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, rusty@rustcorp.com.au, ak@suse.de,
       mingo@elte.hu, chrisw@sous-sol.org, jeremy@goop.org, avi@qumranet.com,
       anthony@codemonkey.ws, virtualization@lists.linux-foundation.org,
       lguest@ozlabs.org, Glauber de Oliveira Costa <gcosta@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 9/25] [PATCH] report ring kernel is running without paravirt
Date: Wed,  8 Aug 2007 01:18:56 -0300
Message-Id: <1186546789356-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.4.4.2
In-Reply-To: <1186546785346-git-send-email-gcosta@redhat.com>
References: <11865467522495-git-send-email-gcosta@redhat.com> <11865467592921-git-send-email-gcosta@redhat.com> <1186546763582-git-send-email-gcosta@redhat.com> <11865467662182-git-send-email-gcosta@redhat.com> <11865467702103-git-send-email-gcosta@redhat.com> <11865467741753-git-send-email-gcosta@redhat.com> <11865467773012-git-send-email-gcosta@redhat.com> <11865467812610-git-send-email-gcosta@redhat.com> <1186546785346-git-send-email-gcosta@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

When paravirtualization is disabled, the kernel is always
running at ring 0. So report it in the appropriate macro

Signed-off-by: Glauber de Oliveira Costa <gcosta@redhat.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/asm-x86_64/segment.h |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/include/asm-x86_64/segment.h b/include/asm-x86_64/segment.h
index 04b8ab2..240c1bf 100644
--- a/include/asm-x86_64/segment.h
+++ b/include/asm-x86_64/segment.h
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

