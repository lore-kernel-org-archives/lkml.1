Return-Path: <linux-kernel-owner+w=401wt.eu-S1757986AbYIDSk0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757986AbYIDSk0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2008 14:40:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756820AbYIDSiR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Sep 2008 14:38:17 -0400
Received: from mail.work.de ([212.12.32.20]:58929 "EHLO mail.work.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757302AbYIDSiP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2008 14:38:15 -0400
Message-ID: <48C02B13.70905@gmail.com>
Date: Thu, 04 Sep 2008 22:38:11 +0400
From: Manu Abraham <abraham.manu@gmail.com>
User-Agent: Thunderbird 1.5.0.14ubu (X11/20080306)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, v4l-dvb-maintainer@linuxtv.org,
       akpm@linux-foundation.org
Subject: DVB Update [PATCH 11/31] multiproto tree
X-Enigmail-Version: 0.94.0.0
Content-Type: multipart/mixed;
 boundary="------------020904090001090904090205"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------020904090001090904090205
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

>From 0fff81ba529c14db6c00da5c9ca105f3ca1ace25 Mon Sep 17 00:00:00 2001
From: Manu Abraham <manu@linuxtv.org>
Date: Thu, 4 Sep 2008 13:39:57 +0200
Subject: [PATCH] DVB Add tuner LOCK debug

* We need to check for tuner LOCK LOSS, especially in the
case of simple PLL's

From: Manu Abraham <abraham.manu@gmail.com>
Signed-off-by: Manu Abraham <manu@linuxtv.org>

 dvb_frontend.c |    5 +++++
 1 file changed, 5 insertions(+)

--------------020904090001090904090205
Content-Type: text/x-patch;
 name="11.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="11.patch"

>From 0fff81ba529c14db6c00da5c9ca105f3ca1ace25 Mon Sep 17 00:00:00 2001
From: Manu Abraham <manu@linuxtv.org>
Date: Thu, 4 Sep 2008 13:39:57 +0200
Subject: [PATCH] DVB Add tuner LOCK debug

* We need to check for tuner LOCK LOSS, especially in the
case of simple PLL's

From: Manu Abraham <abraham.manu@gmail.com>
Signed-off-by: Manu Abraham <manu@linuxtv.org>

diff --git a/drivers/media/dvb/dvb-core/dvb_frontend.c b/drivers/media/dvb/dvb-core/dvb_frontend.c
index 202a0de..60fd371 100644
--- a/drivers/media/dvb/dvb-core/dvb_frontend.c
+++ b/drivers/media/dvb/dvb-core/dvb_frontend.c
@@ -1113,6 +1113,7 @@ static int dvb_frontend_thread(void *data)
 	struct dvb_frontend_private *fepriv = fe->frontend_priv;
 	unsigned long timeout;
 	fe_status_t s;
+	u32 status;
 
 	enum dvbfe_algo algo;
 
@@ -1225,6 +1226,10 @@ restart:
 					fepriv->status = s;
 					if (fe->ops.track) {
 						dprintk("%s: TRACK callback exists at 0x%p\n", __func__, fe->ops.track);
+						if (fe->ops.tuner_ops.get_status)
+							fe->ops.tuner_ops.get_status(fe, &status);
+						if (!status)
+							printk("%s: Tuner LOCK LOST!\n", __func__);
 						fe->ops.track(fe, fe_params, &fepriv->delay);
 					}
 				}

--------------020904090001090904090205--
