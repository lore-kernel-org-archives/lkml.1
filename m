Return-Path: <linux-kernel-owner+w=401wt.eu-S936365AbXJPWFO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936365AbXJPWFO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2007 18:05:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965515AbXJPWEy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Oct 2007 18:04:54 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:53768 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935846AbXJPWEw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2007 18:04:52 -0400
Date: Wed, 17 Oct 2007 00:06:23 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Thomas Meyer <thomas@m3y3r.de>
Cc: Randy Dunlap <randy.dunlap@oracle.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       kexec@lists.infradead.org
Subject: Re: kexec: Cannot determine the file type of arch/x86/boot/bzImage
Message-ID: <20071016220623.GB3035@uranus.ravnborg.org>
References: <47151631.9000307@m3y3r.de> <20071016130657.8cc17011.randy.dunlap@oracle.com> <47152FE6.3050204@m3y3r.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47152FE6.3050204@m3y3r.de>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 16, 2007 at 11:40:54PM +0200, Thomas Meyer wrote:
> >> How to solve this error?

Fixed by following patch.
Sorry for the inconvinience.

	Sam

>From 7eebb9348655b55553d65fc7cb6cfad292d28dbb Mon Sep 17 00:00:00 2001
From: Sam Ravnborg <sam@neptun.(none)>
Date: Tue, 16 Oct 2007 23:50:33 +0200
Subject: [PATCH] x86: fix boot error introduced by kbuild

x86 uses target specific assignment of EXTRA_AFLAGS,
EXTRA_CFLAGS - this caused troubles with
introducing asflags-y, ccflags-y.

Fixed the target specific assignments in arch/x86/boot/Makefile
and auditted the rest of the kernel for similar usage.

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
---
 arch/x86/boot/Makefile |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/boot/Makefile b/arch/x86/boot/Makefile
index d6ed8e5..e8756e5 100644
--- a/arch/x86/boot/Makefile
+++ b/arch/x86/boot/Makefile
@@ -64,10 +64,10 @@ KBUILD_CFLAGS	:= $(LINUXINCLUDE) -g -Os -D_SETUP -D__KERNEL__ \
 KBUILD_AFLAGS	:= $(KBUILD_CFLAGS) -D__ASSEMBLY__
 
 $(obj)/zImage:  IMAGE_OFFSET := 0x1000
-$(obj)/zImage:  EXTRA_AFLAGS := $(SVGA_MODE) $(RAMDISK)
+$(obj)/zImage:  asflags-y := $(SVGA_MODE) $(RAMDISK)
 $(obj)/bzImage: IMAGE_OFFSET := 0x100000
-$(obj)/bzImage: EXTRA_CFLAGS := -D__BIG_KERNEL__
-$(obj)/bzImage: EXTRA_AFLAGS := $(SVGA_MODE) $(RAMDISK) -D__BIG_KERNEL__
+$(obj)/bzImage: ccflags-y := -D__BIG_KERNEL__
+$(obj)/bzImage: asflags-y := $(SVGA_MODE) $(RAMDISK) -D__BIG_KERNEL__
 $(obj)/bzImage: BUILDFLAGS   := -b
 
 quiet_cmd_image = BUILD   $@
-- 
1.5.2.4

