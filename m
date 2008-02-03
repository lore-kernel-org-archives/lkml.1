Return-Path: <linux-kernel-owner+w=401wt.eu-S1754713AbYBCXbS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754713AbYBCXbS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2008 18:31:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752848AbYBCXbD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Feb 2008 18:31:03 -0500
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:42756 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751917AbYBCXbB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2008 18:31:01 -0500
Date: Sun, 03 Feb 2008 15:38:13 -0800
From: Yinghai Lu <Yinghai.Lu@Sun.COM>
Subject: about x86: relax RAM check in ioremap
To: Ingo Molnar <mingo@elte.hu>, kjwinchester@gmail.com
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Message-id: <200802031538.14213.yinghai.lu@sun.com>
Organization: Sun
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7BIT
Content-disposition: inline
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

wonder if you still need that patch after following patch is a applied.

YH

diff --git a/arch/x86/kernel/aperture_64.c b/arch/x86/kernel/aperture_64.c
index 608152a..f645413 100644
--- a/arch/x86/kernel/aperture_64.c
+++ b/arch/x86/kernel/aperture_64.c
@@ -278,7 +278,7 @@ void __init early_gart_iommu_check(void)
 		last_aper_enabled = aper_enabled;
 	}
 
-	if (!fix && !aper_enabled)
+	if (!fix /* && !aper_enabled*/)
 		return;
 
 	if (!aper_base || !aper_size || aper_base + aper_size > 0x100000000UL)
