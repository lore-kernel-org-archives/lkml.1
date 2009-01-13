Return-Path: <linux-kernel-owner+w=401wt.eu-S1757268AbZAMKlt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757268AbZAMKlt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 05:41:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756953AbZAMKjX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 05:39:23 -0500
Received: from hera.kernel.org ([140.211.167.34]:51167 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756836AbZAMKjV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 05:39:21 -0500
From: Tejun Heo <tj@kernel.org>
To: ebiederm@xmission.com, cl@linux-foundation.org, rusty@rustcorp.com.au,
       mingo@elte.hu, travis@sgi.com, linux-kernel@vger.kernel.org,
       hpa@zytor.com, akpm@linux-foundation.org, steiner@sgi.com,
       hugh@veritas.com
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 04/13] x86_32: make vmlinux_32.lds.S use PERCPU() macro
Date: Tue, 13 Jan 2009 19:38:08 +0900
Message-Id: <1231843097-18003-5-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.5.6
In-Reply-To: <1231843097-18003-1-git-send-email-tj@kernel.org>
References: <1231843097-18003-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 13 Jan 2009 10:38:32 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make vmlinux_32.lds.S use the generic PERCPU() macro instead of open
coding it.  This will ease future changes.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 arch/x86/kernel/vmlinux_32.lds.S |    9 +--------
 1 files changed, 1 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kernel/vmlinux_32.lds.S b/arch/x86/kernel/vmlinux_32.lds.S
index 82c6755..3eba7f7 100644
--- a/arch/x86/kernel/vmlinux_32.lds.S
+++ b/arch/x86/kernel/vmlinux_32.lds.S
@@ -178,14 +178,7 @@ SECTIONS
 	__initramfs_end = .;
   }
 #endif
-  . = ALIGN(PAGE_SIZE);
-  .data.percpu  : AT(ADDR(.data.percpu) - LOAD_OFFSET) {
-	__per_cpu_start = .;
-	*(.data.percpu.page_aligned)
-	*(.data.percpu)
-	*(.data.percpu.shared_aligned)
-	__per_cpu_end = .;
-  }
+  PERCPU(PAGE_SIZE)
   . = ALIGN(PAGE_SIZE);
   /* freed after init ends here */
 
-- 
1.5.6

