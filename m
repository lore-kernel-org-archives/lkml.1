Return-Path: <linux-kernel-owner+w=401wt.eu-S1757428AbZCXOB5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757428AbZCXOB5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 10:01:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756811AbZCXOBa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 10:01:30 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:48921 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756340AbZCXOB3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 10:01:29 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 01/30] disallow SERIAL_8250_PNP with SERIAL_8250_CONSOLE
To: linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org,
       torvalds@linux-foundation.org
Date: Tue, 24 Mar 2009 14:01:52 +0000
Message-ID: <20090324140145.12735.29459.stgit@localhost.localdomain>
In-Reply-To: <20090324135930.12735.7827.stgit@localhost.localdomain>
References: <20090324135930.12735.7827.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Clark Williams <williams@redhat.com>

There are known (but hard to fix issues) with using SERIAL_8250_PNP with
SERIAL_8250_CONSOLE. This patch just sidesteps that by not allowing PNP
when CONSOLE is selected.

Signed-off-by: Clark Williams <williams@redhat.com>
Signed-off-by: Alan Cox <number6@the-village.bc.nu>
---

 drivers/serial/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)


diff --git a/drivers/serial/Kconfig b/drivers/serial/Kconfig
index 7d7f576..451b64f 100644
--- a/drivers/serial/Kconfig
+++ b/drivers/serial/Kconfig
@@ -91,7 +91,7 @@ config SERIAL_8250_PCI
 
 config SERIAL_8250_PNP
 	tristate "8250/16550 PNP device support" if EMBEDDED
-	depends on SERIAL_8250 && PNP
+	depends on SERIAL_8250 && PNP && ! SERIAL_8250_CONSOLE
 	default SERIAL_8250
 	help
 	  This builds standard PNP serial support. You may be able to

