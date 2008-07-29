Return-Path: <linux-kernel-owner+w=401wt.eu-S1756492AbYG2F6y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756492AbYG2F6y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 01:58:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753895AbYG2F6p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 01:58:45 -0400
Received: from serv2.oss.ntt.co.jp ([222.151.198.100]:55050 "EHLO
	serv2.oss.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753810AbYG2F6p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 01:58:45 -0400
Subject: [PATCH] iwlwifi: fix iwl-led compile issue when
	CONFIG_IWLWIFI_DEBUG is not set
From: Fernando Luis =?ISO-8859-1?Q?V=E1zquez?= Cao 
	<fernando@oss.ntt.co.jp>
To: yi.zhu@intel.com, reinette.chatre@intel.com
Cc: ipw3945-devel@lists.sourceforge.net, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Content-Type: text/plain
Organization: NTT Open Source Software Center
Date: Tue, 29 Jul 2008 14:58:42 +0900
Message-Id: <1217311122.3087.55.camel@sebastian.kern.oss.ntt.co.jp>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix compile error when CONFIG_IWLWIFI_DEBUG not defined.

Signed-off-by: Fernando Luis Vazquez Cao <fernando@oss.ntt.co.jp>
---

--- linux-2.6.27-rc1/drivers/net/wireless/iwlwifi/iwl-led.c	2008-07-29 13:51:26.000000000 +0900
+++ linux-2.6.27-rc1-iocontext/drivers/net/wireless/iwlwifi/iwl-led.c	2008-07-29 14:47:13.000000000 +0900
@@ -194,9 +194,10 @@ static void iwl_led_brightness_set(struc
 	if (test_bit(STATUS_EXIT_PENDING, &priv->status))
 		return;
 
-
+#ifdef CONFIG_IWLWIFI_DEBUG
 	IWL_DEBUG_LED("Led type = %s brightness = %d\n",
 			led_type_str[led->type], brightness);
+#endif /* CONFIG_IWLWIFI_DEBUG */
 	switch (brightness) {
 	case LED_FULL:
 		if (led->type == IWL_LED_TRG_ASSOC)


