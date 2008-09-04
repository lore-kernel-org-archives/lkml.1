Return-Path: <linux-kernel-owner+w=401wt.eu-S1756656AbYIDSqy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756656AbYIDSqy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2008 14:46:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758435AbYIDSl4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Sep 2008 14:41:56 -0400
Received: from mail.work.de ([212.12.32.20]:42236 "EHLO mail.work.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758426AbYIDSlz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2008 14:41:55 -0400
Message-ID: <48C02BEE.8090103@gmail.com>
Date: Thu, 04 Sep 2008 22:41:50 +0400
From: Manu Abraham <abraham.manu@gmail.com>
User-Agent: Thunderbird 1.5.0.14ubu (X11/20080306)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, v4l-dvb-maintainer@linuxtv.org,
       akpm@linux-foundation.org
CC: rnissl@gmx.de
Subject: DVB Update [PATCH 24/31] multiproto tree
X-Enigmail-Version: 0.94.0.0
Content-Type: multipart/mixed;
 boundary="------------010606080508080007090302"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------010606080508080007090302
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

>From dacdc1e893068e7694a55fe140016bb6e56bc35f Mon Sep 17 00:00:00 2001
From: Manu Abraham <manu@linuxtv.org>
Date: Thu, 4 Sep 2008 14:33:07 +0200
Subject: [PATCH] DVB fix broken DVB-T backward compatibility

due to a missing break DVB-T backward compatibility was
broken all the way. The patch fixes the same.

From: Reinhard Nissl <rnissl@gmx.de>
Signed-off-by: Reinhard Nissl <rnissl@gmx.de>
Signed-off-by: Manu Abraham <manu@linuxtv.org>

 dvb_frontend.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--------------010606080508080007090302
Content-Type: text/x-patch;
 name="24.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="24.patch"

>From dacdc1e893068e7694a55fe140016bb6e56bc35f Mon Sep 17 00:00:00 2001
From: Manu Abraham <manu@linuxtv.org>
Date: Thu, 4 Sep 2008 14:33:07 +0200
Subject: [PATCH] DVB fix broken DVB-T backward compatibility

due to a missing break DVB-T backward compatibility was
broken all the way. The patch fixes the same.

From: Reinhard Nissl <rnissl@gmx.de>
Signed-off-by: Reinhard Nissl <rnissl@gmx.de>
Signed-off-by: Manu Abraham <manu@linuxtv.org>

diff --git a/drivers/media/dvb/dvb-core/dvb_frontend.c b/drivers/media/dvb/dvb-core/dvb_frontend.c
index 7311f0c..c54b12c 100644
--- a/drivers/media/dvb/dvb-core/dvb_frontend.c
+++ b/drivers/media/dvb/dvb-core/dvb_frontend.c
@@ -407,7 +407,7 @@ int newapi_to_olddrv(struct dvbfe_params *params,
 			ofdm->transmission_mode = TRANSMISSION_MODE_AUTO;
 			break;
 		default:
-			dprintk("%s: Unsupported transmission mode %x\n", __func__, dvbt->bandwidth);
+			dprintk("%s: Unsupported transmission mode %x\n", __func__, dvbt->transmission_mode);
 			return -EINVAL;
 		}
 		switch (dvbt->guard_interval) {
@@ -448,6 +448,7 @@ int newapi_to_olddrv(struct dvbfe_params *params,
 			}
 			break;
 		}
+		break;
 	case DVBFE_DELSYS_ATSC:
 		newmod_to_oldmod(atsc->modulation, &vsb->modulation);
 		break;

--------------010606080508080007090302--
