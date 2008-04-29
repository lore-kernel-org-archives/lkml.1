Return-Path: <linux-kernel-owner+w=401wt.eu-S1756528AbYD2ByX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756528AbYD2ByX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 21:54:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753216AbYD2BxF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 21:53:05 -0400
Received: from relay2.sgi.com ([192.48.171.30]:56028 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751564AbYD2BxA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 21:53:00 -0400
Message-Id: <20080429015300.323821221@sgi.com>
References: <20080429015231.908196699@sgi.com>
User-Agent: quilt/0.46-1
Date: Mon, 28 Apr 2008 18:52:33 -0700
From: Christoph Lameter <clameter@sgi.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: travis@sgi.com, linux-kernel@vger.kernel.org
Subject: [patch 2/9] x86: threadinfo: Common include files
Content-Disposition: inline; filename=merge_includes
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move shared includes to a common area in thread_info.h

Adds asm/types.h for x86_64 and linux/compiler.h for x86_32. Not needed but
we can avoid some ifdeffing and it simplifies later joining.

Signed-off-by: Christoph Lameter <clameter@sgi.com>

---
 include/asm-x86/thread_info.h |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

Index: linux-2.6/include/asm-x86/thread_info.h
===================================================================
--- linux-2.6.orig/include/asm-x86/thread_info.h	2008-04-28 17:18:24.182686168 -0700
+++ linux-2.6/include/asm-x86/thread_info.h	2008-04-28 17:19:43.520434319 -0700
@@ -7,9 +7,11 @@
 #ifndef _ASM_X86_THREAD_INFO_H
 #define _ASM_X86_THREAD_INFO_H
 
-#ifdef CONFIG_X86_32
 #include <linux/compiler.h>
 #include <asm/page.h>
+#include <asm/types.h>
+
+#ifdef CONFIG_X86_32
 
 #ifndef __ASSEMBLY__
 #include <asm/processor.h>
@@ -192,8 +194,6 @@ static inline struct thread_info *curren
 
 #else /* X86_32 */
 
-#include <asm/page.h>
-#include <asm/types.h>
 #include <asm/pda.h>
 
 /*

-- 
