Return-Path: <linux-kernel-owner+w=401wt.eu-S1756786AbYGVAaq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756786AbYGVAaq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2008 20:30:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755536AbYGVA3h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jul 2008 20:29:37 -0400
Received: from ug-out-1314.google.com ([66.249.92.173]:9567 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755547AbYGVA3f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2008 20:29:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=SM3a2TNWUtqoJzsUVVrfTL+A5IAtnqaBZ9gh/bx76mQuHwvUKipsFI34sjwPDiWGTb
         2XknE9YUcuCIyhCpEYtkStH8U+j+icOixIFhe6SIWlzS2LBPlCo+r51ns2DbxFHWAyxM
         GXwXgvTqvvrUYqwJH3uCzNm5brImMhF7WtvW4=
Message-ID: <488529EB.9090501@gmail.com>
Date: Mon, 21 Jul 2008 20:29:31 -0400
From: roel kluin <roel.kluin@gmail.com>
User-Agent: Mozilla-Thunderbird 2.0.0.9 (X11/20080110)
MIME-Version: 1.0
To: benh@kernel.crashing.org, linux-fbdev-devel@lists.sourceforge.net
CC: linux-kernel@vger.kernel.org
Subject: [PATCH 6/9] radeon: test below 0 on unsigned v.[xy]offset
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

v.[xy]offset is unsigned so the test doesn't work.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
diff --git a/drivers/video/aty/radeon_base.c b/drivers/video/aty/radeon_base.c
index 400e926..586d04e 100644
--- a/drivers/video/aty/radeon_base.c
+++ b/drivers/video/aty/radeon_base.c
@@ -819,11 +819,6 @@ static int radeonfb_check_var (struct fb_var_screeninfo *var, struct fb_info *in
 	if (v.xres_virtual < v.xres)
 		v.xres = v.xres_virtual;
 
-	if (v.xoffset < 0)
-                v.xoffset = 0;
-        if (v.yoffset < 0)
-                v.yoffset = 0;
-         
         if (v.xoffset > v.xres_virtual - v.xres)
                 v.xoffset = v.xres_virtual - v.xres - 1;
                         
