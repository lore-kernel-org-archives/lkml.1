Return-Path: <linux-kernel-owner+w=401wt.eu-S965898AbXJPXZ2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965898AbXJPXZ2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2007 19:25:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935729AbXJPXZA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Oct 2007 19:25:00 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:56760 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935627AbXJPXY7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2007 19:24:59 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       kbuild devel <kbuild-devel@lists.sourceforge.net>
Subject: [PATCH] x86 boot: Build a bzImage again
References: <20071015205018.GA24467@uranus.ravnborg.org>
Date: Tue, 16 Oct 2007 17:24:04 -0600
In-Reply-To: <20071015205018.GA24467@uranus.ravnborg.org> (Sam Ravnborg's
	message of "Mon, 15 Oct 2007 22:50:18 +0200")
Message-ID: <m14pgqhcdn.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


With the Makefile changes dealing with EXTRA_AFLAGS and
EXTRA_CFLAGS when we attempt to build a bzImage
we get a zImage instead.  Ouch!

Fixup the makefile to use the new ccflags-y and asflags-y
so that we can build a bzImage again.  Making it possible
to actually test the recent kernel changes.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
---
 arch/x86/boot/Makefile |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/boot/Makefile b/arch/x86/boot/Makefile
index d6ed8e5..0e4912f 100644
--- a/arch/x86/boot/Makefile
+++ b/arch/x86/boot/Makefile
@@ -64,10 +64,10 @@ KBUILD_CFLAGS	:= $(LINUXINCLUDE) -g -Os -D_SETUP -D__KERNEL__ \
 KBUILD_AFLAGS	:= $(KBUILD_CFLAGS) -D__ASSEMBLY__
 
 $(obj)/zImage:  IMAGE_OFFSET := 0x1000
-$(obj)/zImage:  EXTRA_AFLAGS := $(SVGA_MODE) $(RAMDISK)
+$(obj)/zImage:  asflags-y += $(SVGA_MODE) $(RAMDISK)
 $(obj)/bzImage: IMAGE_OFFSET := 0x100000
-$(obj)/bzImage: EXTRA_CFLAGS := -D__BIG_KERNEL__
-$(obj)/bzImage: EXTRA_AFLAGS := $(SVGA_MODE) $(RAMDISK) -D__BIG_KERNEL__
+$(obj)/bzImage: ccflags-y += -D__BIG_KERNEL__
+$(obj)/bzImage: asflags-y += $(SVGA_MODE) $(RAMDISK) -D__BIG_KERNEL__
 $(obj)/bzImage: BUILDFLAGS   := -b
 
 quiet_cmd_image = BUILD   $@
-- 
1.5.3.rc6.17.g1911

