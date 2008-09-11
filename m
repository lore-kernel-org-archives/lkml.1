Return-Path: <linux-kernel-owner+w=401wt.eu-S1755265AbYIKMdm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755265AbYIKMdm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2008 08:33:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754984AbYIKMda
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Sep 2008 08:33:30 -0400
Received: from mgw1.diku.dk ([130.225.96.91]:58128 "EHLO mgw1.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754955AbYIKMd3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2008 08:33:29 -0400
Date: Thu, 11 Sep 2008 14:33:26 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: mchehab@infradead.org, v4l-dvb-maintainer@linuxtv.org,
       video4linux-list@redhat.com, vigneshbabu@gmail.com,
       richard.genoud@gmail.com, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: [PATCH 2/5] drivers/media/common/tuners: Drop code after return or
 goto
Message-ID: <Pine.LNX.4.64.0809111433020.9593@pc-004.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

The break after the return or goto serves no purpose.

Signed-off-by: Julia Lawall <julia@diku.dk>
---
 drivers/media/common/tuners/mxl5007t.c     |    1 -
 drivers/media/common/tuners/tda18271-fe.c  |    1 -
 drivers/media/common/tuners/tda9887.c      |    1 -
 drivers/media/common/tuners/tuner-simple.c |    1 -
 4 files changed, 4 deletions(-)

diff -u -p a/drivers/media/common/tuners/tuner-simple.c b/drivers/media/common/tuners/tuner-simple.c
--- a/drivers/media/common/tuners/tuner-simple.c
+++ b/drivers/media/common/tuners/tuner-simple.c
@@ -1038,7 +1038,6 @@ struct dvb_frontend *simple_tuner_attach
 	case 0:
 		mutex_unlock(&tuner_simple_list_mutex);
 		return NULL;
-		break;
 	case 1:
 		fe->tuner_priv = priv;
 
diff -u -p a/drivers/media/common/tuners/tda18271-fe.c b/drivers/media/common/tuners/tda18271-fe.c
--- a/drivers/media/common/tuners/tda18271-fe.c
+++ b/drivers/media/common/tuners/tda18271-fe.c
@@ -1155,7 +1155,6 @@ struct dvb_frontend *tda18271_attach(str
 	switch (instance) {
 	case 0:
 		goto fail;
-		break;
 	case 1:
 		/* new tuner instance */
 		priv->gate = (cfg) ? cfg->gate : TDA18271_GATE_AUTO;
diff -u -p a/drivers/media/common/tuners/mxl5007t.c b/drivers/media/common/tuners/mxl5007t.c
--- a/drivers/media/common/tuners/mxl5007t.c
+++ b/drivers/media/common/tuners/mxl5007t.c
@@ -979,7 +979,6 @@ struct dvb_frontend *mxl5007t_attach(str
 	switch (instance) {
 	case 0:
 		goto fail;
-		break;
 	case 1:
 		/* new tuner instance */
 		state->config = cfg;
diff -u -p a/drivers/media/common/tuners/tda9887.c b/drivers/media/common/tuners/tda9887.c
--- a/drivers/media/common/tuners/tda9887.c
+++ b/drivers/media/common/tuners/tda9887.c
@@ -686,7 +686,6 @@ struct dvb_frontend *tda9887_attach(stru
 	case 0:
 		mutex_unlock(&tda9887_list_mutex);
 		return NULL;
-		break;
 	case 1:
 		fe->analog_demod_priv = priv;
 		priv->mode = T_STANDBY;
