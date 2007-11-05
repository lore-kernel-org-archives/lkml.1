Return-Path: <linux-kernel-owner+w=401wt.eu-S1756267AbXKEMHn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756267AbXKEMHn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2007 07:07:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754346AbXKEMHg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Nov 2007 07:07:36 -0500
Received: from ro-out-1112.google.com ([72.14.202.177]:10604 "EHLO
	ro-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754140AbXKEMHe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2007 07:07:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:reply-to:mime-version:content-type:content-disposition:user-agent;
        b=P50yhkUvsES79+CIJADvKyWJ8pv6dFtRtFNo22wFtIguajvvXVyrROwWMxTddm2DLu7a0noPHfdaFVW5fLo0CJSrOISf8KapCnyzVxv4FrN4FS71QrmuBiqA2MoWoALvDRHWqZHpx3lB4OtnWwjjs6Et18WRkT52rowQQFZma5c=
Date: Mon, 5 Nov 2007 20:06:14 +0800
From: WANG Cong <xiyou.wangcong@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Sam Ravnborg <sam@ravnborg.org>, linux-kbuild@vger.kernel.org,
       Andrew Morton <akpm@osdl.org>
Subject: [Git Patch][Resend] Makefile: fix wrong dirs when making cscope
Message-ID: <20071105120614.GA8245@hacking>
Reply-To: WANG Cong <xiyou.wangcong@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Hi, Sam! Is this one OK for you?

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
 Makefile |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/Makefile b/Makefile
index 188c3b6..7bc0bf7 100644
--- a/Makefile
+++ b/Makefile
@@ -1309,6 +1309,7 @@ ALLINCLUDE_ARCHS := $(ARCH) $(SUBARCH)
 else
 ALLINCLUDE_ARCHS := $(SRCARCH)
 endif
+ALLINCLUDE_ARCHS := $(shell echo $(ALLINCLUDE_ARCHS)|sed -e "s/i386/x86/")
 else
 #Allow user to specify only ALLSOURCE_PATHS on the command line, keeping existing behavour.
 ALLINCLUDE_ARCHS := $(ALLSOURCE_ARCHS)
@@ -1318,7 +1319,7 @@ endif
 ifeq ($(ARCH), $(SRCARCH))
 ALLSOURCE_ARCHS := $(ARCH)
 else
-ALLSOURCE_ARCHS := $(ARCH) $(SRCARCH)
+ALLSOURCE_ARCHS := $(shell echo $(ARCH) $(SRCARCH)|sed -e "s/i386/x86/")
 endif
 
 define find-sources
