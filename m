Return-Path: <linux-kernel-owner+w=401wt.eu-S1765164AbYARUEw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765164AbYARUEw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 15:04:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765385AbYARUE3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 15:04:29 -0500
Received: from mx1.redhat.com ([66.187.233.31]:35931 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765372AbYARUE2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 15:04:28 -0500
From: Glauber de Oliveira Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, glommer@gmail.com, tglx@linutronix.de,
       mingo@elte.hu, ehabkost@redhat.com, jeremy@goop.org, avi@qumranet.com,
       anthony@codemonkey.ws, virtualization@lists.linux-foundation.org,
       rusty@rustcorp.com.au, ak@suse.de, chrisw@sous-sol.org,
       rostedt@goodmis.org, hpa@zytor.com, zach@vmware.com, roland@redhat.com,
       mtosatti@redhat.com, Glauber de Oliveira Costa <gcosta@redhat.com>
Subject: [PATCH 4/10] put generic mm_hooks include into PARAVIRT
Date: Fri, 18 Jan 2008 15:20:19 -0200
Message-Id: <12006768521391-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.4.4.2
In-Reply-To: <12006768473571-git-send-email-gcosta@redhat.com>
References: <12006768251548-git-send-email-gcosta@redhat.com> <12006768362108-git-send-email-gcosta@redhat.com> <1200676842822-git-send-email-gcosta@redhat.com> <12006768473571-git-send-email-gcosta@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With PARAVIRT, we actually have arch_{dup,exit}_mmap functions,
so we can't include the generic header

Signed-off-by: Glauber de Oliveira Costa <gcosta@redhat.com>
---
 include/asm-x86/mmu_context_64.h |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/include/asm-x86/mmu_context_64.h b/include/asm-x86/mmu_context_64.h
index 7e2aa23..ad6dc82 100644
--- a/include/asm-x86/mmu_context_64.h
+++ b/include/asm-x86/mmu_context_64.h
@@ -7,7 +7,9 @@
 #include <asm/pda.h>
 #include <asm/pgtable.h>
 #include <asm/tlbflush.h>
+#ifndef CONFIG_PARAVIRT
 #include <asm-generic/mm_hooks.h>
+#endif
 
 /*
  * possibly do the LDT unload here?
-- 
1.4.4.2

