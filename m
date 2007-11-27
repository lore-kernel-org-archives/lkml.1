Return-Path: <linux-kernel-owner+w=401wt.eu-S1758209AbXK0J7z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758209AbXK0J7z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2007 04:59:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753671AbXK0J7t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Nov 2007 04:59:49 -0500
Received: from gepetto.dc.ltu.se ([130.240.42.40]:48780 "EHLO
	gepetto.dc.ltu.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753510AbXK0J7s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2007 04:59:48 -0500
Date: Tue, 27 Nov 2007 10:59:37 +0100 (MET)
From: Richard Knutsson <ricknu-0@student.ltu.se>
To: mchehab@infradead.org
Cc: v4l-dvb-maintainer@linuxtv.org, linux-kernel@vger.kernel.org,
       Richard Knutsson <ricknu-0@student.ltu.se>
Message-Id: <20071127094728.3746.64579.sendpatchset@thinktank.campus.ltu.se>
Subject: [PATCH] [VIDEO]: Complement va_start() with va_end() + style fixes
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Complement va_start() with va_end() + minor style fixes in the same function.

Signed-off-by: Richard Knutsson <ricknu-0@student.ltu.se>
---
Compile-tested on i386 with allyesconfig and allmodconfig.
Thanks to WANG Cong for pointing out the missing 'style fix'-description.
(Sorry about the repost, but Thunderbird seem unhappy now, so I use
'sendpatchset' and can't post in the previous thread)

 saa5246a.c |   10 ++++++----
 saa5249.c  |    8 +++++---
 2 files changed, 11 insertions(+), 7 deletions(-)


diff --git a/drivers/media/video/saa5246a.c b/drivers/media/video/saa5246a.c
index ad02329..996b494 100644
--- a/drivers/media/video/saa5246a.c
+++ b/drivers/media/video/saa5246a.c
@@ -187,12 +187,14 @@ static int i2c_senddata(struct saa5246a_device *t, ...)
 {
 	unsigned char buf[64];
 	int v;
-	int ct=0;
+	int ct = 0;
 	va_list argp;
-	va_start(argp,t);
+	va_start(argp, t);
 
-	while((v=va_arg(argp,int))!=-1)
-		buf[ct++]=v;
+	while ((v = va_arg(argp, int)) != -1)
+		buf[ct++] = v;
+
+	va_end(argp);
 	return i2c_sendbuf(t, buf[0], ct-1, buf+1);
 }
 
diff --git a/drivers/media/video/saa5249.c b/drivers/media/video/saa5249.c
index 94bb59a..da5ca30 100644
--- a/drivers/media/video/saa5249.c
+++ b/drivers/media/video/saa5249.c
@@ -282,12 +282,14 @@ static int i2c_senddata(struct saa5249_device *t, ...)
 {
 	unsigned char buf[64];
 	int v;
-	int ct=0;
+	int ct = 0;
 	va_list argp;
 	va_start(argp,t);
 
-	while((v=va_arg(argp,int))!=-1)
-		buf[ct++]=v;
+	while ((v = va_arg(argp, int)) != -1)
+		buf[ct++] = v;
+
+	va_end(argp);
 	return i2c_sendbuf(t, buf[0], ct-1, buf+1);
 }
 
