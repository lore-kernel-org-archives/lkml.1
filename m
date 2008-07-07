Return-Path: <linux-kernel-owner+w=401wt.eu-S1759047AbYGGWCh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759047AbYGGWCh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2008 18:02:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758763AbYGGWBA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jul 2008 18:01:00 -0400
Received: from yw-out-2324.google.com ([74.125.46.31]:9170 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758218AbYGGWAv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2008 18:00:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-disposition
         :message-id:content-type:content-transfer-encoding;
        b=SZ8kLrIh33Yp5hekSLacAqUFFYhJ9LTtdfbU+ucsTx+BqNedobHux8DNOKC+OXTh8x
         DswDOfvQiBrzijKyOkSmbtzC3DSROYa5m9jj8bQ/EPVYQbbtCyI/8NHOHszmvan1TiNp
         0R+xkE7m58Lwvv6voc0zFoEBDxL+hwOR6W2so=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Subject: [PATCH 4/10] ide-generic: remove "no_pci_devices()" quirk from ide_default_io_base()
Date: Mon, 7 Jul 2008 23:53:06 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200807072353.06335.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since the decision to probe for ISA ide2-6 is now left to the user
"no_pci_devices()" quirk is no longer needed and may be removed.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 include/asm-mips/mach-generic/ide.h |   18 ++++--------------
 include/asm-x86/ide.h               |   18 ++++--------------
 2 files changed, 8 insertions(+), 28 deletions(-)

Index: b/include/asm-mips/mach-generic/ide.h
===================================================================
--- a/include/asm-mips/mach-generic/ide.h
+++ b/include/asm-mips/mach-generic/ide.h
@@ -72,23 +72,13 @@ static __inline__ int ide_default_irq(un
 
 static __inline__ unsigned long ide_default_io_base(int index)
 {
-	/*
-	 *      If PCI is present then it is not safe to poke around
-	 *      the other legacy IDE ports. Only 0x1f0 and 0x170 are
-	 *      defined compatibility mode ports for PCI. A user can
-	 *      override this using ide= but we must default safe.
-	 */
-	if (no_pci_devices()) {
-		switch (index) {
-		case 2: return 0x1e8;
-		case 3: return 0x168;
-		case 4: return 0x1e0;
-		case 5: return 0x160;
-		}
-	}
 	switch (index) {
 	case 0: return 0x1f0;
 	case 1: return 0x170;
+	case 2: return 0x1e8;
+	case 3: return 0x168;
+	case 4: return 0x1e0;
+	case 5: return 0x160;
 	default:
 		return 0;
 	}
Index: b/include/asm-x86/ide.h
===================================================================
--- a/include/asm-x86/ide.h
+++ b/include/asm-x86/ide.h
@@ -36,23 +36,13 @@ static __inline__ int ide_default_irq(un
 
 static __inline__ unsigned long ide_default_io_base(int index)
 {
-	/*
-	 *	If PCI is present then it is not safe to poke around
-	 *	the other legacy IDE ports. Only 0x1f0 and 0x170 are
-	 *	defined compatibility mode ports for PCI. A user can 
-	 *	override this using ide= but we must default safe.
-	 */
-	if (no_pci_devices()) {
-		switch(index) {
-			case 2: return 0x1e8;
-			case 3: return 0x168;
-			case 4: return 0x1e0;
-			case 5: return 0x160;
-		}
-	}
 	switch (index) {
 		case 0:	return 0x1f0;
 		case 1:	return 0x170;
+		case 2: return 0x1e8;
+		case 3: return 0x168;
+		case 4: return 0x1e0;
+		case 5: return 0x160;
 		default:
 			return 0;
 	}
