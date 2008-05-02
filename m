Return-Path: <linux-kernel-owner+w=401wt.eu-S965694AbYEBTIc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965694AbYEBTIc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2008 15:08:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964959AbYEBTFm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 May 2008 15:05:42 -0400
Received: from el-out-1112.google.com ([209.85.162.182]:53287 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964917AbYEBTFl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2008 15:05:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=cVemKmstN/aq5ft+rduR+VqoJkC7klcX7NDAZqRPNE4guas1n+2JuX8CKVel8ufcfU0AOAvcVZ4UcyhrdynY4i2Db5uQUrrGEmbdAw8mq8S6jXrsGRS/c6jxWh3QamHYysGGCGM4K9Xwan4QPzkYTmm4NffRr3iGMTZ9wiFv6os=
Subject: [PATCH 03/14] media: use get_unaligned_* helpers
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Fri, 02 May 2008 12:05:55 -0700
Message-Id: <1209755155.26173.69.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 drivers/media/radio/radio-si470x.c |   13 +++++--------
 1 files changed, 5 insertions(+), 8 deletions(-)

diff --git a/drivers/media/radio/radio-si470x.c b/drivers/media/radio/radio-si470x.c
index 77354ca..637e39f 100644
--- a/drivers/media/radio/radio-si470x.c
+++ b/drivers/media/radio/radio-si470x.c
@@ -521,8 +521,7 @@ static int si470x_get_register(struct si470x_device *radio, int regnr)
 	retval = si470x_get_report(radio, (void *) &buf, sizeof(buf));
 
 	if (retval >= 0)
-		radio->registers[regnr] = be16_to_cpu(get_unaligned(
-			(unsigned short *) &buf[1]));
+		radio->registers[regnr] = get_unaligned_be16(&buf[1]);
 
 	return (retval < 0) ? -EINVAL : 0;
 }
@@ -561,9 +560,8 @@ static int si470x_get_all_registers(struct si470x_device *radio)
 
 	if (retval >= 0)
 		for (regnr = 0; regnr < RADIO_REGISTER_NUM; regnr++)
-			radio->registers[regnr] = be16_to_cpu(get_unaligned(
-				(unsigned short *)
-				&buf[regnr * RADIO_REGISTER_SIZE + 1]));
+			radio->registers[regnr] = get_unaligned_be16(
+				&buf[regnr * RADIO_REGISTER_SIZE + 1]);
 
 	return (retval < 0) ? -EINVAL : 0;
 }
@@ -593,9 +591,8 @@ static int si470x_get_rds_registers(struct si470x_device *radio)
 
 	if (retval >= 0)
 		for (regnr = 0; regnr < RDS_REGISTER_NUM; regnr++)
-			radio->registers[STATUSRSSI + regnr] =
-				be16_to_cpu(get_unaligned((unsigned short *)
-				&buf[regnr * RADIO_REGISTER_SIZE + 1]));
+			radio->registers[STATUSRSSI + regnr] = get_unaligned_be16(
+				&buf[regnr * RADIO_REGISTER_SIZE + 1]);
 
 	return (retval < 0) ? -EINVAL : 0;
 }
-- 
1.5.5.1.350.gbbbf


