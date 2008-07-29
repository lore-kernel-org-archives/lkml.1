Return-Path: <linux-kernel-owner+w=401wt.eu-S1755824AbYG2Hs0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755824AbYG2Hs0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 03:48:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753116AbYG2HsQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 03:48:16 -0400
Received: from serv2.oss.ntt.co.jp ([222.151.198.100]:59131 "EHLO
	serv2.oss.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753005AbYG2HsQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 03:48:16 -0400
Subject: Re: linux-next: Tree for July 29
From: Fernando Luis =?ISO-8859-1?Q?V=E1zquez?= Cao 
	<fernando@oss.ntt.co.jp>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20080729172337.b3d74100.sfr@canb.auug.org.au>
References: <20080729172337.b3d74100.sfr@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Organization: NTT Open Source Software Center
Date: Tue, 29 Jul 2008 16:48:14 +0900
Message-Id: <1217317694.11957.12.camel@sebastian.kern.oss.ntt.co.jp>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch below gets rid of a compile error that would be nice to get
fixed in Linus' tree.

-------- Forwarded Message --------
From: Fernando Luis Vázquez Cao <fernando@oss.ntt.co.jp>
To: yi.zhu@intel.com, reinette.chatre@intel.com
Cc: ipw3945-devel@lists.sourceforge.net, akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: [PATCH] iwlwifi: fix iwl-led compile issue when CONFIG_IWLWIFI_DEBUG is not set
Date: 	Tue, 29 Jul 2008 14:58:42 +0900

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


--
To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
Please read the FAQ at  http://www.tux.org/lkml/

