Return-Path: <linux-kernel-owner+w=401wt.eu-S1757884AbYHGAem@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757884AbYHGAem (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 20:34:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753279AbYHGAee
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 20:34:34 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:55960 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752931AbYHGAed (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 20:34:33 -0400
Date: Wed, 6 Aug 2008 17:29:38 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       akpm <akpm@linux-foundation.org>, ak@linux.intel.com
Subject: [PATCH -next] Panasonic ACPI depends on INPUT
Message-Id: <20080806172938.74b8033b.randy.dunlap@oracle.com>
In-Reply-To: <20080806182828.6bfe0a16.sfr@canb.auug.org.au>
References: <20080806182828.6bfe0a16.sfr@canb.auug.org.au>
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

Panasonic ACPI driver needs to depend on INPUT.
Otherwise it has build errors when CONFIG_INPUT=n:

drivers/built-in.o: In function `acpi_pcc_hotkey_remove':
pcc_acpi.c:(.text+0x25ded): undefined reference to `input_unregister_device'
pcc_acpi.c:(.text+0x25e03): undefined reference to `input_free_device'
drivers/built-in.o: In function `acpi_pcc_hotkey_notify':
pcc_acpi.c:(.text+0x260d5): undefined reference to `input_event'
pcc_acpi.c:(.text+0x260e2): undefined reference to `input_event'
drivers/built-in.o: In function `acpi_pcc_hotkey_add':
pcc_acpi.c:(.text+0x26267): undefined reference to `input_allocate_device'
pcc_acpi.c:(.text+0x26348): undefined reference to `input_register_device'
pcc_acpi.c:(.text+0x26405): undefined reference to `input_unregister_device'
pcc_acpi.c:(.text+0x26423): undefined reference to `input_free_device'
make[1]: *** [.tmp_vmlinux1] Error 1

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 drivers/acpi/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-next-20080806.orig/drivers/acpi/Kconfig
+++ linux-next-20080806/drivers/acpi/Kconfig
@@ -259,7 +259,7 @@ config ACPI_ASUS
 
 config ACPI_PANASONIC
 	tristate "Panasonic Laptop Extras"
-	depends on X86
+	depends on X86 && INPUT
 	select BACKLIGHT_CLASS_DEVICE
 	---help---
 	  This driver adds support for access to certain system settings
