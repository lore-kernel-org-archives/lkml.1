Return-Path: <linux-kernel-owner+w=401wt.eu-S1763518AbXKNTR3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763518AbXKNTR3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2007 14:17:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759248AbXKNTQ5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Nov 2007 14:16:57 -0500
Received: from pasmtpb.tele.dk ([80.160.77.98]:35041 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756279AbXKNTQz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2007 14:16:55 -0500
Date: Wed, 14 Nov 2007 20:18:36 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: WANG Cong <xiyou.wangcong@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-kbuild@vger.kernel.org,
       Andrew Morton <akpm@osdl.org>
Subject: Re: [Git Patch][Resend] Makefile: fix wrong dirs when making cscope
Message-ID: <20071114191836.GA10047@uranus.ravnborg.org>
References: <20071105120614.GA8245@hacking>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071105120614.GA8245@hacking>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi WANG.

I ended up adding the following patch.
It fixes both x86_64 and i386 and is simpler.
Plus I included the ncscope.out thing in the same patch.

	Sam

commit 5683c81430f9cf2a2eaf71ce93291f00b528b6c4
Author: WANG Cong <xiyou.wangcong@gmail.com>
Date:   Thu Nov 8 17:22:11 2007 +0800

    kbuild: fix cscope so it does not emit warnings
    
    This patch fixed the following errors when doing "make cscope" and
    "make cscope ARCH=um".
    
      FILELST cscope.files
    find: arch/i386: No such file or directory
      MAKE    cscope.out
    
      FILELST cscope.files
    find: include/asm-i386: No such file or directory
      MAKE    cscope.out
    
    In addition it teach kbuild to delete ncscope.out at mrproper
    
    Signed-off-by: WANG Cong <xiyou.wangcong@gmail.com>
    Signed-off-by: Sam Ravnborg <sam@ravnborg.org>

diff --git a/Makefile b/Makefile
index cb740d4..1d48b0f 100644
--- a/Makefile
+++ b/Makefile
@@ -1086,7 +1086,7 @@ MRPROPER_DIRS  += include/config include2 usr/include
 MRPROPER_FILES += .config .config.old include/asm .version .old_version \
                   include/linux/autoconf.h include/linux/version.h      \
                   include/linux/utsrelease.h                            \
-		  Module.symvers tags TAGS cscope*
+		  Module.symvers tags TAGS *cscope*
 
 # clean - Delete most, but leave enough to build external modules
 #
@@ -1318,7 +1318,7 @@ endif
 
 ifeq ($(ALLSOURCE_ARCHS),)
 ifeq ($(ARCH),um)
-ALLINCLUDE_ARCHS := $(ARCH) $(SUBARCH)
+ALLINCLUDE_ARCHS := $(SRCARCH) $(SUBARCH)
 else
 ALLINCLUDE_ARCHS := $(SRCARCH)
 endif
@@ -1327,12 +1327,7 @@ else
 ALLINCLUDE_ARCHS := $(ALLSOURCE_ARCHS)
 endif
 
-# Take care of arch/x86
-ifeq ($(ARCH), $(SRCARCH))
-ALLSOURCE_ARCHS := $(ARCH)
-else
-ALLSOURCE_ARCHS := $(ARCH) $(SRCARCH)
-endif
+ALLSOURCE_ARCHS := $(SRCARCH)
 
 define find-sources
         ( for arch in $(ALLSOURCE_ARCHS) ; do \
