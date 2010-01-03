Return-Path: <linux-kernel-owner+w=401wt.eu-S1753016Ab0ACRBS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753016Ab0ACRBS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jan 2010 12:01:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752988Ab0ACRBQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Jan 2010 12:01:16 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:50321 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752908Ab0ACRBP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jan 2010 12:01:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=MlmQcp4gnRkRuaQ2awzt2QbVXjne6ELD6Ncvf6Bn25CozPwzO1rPctsUldbM44Ue5q
         TWzIuiz9meIjDr6cW8h9EBhvYZLNxz/m9z/opwJg8HtNz3qdFptr1eZBtVNOnBORJaei
         YeG6qcM2D61cWpwsGOppYH3NyyVBC7uBpBlD0=
Message-ID: <4B40CE2A.2090209@gmail.com>
Date: Sun, 03 Jan 2010 18:04:42 +0100
From: Roel Kluin <roel.kluin@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-4.fc12 Thunderbird/3.0
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@infradead.org>, linux-media@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] V4L/DVB (12930): Wrong variable tested
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The return of saa7164_i2caddr_to_reglen() was not tested.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
 drivers/media/video/saa7164/saa7164-api.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/media/video/saa7164/saa7164-api.c b/drivers/media/video/saa7164/saa7164-api.c
index 6f094a9..1d487c1 100644
--- a/drivers/media/video/saa7164/saa7164-api.c
+++ b/drivers/media/video/saa7164/saa7164-api.c
@@ -523,7 +523,7 @@ int saa7164_api_i2c_write(struct saa7164_i2c *bus, u8 addr, u32 datalen,
 	}
 
 	reglen = saa7164_i2caddr_to_reglen(bus, addr);
-	if (unitid < 0) {
+	if (reglen < 0) {
 		printk(KERN_ERR
 			"%s() error, cannot translate regaddr to reglen\n",
 			__func__);
