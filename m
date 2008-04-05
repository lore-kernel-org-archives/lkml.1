Return-Path: <linux-kernel-owner+w=401wt.eu-S1755354AbYDEBal@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755354AbYDEBal (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2008 21:30:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751974AbYDEBaS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Apr 2008 21:30:18 -0400
Received: from relay1.sgi.com ([192.48.171.29]:36926 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751930AbYDEBaP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2008 21:30:15 -0400
Message-Id: <20080405013014.693571000@polaris-admin.engr.sgi.com>
References: <20080405013014.478571000@polaris-admin.engr.sgi.com>
User-Agent: quilt/0.46-1
Date: Fri, 04 Apr 2008 18:30:15 -0700
From: Mike Travis <travis@sgi.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] boot: increase stack size for kernel boot loader decompressor
Content-Disposition: inline; filename=compressed-head_64
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  * Increase stack size for the kernel bootloader decompressor.  This is
    needed to boot a kernel with NR_CPUS = 4096.  I tested with 8k stack
    size but that wasn't sufficient.

Based on:
	git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git
    +   x86/latest          .../x86/linux-2.6-x86.git
    +   sched-devel/latest  .../mingo/linux-2.6-sched-devel.git

Signed-off-by: Mike Travis <travis@sgi.com>
---
 arch/x86/boot/compressed/head_64.S |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-2.6.25-rc5.orig/arch/x86/boot/compressed/head_64.S
+++ linux-2.6.25-rc5/arch/x86/boot/compressed/head_64.S
@@ -314,5 +314,5 @@ gdt_end:
 /* Stack for uncompression */
 	.balign 4
 user_stack:
-	.fill 4096,4,0
+	.fill 16384,4,0
 user_stack_end:

-- 
