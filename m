Return-Path: <linux-kernel-owner+w=401wt.eu-S1754798AbXKEHK6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754798AbXKEHK6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2007 02:10:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752897AbXKEHKv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Nov 2007 02:10:51 -0500
Received: from ro-out-1112.google.com ([72.14.202.176]:3963 "EHLO
	ro-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752798AbXKEHKt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2007 02:10:49 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:reply-to:mime-version:content-type:content-disposition:user-agent;
        b=DJd0N9hyCIsl0ENZy2amqPFhtFMaGAQ3GvmmdoHPRrj16S6teScNkADVO9xVwe9wwkj28deqbXNzo9r5eZVN9mVJbQT1p85zpBRbk7aKmeuIdum02+q0BbuxfWIzmW5Khg4vDKAl1WNDtEB/WM3JglWb+Ntf5XiG961foN3DTGg=
Date: Mon, 5 Nov 2007 15:09:53 +0800
From: WANG Cong <xiyou.wangcong@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: linux-kbuild@vger.kernel.org, Sam Ravnborg <sam@ravnborg.org>,
       Andrew Morton <akpm@osdl.org>
Subject: [Git Patch] Makefile: fix wrong dirs when making cscope
Message-ID: <20071105070953.GB2461@hacking>
Reply-To: WANG Cong <xiyou.wangcong@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Hi, Sam!

This patch fixed the following errors when doing "make cscope" and
"make cscope ARCH=um".

  FILELST cscope.files
find: arch/i386: No such file or directory
  MAKE    cscope.out


  FILELST cscope.files
find: include/asm-i386: No such file or directory
  MAKE    cscope.out


Signed-off-by: WANG Cong <xiyou.wangcong@gmail.com>
Cc: Sam Ravnborg <sam@ravnborg.org>

---
 Makefile |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: linux-2.6/Makefile
===================================================================
--- linux-2.6.orig/Makefile
+++ linux-2.6/Makefile
@@ -1322,7 +1322,7 @@ ALLSOURCE_ARCHS := $(ARCH) $(SRCARCH)
 endif
 
 define find-sources
-        ( for arch in $(ALLSOURCE_ARCHS) ; do \
+        ( for arch in `echo $(ALLSOURCE_ARCHS)|sed -e "s/i386/x86/"`; do \
 	       find $(__srctree)arch/$${arch} $(RCS_FIND_IGNORE) \
 	            -name $1 -print; \
 	  done ; \
@@ -1331,7 +1331,7 @@ define find-sources
 	  find $(__srctree)include $(RCS_FIND_IGNORE) \
 	       \( -name config -o -name 'asm-*' \) -prune \
 	       -o -name $1 -print; \
-	  for arch in $(ALLINCLUDE_ARCHS) ; do \
+	  for arch in `echo $(ALLINCLUDE_ARCHS)|sed -e "s/i386/x86/"`; do \
 	       find $(__srctree)include/asm-$${arch} $(RCS_FIND_IGNORE) \
 	            -name $1 -print; \
 	  done ; \

