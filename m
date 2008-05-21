Return-Path: <linux-kernel-owner+w=401wt.eu-S932778AbYEUAfl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932778AbYEUAfl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 20:35:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765515AbYEUAcX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 20:32:23 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:45317 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756633AbYEUAcW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 20:32:22 -0400
To: mchehab@infradead.org
Subject: [PATCH] bt8xx: unaligned access
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org
Message-Id: <E1JycFh-0004sc-Re@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Date: Wed, 21 May 2008 01:32:21 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 drivers/media/video/bt8xx/bttv-cards.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/media/video/bt8xx/bttv-cards.c b/drivers/media/video/bt8xx/bttv-cards.c
index f20a01c..8ef0424 100644
--- a/drivers/media/video/bt8xx/bttv-cards.c
+++ b/drivers/media/video/bt8xx/bttv-cards.c
@@ -34,6 +34,7 @@
 #include <linux/firmware.h>
 #include <net/checksum.h>
 
+#include <asm/unaligned.h>
 #include <asm/io.h>
 
 #include "bttvp.h"
@@ -3858,7 +3859,7 @@ static void __devinit osprey_eeprom(struct bttv *btv, const u8 ee[256])
 		ee += i;
 
 		/* found a valid descriptor */
-		type = be16_to_cpup((u16*)(ee+4));
+		type = get_unaligned_be16((__be16 *)(ee+4));
 
 		switch(type) {
 		/* 848 based */
@@ -3918,7 +3919,7 @@ static void __devinit osprey_eeprom(struct bttv *btv, const u8 ee[256])
 			       btv->c.nr, type);
 			break;
 		}
-		serial = be32_to_cpup((u32*)(ee+6));
+		serial = get_unaligned_be32((__be32 *)(ee+6));
 	}
 
 	printk(KERN_INFO "bttv%d: osprey eeprom: card=%d '%s' serial=%u\n",
-- 
1.5.3.GIT


