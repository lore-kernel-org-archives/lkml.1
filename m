Return-Path: <linux-kernel-owner+w=401wt.eu-S1757155AbXLFMwj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757155AbXLFMwj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2007 07:52:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754502AbXLFMoD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Dec 2007 07:44:03 -0500
Received: from nic2.axis.se ([193.13.178.10]:35777 "EHLO krynn.se.axis.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754904AbXLFMn6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2007 07:43:58 -0500
From: Jesper Nilsson <jesper.nilsson@axis.com>
Message-Id: <6d6863c8e13af7a7f9cf23206320825aeab88564.1196848533.git.jesper.nilsson@axis.com>
In-Reply-To: <ca13018bb45763422de40e6109171637091a312e.1196848533.git.jesper.nilsson@axis.com>
References: <ca13018bb45763422de40e6109171637091a312e.1196848533.git.jesper.nilsson@axis.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       Mikael Starvik <mikael.starvik@axis.com>,
       Jesper Nilsson <jesper.nilsson@axis.com>, linux-kernel@vger.kernel.org,
       sam@ravnborg.org
Date: Fri, 30 Nov 2007 16:24:07 +0100
Subject: [PATCH 30/47] Update CRISv32 boot Kbuild makefile.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

- Remove old specific targets, use more generic ones instead.
- Use if_changed to avoid creating new images when no change.

Signed-off-by: Jesper Nilsson <jesper.nilsson@axis.com>
---
 arch/cris/arch-v32/boot/Makefile |   23 +++++++++++++++--------
 1 files changed, 15 insertions(+), 8 deletions(-)

diff --git a/arch/cris/arch-v32/boot/Makefile b/arch/cris/arch-v32/boot/Makefile
index 26f293a..3f91349 100644
--- a/arch/cris/arch-v32/boot/Makefile
+++ b/arch/cris/arch-v32/boot/Makefile
@@ -1,14 +1,21 @@
 #
 # arch/cris/arch-v32/boot/Makefile
 #
-target = $(target_boot_dir)
-src    = $(src_boot_dir)
 
-zImage: compressed/vmlinuz
+OBJCOPY = objcopy-cris
+OBJCOPYFLAGS = -O binary -R .note -R .comment
 
-compressed/vmlinuz: $(objtree)/vmlinux
-	@$(MAKE) -f $(src)/compressed/Makefile $(objtree)/vmlinuz
+subdir- := compressed rescue
+targets := Image
 
-clean:
-	rm -f zImage tools/build compressed/vmlinux.out
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

