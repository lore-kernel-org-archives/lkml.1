Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752522Ab0BUOYf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Feb 2010 09:24:35 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:55572 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752262Ab0BUOYd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Feb 2010 09:24:33 -0500
X-Greylist: delayed 84781 seconds by postgrey-1.27 at vger.kernel.org; Sun, 21 Feb 2010 09:24:33 EST
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=DSfdw/gy3MZW7SnFOE6K9BD7E0ae4iQnhgn6mahX3ZPUdjnB9TBZ7G//fXasqQVMu8
         QR0zW5yaJb/SVNzeLGse7v+YO30hIZfXg8GspEVFw8uTMZ2qHBX4ZXQpDxBt/sgWoEnX
         N6D85IG/1e2/gHFwebffWooY4fMJGT2I5yeRY=
Date: Sun, 21 Feb 2010 22:24:25 +0800
From: Dave Young <hidave.darkstar@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       James Morris <jmorris@namei.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       linux-kernel@vger.kernel.org
Subject: [PATCH -mm 10/17] sysctl extern cleanup - block iopoll
Message-ID: <20100221142425.GA3016@darkstar>
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
 kernel/sysctl.c |    6 +++---
 1 file changed, 3 insertion(+), 3 deletions(-)

--- linux-2.6.32.orig/kernel/sysctl.c	2010-02-21 10:01:30.257204779 +0800
+++ linux-2.6.32/kernel/sysctl.c	2010-02-21 11:16:42.329254793 +0800
@@ -60,6 +60,9 @@
 #include <linux/compat.h>
 #include <linux/latencytop.h>
 #include <linux/file.h>
+#ifdef CONFIG_BLOCK
+#include <linux/blk-iopoll.h>
+#endif
 
 #include <asm/uaccess.h>
 #include <asm/processor.h>
@@ -75,9 +78,6 @@
 
 /* External variables not in a header file. */
 extern int max_threads;
-#ifdef CONFIG_BLOCK
-extern int blk_iopoll_enabled;
-#endif
 
 /* Constants used for minimum and  maximum */
 #ifdef CONFIG_DETECT_SOFTLOCKUP
