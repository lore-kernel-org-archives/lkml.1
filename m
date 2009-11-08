Return-Path: <linux-kernel-owner+w=401wt.eu-S1751479AbZKHGA6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751479AbZKHGA6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Nov 2009 01:00:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750749AbZKHGA5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Nov 2009 01:00:57 -0500
Received: from bhuna.collabora.co.uk ([93.93.128.226]:58583 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750815AbZKHGAz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Nov 2009 01:00:55 -0500
Date: Sun, 8 Nov 2009 01:00:51 -0500
From: Andres Salomon <dilinger@collabora.co.uk>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-geode@lists.infradead.org,
       cjb@laptop.org, deepak@laptop.org,
       Jordan Crouse <jordan@cosmicpenguin.net>
Subject: [PATCH 3/6] CS5535: move the DIVIL MSR definition into
 linux/cs5535.h
Message-ID: <20091108010051.4558045a@mycelium.queued.net>
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.18.3; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The only thing that uses this is the reboot_fixups code.

Signed-off-by: Andres Salomon <dilinger@collabora.co.uk>
---
 arch/x86/include/asm/geode.h       |    2 --
 arch/x86/kernel/reboot_fixups_32.c |    2 +-
 include/linux/cs5535.h             |    2 ++
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/include/asm/geode.h b/arch/x86/include/asm/geode.h
index 547e964..976b3f1 100644
--- a/arch/x86/include/asm/geode.h
+++ b/arch/x86/include/asm/geode.h
@@ -45,8 +45,6 @@ extern int geode_get_dev_base(unsigned int dev);
 #define MSR_LBAR_ACPI		0x5140000E
 #define MSR_LBAR_PMS		0x5140000F
 
-#define MSR_DIVIL_SOFT_RESET	0x51400017
-
 #define MSR_LX_SPARE_MSR	0x80000011	/* DC-specific */
 
 #define MSR_GX_GLD_MSR_CONFIG	0xC0002001
diff --git a/arch/x86/kernel/reboot_fixups_32.c b/arch/x86/kernel/reboot_fixups_32.c
index 61a8377..3894e43 100644
--- a/arch/x86/kernel/reboot_fixups_32.c
+++ b/arch/x86/kernel/reboot_fixups_32.c
@@ -12,7 +12,7 @@
 #include <linux/interrupt.h>
 #include <asm/reboot_fixups.h>
 #include <asm/msr.h>
-#include <asm/geode.h>
+#include <linux/cs5535.h>
 
 static void cs5530a_warm_reset(struct pci_dev *dev)
 {
diff --git a/include/linux/cs5535.h b/include/linux/cs5535.h
index 30ecb04..39e93e8 100644
--- a/include/linux/cs5535.h
+++ b/include/linux/cs5535.h
@@ -18,6 +18,8 @@
 #define MSR_LBAR_ACPI		0x5140000E
 #define MSR_LBAR_PMS		0x5140000F
 
+#define MSR_DIVIL_SOFT_RESET	0x51400017
+
 #define MSR_PIC_YSEL_LOW	0x51400020
 #define MSR_PIC_YSEL_HIGH	0x51400021
 #define MSR_PIC_ZSEL_LOW	0x51400022
-- 
1.5.6.5

