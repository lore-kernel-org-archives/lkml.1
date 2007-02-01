Return-Path: <linux-kernel-owner+w=401wt.eu-S1422890AbXBANyc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422890AbXBANyc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Feb 2007 08:54:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422891AbXBANxG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Feb 2007 08:53:06 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:40172 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422884AbXBANxA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Feb 2007 08:53:00 -0500
To: torvalds@linux-foundation.org
Subject: [PATCH] radio modems sitting on serial port are not for s390
Cc: linux-kernel@vger.kernel.org, schwidefsky@de.ibm.com
Message-Id: <E1HCcN1-0007Si-0C@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Date: Thu, 01 Feb 2007 13:52:59 +0000
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Won't build (request_irq()/free_irq()), even if you manage to find an
s390 box with 8250-compatible UART they are expecting.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 drivers/net/hamradio/Kconfig |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/hamradio/Kconfig b/drivers/net/hamradio/Kconfig
index 896aa02..feb0ada 100644
--- a/drivers/net/hamradio/Kconfig
+++ b/drivers/net/hamradio/Kconfig
@@ -113,7 +113,7 @@ config SCC_TRXECHO
 
 config BAYCOM_SER_FDX
 	tristate "BAYCOM ser12 fullduplex driver for AX.25"
-	depends on AX25
+	depends on AX25 && !S390
 	select CRC_CCITT
 	---help---
 	  This is one of two drivers for Baycom style simple amateur radio
@@ -133,7 +133,7 @@ config BAYCOM_SER_FDX
 
 config BAYCOM_SER_HDX
 	tristate "BAYCOM ser12 halfduplex driver for AX.25"
-	depends on AX25
+	depends on AX25 && !S390
 	select CRC_CCITT
 	---help---
 	  This is one of two drivers for Baycom style simple amateur radio
@@ -181,7 +181,7 @@ config BAYCOM_EPP
 
 config YAM
 	tristate "YAM driver for AX.25"
-	depends on AX25
+	depends on AX25 && !S390
 	help
 	  The YAM is a modem for packet radio which connects to the serial
 	  port and includes some of the functions of a Terminal Node
-- 
1.5.0-rc2.GIT


