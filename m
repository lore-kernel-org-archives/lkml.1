Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757630Ab0BCTlu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Feb 2010 14:41:50 -0500
Received: from ey-out-2122.google.com ([74.125.78.26]:57168 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753806Ab0BCTlt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Feb 2010 14:41:49 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=MKv6sAVFIralqoHfeIV6voEfSzVOtZ4NNuAL718wIcEDkIe7ooDaU2xCuiJ22DYGAE
         aRHVM6bCyLZAvxgIkPBMVVDd2NUgCbu3mhiliF/g8Lk2JHA6aEsuj05+qT7+gLt60iJT
         7qk4j3zP0NrbCsIC97LFEgkAru695n0UuW/V8=
Message-ID: <4B69D2F5.2050100@gmail.com>
Date: Wed, 03 Feb 2010 20:48:05 +0100
From: Roel Kluin <roel.kluin@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc12 Thunderbird/3.0.1
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@infradead.org>, tobias.lorenz@gmx.net,
       linux-media@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] radio-si470x-common: -EINVAL overwritten in si470x_vidioc_s_tuner()
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The -EINVAL was overwritten by the si470x_disconnect_check().

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
Is this needed?

diff --git a/drivers/media/radio/si470x/radio-si470x-common.c b/drivers/media/radio/si470x/radio-si470x-common.c
index 4da0f15..65b4a92 100644
--- a/drivers/media/radio/si470x/radio-si470x-common.c
+++ b/drivers/media/radio/si470x/radio-si470x-common.c
@@ -748,12 +748,13 @@ static int si470x_vidioc_s_tuner(struct file *file, void *priv,
 		struct v4l2_tuner *tuner)
 {
 	struct si470x_device *radio = video_drvdata(file);
-	int retval = -EINVAL;
+	int retval;
 
 	/* safety checks */
 	retval = si470x_disconnect_check(radio);
 	if (retval)
 		goto done;
+	retval = -EINVAL;
 
 	if (tuner->index != 0)
 		goto done;
