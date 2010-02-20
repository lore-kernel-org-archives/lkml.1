Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756033Ab0BTORc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Feb 2010 09:17:32 -0500
Received: from mail-gx0-f217.google.com ([209.85.217.217]:47071 "EHLO
	mail-gx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755917Ab0BTORb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Feb 2010 09:17:31 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=Eee6R74X6ncvVbRl4q+d9V+u8X2URPGRlpyFRHQwKz082sCerjgl0gu8xHxLfrDl86
         TSM9kD10G9qCTQEIAiOWbtlpfToru0uJjuwpUj/lKezr3Rx1O1c9+TolR5nlRjdLn3Uj
         zGPKHOMQkke616ioTlYuJXOsiCF1FfZmKfr2A=
Date: Sat, 20 Feb 2010 22:17:20 +0800
From: Dave Young <hidave.darkstar@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       James Morris <jmorris@namei.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       linux-kernel@vger.kernel.org
Subject: [PATCH 11/18] sysctl extern cleanup - block iopoll
Message-ID: <20100220141720.GJ3195@darkstar>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Extern declarations in sysctl.c should be move to their own head file,
and then include them in relavant .c files.

blk_iopoll_enabled declared in linux/blk-iopoll.h, remove the declaration in
sysctl.c, include the head file instead.

Signed-off-by: Dave Young <hidave.darkstar@gmail.com>
---
 kernel/sysctl.c |    6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

--- linux-2.6.32.orig/kernel/sysctl.c	2010-02-12 13:43:17.754981908 +0800
+++ linux-2.6.32/kernel/sysctl.c	2010-02-12 13:44:25.191642639 +0800
@@ -61,6 +61,7 @@
 #include <linux/compat.h>
 #include <linux/latencytop.h>
 #include <linux/file.h>
+#include <linux/blk-iopoll.h>
 
 #include <asm/uaccess.h>
 #include <asm/processor.h>
@@ -74,11 +75,6 @@
 
 #if defined(CONFIG_SYSCTL)
 
-/* External variables not in a header file. */
-#ifdef CONFIG_BLOCK
-extern int blk_iopoll_enabled;
-#endif
-
 /* Constants used for minimum and  maximum */
 #ifdef CONFIG_DETECT_SOFTLOCKUP
 static int sixty = 60;
