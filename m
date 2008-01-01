Return-Path: <linux-kernel-owner+w=401wt.eu-S1754182AbYAAHgk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754182AbYAAHgk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jan 2008 02:36:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751795AbYAAHgc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jan 2008 02:36:32 -0500
Received: from po-out-1718.google.com ([72.14.252.156]:57808 "EHLO
	po-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751671AbYAAHgb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jan 2008 02:36:31 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:reply-to:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=TvtkirFE+9rTkgCvXc6Gt7Q+BPp9HG+C1vMrhZ7I4XMuUFQC1WFGk4ta5Bafv4pvKF+eQIIjWo983rYuWucSNFFKNNL+QEFyUT39vtRgZfp31Yz1vfl6KHtSwCxHUjJgFfsJ/ZA/Rtq9IdSkjqkt9iEuaQuINaxajUsn36V7Lzo=
Date: Tue, 1 Jan 2008 15:36:45 +0800
From: WANG Cong <xiyou.wangcong@gmail.com>
To: David Howells <dhowells@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Sam Ravnborg <sam@ravnborg.org>,
       linux-kbuild@vger.kernel.org, Andrew Morton <akpm@osdl.org>
Subject: [Patch 6/8] FRV: Remove 'TOPDIR' from Makefiles
Message-ID: <20080101073645.GG2496@hacking>
Reply-To: WANG Cong <xiyou.wangcong@gmail.com>
References: <20080101071311.GA2496@hacking>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080101071311.GA2496@hacking>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


TOPDIR is obsolete, use objtree instead.
This patch removes TOPDIR from all frv Makefiles.

Cc: David Howells <dhowells@redhat.com>
Cc: Sam Ravnborg <sam@ravnborg.org>
Signed-off-by: WANG Cong <xiyou.wangcong@gmail.com>

---

diff --git a/arch/frv/boot/Makefile b/arch/frv/boot/Makefile
index dc6f038..d93f768 100644
--- a/arch/frv/boot/Makefile
+++ b/arch/frv/boot/Makefile
@@ -10,7 +10,7 @@
 
 targets := Image zImage bootpImage
 
-SYSTEM	=$(TOPDIR)/$(LINUX)
+SYSTEM	=$(objtree)/$(LINUX)
 
 ZTEXTADDR	 = 0x02080000
 PARAMS_PHYS	 = 0x0207c000
@@ -45,7 +45,7 @@ zImage:	$(CONFIGURE) compressed/$(LINUX)
 bootpImage: bootp/bootp
 	$(OBJCOPY) -O binary -R .note -R .comment -S bootp/bootp $@
 
-compressed/$(LINUX): $(TOPDIR)/$(LINUX) dep
+compressed/$(LINUX): $(objtree)/$(LINUX) dep
 	@$(MAKE) -C compressed $(LINUX)
 
 bootp/bootp: zImage initrd
@@ -59,10 +59,10 @@ initrd:
 # installation
 #
 install: $(CONFIGURE) Image
-	sh ./install.sh $(KERNELRELEASE) Image $(TOPDIR)/System.map "$(INSTALL_PATH)"
+	sh ./install.sh $(KERNELRELEASE) Image $(objtree)/System.map "$(INSTALL_PATH)"
 
 zinstall: $(CONFIGURE) zImage
-	sh ./install.sh $(KERNELRELEASE) zImage $(TOPDIR)/System.map "$(INSTALL_PATH)"
+	sh ./install.sh $(KERNELRELEASE) zImage $(objtree)/System.map "$(INSTALL_PATH)"
 
 #
 # miscellany
