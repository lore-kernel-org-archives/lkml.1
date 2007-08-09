Return-Path: <linux-kernel-owner+w=401wt.eu-S939364AbXHIMnH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S939364AbXHIMnH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2007 08:43:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S939633AbXHIMld
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Aug 2007 08:41:33 -0400
Received: from ns1.suse.de ([195.135.220.2]:50882 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S939625AbXHIMlb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2007 08:41:31 -0400
From: Andi Kleen <ak@suse.de>
References: <20070809241.425881000@suse.de>
In-Reply-To: <20070809241.425881000@suse.de>
To: patches@x86-64.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [3/12] x86_64: Don't mark __exitcall as __cold
Message-Id: <20070809124130.A8E7414F3C@wotan.suse.de>
Date: Thu,  9 Aug 2007 14:41:30 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


gcc currently doesn't support attributes on types, so we can't use it
function pointers.  This avoids some warnings on a gcc 4.3 build.

Signed-off-by: Andi Kleen <ak@suse.de>

---
 include/linux/init.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux/include/linux/init.h
===================================================================
--- linux.orig/include/linux/init.h
+++ linux/include/linux/init.h
@@ -43,7 +43,7 @@
 #define __init		__attribute__ ((__section__ (".init.text"))) __cold
 #define __initdata	__attribute__ ((__section__ (".init.data")))
 #define __exitdata	__attribute__ ((__section__(".exit.data")))
-#define __exit_call	__attribute_used__ __attribute__ ((__section__ (".exitcall.exit"))) __cold
+#define __exit_call	__attribute_used__ __attribute__ ((__section__ (".exitcall.exit")))
 
 /* modpost check for section mismatches during the kernel build.
  * A section mismatch happens when there are references from a
