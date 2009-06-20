Return-Path: <linux-kernel-owner+w=401wt.eu-S1759445AbZFTStp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759445AbZFTStp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Jun 2009 14:49:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758026AbZFTSq6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Jun 2009 14:46:58 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:48161 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758080AbZFTSq5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Jun 2009 14:46:57 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: linux-kernel@vger.kernel.org
Cc: uclinux-dist-devel@blackfin.uclinux.org,
       Robin Getz <rgetz@blackfin.uclinux.org>
Subject: [PATCH 18/25] Blackfin: stick the CPU name into boot image name
Date: Sat, 20 Jun 2009 14:44:41 -0400
Message-Id: <1245523488-26536-19-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.3.1
In-Reply-To: <1245523488-26536-1-git-send-email-vapier@gentoo.org>
References: <1245523488-26536-1-git-send-email-vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Robin Getz <rgetz@blackfin.uclinux.org>

Rather than use "Linux" in the boot image name (as this is redundant --
the image type is already set to "linux"), use the CPU name.  This makes
it fairly obvious when a wrong image is accidentally booted.  Otherwise
there is no kernel output and you waste time scratching your head
wondering wtf just happened.

Signed-off-by: Robin Getz <rgetz@blackfin.uclinux.org>
Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 arch/blackfin/boot/Makefile |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/blackfin/boot/Makefile b/arch/blackfin/boot/Makefile
index 3ab6f23..fd9ccc5 100644
--- a/arch/blackfin/boot/Makefile
+++ b/arch/blackfin/boot/Makefile
@@ -13,7 +13,7 @@ extra-y += vmlinux.bin vmlinux.bin.gz vmlinux.bin.bz2 vmlinux.bin.lzma
 
 quiet_cmd_uimage = UIMAGE  $@
       cmd_uimage = $(CONFIG_SHELL) $(MKIMAGE) -A $(ARCH) -O linux -T kernel \
-                   -C $(2) -n 'Linux-$(KERNELRELEASE)' -a $(CONFIG_BOOT_LOAD) \
+                   -C $(2) -n '$(MACHINE)-$(KERNELRELEASE)' -a $(CONFIG_BOOT_LOAD) \
                    -e $(shell $(NM) vmlinux | awk '$$NF == "__start" {print $$1}') \
                    -d $< $@
 
-- 
1.6.3.1

