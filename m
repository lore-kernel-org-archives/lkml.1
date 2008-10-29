Return-Path: <linux-kernel-owner+w=401wt.eu-S1754940AbYJ2W32@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754940AbYJ2W32 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2008 18:29:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753497AbYJ2W3U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Oct 2008 18:29:20 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:53411 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752041AbYJ2W3T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2008 18:29:19 -0400
Date: Wed, 29 Oct 2008 17:29:18 -0500
From: Russ Anderson <rja@sgi.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-kernel@vger.kernel.org, linux-ia64@vger.kernel.org,
       linux-next@vger.kernel.org
Subject: [PATCH trivial] ia64: Fix gru compiler warning
Message-ID: <20081029222918.GA71188@sgi.com>
Reply-To: Russ Anderson <rja@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix compiler warning in sgi-gru driver.

Signed-off-by: Russ Anderson <rja@sgi.com>

---
Andrew,

This patch gets rid of the gru compiler warnings.


In file included from drivers/misc/sgi-gru/gruhandles.h:25,
                 from drivers/misc/sgi-gru/grutables.h:151,
                 from drivers/misc/sgi-gru/grufile.c:41:
drivers/misc/sgi-gru/gru_instructions.h: In function `gru_flush_cache':
drivers/misc/sgi-gru/gru_instructions.h:292: warning: passing arg 1 of pointer to
function makes integer from pointer without a cast



 drivers/misc/sgi-gru/gru_instructions.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: test/drivers/misc/sgi-gru/gru_instructions.h
===================================================================
--- test.orig/drivers/misc/sgi-gru/gru_instructions.h	2008-10-29 11:19:56.000000000 -0500
+++ test/drivers/misc/sgi-gru/gru_instructions.h	2008-10-29 14:23:43.230943026 -0500
@@ -29,7 +29,7 @@
 #if defined(CONFIG_IA64)
 #include <linux/compiler.h>
 #include <asm/intrinsics.h>
-#define __flush_cache(p)		ia64_fc(p)
+#define __flush_cache(p)		ia64_fc((unsigned long)p)
 /* Use volatile on IA64 to ensure ordering via st4.rel */
 #define gru_ordered_store_int(p,v)					\
 		do {							\
-- 
Russ Anderson, OS RAS/Partitioning Project Lead  
SGI - Silicon Graphics Inc          rja@sgi.com
