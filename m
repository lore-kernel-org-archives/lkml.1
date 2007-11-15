Return-Path: <linux-kernel-owner+w=401wt.eu-S1757760AbXKONgh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757760AbXKONgh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 08:36:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757124AbXKONg3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 08:36:29 -0500
Received: from ro-out-1112.google.com ([72.14.202.180]:17889 "EHLO
	ro-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756854AbXKONg2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 08:36:28 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:reply-to:mime-version:content-type:content-disposition:user-agent;
        b=NU6NgXUvao6D7QpiwTcT7mD17FsJoEMd4Brpp7BWUB8Tar198h9Uq0i6thtWX+5Kb/gIT4wXtOhQCKOZIKvO+ShxktYkfOyBMV3Uzp1kSqyIxy3py0SuuF5p+Wrkmitq/6mvBAOkdHCHjIcljqsNmMnGLicXJlGRPMWMDVUiyO0=
Date: Thu, 15 Nov 2007 21:34:21 +0800
From: WANG Cong <xiyou.wangcong@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Jeff Dike <jdike@karaya.com>, Andrew Morton <akpm@osdl.org>,
       user-mode-linux-devel@lists.sourceforge.net
Subject: [Patch] UML: building error fix
Message-ID: <20071115133421.GD2489@hacking>
Reply-To: WANG Cong <xiyou.wangcong@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


include/asm-um/arch points to the non-existed include/asm-i386 directory.
This patch fixed it.

Signed-off-by: WANG Cong <xiyou.wangcong@gmail.com>
Cc: Jeff Dike <jdike@karaya.com>

---

diff --git a/arch/um/Makefile b/arch/um/Makefile
index 31999bc..ba6813a 100644
--- a/arch/um/Makefile
+++ b/arch/um/Makefile
@@ -168,7 +168,7 @@ ifneq ($(KBUILD_SRC),)
 	$(Q)mkdir -p $(objtree)/include/asm-um
 	$(Q)ln -fsn $(srctree)/include/asm-$(HEADER_ARCH) include/asm-um/arch
 else
-	$(Q)cd $(TOPDIR)/include/asm-um && ln -fsn ../asm-$(SUBARCH) arch
+	$(Q)cd $(TOPDIR)/include/asm-um && ln -fsn ../asm-$(HEADER_ARCH) arch
 endif
 
 $(objtree)/$(ARCH_DIR)/include:
