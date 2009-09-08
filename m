Return-Path: <linux-kernel-owner+w=401wt.eu-S1754253AbZIHKQO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754253AbZIHKQO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Sep 2009 06:16:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754225AbZIHKQN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Sep 2009 06:16:13 -0400
Received: from server1.wserver.cz ([82.113.45.157]:49418 "EHLO
	server1.wserver.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754153AbZIHKQM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Sep 2009 06:16:12 -0400
From: Jiri Slaby <jirislaby@gmail.com>
To: jbarnes@virtuousgeek.org
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
       Jiri Slaby <jirislaby@gmail.com>
Subject: [PATCH 1/1] X86: pci quirks, fix pci refcounting
Date: Tue,  8 Sep 2009 12:16:18 +0200
Message-Id: <1252404978-14977-1-git-send-email-jirislaby@gmail.com>
X-Mailer: git-send-email 1.6.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stanse found a pci reference leak in quirk_amd_nb_node.
Instead of putting nb_ht, there is a put of dev passed as
an argument.

http://stanse.fi.muni.cz/

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
---
 arch/x86/kernel/quirks.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/quirks.c b/arch/x86/kernel/quirks.c
index af71d06..6c3b2c6 100644
--- a/arch/x86/kernel/quirks.c
+++ b/arch/x86/kernel/quirks.c
@@ -508,7 +508,7 @@ static void __init quirk_amd_nb_node(struct pci_dev *dev)
 
 	pci_read_config_dword(nb_ht, 0x60, &val);
 	set_dev_node(&dev->dev, val & 7);
-	pci_dev_put(dev);
+	pci_dev_put(nb_ht);
 }
 
 DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_K8_NB,
-- 
1.6.3.3

