Return-Path: <linux-kernel-owner+w=401wt.eu-S1760186AbXERCoI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760186AbXERCoI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2007 22:44:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756899AbXERCn5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 May 2007 22:43:57 -0400
Received: from ozlabs.org ([203.10.76.45]:50038 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756235AbXERCn4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2007 22:43:56 -0400
Subject: [PATCH 1/2] lguest update for mm: simplify boot_params
From: Rusty Russell <rusty@rustcorp.com.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Fri, 18 May 2007 12:43:44 +1000
Message-Id: <1179456224.17608.23.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew patched up lguest after the boot parameters became a proper
structure, but in fact it can be considerably neatened.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

diff -r ffe7ce731118 drivers/lguest/lguest.c
--- a/drivers/lguest/lguest.c	Fri May 18 10:18:56 2007 +1000
+++ b/drivers/lguest/lguest.c	Fri May 18 11:04:19 2007 +1000
@@ -444,8 +444,7 @@ __init void lguest_init(void *boot)
 {
 	/* Copy boot parameters first. */
 	memcpy(&boot_params, boot, PARAM_SIZE);
-	memcpy(boot_command_line,
-	       __va(*(unsigned long *)((void *)&boot_params + NEW_CL_POINTER)),
+	memcpy(boot_command_line, __va(boot_params.hdr.cmd_line_ptr),
 	       COMMAND_LINE_SIZE);
 
 	paravirt_ops.name = "lguest";


