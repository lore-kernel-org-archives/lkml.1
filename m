Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754010Ab0BTStr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Feb 2010 13:49:47 -0500
Received: from 87-194-149-168.bethere.co.uk ([87.194.149.168]:64797 "EHLO
	svr2.cnick.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751117Ab0BTStq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Feb 2010 13:49:46 -0500
From: chris.nicholson@cnick.org.uk
To: airlied@linux.ie, bskeggs@redhat.com, madman2003@gmail.com,
       koriakin@0x04.net, currojerez@riseup.net, tacconet@libero.it
Cc: dri-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: [PATCH] Gpu: drm: fix buffer overflow in nouveau_bios.c
Date: Sat, 20 Feb 2010 18:49:43 +0000
Message-Id: <1266691783-25029-1-git-send-email-chris.nicholson@cnick.org.uk>
X-Mailer: git-send-email 1.6.6
X-OriginalArrivalTime: 20 Feb 2010 18:48:47.0653 (UTC) FILETIME=[55E93550:01CAB25D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Chris Nicholson <chris@port.cnick.org.uk>

This is a patch to the nouveau_bios.c file that fixes up a
buffer overflow

Signed-off-by: Chris Nicholson <chris.nicholson@cnick.org.uk>
---
 drivers/gpu/drm/nouveau/nouveau_bios.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/gpu/drm/nouveau/nouveau_bios.c b/drivers/gpu/drm/nouveau/nouveau_bios.c
index 0e9cd1d..c1cee91 100644
--- a/drivers/gpu/drm/nouveau/nouveau_bios.c
+++ b/drivers/gpu/drm/nouveau/nouveau_bios.c
@@ -762,7 +762,7 @@ static uint32_t get_tmds_index_reg(struct drm_device *dev, uint8_t mlv)
 			dacoffset ^= 8;
 		return 0x6808b0 + dacoffset;
 	} else {
-		if (mlv > ARRAY_SIZE(pramdac_table)) {
+		if (mlv >= ARRAY_SIZE(pramdac_table)) {
 			NV_ERROR(dev, "Magic Lookup Value too big (%02X)\n",
 									mlv);
 			return 0;
-- 
1.6.6

