Return-Path: <linux-kernel-owner+w=401wt.eu-S1755569AbYIDUZO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755569AbYIDUZO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2008 16:25:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753614AbYIDUYD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Sep 2008 16:24:03 -0400
Received: from mail.work.de ([212.12.32.20]:34082 "EHLO mail.work.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757133AbYIDUYB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2008 16:24:01 -0400
Message-ID: <48C043DC.5090508@gmail.com>
Date: Fri, 05 Sep 2008 00:23:56 +0400
From: Manu Abraham <abraham.manu@gmail.com>
User-Agent: Thunderbird 1.5.0.14ubu (X11/20080306)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, v4l-dvb-maintainer@linuxtv.org,
       akpm@linux-foundation.org
Subject: DVB Update [PATCH 6/31] add delay to track
X-Enigmail-Version: 0.94.0.0
Content-Type: multipart/mixed;
 boundary="------------030307070907030905080304"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------030307070907030905080304
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

>From 0f40abb23ae691fa3badb89b5f25abc277df4b7d Mon Sep 17 00:00:00 2001
From: Manu Abraham <manu@linuxtv.org>
Date: Thu, 4 Sep 2008 12:23:22 +0200
Subject: [PATCH] DVB: Use a delay for tracking acquisition status

* A small delay would be required to reflect the changes in
tracking the status of the demodulator

From: Manu Abraham <abraham.manu@gmail.com>
Signed-off-by: Manu Abraham <manu@linuxtv.org>

 dvb_frontend.c |    2 +-
 dvb_frontend.h |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)



--------------030307070907030905080304
Content-Type: text/x-patch;
 name="6.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="6.patch"

>From 0f40abb23ae691fa3badb89b5f25abc277df4b7d Mon Sep 17 00:00:00 2001
From: Manu Abraham <manu@linuxtv.org>
Date: Thu, 4 Sep 2008 12:23:22 +0200
Subject: [PATCH] DVB: Use a delay for tracking acquisition status

* A small delay would be required to reflect the changes in
tracking the status of the demodulator

From: Manu Abraham <abraham.manu@gmail.com>
Signed-off-by: Manu Abraham <manu@linuxtv.org>

diff --git a/drivers/media/dvb/dvb-core/dvb_frontend.c b/drivers/media/dvb/dvb-core/dvb_frontend.c
index feebac0..106bf2b 100644
--- a/drivers/media/dvb/dvb-core/dvb_frontend.c
+++ b/drivers/media/dvb/dvb-core/dvb_frontend.c
@@ -1230,7 +1230,7 @@ restart:
 					fepriv->status = s;
 					if (fe->ops.track) {
 						dprintk("%s: TRACK callback exists at 0x%p\n", __func__, fe->ops.track);
-						fe->ops.track(fe, fe_params);
+						fe->ops.track(fe, fe_params, &fepriv->delay);
 					}
 				}
 				break;
diff --git a/drivers/media/dvb/dvb-core/dvb_frontend.h b/drivers/media/dvb/dvb-core/dvb_frontend.h
index 84eb7d9..8066ff0 100644
--- a/drivers/media/dvb/dvb-core/dvb_frontend.h
+++ b/drivers/media/dvb/dvb-core/dvb_frontend.h
@@ -301,7 +301,7 @@ struct dvb_frontend_ops {
 	 * tuning algorithms, rather than a simple swzigzag
 	 */
 	enum dvbfe_search (*search)(struct dvb_frontend *fe, struct dvbfe_params *fe_params);
-	int (*track)(struct dvb_frontend *fe, struct dvbfe_params *fe_params);
+	int (*track)(struct dvb_frontend *fe, struct dvbfe_params *fe_params, int *delay);
 
 	struct dvb_tuner_ops tuner_ops;
 	struct analog_demod_ops analog_ops;


--------------030307070907030905080304--
