Return-Path: <linux-kernel-owner+w=401wt.eu-S1756988AbYIDSpP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756988AbYIDSpP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2008 14:45:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757489AbYIDSkt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Sep 2008 14:40:49 -0400
Received: from mail.work.de ([212.12.32.20]:42200 "EHLO mail.work.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758081AbYIDSks (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2008 14:40:48 -0400
Message-ID: <48C02BAA.2050002@gmail.com>
Date: Thu, 04 Sep 2008 22:40:42 +0400
From: Manu Abraham <abraham.manu@gmail.com>
User-Agent: Thunderbird 1.5.0.14ubu (X11/20080306)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, v4l-dvb-maintainer@linuxtv.org,
       akpm@linux-foundation.org
CC: o.endriss@gmx.de
Subject: DVB Update [PATCH 20/31] multiproto tree
X-Enigmail-Version: 0.94.0.0
Content-Type: multipart/mixed;
 boundary="------------010202050006020300030802"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------010202050006020300030802
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

>From f27d011f67d5e00ead196b0fcc2585537c2f2380 Mon Sep 17 00:00:00 2001
From: Manu Abraham <manu@linuxtv.org>
Date: Thu, 4 Sep 2008 14:18:08 +0200
Subject: [PATCH] DVB Code review: explicitly display offending parameters

Code review #1 Explicitly display the offending parameters,
while doing parameter conversion.

Thanks to Oliver Endriss <o.endriss@gmx.de> for the code review

From: Manu Abraham <abraham.manu@gmail.com>
Signed-off-by: Manu Abraham <manu@linuxtv.org>

 dvb_frontend.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)


--------------010202050006020300030802
Content-Type: text/x-patch;
 name="20.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="20.patch"

>From f27d011f67d5e00ead196b0fcc2585537c2f2380 Mon Sep 17 00:00:00 2001
From: Manu Abraham <manu@linuxtv.org>
Date: Thu, 4 Sep 2008 14:18:08 +0200
Subject: [PATCH] DVB Code review: explicitly display offending parameters

Code review #1 Explicitly display the offending parameters,
while doing parameter conversion.

Thanks to Oliver Endriss <o.endriss@gmx.de> for the code review

From: Manu Abraham <abraham.manu@gmail.com>
Signed-off-by: Manu Abraham <manu@linuxtv.org>

diff --git a/drivers/media/dvb/dvb-core/dvb_frontend.c b/drivers/media/dvb/dvb-core/dvb_frontend.c
index e6ae5e6..037199a 100644
--- a/drivers/media/dvb/dvb-core/dvb_frontend.c
+++ b/drivers/media/dvb/dvb-core/dvb_frontend.c
@@ -224,7 +224,7 @@ static int newfec_to_oldfec(enum dvbfe_fec new_fec, enum fe_code_rate *old_fec)
 		*old_fec = FEC_AUTO;
 		break;
 	default:
-		printk("%s: Unsupported FEC\n", __func__);
+		printk("%s: Unsupported FEC %x\n", __func__, new_fec);
 		return -EINVAL;
 	}
 
@@ -265,7 +265,7 @@ static int oldfec_to_newfec(enum fe_code_rate old_fec, enum dvbfe_fec *new_fec)
 		*new_fec = DVBFE_FEC_AUTO;
 		break;
 	default:
-		printk("%s: Unsupported FEC\n", __func__);
+		printk("%s: Unsupported FEC %x\n", __func__, old_fec);
 		return -EINVAL;
 	}
 
@@ -303,7 +303,7 @@ static int newmod_to_oldmod(enum dvbfe_modulation new_mod, enum fe_modulation *o
 		*old_mod = VSB_16;
 		break;
 	default:
-		printk("%s: Unsupported Modulation\n", __func__);
+		printk("%s: Unsupported Modulation %x\n", __func__, new_mod);
 		return -EINVAL;
 	}
 
@@ -341,7 +341,7 @@ static int oldmod_to_newmod(enum fe_modulation old_mod, enum dvbfe_modulation *n
 		*new_mod = DVBFE_MOD_VSB16;
 		break;
 	default:
-		printk("%s: Unsupported Modulation\n", __func__);
+		printk("%s: Unsupported Modulation %x\n", __func__, old_mod);
 		return -EINVAL;
 	}
 
@@ -390,7 +390,7 @@ int newapi_to_olddrv(struct dvbfe_params *params,
 			ofdm->bandwidth		= BANDWIDTH_AUTO;
 			break;
 		default:
-			dprintk("%s: Unsupported bandwidth\n", __func__);
+			dprintk("%s: Unsupported bandwidth %x\n", __func__, dvbt->bandwidth);
 			return -EINVAL;
 		}
 		newfec_to_oldfec(dvbt->code_rate_HP, &ofdm->code_rate_HP);
@@ -407,7 +407,7 @@ int newapi_to_olddrv(struct dvbfe_params *params,
 			ofdm->transmission_mode = TRANSMISSION_MODE_AUTO;
 			break;
 		default:
-			dprintk("%s: Unsupported transmission mode\n", __func__);
+			dprintk("%s: Unsupported transmission mode %x\n", __func__, dvbt->bandwidth);
 			return -EINVAL;
 		}
 		switch (dvbt->guard_interval) {
@@ -452,7 +452,7 @@ int newapi_to_olddrv(struct dvbfe_params *params,
 		newmod_to_oldmod(atsc->modulation, &vsb->modulation);
 		break;
 	default:
-		dprintk("%s: Unsupported delivery system\n", __func__);
+		dprintk("%s: Unsupported delivery system %x\n", __func__, delsys);
 		return -EINVAL;
 		break;
 	}
@@ -558,7 +558,7 @@ int olddrv_to_newapi(struct dvb_frontend *fe,
 		newmod_to_oldmod(atsc->modulation, &vsb->modulation);
 		break;
 	default:
-		dprintk("%s: Unsupported delivery system\n", __func__);
+		dprintk("%s: Unsupported delivery system %x\n", __func__, fe_type);
 		return -EINVAL;
 		break;
 	}

--------------010202050006020300030802--
