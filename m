Return-Path: <linux-kernel-owner+w=401wt.eu-S1759952AbYIDSta@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759952AbYIDSta (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2008 14:49:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756783AbYIDSm5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Sep 2008 14:42:57 -0400
Received: from mail.work.de ([212.12.32.20]:42277 "EHLO mail.work.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758681AbYIDSm4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2008 14:42:56 -0400
Message-ID: <48C02C2C.2060508@gmail.com>
Date: Thu, 04 Sep 2008 22:42:52 +0400
From: Manu Abraham <abraham.manu@gmail.com>
User-Agent: Thunderbird 1.5.0.14ubu (X11/20080306)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, v4l-dvb-maintainer@linuxtv.org,
       akpm@linux-foundation.org
CC: rnissl@gmx.de
Subject: DVB Update [PATCH 30/31] multiproto tree
X-Enigmail-Version: 0.94.0.0
Content-Type: multipart/mixed;
 boundary="------------090400030609060607060209"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------090400030609060607060209
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

>From ce418a935a3439b68273550dea6caf3a7a820e8f Mon Sep 17 00:00:00 2001
From: Manu Abraham <manu@linuxtv.org>
Date: Thu, 4 Sep 2008 14:58:55 +0200
Subject: [PATCH] DVB Support DVBFE_SET_DELSYS backward compatibility

Make DVBFE_SET_DELSYS backward compatible

From: Reinhard Nissl <rnissl@gmx.de>
Signed-off-by: Reinhard Nissl <rnissl@gmx.de>
Signed-off-by: Manu Abraham <manu@linuxtv.org>

 dvb_frontend.c |   18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

--------------090400030609060607060209
Content-Type: text/x-patch;
 name="30.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="30.patch"

>From ce418a935a3439b68273550dea6caf3a7a820e8f Mon Sep 17 00:00:00 2001
From: Manu Abraham <manu@linuxtv.org>
Date: Thu, 4 Sep 2008 14:58:55 +0200
Subject: [PATCH] DVB Support DVBFE_SET_DELSYS backward compatibility

Make DVBFE_SET_DELSYS backward compatible

From: Reinhard Nissl <rnissl@gmx.de>
Signed-off-by: Reinhard Nissl <rnissl@gmx.de>
Signed-off-by: Manu Abraham <manu@linuxtv.org>

diff --git a/drivers/media/dvb/dvb-core/dvb_frontend.c b/drivers/media/dvb/dvb-core/dvb_frontend.c
index 3a49876..a8005ef 100644
--- a/drivers/media/dvb/dvb-core/dvb_frontend.c
+++ b/drivers/media/dvb/dvb-core/dvb_frontend.c
@@ -1854,6 +1854,24 @@ static int dvb_frontend_ioctl(struct inode *inode, struct file *file,
 		if (fe->ops.set_delsys) {
 			fe->ops.set_delsys(fe, fepriv->delsys);
 			err = 0;
+		} else {
+			err = 0;
+			switch (fe->ops.info.type) {
+				case FE_QPSK:
+					if (fepriv->delsys != DVBFE_DELSYS_DVBS)
+						err = -EINVAL;
+					break;
+				case FE_QAM:
+					if (fepriv->delsys != DVBFE_DELSYS_DVBC)
+						err = -EINVAL;
+					break;
+				case FE_OFDM:
+					if (fepriv->delsys != DVBFE_DELSYS_DVBT)
+						err = -EINVAL;
+					break;
+				default:
+					err = -EINVAL;
+			}
 		}
 		break;
 	case DVBFE_GET_INFO:

--------------090400030609060607060209--
