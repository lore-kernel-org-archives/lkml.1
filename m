Return-Path: <linux-kernel-owner+w=401wt.eu-S1757583AbYEMPBT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757583AbYEMPBT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2008 11:01:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752575AbYEMPBL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 May 2008 11:01:11 -0400
Received: from minas.ics.muni.cz ([147.251.4.40]:36892 "EHLO minas.ics.muni.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752277AbYEMPBK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2008 11:01:10 -0400
From: jirislaby@gmail.com
To: Andrew Morton <akpm@linux-foundation.org>
Cc: p.o.roussel@free.fr, linux-kernel@vger.kernel.org,
       Jiri Slaby <jirislaby@gmail.com>
Subject: [PATCH] Char: select fw_loader by moxa
Date: Tue, 13 May 2008 17:00:55 +0200
Message-Id: <1210690855-27785-1-git-send-email-jirislaby@gmail.com>
X-Mailer: git-send-email 1.5.5.1
X-Muni-Spam-TestIP: 147.251.48.3
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (minas.ics.muni.cz [147.251.4.35]); Tue, 13 May 2008 17:00:56 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Slaby <jirislaby@gmail.com>

Select FW_LOADER since moxa needs it, otherwise we face link problems
such as:
drivers/built-in.o: In function
moxa_pci_probe':moxa.c:(.devinit.text+0x76d8): undefined reference to
request_firmware'
:moxa.c:(.devinit.text+0x7e6e): undefined reference to release_firmware'
make: *** [.tmp_vmlinux1] Error 1

Reported-by: Philippe Roussel <p.o.roussel@free.fr>
Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
---
 drivers/char/Kconfig |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/char/Kconfig b/drivers/char/Kconfig
index c3e49f2..da73690 100644
--- a/drivers/char/Kconfig
+++ b/drivers/char/Kconfig
@@ -203,6 +203,7 @@ config ESPSERIAL
 config MOXA_INTELLIO
 	tristate "Moxa Intellio support"
 	depends on SERIAL_NONSTANDARD && (ISA || EISA || PCI)
+	select FW_LOADER
 	help
 	  Say Y here if you have a Moxa Intellio multiport serial card.
 
-- 
1.5.4.5

