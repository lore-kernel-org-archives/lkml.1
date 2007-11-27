Return-Path: <linux-kernel-owner+w=401wt.eu-S1758254AbXK0Jhq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758254AbXK0Jhq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2007 04:37:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752951AbXK0Jhj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Nov 2007 04:37:39 -0500
Received: from gepetto.dc.ltu.se ([130.240.42.40]:47803 "EHLO
	gepetto.dc.ltu.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752369AbXK0Jhj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2007 04:37:39 -0500
Message-ID: <474BE197.9060402@student.ltu.se>
Date: Tue, 27 Nov 2007 10:21:27 +0100
From: Richard Knutsson <ricknu-0@student.ltu.se>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: WANG Cong <xiyou.wangcong@gmail.com>
CC: mchehab@infradead.org, v4l-dvb-maintainer@linuxtv.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH] [VIDEO]: Complement va_start() with va_end() + style fixes
References: <20071127065410.4293.71568.sendpatchset@thinktank.campus.ltu.se> <20071127090101.GA2626@hacking>
In-Reply-To: <20071127090101.GA2626@hacking>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Complement va_start() with va_end() + minor style fixes in the same function.

Signed-off-by: Richard Knutsson <ricknu-0@student.ltu.se>
---
Compile-tested on i386 with allyesconfig and allmodconfig.
Thanks to WANG Cong for pointing out the missing 'style fix'-description.

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
 


