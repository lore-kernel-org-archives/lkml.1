Return-Path: <linux-kernel-owner+w=401wt.eu-S1762861AbXHONBW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762861AbXHONBW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2007 09:01:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762080AbXHOMzQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Aug 2007 08:55:16 -0400
Received: from mx1.redhat.com ([66.187.233.31]:56379 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761587AbXHOMzO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2007 08:55:14 -0400
From: Glauber de Oliveira Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, rusty@rustcorp.com.au, ak@suse.de,
       mingo@elte.hu, chrisw@sous-sol.org, jeremy@goop.org, avi@qumranet.com,
       anthony@codemonkey.ws, virtualization@lists.linux-foundation.org,
       lguest@ozlabs.org, glommer@gmail.com,
       Glauber de Oliveira Costa <gcosta@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 23/25][V3] provide paravirt patching function
Date: Wed, 15 Aug 2007 09:49:43 -0300
Message-Id: <1187182447280-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.5.0.6
In-Reply-To: <1187182438167-git-send-email-gcosta@redhat.com>
References: <11871821854176-git-send-email-gcosta@redhat.com> <1187182197314-git-send-email-gcosta@redhat.com> <11871822062386-git-send-email-gcosta@redhat.com> <11871822163867-git-send-email-gcosta@redhat.com> <11871822244170-git-send-email-gcosta@redhat.com> <11871822342754-git-send-email-gcosta@redhat.com> <11871822421713-git-send-email-gcosta@redhat.com> <1187182253740-git-send-email-gcosta@redhat.com> <1187182268408-git-send-email-gcosta@redhat.com> <1187182282913-git-send-email-gcosta@redhat.com> <11871822951747-git-send-email-gcosta@redhat.com> <11871823042011-git-send-email-gcosta@redhat.com> <11871823151789-git-send-email-gcosta@redhat.com> <11871823273810-git-send-email-gcosta@redhat.com> <11871823373106-git-send-email-gcosta@redhat.com> <11871823673236-git-send-email-gcosta@redhat.com> <11871823782610-git-send-email-gcosta@redhat.com> <11871823892519-git-send-email-gcosta@redhat.com> <11871823991803-git-send-email-gcosta@redhat.com> <11871824081337-git-send-email-!
 gcosta@redhat.com> <11871824192375-git-send-email-gcosta@redhat.com> <11871824292046-git-send-email-gcosta@redhat.com> <1187182438167-git-send-email-gcosta@redhat.com>
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

