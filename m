Return-Path: <linux-kernel-owner+w=401wt.eu-S1755882AbYFPG35@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755882AbYFPG35 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2008 02:29:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752104AbYFPG3r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jun 2008 02:29:47 -0400
Received: from relay1.sgi.com ([192.48.171.29]:50784 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752064AbYFPG3q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2008 02:29:46 -0400
From: Paul Jackson <pj@sgi.com>
To: "Ingo Molnar" <mingo@elte.hu>
Cc: "Thomas Gleixner" <tglx@linutronix.de>,
       "Yinghai Lu" <yhlu.kernel@gmail.com>, "Jack Steiner" <steiner@sgi.com>,
       "Mike Travis" <travis@sgi.com>, "H. Peter Anvin" <hpa@zytor.com>,
       linux-kernel@vger.kernel.org, "Huang, Ying" <ying.huang@intel.com>,
       "Andi Kleen" <andi@firstfloor.org>,
       "Andrew Morton" <akpm@linux-foundation.org>, Paul Jackson <pj@sgi.com>
Date: Sun, 15 Jun 2008 23:29:45 -0700
Message-Id: <20080616062945.14597.78009.sendpatchset@polaris-admin.engr.sgi.com>
Subject: [PATCH 1/8] x86 boot: x86_64 build reserve_bootmem_generic fix
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Paul Jackson <pj@sgi.com>

Fix x86_64 build.  The addition of a third 'flags' argument
to reserve_bootmem() and similar routines missed one instance.

Signed-off-by: Paul Jackson <pj@sgi.com>

---
 arch/x86/kernel/e820.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- linux.orig/arch/x86/kernel/e820.c	2008-06-10 21:31:21.000000000 -0700
+++ linux/arch/x86/kernel/e820.c	2008-06-10 22:37:27.256448098 -0700
@@ -636,7 +636,8 @@ void __init early_res_to_bootmem(u64 sta
 		printk(KERN_INFO "  early res: %d [%llx-%llx] %s\n", i,
 			final_start, final_end - 1, r->name);
 #ifdef CONFIG_X86_64
-		reserve_bootmem_generic(final_start, final_end - final_start);
+		reserve_bootmem_generic(final_start, final_end - final_start,
+				BOOTMEM_DEFAULT);
 #else
 		reserve_bootmem(final_start, final_end - final_start,
 				BOOTMEM_DEFAULT);

-- 
                          I won't rest till it's the best ...
                          Programmer, Linux Scalability
                          Paul Jackson <pj@sgi.com> 1.650.933.1373
