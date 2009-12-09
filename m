Return-Path: <linux-kernel-owner+w=401wt.eu-S1757581AbZLITzO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757581AbZLITzO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Dec 2009 14:55:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757443AbZLITzN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Dec 2009 14:55:13 -0500
Received: from smtp.mujha-vel.cz ([81.30.225.246]:33799 "EHLO
	smtp.mujha-vel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757413AbZLITzM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Dec 2009 14:55:12 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: mchehab@redhat.com
Cc: jirislaby@gmail.com, linux-kernel@vger.kernel.org
Subject: [PATCH 1/1] EDAC: add __init to i7core_xeon_pci_fixup
Date: Wed,  9 Dec 2009 20:55:15 +0100
Message-Id: <1260388515-611-1-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.6.5.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It's called only from an __init function and is the only user
of pcibios_scan_specific_bus which will be marked as __devinit in
the next patch.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/edac/i7core_edac.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/edac/i7core_edac.c b/drivers/edac/i7core_edac.c
index 4de5a18..c7fc0d5 100644
--- a/drivers/edac/i7core_edac.c
+++ b/drivers/edac/i7core_edac.c
@@ -1141,7 +1141,7 @@ static void i7core_put_all_devices(void)
 		i7core_put_devices(i7core_dev);
 }
 
-static void i7core_xeon_pci_fixup(int dev_id)
+static void __init i7core_xeon_pci_fixup(int dev_id)
 {
 	struct pci_dev *pdev = NULL;
 	int i;
-- 
1.6.5.3

