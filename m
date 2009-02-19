Return-Path: <linux-kernel-owner+w=401wt.eu-S1756779AbZBSRQU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756779AbZBSRQU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Feb 2009 12:16:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752968AbZBSRQJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Feb 2009 12:16:09 -0500
Received: from acsinet11.oracle.com ([141.146.126.233]:47050 "EHLO
	acsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752628AbZBSRQH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Feb 2009 12:16:07 -0500
Message-ID: <499D93F0.2090803@oracle.com>
Date: Thu, 19 Feb 2009 09:16:32 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Corentin Chary <corentincj@iksaif.net>
Subject: [PATCH -next] eeepc: needs to depend on INPUT
References: <20090220002832.cad00fcd.sfr@canb.auug.org.au>
In-Reply-To: <20090220002832.cad00fcd.sfr@canb.auug.org.au>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt702.oracle.com [141.146.40.80]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090205.499D93BE.006B:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

EEEPC_LAPTOP needs to depend on INPUT to fix build errors that
can happen when EEEPC_LAPTOP=y and INPUT=m:

drivers/built-in.o: In function `eeepc_hotk_add':
eeepc-laptop.c:(.text+0x14f403): undefined reference to `input_allocate_device'
eeepc-laptop.c:(.text+0x14f7a4): undefined reference to `input_register_device'
eeepc-laptop.c:(.text+0x14f7c8): undefined reference to `input_free_device'
drivers/built-in.o: In function `eeepc_input_exit':
eeepc-laptop.c:(.text+0x14f9d7): undefined reference to `input_unregister_device'
drivers/built-in.o: In function `eeepc_hotk_notify':
eeepc-laptop.c:(.text+0x14faf6): undefined reference to `input_event'
eeepc-laptop.c:(.text+0x14fb0c): undefined reference to `input_event'
eeepc-laptop.c:(.text+0x14fb32): undefined reference to `input_event'
eeepc-laptop.c:(.text+0x14fb48): undefined reference to `input_event'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
cc: Corentin Chary <corentincj@iksaif.net>
---
 drivers/platform/x86/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-next-20090219.orig/drivers/platform/x86/Kconfig
+++ linux-next-20090219/drivers/platform/x86/Kconfig
@@ -313,7 +313,7 @@ config INTEL_MENLOW
 
 config EEEPC_LAPTOP
 	tristate "Eee PC Hotkey Driver (EXPERIMENTAL)"
-	depends on ACPI
+	depends on ACPI && INPUT
 	depends on EXPERIMENTAL
 	select BACKLIGHT_CLASS_DEVICE
 	select HWMON

