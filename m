Return-Path: <linux-kernel-owner+w=401wt.eu-S1755983AbYIOTxv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755983AbYIOTxv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2008 15:53:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751707AbYIOTxl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Sep 2008 15:53:41 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:14584 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753597AbYIOTxl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2008 15:53:41 -0400
Date: Mon, 15 Sep 2008 12:52:58 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: akpm <akpm@linux-foundation.org>, Corentin Chary <corentincj@iksaif.net>,
       acpi4asus-user@lists.sourceforge.net
Subject: [PATCH -mm] eeepc: depends on RFKILL
Message-Id: <20080915125258.77b14e2b.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

EEEPC_LAPTOP uses RFKILL, so the former should depend on RFKILL.
Build errors happen when EEEPC_LAPTOP=y and RFKILL=m.

eeepc-laptop.c:(.text+0xd5a7b): undefined reference to `rfkill_allocate'
eeepc-laptop.c:(.text+0xd5b04): undefined reference to `rfkill_register'
eeepc-laptop.c:(.text+0xd5b48): undefined reference to `rfkill_allocate'
eeepc-laptop.c:(.text+0xd5bd4): undefined reference to `rfkill_register'
eeepc-laptop.c:(.text+0xd5ece): undefined reference to `rfkill_unregister'
eeepc-laptop.c:(.text+0xd5ef6): undefined reference to `rfkill_unregister'
make[1]: *** [.tmp_vmlinux1] Error 1

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
cc: Corentin Chary <corentincj@iksaif.net>
---
 drivers/misc/Kconfig |    1 +
 1 file changed, 1 insertion(+)

--- linux-2.6.27-rc5-mm1.orig/drivers/misc/Kconfig
+++ linux-2.6.27-rc5-mm1/drivers/misc/Kconfig
@@ -410,6 +410,7 @@ config EEEPC_LAPTOP
 	depends on BACKLIGHT_CLASS_DEVICE
 	depends on HWMON
 	depends on EXPERIMENTAL
+	depends on RFKILL
 	---help---
 	  This driver supports the Fn-Fx keys on Eee PC laptops.
 	  It also adds the ability to switch camera/wlan on/off.
