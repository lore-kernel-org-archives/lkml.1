Return-Path: <linux-kernel-owner+w=401wt.eu-S1756624AbYIDSm7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756624AbYIDSm7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2008 14:42:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756759AbYIDSjc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Sep 2008 14:39:32 -0400
Received: from mail.work.de ([212.12.32.20]:58972 "EHLO mail.work.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757779AbYIDSjb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2008 14:39:31 -0400
Message-ID: <48C02B5E.4060804@gmail.com>
Date: Thu, 04 Sep 2008 22:39:26 +0400
From: Manu Abraham <abraham.manu@gmail.com>
User-Agent: Thunderbird 1.5.0.14ubu (X11/20080306)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, v4l-dvb-maintainer@linuxtv.org,
       akpm@linux-foundation.org
CC: Marco Schluessler <marco@lordzodiac.de>
Subject: DVB Update [PATCH 18/31] multiproto tree
X-Enigmail-Version: 0.94.0.0
Content-Type: multipart/mixed;
 boundary="------------090905080307030501020903"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------090905080307030501020903
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

>From 2bffadf07b54a3ee47164b65687d673175f14bac Mon Sep 17 00:00:00 2001
From: Manu Abraham <manu@linuxtv.org>
Date: Thu, 4 Sep 2008 14:09:26 +0200
Subject: [PATCH] DVB Make DVBFE_GET_INFO as well backward compatible.

DVBFE_GET_INFO ioctl was not backward compatible. The patch
fixes the issue.

From: Marco Schluessler <marco@lordzodiac.de>
Signed-off-by: Marco Schluessler <marco@lordzodiac.de>
Signed-off-by: Manu Abraham <manu@linuxtv.org>

 dvb_frontend.c |   64
++++++++++++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 63 insertions(+), 1 deletion(-)

--------------090905080307030501020903
Content-Type: text/x-patch;
 name="18.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="18.patch"

>From 2bffadf07b54a3ee47164b65687d673175f14bac Mon Sep 17 00:00:00 2001
From: Manu Abraham <manu@linuxtv.org>
Date: Thu, 4 Sep 2008 14:09:26 +0200
Subject: [PATCH] DVB Make DVBFE_GET_INFO as well backward compatible.

DVBFE_GET_INFO ioctl was not backward compatible. The patch
fixes the issue.

From: Marco Schluessler <marco@lordzodiac.de>
Signed-off-by: Marco Schluessler <marco@lordzodiac.de>
Signed-off-by: Manu Abraham <manu@linuxtv.org>

diff --git a/drivers/media/dvb/dvb-core/dvb_frontend.c b/drivers/media/dvb/dvb-core/dvb_frontend.c
index d8261b6..c451785 100644
--- a/drivers/media/dvb/dvb-core/dvb_frontend.c
+++ b/drivers/media/dvb/dvb-core/dvb_frontend.c
@@ -1859,7 +1859,69 @@ static int dvb_frontend_ioctl(struct inode *inode, struct file *file,
 			err = fe->ops.get_info(fe, &fepriv->fe_info);
 			memcpy((struct dvbfe_info *) parg, &fepriv->fe_info, sizeof (struct dvbfe_info));
 		} else {
-			memcpy(&fepriv->fe_info, (struct dvbfe_info *) parg, sizeof (struct dvbfe_info));
+			memset(&fepriv->fe_info, 0, sizeof(struct dvbfe_info));
+			switch (fe->ops.info.type) {
+				case FE_QPSK:
+					fepriv->fe_info.delivery = DVBFE_DELSYS_DVBS;
+					fepriv->fe_info.delsys.dvbs.modulation = DVBFE_MOD_QPSK;
+					if (fe->ops.info.caps & FE_CAN_FEC_1_2)
+						fepriv->fe_info.delsys.dvbs.fec |= DVBFE_FEC_1_2;
+					if (fe->ops.info.caps & FE_CAN_FEC_2_3)
+						fepriv->fe_info.delsys.dvbs.fec |= DVBFE_FEC_2_3;
+					if (fe->ops.info.caps & FE_CAN_FEC_3_4)
+						fepriv->fe_info.delsys.dvbs.fec |= DVBFE_FEC_3_4;
+					if (fe->ops.info.caps & FE_CAN_FEC_4_5)
+						fepriv->fe_info.delsys.dvbs.fec |= DVBFE_FEC_4_5;
+					if (fe->ops.info.caps & FE_CAN_FEC_5_6)
+						fepriv->fe_info.delsys.dvbs.fec |= DVBFE_FEC_5_6;
+					if (fe->ops.info.caps & FE_CAN_FEC_6_7)
+						fepriv->fe_info.delsys.dvbs.fec |= DVBFE_FEC_6_7;
+					if (fe->ops.info.caps & FE_CAN_FEC_7_8)
+						fepriv->fe_info.delsys.dvbs.fec |= DVBFE_FEC_7_8;
+					if (fe->ops.info.caps & FE_CAN_FEC_8_9)
+						fepriv->fe_info.delsys.dvbs.fec |= DVBFE_FEC_8_9;
+					if (fe->ops.info.caps & FE_CAN_FEC_AUTO)
+						fepriv->fe_info.delsys.dvbs.fec |= DVBFE_FEC_AUTO;
+					break;
+				case FE_QAM:
+					fepriv->fe_info.delivery = DVBFE_DELSYS_DVBC;
+					if (fe->ops.info.caps & FE_CAN_QAM_16)
+						fepriv->fe_info.delsys.dvbc.modulation |= DVBFE_MOD_QAM16;
+					if (fe->ops.info.caps & FE_CAN_QAM_32)
+						fepriv->fe_info.delsys.dvbc.modulation |= DVBFE_MOD_QAM32;
+					if (fe->ops.info.caps & FE_CAN_QAM_64)
+						fepriv->fe_info.delsys.dvbc.modulation |= DVBFE_MOD_QAM64;
+					if (fe->ops.info.caps & FE_CAN_QAM_128)
+						fepriv->fe_info.delsys.dvbc.modulation |= DVBFE_MOD_QAM128;
+					if (fe->ops.info.caps & FE_CAN_QAM_256)
+						fepriv->fe_info.delsys.dvbc.modulation |= DVBFE_MOD_QAM256;
+					if (fe->ops.info.caps & FE_CAN_QAM_AUTO)
+						fepriv->fe_info.delsys.dvbc.modulation |= DVBFE_MOD_QAMAUTO;
+					break;
+				case FE_OFDM:
+					fepriv->fe_info.delivery = DVBFE_DELSYS_DVBT;
+					if (fe->ops.info.caps & FE_CAN_QPSK)
+						fepriv->fe_info.delsys.dvbt.modulation |= DVBFE_MOD_QPSK;
+					if (fe->ops.info.caps & FE_CAN_QAM_16)
+						fepriv->fe_info.delsys.dvbt.modulation |= DVBFE_MOD_QAM16;
+					if (fe->ops.info.caps & FE_CAN_QAM_64)
+						fepriv->fe_info.delsys.dvbt.modulation |= DVBFE_MOD_QAM64;
+					if (fe->ops.info.caps & FE_CAN_QAM_AUTO)
+						fepriv->fe_info.delsys.dvbt.modulation |= DVBFE_MOD_QAMAUTO;
+					break;
+				default:
+					up (&fepriv->sem);
+					return -EINVAL;
+			}
+			memcpy(&fepriv->fe_info.name, &fe->ops.info.name, 128);
+			fepriv->fe_info.frequency_min         = fe->ops.info.frequency_min;
+			fepriv->fe_info.frequency_max         = fe->ops.info.frequency_max;
+			fepriv->fe_info.frequency_step        = fe->ops.info.frequency_stepsize;
+			fepriv->fe_info.symbol_rate_min       = fe->ops.info.symbol_rate_min;
+			fepriv->fe_info.symbol_rate_max       = fe->ops.info.symbol_rate_max;
+			fepriv->fe_info.symbol_rate_tolerance = fe->ops.info.symbol_rate_tolerance;
+
+			memcpy((struct dvbfe_info *) parg, &fepriv->fe_info, sizeof (struct dvbfe_info));
 			err = 0;
 		}
 		break;

--------------090905080307030501020903--
