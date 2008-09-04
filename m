Return-Path: <linux-kernel-owner+w=401wt.eu-S1758768AbYIDUa6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758768AbYIDUa6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2008 16:30:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757792AbYIDU0q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Sep 2008 16:26:46 -0400
Received: from mail.work.de ([212.12.32.20]:42130 "EHLO mail.work.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758573AbYIDU0p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2008 16:26:45 -0400
Message-ID: <48C04480.5060807@gmail.com>
Date: Fri, 05 Sep 2008 00:26:40 +0400
From: Manu Abraham <abraham.manu@gmail.com>
User-Agent: Thunderbird 1.5.0.14ubu (X11/20080306)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, v4l-dvb-maintainer@linuxtv.org,
       akpm@linux-foundation.org
CC: marco@lordzodiac.de
Subject: DVB Update [PATCH 22/31] fix broken backward compat for DVBFE_GET_PARAMS
X-Enigmail-Version: 0.94.0.0
Content-Type: multipart/mixed;
 boundary="------------080403040306080604000103"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------080403040306080604000103
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

>From a4d4b171211d0c71eda0f807506e905df2b9e4ef Mon Sep 17 00:00:00 2001
From: Manu Abraham <manu@linuxtv.org>
Date: Thu, 4 Sep 2008 14:24:28 +0200
Subject: [PATCH] DVB fix broken backward compatibility for DVBFE_GET_PARAMS

DVBFE_GET_PARAMS 's backward compatibily was broken due to a
wrong copy. Fix it.

Thanks to Marco Schluessler <marco@lordzodiac.de> for pointing
out the bug.

From: Manu Abraham <abraham.manu@gmail.com>
Signed-off-by: Manu Abraham <manu@linuxtv.org>

 dvb_frontend.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


--------------080403040306080604000103
Content-Type: text/x-patch;
 name="22.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="22.patch"

>From a4d4b171211d0c71eda0f807506e905df2b9e4ef Mon Sep 17 00:00:00 2001
From: Manu Abraham <manu@linuxtv.org>
Date: Thu, 4 Sep 2008 14:24:28 +0200
Subject: [PATCH] DVB fix broken backward compatibility for DVBFE_GET_PARAMS

DVBFE_GET_PARAMS 's backward compatibily was broken due to a
wrong copy. Fix it.

Thanks to Marco Schluessler <marco@lordzodiac.de> for pointing
out the bug.

From: Manu Abraham <abraham.manu@gmail.com>
Signed-off-by: Manu Abraham <manu@linuxtv.org>

diff --git a/drivers/media/dvb/dvb-core/dvb_frontend.c b/drivers/media/dvb/dvb-core/dvb_frontend.c
index 2b28bd1..24ae622 100644
--- a/drivers/media/dvb/dvb-core/dvb_frontend.c
+++ b/drivers/media/dvb/dvb-core/dvb_frontend.c
@@ -1816,7 +1816,7 @@ static int dvb_frontend_ioctl(struct inode *inode, struct file *file,
 			memcpy(parg, &fepriv->fe_params, sizeof (struct dvbfe_params));
 			err = fe->ops.get_params(fe, (struct dvbfe_params *) parg);
 		} else if (fe->ops.get_frontend) {
-			err = fe->ops.get_frontend(fe, (struct dvb_frontend_parameters*) parg);
+			err = fe->ops.get_frontend(fe, &fepriv->parameters);
 			if (!err) {
 				if (olddrv_to_newapi(fe, &fepriv->fe_params, &fepriv->parameters, fe->ops.info.type) == -EINVAL)
 					printk("%s: ERROR !!! Converting Old parameters --> New parameters\n", __func__);


--------------080403040306080604000103--
