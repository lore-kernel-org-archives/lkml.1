Return-Path: <linux-kernel-owner+w=401wt.eu-S1758214AbYIDSlZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758214AbYIDSlZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2008 14:41:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757473AbYIDSis
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Sep 2008 14:38:48 -0400
Received: from mail.work.de ([212.12.32.20]:58942 "EHLO mail.work.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757474AbYIDSir (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2008 14:38:47 -0400
Message-ID: <48C02B33.7050307@gmail.com>
Date: Thu, 04 Sep 2008 22:38:43 +0400
From: Manu Abraham <abraham.manu@gmail.com>
User-Agent: Thunderbird 1.5.0.14ubu (X11/20080306)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, v4l-dvb-maintainer@linuxtv.org,
       akpm@linux-foundation.org
Subject: DVB Update [PATCH 14/31] multiproto tree
X-Enigmail-Version: 0.94.0.0
Content-Type: multipart/mixed;
 boundary="------------070808040108010904070301"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------070808040108010904070301
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

>From 38d4629402b8a78da63d3979283955c3c518e25c Mon Sep 17 00:00:00 2001
From: Manu Abraham <manu@linuxtv.org>
Date: Thu, 4 Sep 2008 13:48:42 +0200
Subject: [PATCH] DVB fix wrong copy size

The datastructure was copied with a wrong specified size. The patch
fixes the same.

From: Manu Abraham <abraham.manu@gmail.com>
Signed-off-by: Manu Abraham <manu@linuxtv.org>

 dvb_frontend.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--------------070808040108010904070301
Content-Type: text/x-patch;
 name="14.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="14.patch"

>From 38d4629402b8a78da63d3979283955c3c518e25c Mon Sep 17 00:00:00 2001
From: Manu Abraham <manu@linuxtv.org>
Date: Thu, 4 Sep 2008 13:48:42 +0200
Subject: [PATCH] DVB fix wrong copy size

The datastructure was copied with a wrong specified size. The patch
fixes the same.

From: Manu Abraham <abraham.manu@gmail.com>
Signed-off-by: Manu Abraham <manu@linuxtv.org>

diff --git a/drivers/media/dvb/dvb-core/dvb_frontend.c b/drivers/media/dvb/dvb-core/dvb_frontend.c
index 313c639..3ca28d0 100644
--- a/drivers/media/dvb/dvb-core/dvb_frontend.c
+++ b/drivers/media/dvb/dvb-core/dvb_frontend.c
@@ -1688,7 +1688,7 @@ static int dvb_frontend_ioctl(struct inode *inode, struct file *file,
 
 		if (!(err = dvb_frontend_get_event(fe, &event, file->f_flags))) {
 			out_event->status = event.status;
-			memcpy(&out_event->parameters, &event.parameters, sizeof (struct dvb_frontend_event));
+			memcpy(&out_event->parameters, &event.parameters, sizeof (struct dvb_frontend_parameters));
 		}
 		break;
 	}
@@ -1712,7 +1712,7 @@ static int dvb_frontend_ioctl(struct inode *inode, struct file *file,
 
 		if (!(err = dvb_frontend_get_event(fe, &event, file->f_flags))) {
 			memcpy(&out_event->fe_events, &event.fe_events, sizeof (struct dvbfe_events));
-			memcpy(&out_event->fe_params, &event.fe_params, sizeof (struct dvb_frontend_event));
+			memcpy(&out_event->fe_params, &event.fe_params, sizeof (struct dvbfe_params));
 		}
 		break;
 	}

--------------070808040108010904070301--
