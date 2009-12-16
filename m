Return-Path: <linux-kernel-owner+w=401wt.eu-S934230AbZLPQEn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934230AbZLPQEn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 11:04:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751501AbZLPQEm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 11:04:42 -0500
Received: from mail-qy0-f192.google.com ([209.85.221.192]:44555 "EHLO
	mail-qy0-f192.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751319AbZLPQEl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 11:04:41 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=nysVDw+MNAe/LF4wNMgqgxH8xcTy5FyPKkFmoB+G/sQ6l0NYMj9wd3MHN7OFylya0d
         uTxHHaAn6DQm20ITW7FtpmXz/Fx4lTlEn+wXaCK7zJoSS7uCr9AW3jpqtzv1mk6JJ9/j
         gpxI94Vir/Hhwb1MTMkiFO/9ZdVQMyRbkrpu8=
Message-ID: <4B290589.2030607@gmail.com>
Date: Wed, 16 Dec 2009 17:06:33 +0100
From: Roel Kluin <roel.kluin@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20090922 Fedora/3.0-3.9.b4.fc12 Thunderbird/3.0b4
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@infradead.org>, linux-media@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] vivi: Fix test of unsigned in vivi_create_instance()
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

video_nr is unsigned so the test did not work.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
Found using coccinelle: http://coccinelle.lip6.fr/

diff --git a/drivers/media/video/vivi.c b/drivers/media/video/vivi.c
index 7705fc6..328af3a 100644
--- a/drivers/media/video/vivi.c
+++ b/drivers/media/video/vivi.c
@@ -1375,7 +1375,7 @@ static int __init vivi_create_instance(int inst)
 	snprintf(vfd->name, sizeof(vfd->name), "%s (%i)",
 			vivi_template.name, vfd->num);
 
-	if (video_nr >= 0)
+	if (video_nr != -1)
 		video_nr++;
 
 	dev->vfd = vfd;
