Return-Path: <linux-kernel-owner+w=401wt.eu-S1756816AbYIDSnt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756816AbYIDSnt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2008 14:43:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757137AbYIDSjn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Sep 2008 14:39:43 -0400
Received: from mail.work.de ([212.12.32.20]:58979 "EHLO mail.work.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755955AbYIDSjl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2008 14:39:41 -0400
Message-ID: <48C02B68.8050302@gmail.com>
Date: Thu, 04 Sep 2008 22:39:36 +0400
From: Manu Abraham <abraham.manu@gmail.com>
User-Agent: Thunderbird 1.5.0.14ubu (X11/20080306)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, v4l-dvb-maintainer@linuxtv.org,
       akpm@linux-foundation.org
CC: Marco Schluessler <marco@lordzodiac.de>
Subject: DVB Update [PATCH 19/31] multiproto tree
X-Enigmail-Version: 0.94.0.0
Content-Type: multipart/mixed;
 boundary="------------000509050600060105040301"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------000509050600060105040301
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

>From 7d0389d6826fb460c85b25a54450151a55fa5338 Mon Sep 17 00:00:00 2001
From: Manu Abraham <manu@linuxtv.org>
Date: Thu, 4 Sep 2008 14:12:32 +0200
Subject: [PATCH] DVB Fix wrong copy for DVBFE_GET_PARAMS

The translated frontend parameters for the ioctl DVBFE_GET_PARAMS
wasn't copied back. The patch fixes the issue.

From: Marco Schluessler <marco@lorzodiac.de>
Signed-off-by: Marco Schluessler <marco@lordzodiac.de>
Signed-off-by: Manu Abraham <manu@linuxtv.org>

 dvb_frontend.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

--------------000509050600060105040301
Content-Type: text/x-patch;
 name="19.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="19.patch"

>From 7d0389d6826fb460c85b25a54450151a55fa5338 Mon Sep 17 00:00:00 2001
From: Manu Abraham <manu@linuxtv.org>
Date: Thu, 4 Sep 2008 14:12:32 +0200
Subject: [PATCH] DVB Fix wrong copy for DVBFE_GET_PARAMS

The translated frontend parameters for the ioctl DVBFE_GET_PARAMS
wasn't copied back. The patch fixes the issue.

From: Marco Schluessler <marco@lorzodiac.de>
Signed-off-by: Marco Schluessler <marco@lordzodiac.de>
Signed-off-by: Manu Abraham <manu@linuxtv.org>

diff --git a/drivers/media/dvb/dvb-core/dvb_frontend.c b/drivers/media/dvb/dvb-core/dvb_frontend.c
index c451785..e6ae5e6 100644
--- a/drivers/media/dvb/dvb-core/dvb_frontend.c
+++ b/drivers/media/dvb/dvb-core/dvb_frontend.c
@@ -1823,10 +1823,12 @@ static int dvb_frontend_ioctl(struct inode *inode, struct file *file,
 			memcpy(parg, &fepriv->fe_params, sizeof (struct dvbfe_params));
 			err = fe->ops.get_params(fe, (struct dvbfe_params *) parg);
 		} else if (fe->ops.get_frontend) {
-			memcpy (parg, &fepriv->parameters, sizeof (struct dvb_frontend_parameters));
 			err = fe->ops.get_frontend(fe, (struct dvb_frontend_parameters*) parg);
-			if (olddrv_to_newapi(fe, &fepriv->fe_params, &fepriv->parameters, fe->ops.info.type) == -EINVAL)
-				printk("%s: ERROR !!! Converting Old parameters --> New parameters\n", __func__);
+			if (!err) {
+				if (olddrv_to_newapi(fe, &fepriv->fe_params, &fepriv->parameters, fe->ops.info.type) == -EINVAL)
+					printk("%s: ERROR !!! Converting Old parameters --> New parameters\n", __func__);
+				memcpy(parg, &fepriv->fe_params, sizeof (struct dvbfe_params));
+			}
 		}
 		break;
 	case DVBFE_GET_DELSYS:

--------------000509050600060105040301--
