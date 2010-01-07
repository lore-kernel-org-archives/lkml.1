Return-Path: <linux-kernel-owner+w=401wt.eu-S1754872Ab0AGHIL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754872Ab0AGHIL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jan 2010 02:08:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754276Ab0AGHIJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jan 2010 02:08:09 -0500
Received: from mx1.redhat.com ([209.132.183.28]:15619 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753857Ab0AGHII (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jan 2010 02:08:08 -0500
From: Dave Airlie <airlied@gmail.com>
To: linux-fbdev-devel@lists.sf.net
Cc: linux-kernel@vger.kernel.org, Dave Airlie <airlied@redhat.com>
Subject: [PATCH] x86: allow fbdev primary video code on 64-bit.
Date: Thu,  7 Jan 2010 17:04:54 +1000
Message-Id: <1262847894-27498-1-git-send-email-airlied@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dave Airlie <airlied@redhat.com>

For some reason the 64-bit tree was doing this differently and
I can't see why it would need to.

This correct behaviour when you have two GPUs plugged in and
32-bit put the console in one place and 64-bit in another.

Signed-off-by: Dave Airlie <airlied@redhat.com>
---
 arch/x86/Makefile         |    2 --
 arch/x86/include/asm/fb.h |    4 ----
 2 files changed, 0 insertions(+), 6 deletions(-)

diff --git a/arch/x86/Makefile b/arch/x86/Makefile
index 78b32be..0a43dc5 100644
--- a/arch/x86/Makefile
+++ b/arch/x86/Makefile
@@ -135,9 +135,7 @@ drivers-$(CONFIG_OPROFILE) += arch/x86/oprofile/
 # suspend and hibernation support
 drivers-$(CONFIG_PM) += arch/x86/power/
 
-ifeq ($(CONFIG_X86_32),y)
 drivers-$(CONFIG_FB) += arch/x86/video/
-endif
 
 ####
 # boot loader support. Several targets are kept for legacy purposes
diff --git a/arch/x86/include/asm/fb.h b/arch/x86/include/asm/fb.h
index 5301846..2519d06 100644
--- a/arch/x86/include/asm/fb.h
+++ b/arch/x86/include/asm/fb.h
@@ -12,10 +12,6 @@ static inline void fb_pgprotect(struct file *file, struct vm_area_struct *vma,
 		pgprot_val(vma->vm_page_prot) |= _PAGE_PCD;
 }
 
-#ifdef CONFIG_X86_32
 extern int fb_is_primary_device(struct fb_info *info);
-#else
-static inline int fb_is_primary_device(struct fb_info *info) { return 0; }
-#endif
 
 #endif /* _ASM_X86_FB_H */
-- 
1.6.5.2

