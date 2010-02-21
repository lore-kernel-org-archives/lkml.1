Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752243Ab0BUOZB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Feb 2010 09:25:01 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:55572 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752332Ab0BUOY6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Feb 2010 09:24:58 -0500
X-Greylist: delayed 84781 seconds by postgrey-1.27 at vger.kernel.org; Sun, 21 Feb 2010 09:24:33 EST
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=FFAvDqSl7pFG1G0ofs7fZ2j32GJQz04SFe3+wXeYYIyy9z+p4bdU8t+CnXVBM5hCa/
         BOICdp9n9yIvI3SGlMs6ZK+NcYzqquDbuYTVxLQFU/iAXRgDxfRoVG4dK526nWNMutiC
         yih4iKxfIzR0kHknLJtjjGsCj8JoBbLH+uD3A=
Date: Sun, 21 Feb 2010 22:24:49 +0800
From: Dave Young <hidave.darkstar@gmail.com>
To: Doug Gilbert <dgilbert@interlog.com>,
       "James E.J. Bottomley" <James.Bottomley@suse.de>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       James Morris <jmorris@namei.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>, linux-scsi@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH -mm 12/17] sysctl extern cleanup - sg
Message-ID: <20100221142449.GA3022@darkstar>
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
 include/scsi/sg.h |    3 +++
 kernel/sysctl.c   |    7 +++----
 2 files changed, 6 insertions(+), 4 deletions(-)

--- linux-2.6.32.orig/include/scsi/sg.h	2010-02-21 11:15:43.753424739 +0800
+++ linux-2.6.32/include/scsi/sg.h	2010-02-21 11:20:17.046732438 +0800
@@ -70,6 +70,9 @@ Major new features in SG 3.x driver (cf 
  (for the lk 2.2 series).
 */
 
+#ifdef __KERNEL__
+extern int sg_big_buff; /* for sysctl */
+#endif
 
 /* New interface introduced in the 3.x SG drivers follows */
 
--- linux-2.6.32.orig/kernel/sysctl.c	2010-02-21 11:20:12.086732161 +0800
+++ linux-2.6.32/kernel/sysctl.c	2010-02-21 11:21:02.202561933 +0800
@@ -63,6 +63,9 @@
 #ifdef CONFIG_BLOCK
 #include <linux/blk-iopoll.h>
 #endif
+#ifdef CONFIG_CHR_DEV_SG
+#include <scsi/sg.h>
+#endif
 
 #include <asm/uaccess.h>
 #include <asm/processor.h>
@@ -104,10 +107,6 @@ static int min_percpu_pagelist_fract = 8
 
 static int ngroups_max = NGROUPS_MAX;
 
-#ifdef CONFIG_CHR_DEV_SG
-extern int sg_big_buff;
-#endif
-
 #ifdef CONFIG_SPARC
 #include <asm/system.h>
 #endif
