Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756140Ab0BTOTN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Feb 2010 09:19:13 -0500
Received: from mail-yx0-f200.google.com ([209.85.210.200]:51465 "EHLO
	mail-yx0-f200.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755974Ab0BTOTM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Feb 2010 09:19:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=erQuiW3vDoumWswMdNmyaAzP9iGwyMkfrmQ74z2SVpUo4ffnB6tW68fdUmownrsaYP
         wrqcPiIkxnpfB2Mr9yGE7/B2ILEEHqI8bHZ3Fx463yjUHTZOLCsYc78LmYppS4UFQzeX
         8AShP70eOsQLSUSmjB+XS0LX8+qilMK7u0R7w=
Date: Sat, 20 Feb 2010 22:19:03 +0800
From: Dave Young <hidave.darkstar@gmail.com>
To: Doug Gilbert <dgilbert@interlog.com>,
       "James E.J. Bottomley" <James.Bottomley@suse.de>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       James Morris <jmorris@namei.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>, linux-scsi@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH 13/18] sysctl extern cleanup - sg
Message-ID: <20100220141903.GL3195@darkstar>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Extern declarations in sysctl.c should be move to their own head file,
and then include them in relavant .c files.

Move sg_big_buff extern declaration to scsi/sg.h

Signed-off-by: Dave Young <hidave.darkstar@gmail.com>
---
 include/scsi/sg.h |    5 +++++
 kernel/sysctl.c   |    5 +----
 2 files changed, 6 insertions(+), 4 deletions(-)

--- linux-2.6.32.orig/include/scsi/sg.h	2010-02-20 14:02:18.708258892 +0800
+++ linux-2.6.32/include/scsi/sg.h	2010-02-20 14:39:48.631369361 +0800
@@ -70,6 +70,11 @@ Major new features in SG 3.x driver (cf 
  (for the lk 2.2 series).
 */
 
+#ifdef __KERNEL__
+#if defined(CONFIG_SYSCTL) && defined(CONFIG_CHR_DEV_SG)
+extern int sg_big_buff;
+#endif
+#endif
 
 /* New interface introduced in the 3.x SG drivers follows */
 
--- linux-2.6.32.orig/kernel/sysctl.c	2010-02-20 14:27:50.691439411 +0800
+++ linux-2.6.32/kernel/sysctl.c	2010-02-20 14:38:51.008872869 +0800
@@ -62,6 +62,7 @@
 #include <linux/latencytop.h>
 #include <linux/file.h>
 #include <linux/blk-iopoll.h>
+#include <scsi/sg.h>
 
 #include <asm/uaccess.h>
 #include <asm/processor.h>
@@ -100,10 +101,6 @@ static int min_percpu_pagelist_fract = 8
 
 static int ngroups_max = NGROUPS_MAX;
 
-#ifdef CONFIG_CHR_DEV_SG
-extern int sg_big_buff;
-#endif
-
 #ifdef CONFIG_SPARC
 #include <asm/system.h>
 #endif
