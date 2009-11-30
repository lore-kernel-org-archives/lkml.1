Return-Path: <linux-kernel-owner+w=401wt.eu-S1752866AbZK3WZg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752866AbZK3WZg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Nov 2009 17:25:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752280AbZK3WZf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Nov 2009 17:25:35 -0500
Received: from smtp.mujha-vel.cz ([81.30.225.246]:46557 "EHLO
	smtp.mujha-vel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752150AbZK3WZe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Nov 2009 17:25:34 -0500
X-Greylist: delayed 7554 seconds by postgrey-1.27 at vger.kernel.org; Mon, 30 Nov 2009 17:25:34 EST
From: Jiri Slaby <jslaby@suse.cz>
To: jbarnes@virtuousgeek.org
Cc: jirislaby@gmail.com, linux-kernel@vger.kernel.org,
       Aristeu Sergio <arozansk@redhat.com>,
       Mauro Carvalho Chehab <mchehab@redhat.com>, linux-pci@vger.kernel.org,
       x86@kernel.org
Subject: [PATCH 2/2] X86: pci, fix section mismatches
Date: Mon, 30 Nov 2009 21:19:42 +0100
Message-Id: <1259612382-32722-2-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.6.5.3
In-Reply-To: <1259612382-32722-1-git-send-email-jslaby@suse.cz>
References: <1259612382-32722-1-git-send-email-jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

pcibios_scan_specific_bus calls pci_scan_bus_on_node which is __devinit.
Mark it __devinit as well. All users are now __init or __devinit.

Remark update_res from __init to __devinit as it is called also from
__devinit functions.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: Aristeu Sergio <arozansk@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: linux-pci@vger.kernel.org
Cc: x86@kernel.org
---
 arch/x86/pci/amd_bus.c |    2 +-
 arch/x86/pci/legacy.c  |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/pci/amd_bus.c b/arch/x86/pci/amd_bus.c
index 995f360..b78ffff 100644
--- a/arch/x86/pci/amd_bus.c
+++ b/arch/x86/pci/amd_bus.c
@@ -119,7 +119,7 @@ static void __init update_range(struct res_range *range, size_t start,
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

