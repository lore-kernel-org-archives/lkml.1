Return-Path: <linux-kernel-owner+w=401wt.eu-S1759851AbYEGT7o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759851AbYEGT7o (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 15:59:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753992AbYEGT7d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 15:59:33 -0400
Received: from yw-out-2324.google.com ([74.125.46.29]:33094 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753690AbYEGT7b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 15:59:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=avOB42w5nuzrcFj8zFvyFNbElpYSSXyc95M5ORnqcQNiKlJOh/e5NjU4+lTkV6/ZnA60AVQdzIJuoVSIOLuTSXl4AsCGZLojNxzqGLJ4LZb4e+CjBU3Ezsa+n554nb46xfntbHqvGyUUIyhndKnJngg6T2OAeg0cZ4r1XnQizeE=
Subject: [PATCH] i2c: cs8427.c use put_unaligned helper
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>, Takashi Iwai <tiwai@suse.de>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Wed, 07 May 2008 12:59:27 -0700
Message-Id: <1210190367.19279.45.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 sound/i2c/cs8427.c |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/sound/i2c/cs8427.c b/sound/i2c/cs8427.c
index e57e9cb..9c3d361 100644
--- a/sound/i2c/cs8427.c
+++ b/sound/i2c/cs8427.c
@@ -23,6 +23,7 @@
 #include <linux/slab.h>
 #include <linux/delay.h>
 #include <linux/init.h>
+#include <asm/unaligned.h>
 #include <sound/core.h>
 #include <sound/control.h>
 #include <sound/pcm.h>
@@ -264,10 +265,7 @@ int snd_cs8427_create(struct snd_i2c_bus *bus,
 		goto __fail;
 	}
 	/* write default channel status bytes */
-	buf[0] = ((unsigned char)(SNDRV_PCM_DEFAULT_CON_SPDIF >> 0));
-	buf[1] = ((unsigned char)(SNDRV_PCM_DEFAULT_CON_SPDIF >> 8));
-	buf[2] = ((unsigned char)(SNDRV_PCM_DEFAULT_CON_SPDIF >> 16));
-	buf[3] = ((unsigned char)(SNDRV_PCM_DEFAULT_CON_SPDIF >> 24));
+	put_unaligned_le32(SNDRV_PCM_DEFAULT_CON_SPDIF, buf);
 	memset(buf + 4, 0, 24 - 4);
 	if (snd_cs8427_send_corudata(device, 0, buf, 24) < 0)
 		goto __fail;
-- 
1.5.5.1.404.g981f6



