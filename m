Return-Path: <linux-kernel-owner+w=401wt.eu-S1762204AbZLPPGI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762204AbZLPPGI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 10:06:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760389AbZLPPGG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 10:06:06 -0500
Received: from mail-bw0-f227.google.com ([209.85.218.227]:58886 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759290AbZLPPGB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 10:06:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=dCPqgEwNDFMyguYqLj1p7IsAsgkhbLtmtD7BtCoW+aSK+wBi+5Y8OaK+y1Mtgp8SId
         qCupeynHzCJMaX/X9HkueH4zxvbjT0DKI+hKnRFnZaPpbWqhwfDi/eLwLWSvI7dtQB8Z
         qQDGsvEzZFGhfZq3z4lJgEG5O2pnafq6lxWS8=
Message-ID: <4B28F7C9.5040206@gmail.com>
Date: Wed, 16 Dec 2009 16:07:53 +0100
From: Roel Kluin <roel.kluin@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20090922 Fedora/3.0-3.9.b4.fc12 Thunderbird/3.0b4
MIME-Version: 1.0
To: Jean-Francois Moine <moinejf@free.fr>, linux-media@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] gspca: Fix tests of unsigned
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

val and sd->gain are unsigned so the tests did not work.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
Found using coccinelle: http://coccinelle.lip6.fr/

diff --git a/drivers/media/video/gspca/ov534.c b/drivers/media/video/gspca/ov534.c
index 4dbb882..f5d1f18 100644
--- a/drivers/media/video/gspca/ov534.c
+++ b/drivers/media/video/gspca/ov534.c
@@ -1536,7 +1536,7 @@ static void setsharpness_96(struct gspca_dev *gspca_dev)
 	u8 val;
 
 	val = sd->sharpness;
-	if (val < 0) {				/* auto */
+	if (val == -1) {				/* auto */
 		val = sccb_reg_read(gspca_dev, 0x42);	/* com17 */
 		sccb_reg_write(gspca_dev, 0xff, 0x00);
 		sccb_reg_write(gspca_dev, 0x42, val | 0x40);
diff --git a/drivers/media/video/gspca/sn9c20x.c b/drivers/media/video/gspca/sn9c20x.c
index b1944a7..7ebabe7 100644
--- a/drivers/media/video/gspca/sn9c20x.c
+++ b/drivers/media/video/gspca/sn9c20x.c
@@ -2319,7 +2319,7 @@ static void do_autogain(struct gspca_dev *gspca_dev, u16 avg_lum)
 		}
 	}
 	if (avg_lum > MAX_AVG_LUM) {
-		if (sd->gain - 1 >= 0) {
+		if (sd->gain >= 1) {
 			sd->gain--;
 			set_gain(gspca_dev);
 		}
