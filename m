Return-Path: <linux-kernel-owner+w=401wt.eu-S1753946AbZLTKsj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753946AbZLTKsj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Dec 2009 05:48:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753523AbZLTKsi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Dec 2009 05:48:38 -0500
Received: from mail.issp.bas.bg ([195.96.236.10]:55191 "EHLO mail.issp.bas.bg"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753513AbZLTKsi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Dec 2009 05:48:38 -0500
From: Marin Mitov <mitov@issp.bas.bg>
Organization: Institute of Solid State Physics
To: Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH]Section mismatch: __devinit pci_root_bus_res() is calling __init update_res()
Date: Sun, 20 Dec 2009 12:46:36 +0200
User-Agent: KMail/1.11.4 (Linux/2.6.33-rc1; KDE/4.2.4; x86_64; ; )
Cc: Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       x86@kernel.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200912201246.37272.mitov@issp.bas.bg>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Section mismatch: __devinit pci_root_bus_res() is calling __init update_res().
grepping the tree one find pci_root_bus_res is used only as:
DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_INTEL, 0x342e, pci_root_bus_res);
Mark it __init.

The patch is against 2.6.33-rc1.

Signed-off-by: Marin Mitov <mitov@issp.bas.bg>

==================================================================
--- a/arch/x86/pci/intel_bus.c	2009-12-20 11:50:44.000000000 +0200
+++ b/arch/x86/pci/intel_bus.c	2009-12-20 11:51:03.000000000 +0200
@@ -39,7 +39,7 @@
 #define IOH_LMMIOH_LIMITU	0x118
 #define IOH_LCFGBUS		0x11c
 
-static void __devinit pci_root_bus_res(struct pci_dev *dev)
+static void __init pci_root_bus_res(struct pci_dev *dev)
 {
 	u16 word;
 	u32 dword;
