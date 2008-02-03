Return-Path: <linux-kernel-owner+w=401wt.eu-S935029AbYBCLe2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935029AbYBCLe2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2008 06:34:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759529AbYBCLc4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Feb 2008 06:32:56 -0500
Received: from hu-out-0506.google.com ([72.14.214.230]:23922 "EHLO
	hu-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758836AbYBCLcz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2008 06:32:55 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=references:user-agent:date:from:to:cc:subject:content-disposition:message-id;
        b=ms8XLJD8CwmYLhXz/s9uMYKJxxlkv7jCR0UtPwrfTEfPBqFZb4G0y7Etcf7K8Tt7eD0x5HNNQ+sDYYC+fz/B4CRo89ajXDbh7rHY56vnfbb2Sh0WbeiJh5LyQPrNk+ULQnWxPxkFLMIsBPA/qMUxFmOx0bnQHJYNbJdbGh/YcyA=
References: <20080203112217.126814108@gmail.com>>
User-Agent: quilt/0.46-1
Date: Sun, 03 Feb 2008 14:22:21 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: linux-kernel@vger.kernel.org, davem@davemloft.net, bryan.wu@analog.com,
       hskinnemoen@atmel.co, dhowells@redhat.com
Cc: Cyrill Gorcunov <gorcunov@gmail.com>
Subject: [patch 4/4] SPARC: cleanup - use _AC macro to define PAGE_SIZE
Content-Disposition: inline; filename=asm-sparc.diff
Message-ID: <47a5a661.04eb300a.0405.ffff99ee@mx.google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
---

 page.h |   11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

Index: linux-2.6.git/include/asm-sparc/page.h
===================================================================
--- linux-2.6.git.orig/include/asm-sparc/page.h	2008-01-21 19:35:29.000000000 +0300
+++ linux-2.6.git/include/asm-sparc/page.h	2008-02-03 14:02:48.000000000 +0300
@@ -10,18 +10,15 @@
 
 #ifdef __KERNEL__
 
+#include <linux/const.h>
+
 #ifdef CONFIG_SUN4
 #define PAGE_SHIFT   13
 #else
 #define PAGE_SHIFT   12
 #endif
-#ifndef __ASSEMBLY__
-/* I have my suspicions... -DaveM */
-#define PAGE_SIZE    (1UL << PAGE_SHIFT)
-#else
-#define PAGE_SIZE    (1 << PAGE_SHIFT)
-#endif
-#define PAGE_MASK    (~(PAGE_SIZE-1))
+#define PAGE_SIZE	(_AC(1, UL) << PAGE_SHIFT)
+#define PAGE_MASK	(~(PAGE_SIZE-1))
 
 #include <asm/btfixup.h>
 

-- 
