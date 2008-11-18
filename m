Return-Path: <linux-kernel-owner+w=401wt.eu-S1752662AbYKRLol@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752662AbYKRLol (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2008 06:44:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751985AbYKRLod
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Nov 2008 06:44:33 -0500
Received: from outbound-sin.frontbridge.com ([207.46.51.80]:35096 "EHLO
	SG2EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751947AbYKRLoc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2008 06:44:32 -0500
X-BigFish: VPS3(zzzzzzz32i43j62h)
X-Spam-TCS-SCL: 1:0
X-WSS-ID: 0KAJ1XX-04-6R2-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>
CC: linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org,
       Joerg Roedel <joerg.roedel@amd.com>, hawk@pld-linux.org,
       stable@kernel.org
Subject: [PATCH] x86: always select SWIOTLB on x86_64
Date: Tue, 18 Nov 2008 12:44:21 +0100
Message-ID: <1227008661-1609-1-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.5.6.4
X-OriginalArrivalTime: 18 Nov 2008 11:44:21.0453 (UTC) FILETIME=[FF4437D0:01C94972]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: fixes korg bugzilla 11980

A kernel for a 64bit x86 system should always contain the swiotlb code
in case it is booted on a machine without any hardware IOMMU supported
by the kernel and more than 4GB of RAM. This patch changes Kconfig to
always compile swiotlb into the kernel for x86_64.

Cc: hawk@pld-linux.org
Cc: stable@kernel.org
Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 93224b5..669c6d5 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -566,7 +566,7 @@ config AMD_IOMMU
 
 # need this always selected by IOMMU for the VIA workaround
 config SWIOTLB
-	bool
+	def_bool y if X86_64
 	help
 	  Support for software bounce buffers used on x86-64 systems
 	  which don't have a hardware IOMMU (e.g. the current generation
-- 
1.5.6.4


