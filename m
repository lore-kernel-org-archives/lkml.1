Return-Path: <linux-kernel-owner+w=401wt.eu-S1756161AbYDWUKo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756161AbYDWUKo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2008 16:10:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753928AbYDWUKd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Apr 2008 16:10:33 -0400
Received: from smtp-out3.tiscali.nl ([195.241.79.178]:58327 "EHLO
	smtp-out3.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751067AbYDWUKc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2008 16:10:32 -0400
Message-ID: <480F97B5.9030009@tiscali.nl>
Date: Wed, 23 Apr 2008 22:10:29 +0200
From: Roel Kluin <12o3l@tiscali.nl>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: jussi.kivilinna@mbnet.fi, linux-wireless@vger.kernel.org
CC: lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH] wireless: rndis_wlan: modparam_workaround_interval is never
 below 0.
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

priv->param_workaround_interval is unsigned, modparam_workaround_interval not.
the former is never < 0.

Signed-off-by: Roel Kluin <12o3l@tiscali.nl>
---
diff --git a/drivers/net/wireless/rndis_wlan.c b/drivers/net/wireless/rndis_wlan.c
index 977751f..d0b1fb1 100644
--- a/drivers/net/wireless/rndis_wlan.c
+++ b/drivers/net/wireless/rndis_wlan.c
@@ -2402,7 +2402,6 @@ static int bcm4320_early_init(struct usbnet *dev)
 	priv->param_power_output = modparam_power_output;
 	priv->param_roamtrigger  = modparam_roamtrigger;
 	priv->param_roamdelta    = modparam_roamdelta;
-	priv->param_workaround_interval = modparam_workaround_interval;
 
 	priv->param_country[0] = toupper(priv->param_country[0]);
 	priv->param_country[1] = toupper(priv->param_country[1]);
@@ -2425,8 +2424,10 @@ static int bcm4320_early_init(struct usbnet *dev)
 	else if (priv->param_roamdelta > 2)
 		priv->param_roamdelta = 2;
 
-	if (priv->param_workaround_interval < 0)
+	if (modparam_workaround_interval < 0)
 		priv->param_workaround_interval = 500;
+	else
+		priv->param_workaround_interval = modparam_workaround_interval;
 
 	rndis_set_config_parameter_str(dev, "Country", priv->param_country);
 	rndis_set_config_parameter_str(dev, "FrameBursting",
