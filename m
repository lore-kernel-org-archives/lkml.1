Return-Path: <linux-kernel-owner+w=401wt.eu-S1754742AbYAAOAO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754742AbYAAOAO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jan 2008 09:00:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753923AbYAAOAA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jan 2008 09:00:00 -0500
Received: from po-out-1718.google.com ([72.14.252.156]:3157 "EHLO
	po-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753604AbYAAN77 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jan 2008 08:59:59 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:reply-to:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=ZncYO6ZSBOwA6Rn/iCIZUZ5OwmKHiXAk5tpcQxQibbdG6bOpDMlpNa73ciMtwM7VMIKSLzVo490o3eX+f0DJZEGihC3EX7GElKPnB/0PyaGJi60kf8o/zp9BKaxJbc296FrJpmicjpfefR4kwuM3Bgtw+hBiaQN+jJP7Jfkn3XQ=
Date: Tue, 1 Jan 2008 22:00:04 +0800
From: WANG Cong <xiyou.wangcong@gmail.com>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: WANG Cong <xiyou.wangcong@gmail.com>, David Howells <dhowells@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>, linux-kbuild@vger.kernel.org,
       Andrew Morton <akpm@osdl.org>
Subject: (Try #2) [Patch 6/8] FRV: Drop 'TOPDIR' from Makefiles
Message-ID: <20080101140004.GF2499@hacking>
Reply-To: WANG Cong <xiyou.wangcong@gmail.com>
References: <20080101071311.GA2496@hacking> <20080101073645.GG2496@hacking> <20080101102759.GF28913@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080101102759.GF28913@uranus.ravnborg.org>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>
>In this file we can just drop use of $(TOPDIR) since this is our
>current directory anyway.

Thanks!

-------->

This patch drops TOPDIR from frv Makefiles.

Cc: David Howells <dhowells@redhat.com>
Cc: Sam Ravnborg <sam@ravnborg.org>
Signed-off-by: WANG Cong <xiyou.wangcong@gmail.com>

---

diff --git a/arch/frv/boot/Makefile b/arch/frv/boot/Makefile
index dc6f038..6ae3254 100644
--- a/arch/frv/boot/Makefile
+++ b/arch/frv/boot/Makefile
@@ -10,7 +10,7 @@
 
 targets := Image zImage bootpImage
 
-SYSTEM	=$(TOPDIR)/$(LINUX)
+SYSTEM	=$(LINUX)
 
 ZTEXTADDR	 = 0x02080000
 PARAMS_PHYS	 = 0x0207c000
@@ -45,7 +45,7 @@ zImage:	$(CONFIGURE) compressed/$(LINUX)
 bootpImage: bootp/bootp
 	$(OBJCOPY) -O binary -R .note -R .comment -S bootp/bootp $@
 
-compressed/$(LINUX): $(TOPDIR)/$(LINUX) dep
+compressed/$(LINUX): $(LINUX) dep
 	@$(MAKE) -C compressed $(LINUX)
 
 bootp/bootp: zImage initrd
@@ -59,10 +59,10 @@ initrd:
 # installation
 #
 install: $(CONFIGURE) Image
-	sh ./install.sh $(KERNELRELEASE) Image $(TOPDIR)/System.map "$(INSTALL_PATH)"
+	sh ./install.sh $(KERNELRELEASE) Image System.map "$(INSTALL_PATH)"
 
 zinstall: $(CONFIGURE) zImage
-	sh ./install.sh $(KERNELRELEASE) zImage $(TOPDIR)/System.map "$(INSTALL_PATH)"
+	sh ./install.sh $(KERNELRELEASE) zImage System.map "$(INSTALL_PATH)"
 
 #
 # miscellany
