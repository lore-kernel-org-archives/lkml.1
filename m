Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755961Ab0BTOOk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Feb 2010 09:14:40 -0500
Received: from mail-yx0-f200.google.com ([209.85.210.200]:61377 "EHLO
	mail-yx0-f200.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755866Ab0BTOOi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Feb 2010 09:14:38 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=iOIugXg7cfzXautgBZe2Zp9fDHQ6EQ1quRIFVCBxcjlAr3Gd1SUHt3ZREnOs2auCqv
         BkmcjtQwVjey9vh6wWKACqy+4Ry2tVyo/MDesyX5qCp/DKm6QyHHiK57bgC3p7fGRith
         KpcqQD0tv/K2Z+TWJIMafwfmMzqf7pSjnm7sA=
Date: Sat, 20 Feb 2010 22:14:31 +0800
From: Dave Young <hidave.darkstar@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       James Morris <jmorris@namei.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       linux-kernel@vger.kernel.org
Subject: [PATCH 08/18] sysctl extern cleanup - latencytop
Message-ID: <20100220141431.GG3195@darkstar>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Extern declarations in sysctl.c should be move to their own head file,
and then include them in relavant .c files.

latencytop_enabled is declcared in linux/latencytop.h, so remove the
declaration in sysctl.c, include the head file instead.

Signed-off-by: Dave Young <hidave.darkstar@gmail.com>
---
 kernel/sysctl.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-2.6.32.orig/kernel/sysctl.c	2010-02-12 13:31:27.679219480 +0800
+++ linux-2.6.32/kernel/sysctl.c	2010-02-12 13:31:54.965050841 +0800
@@ -59,6 +59,7 @@
 #include <linux/binfmts.h>
 #include <linux/pid.h>
 #include <linux/compat.h>
+#include <linux/latencytop.h>
 
 #include <asm/uaccess.h>
 #include <asm/processor.h>
@@ -73,7 +74,6 @@
 #if defined(CONFIG_SYSCTL)
 
 /* External variables not in a header file. */
-extern int latencytop_enabled;
 extern int sysctl_nr_open_min, sysctl_nr_open_max;
 #ifdef CONFIG_RCU_TORTURE_TEST
 extern int rcutorture_runnable;
