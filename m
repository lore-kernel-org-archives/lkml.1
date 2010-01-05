Return-Path: <linux-kernel-owner+w=401wt.eu-S1754998Ab0AEAqi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754998Ab0AEAqi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jan 2010 19:46:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754964Ab0AEAq3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jan 2010 19:46:29 -0500
Received: from kroah.org ([198.145.64.141]:34391 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754359Ab0AEAfe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jan 2010 19:35:34 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk,
       Vasanthakumar Thiagarajan <vasanth@atheros.com>,
       "John W. Linville" <linville@tuxdriver.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 52/97] ath9k_hw: Fix AR_GPIO_INPUT_EN_VAL_BT_PRIORITY_BB and its shift value in 0x4054
Date: Mon,  4 Jan 2010 16:33:05 -0800
Message-Id: <1262651630-7354-52-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.6
In-Reply-To: <20100105003133.GA7199@kroah.com>
References: <20100105003133.GA7199@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Vasanthakumar Thiagarajan <vasanth@atheros.com>

commit c37919bfe0a5c1bee9a31701a31e05a2f8840936 upstream.

The bit value of AR_GPIO_INPUT_EN_VAL_BT_PRIORITY_BB is wrong, it should
be 0x400 and the number of bits to be right shifted is 10. Having this
wrong value in 0x4054 sometimes affects bt quality on btcoex environment.

Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/net/wireless/ath/ath9k/reg.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/reg.h b/drivers/net/wireless/ath/ath9k/reg.h
index d83b77f..c0d7e65 100644
--- a/drivers/net/wireless/ath/ath9k/reg.h
+++ b/drivers/net/wireless/ath/ath9k/reg.h
@@ -969,10 +969,10 @@ enum {
 #define AR_GPIO_INPUT_EN_VAL_BT_ACTIVE_S         4
 #define AR_GPIO_INPUT_EN_VAL_RFSILENT_DEF        0x00000080
 #define AR_GPIO_INPUT_EN_VAL_RFSILENT_DEF_S      7
+#define AR_GPIO_INPUT_EN_VAL_BT_PRIORITY_BB      0x00000400
+#define AR_GPIO_INPUT_EN_VAL_BT_PRIORITY_BB_S    10
 #define AR_GPIO_INPUT_EN_VAL_BT_ACTIVE_BB        0x00001000
 #define AR_GPIO_INPUT_EN_VAL_BT_ACTIVE_BB_S      12
-#define AR_GPIO_INPUT_EN_VAL_BT_PRIORITY_BB      0x00001000
-#define AR_GPIO_INPUT_EN_VAL_BT_PRIORITY_BB_S    1
 #define AR_GPIO_INPUT_EN_VAL_RFSILENT_BB         0x00008000
 #define AR_GPIO_INPUT_EN_VAL_RFSILENT_BB_S       15
 #define AR_GPIO_RTC_RESET_OVERRIDE_ENABLE        0x00010000
-- 
1.6.6

