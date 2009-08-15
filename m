Return-Path: <linux-kernel-owner+w=401wt.eu-S1754409AbZHONlM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754409AbZHONlM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Aug 2009 09:41:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754279AbZHONlM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Aug 2009 09:41:12 -0400
Received: from fg-out-1718.google.com ([72.14.220.158]:29075 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754122AbZHONlK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Aug 2009 09:41:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=ntg7BAG/g/EDbBGzJsi+hDEiqxqNjwAgovsoyMQorPxqAVuqJgW8+it72Wwik/1o9q
         g6rNk2H3FEr1Y+UyFdF7Di/JbuPUoh7vozDDbqoArTzIIVZEqRA+JcVx6SXt5r2ccDIx
         dig0/A+drZkF3uQzzErK/f7DfF7LpJp+VyGNc=
Date: Sat, 15 Aug 2009 16:43:12 +0300
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] Make shr to divide by power of 2 (resend)
Message-ID: <20090815134312.GA7533@localdomain.by>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make an arithmetic right shift to divide by power of 2.

Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
---
diff --git a/drivers/video/console/bitblit.c b/drivers/video/console/bitblit.c
index 69864b1..b816151 100644
--- a/drivers/video/console/bitblit.c
+++ b/drivers/video/console/bitblit.c
@@ -144,7 +144,7 @@ static void bit_putcs(struct vc_data *vc, struct fb_info *info,
 		      int fg, int bg)
 {
 	struct fb_image image;
-	u32 width = (vc->vc_font.width + 7)/8;
+	u32 width = (vc->vc_font.width + 7) >> 3;
 	u32 cellsize = width * vc->vc_font.height;
 	u32 maxcnt = info->pixmap.size/cellsize;
 	u32 scan_align = info->pixmap.scan_align - 1;
