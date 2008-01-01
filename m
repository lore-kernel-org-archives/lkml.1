Return-Path: <linux-kernel-owner+w=401wt.eu-S1754014AbYAAHWd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754014AbYAAHWd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jan 2008 02:22:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751726AbYAAHWZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jan 2008 02:22:25 -0500
Received: from po-out-1718.google.com ([72.14.252.157]:50562 "EHLO
	po-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750722AbYAAHWY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jan 2008 02:22:24 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:reply-to:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=NN/LtgxMqz73XwZuwe52LNxVJcqOTRoNcicAPcfp3vWg6g6DbKYi7N0VROqOI8jMUMu5q31preQw/xOQfydc4K9EJUoTd2B7xpmWuQjwH9iWkU/ByXvdfM8KOpI74tBSwbh3H9a85oHq+qxEBaSDXq4Au5ZA4XEhNJz1pX5WZlM=
Date: Tue, 1 Jan 2008 15:22:38 +0800
From: WANG Cong <xiyou.wangcong@gmail.com>
To: Ralf Baechle <ralf@linux-mips.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Sam Ravnborg <sam@ravnborg.org>,
       linux-kbuild@vger.kernel.org, Andrew Morton <akpm@osdl.org>,
       linux-mips@linux-mips.org
Subject: [Patch 2/8] MIPS: Remove 'TOPDIR' from Makefiles
Message-ID: <20080101072238.GC2496@hacking>
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
This patch removes TOPDIR from all Mips Makefiles.

Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: Sam Ravnborg <sam@ravnborg.org>
Signed-off-by: WANG Cong <xiyou.wangcong@gmail.com>

---

diff --git a/arch/mips/lasat/image/Makefile b/arch/mips/lasat/image/Makefile
index 5332449..5196962 100644
--- a/arch/mips/lasat/image/Makefile
+++ b/arch/mips/lasat/image/Makefile
@@ -12,7 +12,7 @@ endif
 
 MKLASATIMG = mklasatimg
 MKLASATIMG_ARCH = mq2,mqpro,sp100,sp200
-KERNEL_IMAGE = $(TOPDIR)/vmlinux
+KERNEL_IMAGE = $(objtree)/vmlinux
 KERNEL_START = $(shell $(NM) $(KERNEL_IMAGE) | grep " _text" | cut -f1 -d\ )
 KERNEL_ENTRY = $(shell $(NM) $(KERNEL_IMAGE) | grep kernel_entry | cut -f1 -d\ )
 
@@ -24,7 +24,7 @@ HEAD_DEFINES := -D_kernel_start=0x$(KERNEL_START) \
 		-D TIMESTAMP=$(shell date +%s)
 
 $(obj)/head.o: $(obj)/head.S $(KERNEL_IMAGE)
-	$(CC) -fno-pic $(HEAD_DEFINES) -I$(TOPDIR)/include -c -o $@ $<
+	$(CC) -fno-pic $(HEAD_DEFINES) -I$(objtree)/include -c -o $@ $<
 
 OBJECTS = head.o kImage.o
 
