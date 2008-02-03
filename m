Return-Path: <linux-kernel-owner+w=401wt.eu-S934014AbYBCLeC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934014AbYBCLeC (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2008 06:34:02 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757446AbYBCLcx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Feb 2008 06:32:53 -0500
Received: from hu-out-0506.google.com ([72.14.214.225]:23496 "EHLO
	hu-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754269AbYBCLcv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2008 06:32:51 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=references:user-agent:date:from:to:cc:subject:content-disposition:message-id;
        b=rruXYYKmopmKJXYCrhl4h7GErvZM0zdxQ7tQ3/BN8Z3R//wJLr62jMRPwRs4h111vnjq/uxwE49ecfdbftfdb5opVcVyRlqPW2K9e0e5Jur8O/DVvRpyyUoxGkwgc3CF4CNtMSx66vq5FJSVcO914SiZLUntaYoIMMaK3KYpgrE=
References: <20080203112217.126814108@gmail.com>>
User-Agent: quilt/0.46-1
Date: Sun, 03 Feb 2008 14:22:18 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: linux-kernel@vger.kernel.org, davem@davemloft.net, bryan.wu@analog.com,
       hskinnemoen@atmel.co, dhowells@redhat.com
Cc: Cyrill Gorcunov <gorcunov@gmail.com>
Subject: [patch 1/4] AVR32: cleanup - use _AC macro to define PAGE_SIZE
Content-Disposition: inline; filename=avr32-page.diff
Message-ID: <47a5a660.19e7300a.0584.329a@mx.google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
---

 page.h |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

Index: linux-2.6.git/include/asm-avr32/page.h
===================================================================
--- linux-2.6.git.orig/include/asm-avr32/page.h	2008-01-21 19:35:27.000000000 +0300
+++ linux-2.6.git/include/asm-avr32/page.h	2008-02-03 12:42:51.000000000 +0300
@@ -10,13 +10,11 @@
 
 #ifdef __KERNEL__
 
+#include <linux/const.h>
+
 /* PAGE_SHIFT determines the page size */
 #define PAGE_SHIFT	12
-#ifdef __ASSEMBLY__
-#define PAGE_SIZE	(1 << PAGE_SHIFT)
-#else
-#define PAGE_SIZE	(1UL << PAGE_SHIFT)
-#endif
+#define PAGE_SIZE	(_AC(1, UL) << PAGE_SHIFT)
 #define PAGE_MASK	(~(PAGE_SIZE-1))
 #define PTE_MASK	PAGE_MASK
 

-- 
