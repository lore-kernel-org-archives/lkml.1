Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751290Ab0BQFeW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Feb 2010 00:34:22 -0500
Received: from hera.kernel.org ([140.211.167.34]:47858 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751194Ab0BQFeU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Feb 2010 00:34:20 -0500
Date: Wed, 17 Feb 2010 05:33:49 GMT
From: tip-bot for Dave Airlie <airlied@redhat.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       airlied@redhat.com, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       airlied@redhat.com, tglx@linutronix.de
In-Reply-To: <1262847894-27498-1-git-send-email-airlied@gmail.com>
References: <1262847894-27498-1-git-send-email-airlied@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/gpu] x86-64: Allow fbdev primary video code
Message-ID: <tip-477346ff74f4c2aed50e8a0db96a61069f3e5b80@git.kernel.org>
Git-Commit-ID: 477346ff74f4c2aed50e8a0db96a61069f3e5b80
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 17 Feb 2010 05:33:51 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  477346ff74f4c2aed50e8a0db96a61069f3e5b80
Gitweb:     http://git.kernel.org/tip/477346ff74f4c2aed50e8a0db96a61069f3e5b80
Author:     Dave Airlie <airlied@redhat.com>
AuthorDate: Thu, 7 Jan 2010 17:04:54 +1000
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Tue, 16 Feb 2010 21:22:26 -0800

x86-64: Allow fbdev primary video code

For some reason the 64-bit tree was doing this differently and
I can't see why it would need to.

This correct behaviour when you have two GPUs plugged in and
32-bit put the console in one place and 64-bit in another.

Signed-off-by: Dave Airlie <airlied@redhat.com>
LKML-Reference: <1262847894-27498-1-git-send-email-airlied@gmail.com>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
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
