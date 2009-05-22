Return-Path: <linux-kernel-owner+w=401wt.eu-S1757313AbZEVN14@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757313AbZEVN14 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 May 2009 09:27:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753649AbZEVN1r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 May 2009 09:27:47 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:43795 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752514AbZEVN1q convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 May 2009 09:27:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=Y5amqfo7ecUV1jqCm5Q7nwgtpdrI4g15Pj/Vv8osHCovLZImE8A/H3AVt29ZG+9Kwo
         OxLQfiK7NDBw00urRcCL0HILwrSTRqIfNFpC3HemRMtxvrScJ3u1x17Xe8blbS+37l1K
         BvtzeY171onDSxPSTImL2fToxFpHRfUijxTCA=
MIME-Version: 1.0
Date: Fri, 22 May 2009 14:27:45 +0100
Message-ID: <5c43c2d40905220627g4036fd80n6f0ef8469e48aa1f@mail.gmail.com>
Subject: [PATCH] oss: Remove void casts
From: =?ISO-8859-1?Q?Andr=E9_Lopes?= <andre.neo.net@gmail.com>
To: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org,
       askulysh@image.kiev.ua
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This trivial patch just remove void cats from sound/oss/sh_dac_audio.c

Signed-off-by: André Lopes <andre.neo.net@gmail.com>

---
 sound/oss/sh_dac_audio.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/sound/oss/sh_dac_audio.c b/sound/oss/sh_dac_audio.c
index 78cfb66..7247ea1 100755
--- a/sound/oss/sh_dac_audio.c
+++ b/sound/oss/sh_dac_audio.c
@@ -200,21 +200,21 @@ static ssize_t dac_audio_write(struct file
*file, const char *buf, size_t count,
 	if (count > free)
 		count = free;
 	if (buffer_begin > buffer_end) {
-		if (copy_from_user((void *)buffer_end, buf, count))
+		if (copy_from_user(buffer_end, buf, count))
 			return -EFAULT;

 		buffer_end += count;
 	} else {
 		nbytes = data_buffer + BUFFER_SIZE - buffer_end;
 		if (nbytes > count) {
-			if (copy_from_user((void *)buffer_end, buf, count))
+			if (copy_from_user(buffer_end, buf, count))
 				return -EFAULT;
 			buffer_end += count;
 		} else {
-			if (copy_from_user((void *)buffer_end, buf, nbytes))
+			if (copy_from_user(buffer_end, buf, nbytes))
 				return -EFAULT;
 			if (copy_from_user
-			    ((void *)data_buffer, buf + nbytes, count - nbytes))
+			    (data_buffer, buf + nbytes, count - nbytes))
 				return -EFAULT;
 			buffer_end = data_buffer + count - nbytes;
 		}
@@ -322,7 +322,7 @@ static void __exit dac_audio_exit(void)
 	free_irq(TIMER1_IRQ, 0);

 	unregister_sound_dsp(device_major);
-	kfree((void *)data_buffer);
+	kfree(data_buffer);
 }

 module_init(dac_audio_init);
-- 
1.5.6.5
