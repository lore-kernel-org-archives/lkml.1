Return-Path: <linux-kernel-owner+w=401wt.eu-S1760350AbYIDUfB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760350AbYIDUfB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2008 16:35:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758707AbYIDU1l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Sep 2008 16:27:41 -0400
Received: from mail.work.de ([212.12.32.20]:42166 "EHLO mail.work.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758701AbYIDU1k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2008 16:27:40 -0400
Message-ID: <48C044B8.7030301@gmail.com>
Date: Fri, 05 Sep 2008 00:27:36 +0400
From: Manu Abraham <abraham.manu@gmail.com>
User-Agent: Thunderbird 1.5.0.14ubu (X11/20080306)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, v4l-dvb-maintainer@linuxtv.org,
       akpm@linux-foundation.org
Subject: DVB Update [PATCH 29/31] fix missing return value
X-Enigmail-Version: 0.94.0.0
Content-Type: multipart/mixed;
 boundary="------------080109000001060300040600"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------080109000001060300040600
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

>From d947346c66e2af7f3dd055e7daf1778d98c61e50 Mon Sep 17 00:00:00 2001
From: Manu Abraham <manu@linuxtv.org>
Date: Thu, 4 Sep 2008 14:56:05 +0200
Subject: [PATCH] DVB fix missing return value

From: Manu Abraham <abraham.manu@gmail.com>
Signed-off-by: Manu Abraham <manu@linuxtv.org>

 dvb_frontend.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)


--------------080109000001060300040600
Content-Type: text/x-patch;
 name="29.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="29.patch"

>From d947346c66e2af7f3dd055e7daf1778d98c61e50 Mon Sep 17 00:00:00 2001
From: Manu Abraham <manu@linuxtv.org>
Date: Thu, 4 Sep 2008 14:56:05 +0200
Subject: [PATCH] DVB fix missing return value

From: Manu Abraham <abraham.manu@gmail.com>
Signed-off-by: Manu Abraham <manu@linuxtv.org>

diff --git a/drivers/media/dvb/dvb-core/dvb_frontend.c b/drivers/media/dvb/dvb-core/dvb_frontend.c
index 42ed894..3a49876 100644
--- a/drivers/media/dvb/dvb-core/dvb_frontend.c
+++ b/drivers/media/dvb/dvb-core/dvb_frontend.c
@@ -1851,9 +1851,10 @@ static int dvb_frontend_ioctl(struct inode *inode, struct file *file,
 		break;
 	case DVBFE_SET_DELSYS:
 		memcpy(&fepriv->delsys, (enum dvbfe_delsys *) parg, sizeof (enum dvbfe_delsys));
-		if (fe->ops.set_delsys)
+		if (fe->ops.set_delsys) {
 			fe->ops.set_delsys(fe, fepriv->delsys);
-
+			err = 0;
+		}
 		break;
 	case DVBFE_GET_INFO:
 		printk("%s: DVBFE_GET_INFO\n", __func__);


--------------080109000001060300040600--
