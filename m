Return-Path: <linux-kernel-owner+w=401wt.eu-S1757310AbYAXQzQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757310AbYAXQzQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2008 11:55:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754910AbYAXQxM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jan 2008 11:53:12 -0500
Received: from smtp06.mtu.ru ([62.5.255.53]:64224 "EHLO smtp06.mtu.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753252AbYAXQxE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2008 11:53:04 -0500
From: Dmitri Vorobiev <dmitri.vorobiev@gmail.com>
To: ralf@linux-mips.org, linux-mips@linux-mips.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH 08/17] [MIPS] Malta, Atlas, Sead: remove an extern from .c files
Date: Thu, 24 Jan 2008 19:52:48 +0300
Message-Id: <1201193577-4261-9-git-send-email-dmitri.vorobiev@gmail.com>
X-Mailer: git-send-email 1.5.3.6
In-Reply-To: <1201193577-4261-1-git-send-email-dmitri.vorobiev@gmail.com>
References: <1201193577-4261-1-git-send-email-dmitri.vorobiev@gmail.com>
X-DCC-STREAM-Metrics: smtp06.mtu.ru 10001; Body=0 Fuz1=0 Fuz2=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch moves the "extern" declaration for the function
mips_reboot_setup() from the board setup .c files to the
header file include/asm-mips/mips-boards/generic.h.

This fixes a warning produced by the checkpatch.pl script.

No functional changes introduced.

This was compile-tested by building the kernel for all
three boards affected by this change. All builds finished
successfully.

Signed-off-by: Dmitri Vorobiev <dmitri.vorobiev@gmail.com>
---
 arch/mips/mips-boards/atlas/atlas_setup.c |    2 --
 arch/mips/mips-boards/malta/malta_setup.c |    2 --
 arch/mips/mips-boards/sead/sead_setup.c   |    2 --
 include/asm-mips/mips-boards/generic.h    |    2 ++
 4 files changed, 2 insertions(+), 6 deletions(-)

diff --git a/arch/mips/mips-boards/atlas/atlas_setup.c b/arch/mips/mips-boards/atlas/atlas_setup.c
index e405d11..5ce8004 100644
--- a/arch/mips/mips-boards/atlas/atlas_setup.c
+++ b/arch/mips/mips-boards/atlas/atlas_setup.c
@@ -34,8 +34,6 @@
 #include <asm/time.h>
 #include <asm/traps.h>
 
-extern void mips_reboot_setup(void);
-
 #ifdef CONFIG_KGDB
 extern void kgdb_config(void);
 #endif
diff --git a/arch/mips/mips-boards/malta/malta_setup.c b/arch/mips/mips-boards/malta/malta_setup.c
index 480521f..e5ac079 100644
--- a/arch/mips/mips-boards/malta/malta_setup.c
+++ b/arch/mips/mips-boards/malta/malta_setup.c
@@ -35,8 +35,6 @@
 #include <linux/console.h>
 #endif
 
-extern void mips_reboot_setup(void);
-
 #ifdef CONFIG_KGDB
 extern void kgdb_config(void);
 #endif
diff --git a/arch/mips/mips-boards/sead/sead_setup.c b/arch/mips/mips-boards/sead/sead_setup.c
index 1fb61b8..8aa8e5b 100644
--- a/arch/mips/mips-boards/sead/sead_setup.c
+++ b/arch/mips/mips-boards/sead/sead_setup.c
@@ -34,8 +34,6 @@
 #include <asm/mips-boards/seadint.h>
 #include <asm/time.h>
 
-extern void mips_reboot_setup(void);
-
 static void __init serial_init(void);
 
 const char *get_system_type(void)
diff --git a/include/asm-mips/mips-boards/generic.h b/include/asm-mips/mips-boards/generic.h
index d589774..2ca6bda 100644
--- a/include/asm-mips/mips-boards/generic.h
+++ b/include/asm-mips/mips-boards/generic.h
@@ -97,6 +97,8 @@ extern int mips_revision_corid;
 
 extern int mips_revision_sconid;
 
+extern void mips_reboot_setup(void);
+
 #ifdef CONFIG_PCI
 extern void mips_pcibios_init(void);
 #else
-- 
1.5.3

