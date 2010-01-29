Return-Path: <linux-kernel-owner+w=401wt.eu-S932302Ab0A2JWs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932302Ab0A2JWs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jan 2010 04:22:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754305Ab0A2JWr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jan 2010 04:22:47 -0500
Received: from smtp.mujha-vel.cz ([81.30.225.246]:55312 "EHLO
	smtp.mujha-vel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753157Ab0A2JWo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jan 2010 04:22:44 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: jbarnes@virtuousgeek.org
Cc: linux-kernel@vger.kernel.org, jirislaby@gmail.com,
       linux-pci@vger.kernel.org, x86@kernel.org
Subject: [PATCH 1/1] X86: pci, fix section mismatch
Date: Fri, 29 Jan 2010 10:22:36 +0100
Message-Id: <1264756956-30006-1-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.6.6.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

pcibios_scan_specific_bus calls pci_scan_bus_on_node which is
__devinit. Mark pcibios_scan_specific_bus __devinit as well since
all users are now __init or __devinit.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: linux-pci@vger.kernel.org
Cc: x86@kernel.org
---
 arch/x86/pci/legacy.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

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
1.6.6.1

