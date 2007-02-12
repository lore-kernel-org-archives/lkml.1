Return-Path: <linux-kernel-owner+w=401wt.eu-S965003AbXBLQ6Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965003AbXBLQ6Y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Feb 2007 11:58:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964979AbXBLQ5V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Feb 2007 11:57:21 -0500
Received: from mail.suse.de ([195.135.220.2]:47934 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964987AbXBLQvg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Feb 2007 11:51:36 -0500
From: Andi Kleen <ak@suse.de>
References: <20070212551.664370000@suse.de>
In-Reply-To: <20070212551.664370000@suse.de>
To: patches@x86-64.org, linux-kernel@vger.kernel.org
Subject: [PATCH x86 for review III] [15/29] x86_64: Fix wrong gcc check in bitops.h
Message-Id: <20070212165135.9138013E1B@wotan.suse.de>
Date: Mon, 12 Feb 2007 17:51:35 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


gcc 5.0 will likely not have the constraint problem
Signed-off-by: Andi Kleen <ak@suse.de>

---
 include/asm-x86_64/bitops.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux/include/asm-x86_64/bitops.h
===================================================================
--- linux.orig/include/asm-x86_64/bitops.h
+++ linux/include/asm-x86_64/bitops.h
@@ -7,7 +7,7 @@
 
 #include <asm/alternative.h>
 
-#if __GNUC__ < 4 || __GNUC_MINOR__ < 1
+#if __GNUC__ < 4 || (__GNUC__ == 4 && __GNUC_MINOR__ < 1)
 /* Technically wrong, but this avoids compilation errors on some gcc
    versions. */
 #define ADDR "=m" (*(volatile long *) addr)
