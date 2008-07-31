Return-Path: <linux-kernel-owner+w=401wt.eu-S1755490AbYGaMMY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755490AbYGaMMY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2008 08:12:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752033AbYGaMMP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jul 2008 08:12:15 -0400
Received: from nf-out-0910.google.com ([64.233.182.190]:4453 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751374AbYGaMMO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2008 08:12:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=pshGijT6cC5dSNj2jpkxLB5p0oO02ZZRU8lbNeFcoORjo8XsaIg33XSJF4O9eu6ttf
         CRmLDKKknURhsSTNi/+LgQFJU/dAcOmT0Z1OYwImxqX6vFURhqK4sRzCkH3S82fYrBZh
         yM87QMqoP6W3R7/15PMxa76RnHJ2rmVk3QSEk=
Date: Thu, 31 Jul 2008 13:10:28 +0100
From: WANG Cong <xiyou.wangcong@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: jdike@addtoit.com, sam@ravnborg.org, linux-kbuild@vger.kernel.org,
       user-mode-linux-devel@lists.sourceforge.net,
       Andrew Morton <akpm@osdl.org>
Subject: [Patch] UML build: fix missing posix_types.h
Message-ID: <20080731121028.GA23636@hack.voiplan.pt>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


When building UML with 'O=foo' specified, I got:

CC      kernel/bounds.s
  In file included from
/home/wangcong/Projects/linux-2.6/include/linux/types.h:11,
                 from
/home/wangcong/Projects/linux-2.6/include/linux/page-flags.h:8,
                 from
/home/wangcong/Projects/linux-2.6/kernel/bounds.c:9:
/home/wangcong/Projects/linux-2.6/include/linux/posix_types.h:47:29:
error: asm/posix_types.h: No such file or directory
In file included from
/home/wangcong/Projects/linux-2.6/include/linux/page-flags.h:8,
                 from
/home/wangcong/Projects/linux-2.6/kernel/bounds.c:9:
/home/wangcong/Projects/linux-2.6/include/linux/types.h:12:23: error:
asm/types.h: No such file or directory
In file included from
/home/wangcong/Projects/linux-2.6/include/linux/page-flags.h:8,

Below patch fixed it, note, it is only tested for x86 and um.

Signed-off-by: WANG Cong <wangcong@zeuux.org>
Cc: sam@ravnborg.org
Cc: jdike@addtoit.com

---
diff --git a/Makefile b/Makefile
index aa527a4..39130d1 100644
--- a/Makefile
+++ b/Makefile
@@ -930,7 +930,8 @@ ifneq ($(KBUILD_SRC),)
 		/bin/false; \
 	fi;
 	$(Q)if [ ! -d include2 ]; then mkdir -p include2; fi;
-	$(Q)if [ -e $(srctree)/include/asm-$(SRCARCH)/system.h ]; then  \
+	$(Q)if [ -e $(srctree)/include/asm-$(SRCARCH)/system.h -o \
+		 -e $(objtree)/include/asm-$(SRCARCH)/system.h ] ; then \
 	    ln -fsn $(srctree)/include/asm-$(SRCARCH) include2/asm;     \
 	    fi
 endif


