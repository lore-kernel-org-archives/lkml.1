Return-Path: <linux-kernel-owner+w=401wt.eu-S1752971AbXEXUNy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752971AbXEXUNy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2007 16:13:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750868AbXEXUNq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 May 2007 16:13:46 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:40883 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750809AbXEXUNo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2007 16:13:44 -0400
Date: Thu, 24 May 2007 22:14:44 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: David Miller <davem@davemloft.net>, linux-arch@vger.kernel.org,
       sparclinux@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH/RFC 4/5] asm-generic: add INITRAMFS to vmlinux.lds.h
Message-ID: <20070524201444.GF1109@uranus.ravnborg.org>
References: <20070524200440.GA1109@uranus.ravnborg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070524200440.GA1109@uranus.ravnborg.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add the definition of initramfs to vmlinux.lds.h
This simplifies arch lds script a bit.

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
---

Is these 8 lines really worth it.
I think yes - but no less than this.

	Sam


 include/asm-generic/vmlinux.lds.h |   13 +++++++++++++
 1 files changed, 13 insertions(+), 0 deletions(-)

diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinux.lds.h
index 5388c41..0e3d2eb 100644
--- a/include/asm-generic/vmlinux.lds.h
+++ b/include/asm-generic/vmlinux.lds.h
@@ -140,6 +140,19 @@
 /* for backward compatibility */
 #define RODATA RO_DATA(4096)
 
+/* INITRAMFS is used to hold the filesystem used during early boot. */
+#ifdef CONFIG_BLK_DEV_INITRD
+#define INITRAMFS(align)						\
+	. = ALIGN((align));						\
+	.init.ramfs : AT(ADDR(.init.ramfs) - LOAD_OFFSET) {		\
+	VMLINUX_SYMBOL(__initramfs_start) = .;				\
+		*(.init.ramfs)						\
+	VMLINUX_SYMBOL(__initramfs_end) = .;				\
+	}
+#else
+#define INITRAMFS(align)
+#endif
+
 #define SECURITY_INIT							\
 	.security_initcall.init : AT(ADDR(.security_initcall.init) - LOAD_OFFSET) { \
 		VMLINUX_SYMBOL(__security_initcall_start) = .;		\
-- 
1.5.1.rc3.20.gaa453

