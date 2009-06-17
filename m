Return-Path: <linux-kernel-owner+w=401wt.eu-S1756562AbZFQQWz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756562AbZFQQWz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 12:22:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753325AbZFQQWg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 12:22:36 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:34004 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751893AbZFQQWf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 12:22:35 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: linux-kernel@vger.kernel.org
Cc: mingo@redhat.com, rgetz@blackfin.uclinux.org, akpm@linux-foundation.org
Subject: [PATCH 2/4] kallsyms: use new arch_is_kernel_text()
Date: Wed, 17 Jun 2009 12:22:22 -0400
Message-Id: <1245255744-21039-2-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.3.1
In-Reply-To: <1245255744-21039-1-git-send-email-vapier@gentoo.org>
References: <1245255744-21039-1-git-send-email-vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This allows kallsyms to locate symbols that are in arch-specific text
sections (such as text in Blackfin on-chip SRAM regions).

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 kernel/kallsyms.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/kernel/kallsyms.c b/kernel/kallsyms.c
index 3a29dbe..8b6b8b6 100644
--- a/kernel/kallsyms.c
+++ b/kernel/kallsyms.c
@@ -59,7 +59,8 @@ static inline int is_kernel_inittext(unsigned long addr)
 
 static inline int is_kernel_text(unsigned long addr)
 {
-	if (addr >= (unsigned long)_stext && addr <= (unsigned long)_etext)
+	if ((addr >= (unsigned long)_stext && addr <= (unsigned long)_etext) ||
+	    arch_is_kernel_text(addr))
 		return 1;
 	return in_gate_area_no_task(addr);
 }
-- 
1.6.3.1

