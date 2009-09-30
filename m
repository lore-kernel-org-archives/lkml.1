Return-Path: <linux-kernel-owner+w=401wt.eu-S1754508AbZI3OJG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754508AbZI3OJG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Sep 2009 10:09:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753382AbZI3OJF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Sep 2009 10:09:05 -0400
Received: from one.firstfloor.org ([213.235.205.2]:50552 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752878AbZI3OJF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Sep 2009 10:09:05 -0400
Date: Wed, 30 Sep 2009 16:09:04 +0200
From: Andi Kleen <andi@firstfloor.org>
To: x86@kernel.org, linux-kernel@vger.kernel.org
Cc: Borislav Petkov <borislav.petkov@amd.com>, torvalds@osdl.org
Subject: x86: mce: Please revert 22223c9b417be5fd0ab2cf9ad17eb7bd1e19f7b9
Message-ID: <20090930140904.GA6150@one.firstfloor.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Can someone please revert this incorrect commit that's in mainline
now? 

Obviously kernels compiled with AMD support can still run on non
AMD systems, so messages like this can never be removed at compile time.

-andi

Commit 22223c9b417be5fd0ab2cf9ad17eb7bd1e19f7b9
Author: Borislav Petkov <borislav.petkov@amd.com>
Date:   Tue Jul 28 14:47:10 2009 +0200

    x86, mce: do not compile mcelog message on AMD
    
    Now that decoding is done in-kernel, suppress mcelog message part.
    
    CC: Andi Kleen <andi@firstfloor.org>
    Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>

diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
index b82866f..9bfe9d2 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -222,7 +222,10 @@ static void print_mce_head(void)
 static void print_mce_tail(void)
 {
        printk(KERN_EMERG "This is not a software problem!\n"
-              "Run through mcelog --ascii to decode and contact your hardware vendor\n");
+#if (!defined(CONFIG_EDAC) || !defined(CONFIG_CPU_SUP_AMD))
+              "Run through mcelog --ascii to decode and contact your hardware vendor\n"
+#endif
+              );
 }
 
 #define PANIC_TIMEOUT 5 /* 5 seconds */

-- 
ak@linux.intel.com -- Speaking for myself only.
