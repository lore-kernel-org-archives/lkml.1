Return-Path: <linux-kernel-owner+w=401wt.eu-S933895AbXC0BDM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933895AbXC0BDM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2007 21:03:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933880AbXC0BDA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Mar 2007 21:03:00 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:35472 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933895AbXC0BCn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2007 21:02:43 -0400
Date: Tue, 27 Mar 2007 03:02:47 +0200
From: Adrian Bunk <bunk@stusta.de>
To: "Eric W. Biederman" <ebiederm@xmission.com>, gregkh@suse.de
Cc: linux-kernel@vger.kernel.org, linux-pci@atrey.karlin.mff.cuni.cz
Subject: [RFC: 2.6.21 patch] let PCI_MSI depend on EXPERIMENTAL
Message-ID: <20070327010247.GW16477@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

We had during the last months have quite a few MSI bugs and even 
regressions due to:
- core kernel bugs,
- device driver bugs and
- hardware bugs

OTOH, MSI doesn't bring any real advantages for most users.

Let's therefore mark PCI_MSI as EXPERIMENTAL.

Signed-off-by: Adrian Bunk <bunk@stusta.de>

---
--- linux-2.6.21-rc4-mm1/drivers/pci/Kconfig.old	2007-03-26 21:04:11.000000000 +0200
+++ linux-2.6.21-rc4-mm1/drivers/pci/Kconfig	2007-03-26 21:04:29.000000000 +0200
@@ -2,8 +2,8 @@
 # PCI configuration
 #
 config PCI_MSI
-	bool "Message Signaled Interrupts (MSI and MSI-X)"
-	depends on PCI
+	bool "Message Signaled Interrupts (MSI and MSI-X)  (EXPERIMENTAL)"
+	depends on PCI && EXPERIMENTAL
 	depends on (X86_LOCAL_APIC && X86_IO_APIC) || IA64 || (PPC_MERGE && PPC_RTAS) || SPARC64
 	help
 	   This allows device drivers to enable MSI (Message Signaled


