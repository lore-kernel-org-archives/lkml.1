Return-Path: <linux-kernel-owner+w=401wt.eu-S1756537AbXLFMtf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756537AbXLFMtf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2007 07:49:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752614AbXLFMnM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Dec 2007 07:43:12 -0500
Received: from miranda.se.axis.com ([193.13.178.8]:53741 "EHLO
	miranda.se.axis.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754133AbXLFMnK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2007 07:43:10 -0500
From: Jesper Nilsson <jesper.nilsson@axis.com>
Message-Id: <6c7ed9b68cc61f3cdfedbafc009330283d21a7dd.1196848533.git.jesper.nilsson@axis.com>
In-Reply-To: <ca13018bb45763422de40e6109171637091a312e.1196848533.git.jesper.nilsson@axis.com>
References: <ca13018bb45763422de40e6109171637091a312e.1196848533.git.jesper.nilsson@axis.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       Mikael Starvik <mikael.starvik@axis.com>,
       Jesper Nilsson <jesper.nilsson@axis.com>, linux-kernel@vger.kernel.org,
       sam@ravnborg.org
Date: Fri, 30 Nov 2007 16:08:34 +0100
Subject: [PATCH 24/47] Update CRISv10 boot Kbuild makefile.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

- Remove old specific targets, use more generic ones instead.

Signed-off-by: Jesper Nilsson <jesper.nilsson@axis.com>
---
 arch/cris/arch-v10/boot/Makefile |   24 ++++++++++++++++--------
 1 files changed, 16 insertions(+), 8 deletions(-)

diff --git a/arch/cris/arch-v10/boot/Makefile b/arch/cris/arch-v10/boot/Makefile
index e5b1058..20c83a5 100644
--- a/arch/cris/arch-v10/boot/Makefile
+++ b/arch/cris/arch-v10/boot/Makefile
@@ -1,13 +1,21 @@
 #
-# arch/cris/boot/Makefile
+# arch/cris/arch-v10/boot/Makefile
 #
-target = $(target_boot_dir)
-src    = $(src_boot_dir)
 
-zImage: compressed/vmlinuz
+OBJCOPY = objcopy-cris
+OBJCOPYFLAGS = -O binary --remove-section=.bss
 
-compressed/vmlinuz:
-	@$(MAKE) -f $(src)/compressed/Makefile $(target_compressed_dir)/vmlinuz
+subdir- := compressed rescue
+targets := Image
 
-clean:
-	@$(MAKE) -f $(src)/compressed/Makefile clean
+$(obj)/Image: vmlinux FORCE
+	$(call if_changed,objcopy)
+	@echo '  Kernel: $@ is ready'
+
+$(obj)/compressed/vmlinux: $(obj)/Image FORCE
+	$(Q)$(MAKE) $(build)=$(obj)/compressed $@
+	$(Q)$(MAKE) $(build)=$(obj)/rescue $(obj)/rescue/rescue.bin
+
+$(obj)/zImage:  $(obj)/compressed/vmlinux
+	@cp $< $@
+	@echo '  Kernel: $@ is ready'
-- 
1.5.3.6.970.gd25430

