Return-Path: <linux-kernel-owner+w=401wt.eu-S2992549AbXCGUo4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992549AbXCGUo4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 15:44:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965640AbXCGUo4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 15:44:56 -0500
Received: from gateway-1237.mvista.com ([63.81.120.158]:46833 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965639AbXCGUo4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 15:44:56 -0500
Date: Wed, 7 Mar 2007 13:45:16 -0700
From: Dave Jiang <djiang@mvista.com>
To: linux-kernel@vger.kernel.org
Cc: ak@suse.de, trini@kernel.crashing.org, sshtylyov@ru.mvista.com
Subject: [PATCH] x86_64 RESTORE_CONTEXT missing '\n'
Message-ID: <20070307204516.GA24095@blade.az.mvista.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


The RESTORE_CONTEXT macro is missing the '\n' at the end. It was removed in the
previous patch that touched system.h. It causes compile failure if any
inline asm is added after the macro. Discovered this when playing with
kgdb.

Signed-off-by: Dave Jiang <djiang@mvista.com>

---

 include/asm-x86_64/system.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

---

diff --git a/include/asm-x86_64/system.h b/include/asm-x86_64/system.h
index bd376bc..cbb8579 100644
--- a/include/asm-x86_64/system.h
+++ b/include/asm-x86_64/system.h
@@ -15,7 +15,7 @@
 
 /* frame pointer must be last for get_wchan */
 #define SAVE_CONTEXT    "pushf ; pushq %%rbp ; movq %%rsi,%%rbp\n\t"
-#define RESTORE_CONTEXT "movq %%rbp,%%rsi ; popq %%rbp ; popf\t"
+#define RESTORE_CONTEXT "movq %%rbp,%%rsi ; popq %%rbp ; popf\n\t"
 
 #define __EXTRA_CLOBBER  \
 	,"rcx","rbx","rdx","r8","r9","r10","r11","r12","r13","r14","r15"
