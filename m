Return-Path: <linux-kernel-owner+w=401wt.eu-S1751857AbZKCOkg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751857AbZKCOkg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Nov 2009 09:40:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750915AbZKCOkf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Nov 2009 09:40:35 -0500
Received: from sputnik.urmx.de ([88.198.51.18]:37110 "EHLO sputnik.urmx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750778AbZKCOke (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Nov 2009 09:40:34 -0500
X-Greylist: delayed 1176 seconds by postgrey-1.27 at vger.kernel.org; Tue, 03 Nov 2009 09:40:34 EST
From: Dirk Eibach <eibach@gdsys.de>
To: linux-kernel@vger.kernel.org
Cc: Dirk Eibach <eibach@gdsys.de>
Subject: [PATCH] arch/powerpc: Improve _memcpy
Date: Tue,  3 Nov 2009 15:20:56 +0100
Message-Id: <1257258056-4008-1-git-send-email-eibach@gdsys.de>
X-SafeGuard_MailGateway: Version: 5.60.3.9732 SGMG Date: 20091103142101Z
X-AntiVirus: checked by AntiVir MailGate (version: 2.0.2-5; AVE: 7.9.1.53; VDF: 7.1.6.183; host: mailrelay)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The implementation of _memcpy_fromio and _memcpy_toio seems to be suboptimal for size 4.

Signed-off-by: Dirk Eibach <eibach@gdsys.de>
---
 arch/powerpc/kernel/io.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/powerpc/kernel/io.c b/arch/powerpc/kernel/io.c
index 1882bf4..8dc7547 100644
--- a/arch/powerpc/kernel/io.c
+++ b/arch/powerpc/kernel/io.c
@@ -161,7 +161,7 @@ void _memcpy_fromio(void *dest, const volatile void __iomem *src,
 		dest++;
 		n--;
 	}
-	while(n > 4) {
+	while(n >= 4) {
 		*((u32 *)dest) = *((volatile u32 *)vsrc);
 		eieio();
 		vsrc += 4;
@@ -190,7 +190,7 @@ void _memcpy_toio(volatile void __iomem *dest, const void *src, unsigned long n)
 		vdest++;
 		n--;
 	}
-	while(n > 4) {
+	while(n >= 4) {
 		*((volatile u32 *)vdest) = *((volatile u32 *)src);
 		src += 4;
 		vdest += 4;
-- 
1.5.6.5

