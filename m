Return-Path: <linux-kernel-owner+w=401wt.eu-S933045AbXGVMuZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933045AbXGVMuZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jul 2007 08:50:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760801AbXGVMuH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jul 2007 08:50:07 -0400
Received: from mailhub.sw.ru ([195.214.233.200]:5317 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755099AbXGVMuG (ORCPT <rfc822;Linux-Kernel@vger.kernel.org>);
	Sun, 22 Jul 2007 08:50:06 -0400
Date: Sun, 22 Jul 2007 16:50:39 +0400
From: Dmitry Monakhov <dmonakhov@openvz.org>
To: Linux-Kernel@vger.kernel.org
Cc: hpa@zytor.com
Subject: [PATCH 2/2] x86: ignore_int cleanup
Message-ID: <20070722125039.GB20538@dnb.sw.ru>
Mail-Followup-To: Linux-Kernel@vger.kernel.org, hpa@zytor.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: SWsoft
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

- for argument was pushed to the stack, but printk use only three of
  them.

Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
---
 arch/i386/kernel/head.S |    7 +++----
 1 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/arch/i386/kernel/head.S b/arch/i386/kernel/head.S
index 7c52b22..9bcd106 100644
--- a/arch/i386/kernel/head.S
+++ b/arch/i386/kernel/head.S
@@ -481,10 +481,9 @@ ignore_int:
 	cmpl $2,early_recursion_flag
 	je hlt_loop
 	incl early_recursion_flag
-	pushl 16(%esp)
-	pushl 24(%esp)
-	pushl 32(%esp)
-	pushl 40(%esp)
+	pushl 20(%esp)
+	pushl 28(%esp)
+	pushl 36(%esp)
 	pushl $int_msg
 #ifdef CONFIG_EARLY_PRINTK
 	call early_printk
-- 
1.5.2.2


