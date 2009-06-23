Return-Path: <linux-kernel-owner+w=401wt.eu-S1759168AbZFXAF6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759168AbZFXAF6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 20:05:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755821AbZFXAFv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 20:05:51 -0400
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:44404 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753770AbZFXAFu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 20:05:50 -0400
From: Tim Abbott <tabbott@ksplice.com>
To: Linux kernel mailing list <linux-kernel@vger.kernel.org>
Cc: Sam Ravnborg <sam@ravnborg.org>, devel@ksplice.com,
       Denys Vlasenko <vda.linux@googlemail.com>,
       Tim Abbott <tabbott@ksplice.com>
Subject: [PATCH 1/2] Add new macros for page-aligned data and bss sections.
Date: Tue, 23 Jun 2009 19:59:35 -0400
Message-Id: <1245801576-13374-1-git-send-email-tabbott@ksplice.com>
X-Mailer: git-send-email 1.6.3.1
In-Reply-To: <1245801452-13222-1-git-send-email-tabbott@ksplice.com>
References: <1245801452-13222-1-git-send-email-tabbott@ksplice.com>
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch is preparation for replacing most uses of
".bss.page_aligned" and ".data.page_aligned" in the kernel with
macros, so that the section name can later be changed without having
to touch a lot of the kernel.

The long-term goal here is to be able to change the kernel's magic
section names to those that are compatible with -ffunction-sections
-fdata-sections.  This requires renaming all magic sections with names
of the form ".data.foo".

Signed-off-by: Tim Abbott <tabbott@ksplice.com>
Cc: Sam Ravnborg <sam@ravnborg.org>
Acked-by: David Howells <dhowells@redhat.com>
---
 include/linux/linkage.h |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/include/linux/linkage.h b/include/linux/linkage.h
index fee9e59..691f591 100644
--- a/include/linux/linkage.h
+++ b/include/linux/linkage.h
@@ -22,6 +22,15 @@
 #define __page_aligned_bss	__section(.bss.page_aligned) __aligned(PAGE_SIZE)
 
 /*
+ * For assembly routines.
+ *
+ * Note when using these that you must specify the appropriate
+ * alignment directives yourself
+ */
+#define __PAGE_ALIGNED_DATA	.section ".data.page_aligned", "aw"
+#define __PAGE_ALIGNED_BSS	.section ".bss.page_aligned", "aw"
+
+/*
  * This is used by architectures to keep arguments on the stack
  * untouched by the compiler by keeping them live until the end.
  * The argument stack may be owned by the assembly-language
-- 
1.6.3.1

