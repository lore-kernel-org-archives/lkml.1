Return-Path: <linux-kernel-owner+w=401wt.eu-S1753037AbZGVPcz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753037AbZGVPcz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jul 2009 11:32:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752963AbZGVPcy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Jul 2009 11:32:54 -0400
Received: from imp03.mtu.ru ([62.5.255.20]:51932 "EHLO imp03.mtu.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751549AbZGVPcx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jul 2009 11:32:53 -0400
X-Greylist: delayed 359 seconds by postgrey-1.27 at vger.kernel.org; Wed, 22 Jul 2009 11:32:53 EDT
From: Pavel Vasilyev <pavel@pavlinux.ru>
Reply-To: pavel@pavlinux.ru
Organization: Pavlinux Inc.
To: linux-kernel@vger.kernel.org
Subject: GART_IOMMU without AGP
Date: Wed, 22 Jul 2009 19:26:49 +0400
User-Agent: KMail/1.9.10
X-Face: =?utf-8?q?=2EqZWJ=3F=248Zrl=26r=7C-=3B8=7ESTufc!R0d=5E=3FdE-g/S=5FryU2S=5D=27?=
 =?utf-8?q?=24vQ7EYY=3DBSj=5DJ-Gp=5FVXPpl=27ci/i=0A=09yH=5B=249HGUU=3Af?=@6hyHiQKeEv#S(K4XtVe$?0UO@',
 =?utf-8?q?!=25=5CR=3A7a=3BITA=3B=7Cs=7C=3F=25+T6=7E5=3Aq=2E2i=5DzA=25=0A=09?=
 =?utf-8?q?Mn-t3kOWGQ?=(7@ZOZ/0@+baHY#Fj&e/k'#p}#F<U{[DP[@"XbG&pmU~{oOMsPc4q|4/,
 =?utf-8?q?du8=0A=09?="'s*i`2=h[f!7!`#',39O3
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200907221926.50397.pavel@pavlinux.ru>
X-Spam-Flag: NO
X-Spam-Yversion: Spamooborona-3.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In the kernel configuration, if I choose x86_64 and PCI, then choose the item
"Garth IOMMU support", which, in turn, chooses not to switch off, support for
AGP. But many IOMMU system does not have AGP bus.

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 738bdc6..410369d 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -585,7 +585,6 @@ config GART_IOMMU
 	bool "GART IOMMU support" if EMBEDDED
 	default y
 	select SWIOTLB
-	select AGP
 	depends on X86_64 && PCI
 	---help---
 	  Support for full DMA access of devices with 32bit memory access only

Signed-off-by: Pavel Vasilyev <pavel@pavlinux.ru>

