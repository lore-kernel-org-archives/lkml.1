Return-Path: <linux-kernel-owner+w=401wt.eu-S1754036AbYGUMNa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754036AbYGUMNa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2008 08:13:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752430AbYGUMMm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jul 2008 08:12:42 -0400
Received: from mga02.intel.com ([134.134.136.20]:14728 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750760AbYGUMMi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2008 08:12:38 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.31,223,1215414000"; 
   d="scan'208";a="419942151"
From: Tomas Winkler <tomas.winkler@intel.com>
To: mingo@elte.hu
Cc: davem@davemloft.net, linville@tuxdriver.com, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, "Denis V. Lunev" <den@openvz.org>
Subject: [PATCH] iwlwifi: compilation error when CONFIG_IWLWIFI_DEBUG is not set
Date: Mon, 21 Jul 2008 15:12:28 +0300
Message-Id: <1216642348-26826-3-git-send-email-tomas.winkler@intel.com>
X-Mailer: git-send-email 1.5.4.1
In-Reply-To: <1216642348-26826-2-git-send-email-tomas.winkler@intel.com>
References: <20080721083654.GA19849@elte.hu>
 <1216642348-26826-1-git-send-email-tomas.winkler@intel.com>
 <1216642348-26826-2-git-send-email-tomas.winkler@intel.com>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Denis V. Lunev <den@openvz.org>

CC [M]  drivers/net/wireless/iwlwifi/iwl-rfkill.o
drivers/net/wireless/iwlwifi/iwl-led.c: In function 'iwl_led_brightness_set':
drivers/net/wireless/iwlwifi/iwl-led.c:198: error: 'led_type_str' undeclared (first use in this function)
drivers/net/wireless/iwlwifi/iwl-led.c:198: error: (Each undeclared identifier is reported only once
drivers/net/wireless/iwlwifi/iwl-led.c:198: error: for each function it appears in.)

The problem is that led_type_str is defined under CONFIG_IWLWIFI_DEBUG
while IWL_DEBUG is a static inline function in this case. Replace it
with macro.

Signed-off-by: Denis V. Lunev <den@openvz.org>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-debug.h |    8 ++------
 1 files changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-debug.h b/drivers/net/wireless/iwlwifi/iwl-debug.h
index 097a72f..b4ffd33 100644
--- a/drivers/net/wireless/iwlwifi/iwl-debug.h
+++ b/drivers/net/wireless/iwlwifi/iwl-debug.h
@@ -68,12 +68,8 @@ void iwl_dbgfs_unregister(struct iwl_priv *priv);
 #endif
 
 #else
-static inline void IWL_DEBUG(int level, const char *fmt, ...)
-{
-}
-static inline void IWL_DEBUG_LIMIT(int level, const char *fmt, ...)
-{
-}
+#define IWL_DEBUG(level, fmt, args...)
+#define IWL_DEBUG_LIMIT(level, fmt, args...)
 #endif				/* CONFIG_IWLWIFI_DEBUG */
 
 
-- 
1.5.4.1

---------------------------------------------------------------------
Intel Israel (74) Limited

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.

