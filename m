Return-Path: <linux-kernel-owner+w=401wt.eu-S1759311AbYCZBnq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759311AbYCZBnq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2008 21:43:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760101AbYCZBll
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Mar 2008 21:41:41 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:53346 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1762157AbYCZBli (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2008 21:41:38 -0400
Message-Id: <20080326014138.134849000@polaris-admin.engr.sgi.com>
References: <20080326014137.934171000@polaris-admin.engr.sgi.com>
User-Agent: quilt/0.46-1
Date: Tue, 25 Mar 2008 18:41:38 -0700
From: Mike Travis <travis@sgi.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] boot: increase stack size for kernel boot loader decompressor
Content-Disposition: inline; filename=compressed-head_64
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Increase stack size for the kernel bootloader decompressor.  This is
needed to boot a kernel with NR_CPUS = 4096.  I tested with 8k stack
size but that wasn't sufficient.

Based on:
	git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git
	git://git.kernel.org/pub/scm/linux/kernel/git/x86/linux-2.6-x86.git

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
