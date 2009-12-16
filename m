Return-Path: <linux-kernel-owner+w=401wt.eu-S1759231AbZLPOdz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759231AbZLPOdz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 09:33:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757736AbZLPOdy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 09:33:54 -0500
Received: from mail-bw0-f227.google.com ([209.85.218.227]:50840 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756738AbZLPOdx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 09:33:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=el6s8C4pA5BASS6CYenl8tis0XrQlBPncwqLCP53oW6Y+D5Y9Id3KQJJs3xc2QV3m1
         2dTPisezpnc5g4HabmeGKdU1UMUUAA5Ye+Kz3TcB1CbKm7TmmpGQQv+8oFPekDZny3lK
         qaM+0VZxyXQvqhKra9EQ6+R9AMPIV86hZ3npA=
Message-ID: <4B28F041.2040603@gmail.com>
Date: Wed, 16 Dec 2009 15:35:45 +0100
From: Roel Kluin <roel.kluin@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20090922 Fedora/3.0-3.9.b4.fc12 Thunderbird/3.0b4
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@infradead.org>, linux-media@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] V4L/DVB: use correct size in put_v4l2_window32()
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Although these sizes may be the same it is better to calculate the size of
the source, than the destiny.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
diff --git a/drivers/media/video/v4l2-compat-ioctl32.c b/drivers/media/video/v4l2-compat-ioctl32.c
index 997975d..23ad218 100644
--- a/drivers/media/video/v4l2-compat-ioctl32.c
+++ b/drivers/media/video/v4l2-compat-ioctl32.c
@@ -288,7 +288,7 @@ static int get_v4l2_window32(struct v4l2_window *kp, struct v4l2_window32 __user
 
 static int put_v4l2_window32(struct v4l2_window *kp, struct v4l2_window32 __user *up)
 {
-	if (copy_to_user(&up->w, &kp->w, sizeof(up->w)) ||
+	if (copy_to_user(&up->w, &kp->w, sizeof(kp->w)) ||
 		put_user(kp->field, &up->field) ||
 		put_user(kp->chromakey, &up->chromakey) ||
 		put_user(kp->clipcount, &up->clipcount))
