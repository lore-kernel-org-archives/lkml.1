Return-Path: <linux-kernel-owner+w=401wt.eu-S1757592AbYGUIh1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757592AbYGUIh1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2008 04:37:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754325AbYGUIhN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jul 2008 04:37:13 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:32894 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753979AbYGUIhL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2008 04:37:11 -0400
Date: Mon, 21 Jul 2008 10:36:54 +0200
From: Ingo Molnar <mingo@elte.hu>
To: David Miller <davem@davemloft.net>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       Tomas Winkler <tomas.winkler@intel.com>,
       "John W. Linville" <linville@tuxdriver.com>
Subject: iwlwifi: fix build bug in "iwlwifi: fix LED stall"
Message-ID: <20080721083654.GA19849@elte.hu>
References: <20080720.104411.81744468.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20080720.104411.81744468.davem@davemloft.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


hi David,

>       iwlwifi: fix LED stall

please find a small build fix below.

	Ingo

-------------->
commit c61b0199e779caf2dcfdb6e83439c1fdf9f20209
Author: Ingo Molnar <mingo@elte.hu>
Date:   Mon Jul 21 10:33:42 2008 +0200

    iwlwifi: fix build bug in "iwlwifi: fix LED stall"
    
    -tip testing found the following build failure:
    
      drivers/net/wireless/iwlwifi/iwl-led.c: In function ‘iwl_led_brightness_set’:
      drivers/net/wireless/iwlwifi/iwl-led.c:198: error: ‘led_type_str’ undeclared (first use in this function)
      drivers/net/wireless/iwlwifi/iwl-led.c:198: error: (Each undeclared identifier is reported only once
      drivers/net/wireless/iwlwifi/iwl-led.c:198: error: for each function it appears in.)
    
    Triggered if this driver is built with !CONFIG_IWLWIFI_DEBUG. Introduced
    by commit 0eee61273.
    
    The best fix is to make led_type_str available as a zero-size symbol and to
    only add members to the array if CONFIG_IWLWIFI_DEBUG is set. This way
    there's no overhead in the debugging case and we have type checking in the
    IWL_DEBUG_LED() macro as well.
    
    Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 drivers/net/wireless/iwlwifi/iwl-led.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-led.c b/drivers/net/wireless/iwlwifi/iwl-led.c
index 899d7a2..d7129f7 100644
--- a/drivers/net/wireless/iwlwifi/iwl-led.c
+++ b/drivers/net/wireless/iwlwifi/iwl-led.c
@@ -44,15 +44,15 @@
 #include "iwl-io.h"
 #include "iwl-helpers.h"
 
-#ifdef CONFIG_IWLWIFI_DEBUG
 static const char *led_type_str[] = {
+#ifdef CONFIG_IWLWIFI_DEBUG
 	__stringify(IWL_LED_TRG_TX),
 	__stringify(IWL_LED_TRG_RX),
 	__stringify(IWL_LED_TRG_ASSOC),
 	__stringify(IWL_LED_TRG_RADIO),
 	NULL
-};
 #endif /* CONFIG_IWLWIFI_DEBUG */
+};
 
 
 static const struct {
