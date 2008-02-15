Return-Path: <linux-kernel-owner+w=401wt.eu-S934858AbYBOAmu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934858AbYBOAmu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 19:42:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756984AbYBOAmQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 19:42:16 -0500
Received: from ns1.suse.de ([195.135.220.2]:37957 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753695AbYBOAmP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 19:42:15 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-pci@atrey.karlin.mff.cuni.cz
Cc: linux-kernel@vger.kernel.org, pcihpd-discuss@lists.sourceforge.net,
       Greg Kroah-Hartman <gregkh@suse.de>, Jon Mason <jdmason@kudzu.us>
Subject: [PATCH 02/12] PCI: remove pci_get_device_reverse from calgary driver
Date: Thu, 14 Feb 2008 16:40:00 -0800
Message-Id: <1203036010-27988-2-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.4
In-Reply-To: <20080215003909.GA27981@kroah.com>
References: <20080215003909.GA27981@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This isn't needed, we can just walk the devices in bus order with no
problems at all, as we really want to remove pci_get_device_reverse from
the kernel tree.

Acked-by: Muli Ben-Yehuda <muli@il.ibm.com>
Cc: Jon Mason <jdmason@kudzu.us>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 arch/x86/kernel/pci-calgary_64.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/pci-calgary_64.c b/arch/x86/kernel/pci-calgary_64.c
index 1b5464c..67a3feb 100644
--- a/arch/x86/kernel/pci-calgary_64.c
+++ b/arch/x86/kernel/pci-calgary_64.c
@@ -1232,8 +1232,7 @@ static int __init calgary_init(void)
 
 error:
 	do {
-		dev = pci_get_device_reverse(PCI_VENDOR_ID_IBM,
-					     PCI_ANY_ID, dev);
+		dev = pci_get_device(PCI_VENDOR_ID_IBM, PCI_ANY_ID, dev);
 		if (!dev)
 			break;
 		if (!is_cal_pci_dev(dev->device))
-- 
1.5.4

