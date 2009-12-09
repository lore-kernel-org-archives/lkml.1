Return-Path: <linux-kernel-owner+w=401wt.eu-S1757586AbZLIT4M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757586AbZLIT4M (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Dec 2009 14:56:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757392AbZLIT4H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Dec 2009 14:56:07 -0500
Received: from smtp.mujha-vel.cz ([81.30.225.246]:33891 "EHLO
	smtp.mujha-vel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757334AbZLIT4G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Dec 2009 14:56:06 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: jbarnes@virtuousgeek.org
Cc: jirislaby@gmail.com, linux-kernel@vger.kernel.org,
       Aristeu Sergio <arozansk@redhat.com>, linux-pci@vger.kernel.org,
       x86@kernel.org
Subject: [PATCH 1/1] X86: pci, fix section mismatches
Date: Wed,  9 Dec 2009 20:56:10 +0100
Message-Id: <1260388570-680-1-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.6.5.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

pcibios_scan_specific_bus calls pci_scan_bus_on_node which is __devinit.
Mark it __devinit as well. All users are now __init or __devinit.

Remark update_res from __init to __devinit as it is called also from
__devinit functions.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: Aristeu Sergio <arozansk@redhat.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: linux-pci@vger.kernel.org
Cc: x86@kernel.org
---
 arch/x86/pci/bus_numa.c |    2 +-
 arch/x86/pci/legacy.c   |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/pci/bus_numa.c b/arch/x86/pci/bus_numa.c
index 145df00..f939d60 100644
--- a/arch/x86/pci/bus_numa.c
+++ b/arch/x86/pci/bus_numa.c
@@ -51,7 +51,7 @@ void x86_pci_root_bus_res_quirks(struct pci_bus *b)
 	}
 }
 
-void __init update_res(struct pci_root_info *info, size_t start,
+void __devinit update_res(struct pci_root_info *info, size_t start,
 			      size_t end, unsigned long flags, int merge)
 {
 	int i;
diff --git a/arch/x86/pci/legacy.c b/arch/x86/pci/legacy.c
index a8194c8..8cf7835 100644
--- a/arch/x86/pci/legacy.c
+++ b/arch/x86/pci/legacy.c
@@ -39,7 +39,7 @@ static int __init pci_legacy_init(void)
 	return 0;
 }
 
-void pcibios_scan_specific_bus(int busn)
+void __devinit pcibios_scan_specific_bus(int busn)
 {
 	int devfn;
 	long node;
-- 
1.6.5.3

