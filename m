Return-Path: <linux-kernel-owner+w=401wt.eu-S1763947AbYEBDy2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763947AbYEBDy2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2008 23:54:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757349AbYEBDwx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 May 2008 23:52:53 -0400
Received: from wx-out-0506.google.com ([66.249.82.228]:62619 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756477AbYEBDwi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2008 23:52:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=lZZ4sl314ZBllMSWWmhA8DH46yHOEw7kR9h/6PRpIwjYmooOu4UQzwul5o4HtWikE+119L3huatFwEBcx+IG3ZOodVAMN7TbVUtVSoixpTiDIgMd9APiAObC0bHz9u77rl4I+qr4ts/M5sqVr/DV0zOC2ebSTfiEIvMkxxAQSpE=
Subject: [PATCH 3/8] media: use get_unaligned_* helpers
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Thu, 01 May 2008 20:52:56 -0700
Message-Id: <1209700376.22362.18.camel@brick>
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


