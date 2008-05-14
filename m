Return-Path: <linux-kernel-owner+w=401wt.eu-S1762865AbYENPQN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762865AbYENPQN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2008 11:16:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760315AbYENPP0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 May 2008 11:15:26 -0400
Received: from relay1.sgi.com ([192.48.171.29]:48174 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1760209AbYENPPY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2008 11:15:24 -0400
From: Paul Jackson <pj@sgi.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Cc: "Thomas Gleixner" <tglx@linutronix.de>, "Jack Steiner" <steiner@sgi.com>,
       "Mike Travis" <travis@sgi.com>, "H. Peter Anvin" <hpa@zytor.com>,
       linux-kernel@vger.kernel.org, "Huang, Ying" <ying.huang@intel.com>,
       "Andi Kleen" <andi@firstfloor.org>, "Ingo Molnar" <mingo@elte.hu>,
       Paul Jackson <pj@sgi.com>
Date: Wed, 14 May 2008 08:15:23 -0700
Message-Id: <20080514151523.148486.35372.sendpatchset@jackhammer.engr.sgi.com>
In-Reply-To: <20080514151504.148486.32236.sendpatchset@jackhammer.engr.sgi.com>
References: <20080514151504.148486.32236.sendpatchset@jackhammer.engr.sgi.com>
Subject: [PATCH 4/10] x86 boot: simplify pageblock_bits enum declaration
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Paul Jackson <pj@sgi.com>

The use of #defines with '##' pre-processor concatenation is a useful
way to form several symbol names with a common pattern.  But when there
is just a single name obtained from that #define, it's just obfuscation.
Better to just write the plain symbol name, as is.

The following patch is a result of my wasting ten minutes looking through
the kernel to figure out what 'PB_migrate_end' meant, and forgetting what
I came to do, by the time I figured out that the #define PB_range macro
defined it.

Signed-off-by: Paul Jackson <pj@sgi.com>

---
 include/linux/pageblock-flags.h |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

--- linux.orig/include/linux/pageblock-flags.h	2008-05-13 05:42:39.869811856 -0700
+++ linux/include/linux/pageblock-flags.h	2008-05-13 05:51:47.994829315 -0700
@@ -25,13 +25,11 @@
 
 #include <linux/types.h>
 
-/* Macro to aid the definition of ranges of bits */
-#define PB_range(name, required_bits) \
-	name, name ## _end = (name + required_bits) - 1
-
 /* Bit indices that affect a whole block of pages */
 enum pageblock_bits {
-	PB_range(PB_migrate, 3), /* 3 bits required for migrate types */
+	PB_migrate,
+	PB_migrate_end = PB_migrate + 3 - 1,
+			/* 3 bits required for migrate types */
 	NR_PAGEBLOCK_BITS
 };
 

-- 
                          I won't rest till it's the best ...
                          Programmer, Linux Scalability
                          Paul Jackson <pj@sgi.com> 1.650.933.1373
