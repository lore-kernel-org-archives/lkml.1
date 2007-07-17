Return-Path: <linux-kernel-owner+w=401wt.eu-S932632AbXGQHua@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932632AbXGQHua (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 03:50:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757081AbXGQHti
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 03:49:38 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:50989 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755588AbXGQHtg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 03:49:36 -0400
To: torvalds@linux-foundation.org
Subject: [PATCH] no USB on M32R
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, gregkh@suse.de
Message-Id: <E1IAhoN-0001il-Ql@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Date: Tue, 17 Jul 2007 08:49:35 +0100
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Won't build due to lack of dma-mapping.  Shouldn't that dependency
(having PCMCIA => HCD possible) be on CARDBUS, anyway?

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 drivers/usb/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/usb/Kconfig b/drivers/usb/Kconfig
index 071b967..7dd7354 100644
--- a/drivers/usb/Kconfig
+++ b/drivers/usb/Kconfig
@@ -16,7 +16,7 @@ config USB_ARCH_HAS_HCD
 	boolean
 	default y if USB_ARCH_HAS_OHCI
 	default y if USB_ARCH_HAS_EHCI
-	default y if PCMCIA				# sl811_cs
+	default y if PCMCIA && !M32R			# sl811_cs
 	default y if ARM				# SL-811
 	default PCI
 
-- 
1.5.3.GIT


