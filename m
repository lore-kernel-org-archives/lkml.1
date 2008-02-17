Return-Path: <linux-kernel-owner+w=401wt.eu-S1761051AbYBQMcJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761051AbYBQMcJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2008 07:32:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757695AbYBQMX3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Feb 2008 07:23:29 -0500
Received: from pasmtpa.tele.dk ([80.160.77.114]:38356 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755372AbYBQMW5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2008 07:22:57 -0500
From: Sam Ravnborg <sam@ravnborg.org>
To: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: Sam Ravnborg <sam@ravnborg.org>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH 23/27] x86: annotate pci/common.s:pci_scan_bus_with_sysdata with __devinit
Date: Sun, 17 Feb 2008 13:23:00 +0100
Message-Id: <1203250984-11285-23-git-send-email-sam@ravnborg.org>
X-Mailer: git-send-email 1.5.4.1.143.ge7e51
In-Reply-To: <20080217121255.GA10519@uranus.ravnborg.org>
References: <20080217121255.GA10519@uranus.ravnborg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

pci_scan_bus_with_sysdata() is only used from either __init
or __devinit functions so annotate it __devinit to match the usage.

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: H. Peter Anvin <hpa@zytor.com>
---
 arch/x86/pci/common.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/pci/common.c b/arch/x86/pci/common.c
index b7c67a1..7b6e3bb 100644
--- a/arch/x86/pci/common.c
+++ b/arch/x86/pci/common.c
@@ -541,7 +541,7 @@ void pcibios_disable_device (struct pci_dev *dev)
 		pcibios_disable_irq(dev);
 }
 
-struct pci_bus *pci_scan_bus_with_sysdata(int busno)
+struct pci_bus *__devinit pci_scan_bus_with_sysdata(int busno)
 {
 	struct pci_bus *bus = NULL;
 	struct pci_sysdata *sd;
-- 
1.5.4.rc3.14.g44397

