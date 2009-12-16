Return-Path: <linux-kernel-owner+w=401wt.eu-S1755372AbZLPOtF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755372AbZLPOtF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 09:49:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750819AbZLPOtA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 09:49:00 -0500
Received: from mail-bw0-f227.google.com ([209.85.218.227]:60695 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750742AbZLPOs7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 09:48:59 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=gIexlLW+HzAsVV8pwPqmkfn8/nufxIWHkLzH3VfWClrn9tUTEAyk5tuJmepYlwV/B5
         IY+Fd5YdxhKP1NLCkxUKKjALMyfrmL2Gyghiz3aiCc60ds6YoUiWeRjzFRLXBfCPlIlO
         yHkvu4uT8Sv4Sdq4PADER4NE3gfWsr6ItQ3Ts=
Message-ID: <4B28F3CC.90509@gmail.com>
Date: Wed, 16 Dec 2009 15:50:52 +0100
From: Roel Kluin <roel.kluin@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20090922 Fedora/3.0-3.9.b4.fc12 Thunderbird/3.0b4
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, adaplas@pol.net,
       linux-fbdev@vger.kernel.org
Subject: [PATCH] fbdev: use correct size in do_fscreeninfo_to_user()
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Although these sizes may be the same it is better to calculate the size of
the source, than of the destiny.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
diff --git a/drivers/video/fbmem.c b/drivers/video/fbmem.c
index 99bbd28..57959c8 100644
--- a/drivers/video/fbmem.c
+++ b/drivers/video/fbmem.c
@@ -1234,7 +1234,7 @@ static int do_fscreeninfo_to_user(struct fb_fix_screeninfo *fix,
 	__u32 data;
 	int err;
 
-	err = copy_to_user(&fix32->id, &fix->id, sizeof(fix32->id));
+	err = copy_to_user(&fix32->id, &fix->id, sizeof(fix->id));
 
 	data = (__u32) (unsigned long) fix->smem_start;
 	err |= put_user(data, &fix32->smem_start);
