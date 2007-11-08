Return-Path: <linux-kernel-owner+w=401wt.eu-S1760196AbXKHJXs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760196AbXKHJXs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2007 04:23:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758165AbXKHJXk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Nov 2007 04:23:40 -0500
Received: from ro-out-1112.google.com ([72.14.202.177]:52163 "EHLO
	ro-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751414AbXKHJXj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2007 04:23:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:reply-to:mime-version:content-type:content-disposition:user-agent;
        b=acpj7x43RaBAxcPS/GrviSpPs7v38uvRUP+RA5MKEDFJqr3WYk6WbPJV0gjly7dBIqB5N0ytbzxCeMenAoc7V7NE7zmnjV/Dp0SoONHDEIrJTedGOoayl3KG1tsilA+MFywR2rzLxXYOFwF0Q9rdrPKO593p5j75FMLT+6yw4pE=
Date: Thu, 8 Nov 2007 17:22:11 +0800
From: WANG Cong <xiyou.wangcong@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Sam Ravnborg <sam@ravnborg.org>, linux-kbuild@vger.kernel.org,
       Andrew Morton <akpm@osdl.org>
Subject: [Patch](Resend) Makefile: Fix wrong i386 directory when making
	cscope
Message-ID: <20071108092210.GD2479@hacking>
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

diff --git a/Makefile b/Makefile
index e28dde8..01335ca 100644
--- a/Makefile
+++ b/Makefile
@@ -1322,6 +1322,7 @@ ALLINCLUDE_ARCHS := $(ARCH) $(SUBARCH)
 else
 ALLINCLUDE_ARCHS := $(SRCARCH)
 endif
+ALLINCLUDE_ARCHS := $(shell echo $(ALLINCLUDE_ARCHS)|sed -e "s/i386/x86/")
 else
 #Allow user to specify only ALLSOURCE_PATHS on the command line, keeping existing behavour.
 ALLINCLUDE_ARCHS := $(ALLSOURCE_ARCHS)
@@ -1331,7 +1332,7 @@ endif
 ifeq ($(ARCH), $(SRCARCH))
 ALLSOURCE_ARCHS := $(ARCH)
 else
-ALLSOURCE_ARCHS := $(ARCH) $(SRCARCH)
+ALLSOURCE_ARCHS := $(shell echo $(ARCH) $(SRCARCH)|sed -e "s/i386/x86/")
 endif
 
 define find-sources
