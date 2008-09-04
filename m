Return-Path: <linux-kernel-owner+w=401wt.eu-S1757111AbYIDSqj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757111AbYIDSqj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2008 14:46:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758278AbYIDSlj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Sep 2008 14:41:39 -0400
Received: from mail.work.de ([212.12.32.20]:42225 "EHLO mail.work.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757696AbYIDSli (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2008 14:41:38 -0400
Message-ID: <48C02BDE.6020403@gmail.com>
Date: Thu, 04 Sep 2008 22:41:34 +0400
From: Manu Abraham <abraham.manu@gmail.com>
User-Agent: Thunderbird 1.5.0.14ubu (X11/20080306)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, v4l-dvb-maintainer@linuxtv.org,
       akpm@linux-foundation.org
CC: o.endriss@gmx.de
Subject: DVB Update [PATCH 23/31] multiproto tree
X-Enigmail-Version: 0.94.0.0
Content-Type: multipart/mixed;
 boundary="------------080805040306070103010409"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------080805040306070103010409
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

>From cb2ad43c376d891438ee5a963f574f0f0166100e Mon Sep 17 00:00:00 2001
From: Manu Abraham <manu@linuxtv.org>
Date: Thu, 4 Sep 2008 14:27:55 +0200
Subject: [PATCH] DVB Code review fix broken use get_frontend_algo

Code review #3 In legacy drivers, where get_frontend_algo is NULL,
dvb_frontend_swzigzag_update_delay won't be called.

Thanks to Oliver Endriss <o.endriss@gmx.de> for the code review

From: Manu Abraham <abraham.manu@gmail.com>
Signed-off-by: Manu Abraham <manu@linuxtv.org>

 dvb_frontend.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--------------080805040306070103010409
Content-Type: text/x-patch;
 name="23.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="23.patch"

>From cb2ad43c376d891438ee5a963f574f0f0166100e Mon Sep 17 00:00:00 2001
From: Manu Abraham <manu@linuxtv.org>
Date: Thu, 4 Sep 2008 14:27:55 +0200
Subject: [PATCH] DVB Code review fix broken use get_frontend_algo

Code review #3 In legacy drivers, where get_frontend_algo is NULL,
dvb_frontend_swzigzag_update_delay won't be called.

Thanks to Oliver Endriss <o.endriss@gmx.de> for the code review

From: Manu Abraham <abraham.manu@gmail.com>
Signed-off-by: Manu Abraham <manu@linuxtv.org>

diff --git a/drivers/media/dvb/dvb-core/dvb_frontend.c b/drivers/media/dvb/dvb-core/dvb_frontend.c
index 24ae622..7311f0c 100644
--- a/drivers/media/dvb/dvb-core/dvb_frontend.c
+++ b/drivers/media/dvb/dvb-core/dvb_frontend.c
@@ -995,11 +995,11 @@ static void dvb_frontend_swzigzag(struct dvb_frontend *fe)
 	 */
 	/* Legacy	*/
 	if (fe->legacy) {
-		if ((fepriv->state & FESTATE_LOSTLOCK) && (fepriv->max_drift == 0)) {
-			if (fe->ops.get_frontend_algo)
-				if (fe->ops.get_frontend_algo(fe) == DVBFE_ALGO_RECOVERY)
-					dvb_frontend_swzigzag_update_delay(fepriv, s & FE_HAS_LOCK);
+		if ((fepriv->state & FESTATE_LOSTLOCK) &&
+		    (fe->ops.info.caps & FE_CAN_RECOVER) &&
+		    (fepriv->max_drift == 0)) {
 
+			dvb_frontend_swzigzag_update_delay(fepriv, s & FE_HAS_LOCK);
 			return 0;
 		}
 	} else {

--------------080805040306070103010409--
