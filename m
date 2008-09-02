Return-Path: <linux-kernel-owner+w=401wt.eu-S1753425AbYIBLOo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753425AbYIBLOo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2008 07:14:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751414AbYIBLOI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Sep 2008 07:14:08 -0400
Received: from outbound-sin.frontbridge.com ([207.46.51.80]:30937 "EHLO
	SG2EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751248AbYIBLOG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2008 07:14:06 -0400
X-BigFish: VPS13(z329epba6izzz10d3izzz32i43j61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0K6KF6V-04-A5Q-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: mingo@redhat.com, tglx@linutronix.de, hpa@zytor.com
CC: linux-kernel@vger.kernel.org, Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 2/2] x86, gart: add detection of AMD family 0x11 northbridges
Date: Tue, 2 Sep 2008 13:13:40 +0200
Message-ID: <1220354020-4883-3-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1220354020-4883-1-git-send-email-joerg.roedel@amd.com>
References: <1220354020-4883-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 02 Sep 2008 11:13:40.0661 (UTC) FILETIME=[F442E650:01C90CEC]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the detection of the northbridges in the AMD family 0x11
processors. It also fixes the magic numbers there while changing this code.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kernel/k8.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/k8.c b/arch/x86/kernel/k8.c
index 7377ccb..304d8ba 100644
--- a/arch/x86/kernel/k8.c
+++ b/arch/x86/kernel/k8.c
@@ -16,8 +16,9 @@ EXPORT_SYMBOL(num_k8_northbridges);
 static u32 *flush_words;
 
 struct pci_device_id k8_nb_ids[] = {
-	{ PCI_DEVICE(PCI_VENDOR_ID_AMD, 0x1103) },
-	{ PCI_DEVICE(PCI_VENDOR_ID_AMD, 0x1203) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_K8_NB_MISC) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_10H_NB_MISC) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_11H_NB_MISC) },
 	{}
 };
 EXPORT_SYMBOL(k8_nb_ids);
-- 
1.5.3.7


