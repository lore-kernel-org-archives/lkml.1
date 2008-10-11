Return-Path: <linux-kernel-owner+w=401wt.eu-S1756197AbYJKGor@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756197AbYJKGor (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Oct 2008 02:44:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755113AbYJKGiH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Oct 2008 02:38:07 -0400
Received: from vms173003pub.verizon.net ([206.46.173.3]:40791 "EHLO
	vms173003pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754475AbYJKGhh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Oct 2008 02:37:37 -0400
Date: Sat, 11 Oct 2008 02:36:20 -0400
From: Len Brown <lenb@kernel.org>
Subject: [PATCH 60/85] toshiba_acpi: depends on INPUT
In-reply-to: <1223707005-26864-1-git-send-email-lenb@kernel.org>
In-reply-to: <1d80ebdb81444701024ad9b9f026516561496a43.1223706853.git.len.brown@intel.com>
To: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Randy Dunlap <randy.dunlap@oracle.com>, Len Brown <len.brown@intel.com>
Message-id: <b3cef8f6eba47a10b80aa3e7a99e27110e34f3df.1223706853.git.len.brown@intel.com>
Organization: Intel Open Source Technology Center
X-Mailer: git-send-email 1.6.0.2.307.gc427
References: <1223707005-26864-1-git-send-email-lenb@kernel.org>
References: <1d80ebdb81444701024ad9b9f026516561496a43.1223706853.git.len.brown@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

CONFIG_ACPI_TOSHIBA can =y when CONFIG_INPUT=m, so prevent that
combination and its subsequent build errors:

toshiba_acpi.c:(.text+0x3e877): undefined reference to `input_event'
toshiba_acpi.c:(.text+0x3e98a): undefined reference to `input_unregister_polled_device'
toshiba_acpi.c:(.text+0x3e994): undefined reference to `input_free_polled_device'
toshiba_acpi.c:(.init.text+0x21b4): undefined reference to `input_allocate_polled_device'
toshiba_acpi.c:(.init.text+0x2263): undefined reference to `input_register_polled_device'
make[1]: *** [.tmp_vmlinux1] Error 1

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Len Brown <len.brown@intel.com>
---
 drivers/acpi/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/acpi/Kconfig b/drivers/acpi/Kconfig
index 735f5ea..79540db 100644
--- a/drivers/acpi/Kconfig
+++ b/drivers/acpi/Kconfig
@@ -259,7 +259,7 @@ config ACPI_ASUS
 
 config ACPI_TOSHIBA
 	tristate "Toshiba Laptop Extras"
-	depends on X86
+	depends on X86 && INPUT
 	select BACKLIGHT_CLASS_DEVICE
 	---help---
 	  This driver adds support for access to certain system settings
-- 
1.5.5.1

