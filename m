Return-Path: <linux-kernel-owner+w=401wt.eu-S1758629AbYFBNw1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758629AbYFBNw1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2008 09:52:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755920AbYFBNv6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jun 2008 09:51:58 -0400
Received: from ns1.suse.de ([195.135.220.2]:53245 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754411AbYFBNv5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2008 09:51:57 -0400
From: Olaf Dabrunz <od@suse.de>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Jon Masters <jonathan@jonmasters.org>, linux-kernel@vger.kernel.org,
       Olaf Dabrunz <od@suse.de>, Stefan Assmann <sassmann@suse.de>
Subject: [PATCH 1/7] add kernel cmdline option to disable pci-irq quirks
Date: Mon,  2 Jun 2008 14:45:01 +0200
Message-Id: <12124107071030-git-send-email-od@suse.de>
X-Mailer: git-send-email 1.5.2.4
In-Reply-To: <12124107071847-git-send-email-od@suse.de>
References: <12124107071847-git-send-email-od@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Olaf Dabrunz <od@suse.de>

Add a switch to disable all boot interrupt quirks, using the parameter
nobootirqquirk.

Signed-off-by: Olaf Dabrunz <od@suse.de>
Signed-off-by: Stefan Assmann <sassmann@suse.de>
---
 drivers/pci/quirks.c |   15 +++++++++++++++
 1 files changed, 15 insertions(+), 0 deletions(-)

diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
index dabb563..6245486 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -1363,6 +1363,21 @@ DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_INTEL,	0x2609, quirk_intel_pcie_pm);
 DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_INTEL,	0x260a, quirk_intel_pcie_pm);
 DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_INTEL,	0x260b, quirk_intel_pcie_pm);
 
+
+#ifdef CONFIG_X86_IO_APIC
+int nobootirqquirk __read_mostly = 0;
+
+int nobootirqquirk_setup(char *str)
+{
+	nobootirqquirk = 1;
+	printk(KERN_INFO "Boot IRQ quirk handling disabled\n");
+
+	return 1;
+}
+__setup("nobootirqquirk", nobootirqquirk_setup);
+#endif /* CONFIG_X86_IO_APIC */
+
+
 /*
  * Toshiba TC86C001 IDE controller reports the standard 8-byte BAR0 size
  * but the PIO transfers won't work if BAR0 falls at the odd 8 bytes.
-- 
1.5.2.4

-- 
Olaf Dabrunz (od/odabrunz), SUSE Linux Products GmbH, Nürnberg

