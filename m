Return-Path: <linux-kernel-owner+w=401wt.eu-S965182AbXH0VkX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965182AbXH0VkX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2007 17:40:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765181AbXH0V3T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Aug 2007 17:29:19 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:58864 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1765498AbXH0V3R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2007 17:29:17 -0400
Date: Mon, 27 Aug 2007 23:29:13 +0200
From: Adrian Bunk <bunk@kernel.org>
To: perex@suse.cz
Cc: linux-kernel@vger.kernel.org
Subject: [2.6 patch] au88x0_synth.c bugfix
Message-ID: <20070827212913.GF26410@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes the code in vortex_wt_SetFrequency() to what seems to 
have been intended.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---
71ccb57f36553decc9cae117f3ff6dff1658c91f 
diff --git a/sound/pci/au88x0/au88x0_synth.c b/sound/pci/au88x0/au88x0_synth.c
index d3e662a..978b856 100644
--- a/sound/pci/au88x0/au88x0_synth.c
+++ b/sound/pci/au88x0/au88x0_synth.c
@@ -370,8 +370,8 @@ static void vortex_wt_SetFrequency(vortex_t * vortex, int wt, unsigned int sr)
 			while ((edx & 0x80000000) == 0) {
 				edx <<= 1;
 				eax--;
-				if (eax == 0) ;
-				break;
+				if (eax == 0)
+					break;
 			}
 			if (eax)
 				edx <<= 1;

