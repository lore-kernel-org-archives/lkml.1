Return-Path: <linux-kernel-owner+w=401wt.eu-S1755129AbZJFHk4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755129AbZJFHk4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 03:40:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754252AbZJFHk4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 03:40:56 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:38406 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754168AbZJFHkz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 03:40:55 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH v3] firmware: only allow EDD on x86
Date: Tue,  6 Oct 2009 03:40:18 -0400
Message-Id: <1254814818-15658-1-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.5.rc2
In-Reply-To: <1254808627-3889-1-git-send-email-vapier@gentoo.org>
References: <1254808627-3889-1-git-send-email-vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rather than have the EDD depend on !ia64 (and assuming that only ia64,
x86, x86_64 will be including this Kconfig), have EDD depend on the only
arches which can support this code.  This should allow all other arches
to cleanly include the firmware Kconfig.

Also simplify the x86 string used by FIRMWARE_MEMMAP to match EDD.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
v3
	- use simpler x86 string pointed out by Takashi

 drivers/firmware/Kconfig |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/firmware/Kconfig b/drivers/firmware/Kconfig
index ebb9e51..1b03ba1 100644
--- a/drivers/firmware/Kconfig
+++ b/drivers/firmware/Kconfig
@@ -7,7 +7,7 @@ menu "Firmware Drivers"
 
 config EDD
 	tristate "BIOS Enhanced Disk Drive calls determine boot disk"
-	depends on !IA64
+	depends on X86
 	help
 	  Say Y or M here if you want to enable BIOS Enhanced Disk Drive
 	  Services real mode BIOS calls to determine which disk
@@ -28,7 +28,7 @@ config EDD_OFF
 
 config FIRMWARE_MEMMAP
     bool "Add firmware-provided memory map to sysfs" if EMBEDDED
-    default (X86_64 || X86_32)
+    default X86
     help
       Add the firmware-provided (unmodified) memory map to /sys/firmware/memmap.
       That memory map is used for example by kexec to set up parameter area
-- 
1.6.5.rc2

