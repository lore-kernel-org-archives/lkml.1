Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754603Ab0CBXan (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Mar 2010 18:30:43 -0500
Received: from kroah.org ([198.145.64.141]:38753 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754547Ab0CBX3y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Mar 2010 18:29:54 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Randy Dunlap <randy.dunlap@oracle.com>,
       Lennart Poettering <mzxreary@0pointer.de>,
       "Lee, Chun-Yi" <jlee@novell.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 61/62] msi-laptop: depends on RFKILL
Date: Tue,  2 Mar 2010 15:29:00 -0800
Message-Id: <1267572541-410-61-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.0.1
In-Reply-To: <20100302230933.GA32287@kroah.com>
References: <20100302230933.GA32287@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

msi-laptop uses rfkill*() interfaces so it should depend on RFKILL.

msi-laptop.c:(.text+0x1fcd1b): undefined reference to `rfkill_alloc'
msi-laptop.c:(.text+0x1fcd76): undefined reference to `rfkill_register'
msi-laptop.c:(.text+0x1fcdc8): undefined reference to `rfkill_destroy'
msi-laptop.c:(.text+0x1fcdd9): undefined reference to `rfkill_unregister'

This repairs "msi-laptop: Detect 3G device exists by standard ec command",
which is in some gregkh tree.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Lennart Poettering <mzxreary@0pointer.de>
Cc: Lee, Chun-Yi <jlee@novell.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/platform/x86/Kconfig |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/platform/x86/Kconfig b/drivers/platform/x86/Kconfig
index 6848f21..d911de3 100644
--- a/drivers/platform/x86/Kconfig
+++ b/drivers/platform/x86/Kconfig
@@ -148,6 +148,7 @@ config MSI_LAPTOP
 	tristate "MSI Laptop Extras"
 	depends on ACPI
 	depends on BACKLIGHT_CLASS_DEVICE
+	depends on RFKILL
 	---help---
 	  This is a driver for laptops built by MSI (MICRO-STAR
 	  INTERNATIONAL):
-- 
1.7.0.1

