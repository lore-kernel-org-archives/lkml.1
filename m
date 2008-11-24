Return-Path: <linux-kernel-owner+w=401wt.eu-S1753248AbYKXMes@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753248AbYKXMes (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2008 07:34:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752239AbYKXMel
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Nov 2008 07:34:41 -0500
Received: from fmmailgate03.web.de ([217.72.192.234]:57194 "EHLO
	fmmailgate03.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752212AbYKXMek (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2008 07:34:40 -0500
From: Chr <chunkeey@web.de>
To: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] p54: fix wmm queue settings
Date: Mon, 24 Nov 2008 13:34:38 +0100
User-Agent: KMail/1.9.9
Cc: John W Linville <linville@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200811241334.38299.chunkeey@web.de>
X-Provags-ID: V01U2FsdGVkX185KyqeKA7pIctxmX7X96Ee1Ky5F41qalSt6Tha
	5r4XJgYgIdjxP7zNKVlnSp/MTn/GW4K2EAcsl2JuKWQ2lKOEui
	UpSgzUCmU=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes a regression (introduced by 453fae72b2f19
"p54: more definitions form lmac_longbow.h and pda.h" )

It turned out that the "ret" variable wasn't initialized and
this caused the following warnings/errors to appear:

wmaster1: failed to set TX queue parameters for queue 2
wmaster1: failed to set TX queue parameters for queue 3
wmaster1: failed to set TX queue parameters for queue 1
wmaster1: failed to set TX queue parameters for queue 0

Signed-off-by: Christian Lamparter <chunkeey@web.de>
---
diff -Nurp a/drivers/net/wireless/p54/p54common.c b/drivers/net/wireless/p54/p54common.c
--- a/drivers/net/wireless/p54/p54common.c	2008-11-24 00:01:27.899490373 +0100
+++ b/drivers/net/wireless/p54/p54common.c	2008-11-24 13:07:09.053832187 +0100
@@ -1729,10 +1729,9 @@ static int p54_conf_tx(struct ieee80211_
 	if ((params) && !(queue > 4)) {
 		P54_SET_QUEUE(priv->qos_params[queue], params->aifs,
 			params->cw_min, params->cw_max, params->txop);
+		ret = p54_set_edcf(dev);
 	} else
 		ret = -EINVAL;
-	if (!ret)
-		ret = p54_set_edcf(dev);
 	mutex_unlock(&priv->conf_mutex);
 	return ret;
 }
