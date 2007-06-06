Return-Path: <linux-kernel-owner+w=401wt.eu-S1764751AbXFFCiG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764751AbXFFCiG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2007 22:38:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750823AbXFFChz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jun 2007 22:37:55 -0400
Received: from ozlabs.org ([203.10.76.45]:36387 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750810AbXFFChy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2007 22:37:54 -0400
Subject: [PATCH] neaten lguest boot code (again)
From: Rusty Russell <rusty@rustcorp.com.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Wed, 06 Jun 2007 12:37:39 +1000
Message-Id: <1181097459.14054.100.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

(This cleanup seems to have gotten lost in rc3-mm1?  It was in rc2-mm1
called lguest-the-host-code-update-for-mm-simplify-boot_params.patch)

Andrew patched up lguest after the boot parameters became a proper
structure, but in fact it can be considerably neatened.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
---
 drivers/lguest/lguest.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

===================================================================
--- a/drivers/lguest/lguest.c
+++ b/drivers/lguest/lguest.c
@@ -444,8 +444,7 @@ __init void lguest_init(void *boot)
 {
 	/* Copy boot parameters first. */
 	memcpy(&boot_params, boot, PARAM_SIZE);
-	memcpy(boot_command_line,
-	       __va(*(unsigned long *)((void *)&boot_params + NEW_CL_POINTER)),
+	memcpy(boot_command_line, __va(boot_params.hdr.cmd_line_ptr),
 	       COMMAND_LINE_SIZE);
 
 	paravirt_ops.name = "lguest";


