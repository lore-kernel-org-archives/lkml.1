Return-Path: <linux-kernel-owner+w=401wt.eu-S1760530AbXHJWJo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760530AbXHJWJo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2007 18:09:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755197AbXHJWBg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Aug 2007 18:01:36 -0400
Received: from mx1.redhat.com ([66.187.233.31]:57826 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759636AbXHJWBY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2007 18:01:24 -0400
From: Glauber de Oliveira Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, rusty@rustcorp.com.au, ak@suse.de,
       mingo@elte.hu, chrisw@sous-sol.org, jeremy@goop.org, avi@qumranet.com,
       anthony@codemonkey.ws, virtualization@lists.linux-foundation.org,
       lguest@ozlabs.org, glommer@gmail.com,
       Glauber de Oliveira Costa <gcosta@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 23/25 -v2] provide paravirt patching function
Date: Fri, 10 Aug 2007 16:12:35 -0300
Message-Id: <11867732713519-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.4.4.2
In-Reply-To: <11867732661840-git-send-email-gcosta@redhat.com>
References: <1186773157329-git-send-email-gcosta@redhat.com> <11867731633002-git-send-email-gcosta@redhat.com> <11867731681763-git-send-email-gcosta@redhat.com> <11867731732274-git-send-email-gcosta@redhat.com> <11867731781610-git-send-email-gcosta@redhat.com> <11867731831138-git-send-email-gcosta@redhat.com> <11867731882768-git-send-email-gcosta@redhat.com> <11867731932688-git-send-email-gcosta@redhat.com> <11867731981891-git-send-email-gcosta@redhat.com> <1186773203887-git-send-email-gcosta@redhat.com> <11867732082735-git-send-email-gcosta@redhat.com> <11867732121974-git-send-email-gcosta@redhat.com> <1186773217875-git-send-email-gcosta@redhat.com> <11867732221652-git-send-email-gcosta@redhat.com> <11867732273108-git-send-email-gcosta@redhat.com> <11867732323106-git-send-email-gcosta@redhat.com> <11867732373232-git-send-email-gcosta@redhat.com> <11867732424024-git-send-email-gcosta@redhat.com> <11867732461037-git-send-email-gcosta@redhat.com> <11867732511513-git-send-email!
 -gcosta@redhat.com> <11867732562020-git-send-email-gcosta@redhat.com> <1186773261537-git-send-email-gcosta@redhat.com> <11867732661840-git-send-email-gcosta@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch introduces apply_paravirt(), a function that shall
be called by i386/alternative.c to apply replacements to
paravirt_functions. It is defined to an do-nothing function
if paravirt is not enabled.

Signed-off-by: Glauber de Oliveira Costa <gcosta@redhat.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/asm-x86_64/alternative.h |    8 +++++---
 1 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/include/asm-x86_64/alternative.h b/include/asm-x86_64/alternative.h
index ab161e8..e69a141 100644
--- a/include/asm-x86_64/alternative.h
+++ b/include/asm-x86_64/alternative.h
@@ -143,12 +143,14 @@ static inline void alternatives_smp_switch(int smp) {}
  */
 #define ASM_OUTPUT2(a, b) a, b
 
-struct paravirt_patch;
+struct paravirt_patch_site;
 #ifdef CONFIG_PARAVIRT
-void apply_paravirt(struct paravirt_patch *start, struct paravirt_patch *end);
+void apply_paravirt(struct paravirt_patch_site *start,
+				struct paravirt_patch_site *end);
 #else
 static inline void
-apply_paravirt(struct paravirt_patch *start, struct paravirt_patch *end)
+apply_paravirt(struct paravirt_patch_site *start,
+				struct paravirt_patch_site *end)
 {}
 #define __parainstructions NULL
 #define __parainstructions_end NULL
-- 
1.4.4.2

