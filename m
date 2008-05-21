Return-Path: <linux-kernel-owner+w=401wt.eu-S933186AbYEUAhr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933186AbYEUAhr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 20:37:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765428AbYEUAdP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 20:33:15 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:45334 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764827AbYEUAdN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 20:33:13 -0400
To: mchehab@infradead.org
Subject: [PATCH] or51132.c: unaligned
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org
Message-Id: <E1JycGV-0004yJ-SP@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Date: Wed, 21 May 2008 01:33:11 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 drivers/media/dvb/frontends/or51132.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/media/dvb/frontends/or51132.c b/drivers/media/dvb/frontends/or51132.c
index c7b5785..5ed3254 100644
--- a/drivers/media/dvb/frontends/or51132.c
+++ b/drivers/media/dvb/frontends/or51132.c
@@ -126,7 +126,7 @@ static int or51132_readreg(struct or51132_state *state, u8 reg)
 		       reg, err);
 		return -EREMOTEIO;
 	}
-	return le16_to_cpup((u16*)buf);
+	return buf[0] | (buf[1] << 8);
 }
 
 static int or51132_load_firmware (struct dvb_frontend* fe, const struct firmware *fw)
@@ -140,9 +140,9 @@ static int or51132_load_firmware (struct dvb_frontend* fe, const struct firmware
 	dprintk("Firmware is %Zd bytes\n",fw->size);
 
 	/* Get size of firmware A and B */
-	firmwareAsize = le32_to_cpu(*((u32*)fw->data));
+	firmwareAsize = le32_to_cpu(*((__le32*)fw->data));
 	dprintk("FirmwareA is %i bytes\n",firmwareAsize);
-	firmwareBsize = le32_to_cpu(*((u32*)(fw->data+4)));
+	firmwareBsize = le32_to_cpu(*((__le32*)(fw->data+4)));
 	dprintk("FirmwareB is %i bytes\n",firmwareBsize);
 
 	/* Upload firmware */
-- 
1.5.3.GIT

