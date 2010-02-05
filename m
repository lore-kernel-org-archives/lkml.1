Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932784Ab0BEXKJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Feb 2010 18:10:09 -0500
Received: from hera.kernel.org ([140.211.167.34]:54071 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757629Ab0BEXKG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Feb 2010 18:10:06 -0500
Date: Fri, 5 Feb 2010 23:09:36 GMT
From: tip-bot for Mike Travis <travis@sgi.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       travis@sgi.com, holt@sgi.com, airlied@linux.ie,
       akpm@linux-foundation.org, steiner@sgi.com, jbarnes@virtuousgeek.org,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       travis@sgi.com, holt@sgi.com, airlied@linux.ie,
       jbarnes@virtuousgeek.org, akpm@linux-foundation.org, steiner@sgi.com,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <4B68D51D.6090401@sgi.com>
References: <4B68D51D.6090401@sgi.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/pci] vgaarb: Add user selectability of the number of GPUS in a system
Message-ID: <tip-36028f3383872eefb558a4aae4c12ec2b5fa640f@git.kernel.org>
Git-Commit-ID: 36028f3383872eefb558a4aae4c12ec2b5fa640f
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 05 Feb 2010 23:09:37 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  36028f3383872eefb558a4aae4c12ec2b5fa640f
Gitweb:     http://git.kernel.org/tip/36028f3383872eefb558a4aae4c12ec2b5fa640f
Author:     Mike Travis <travis@sgi.com>
AuthorDate: Tue, 2 Feb 2010 17:45:01 -0800
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Fri, 5 Feb 2010 15:02:47 -0800

vgaarb: Add user selectability of the number of GPUS in a system

Update the VGA Arbiter to allow the user to select the number
of GPU's supported in a system.

v2: simplify setting of MAX_USER_CARDS, revert back to original default of 16

Signed-off-by: Mike Travis <travis@sgi.com>
LKML-Reference: <4B68D51D.6090401@sgi.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Robin Holt <holt@sgi.com>
Cc: Jack Steiner <steiner@sgi.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: David Airlie <airlied@linux.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 drivers/gpu/vga/Kconfig  |    8 ++++++++
 drivers/gpu/vga/vgaarb.c |    2 +-
 2 files changed, 9 insertions(+), 1 deletions(-)

diff --git a/drivers/gpu/vga/Kconfig b/drivers/gpu/vga/Kconfig
index 790e675..0920492 100644
--- a/drivers/gpu/vga/Kconfig
+++ b/drivers/gpu/vga/Kconfig
@@ -8,3 +8,11 @@ config VGA_ARB
 	  are accessed at same time they need some kind of coordination. Please
 	  see Documentation/vgaarbiter.txt for more details. Select this to
 	  enable VGA arbiter.
+
+config VGA_ARB_MAX_GPUS
+	int "Maximum number of GPUs"
+	default 16
+	depends on VGA_ARB
+	help
+	  Reserves space in the kernel to maintain resource locking for
+	  multiple GPUS.  The overhead for each GPU is very small.
diff --git a/drivers/gpu/vga/vgaarb.c b/drivers/gpu/vga/vgaarb.c
index ba7fa9e..325a533 100644
--- a/drivers/gpu/vga/vgaarb.c
+++ b/drivers/gpu/vga/vgaarb.c
@@ -688,7 +688,7 @@ EXPORT_SYMBOL(vga_client_register);
  * the arbiter.
  */
 
-#define MAX_USER_CARDS         16
+#define MAX_USER_CARDS         CONFIG_VGA_ARB_MAX_GPUS
 #define PCI_INVALID_CARD       ((struct pci_dev *)-1UL)
 
 /*
