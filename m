Return-Path: <linux-kernel-owner+w=401wt.eu-S1754100AbZDYMKV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754100AbZDYMKV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Apr 2009 08:10:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752631AbZDYMKF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Apr 2009 08:10:05 -0400
Received: from smtp.wellnetcz.com ([212.24.148.102]:35088 "EHLO
	smtp.wellnetcz.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752073AbZDYMKE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Apr 2009 08:10:04 -0400
From: Jiri Slaby <jirislaby@gmail.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
       Jiri Slaby <jirislaby@gmail.com>, Nick Kossifidis <mickflemm@gmail.com>,
       "Luis R. Rodriguez" <lrodriguez@atheros.com>,
       Bob Copeland <me@bobcopeland.com>
Subject: [PATCH 1/1] ath5k: 5211, don't crypt every protected frame
Date: Sat, 25 Apr 2009 14:09:23 +0200
Message-Id: <1240661363-16631-1-git-send-email-jirislaby@gmail.com>
X-Mailer: git-send-email 1.6.2.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi guys,
do you remember some 5211 HW which didn't work with this?
--

Set null key type even on ar5211, otherwise it en/decrypts every frame with
protected bit set which renders the card unusable on encrypted networks.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Cc: Nick Kossifidis <mickflemm@gmail.com>
Cc: Luis R. Rodriguez <lrodriguez@atheros.com>
Cc: Bob Copeland <me@bobcopeland.com>
---
 drivers/net/wireless/ath/ath5k/pcu.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/pcu.c b/drivers/net/wireless/ath/ath5k/pcu.c
index 55122f1..5f07e87 100644
--- a/drivers/net/wireless/ath/ath5k/pcu.c
+++ b/drivers/net/wireless/ath/ath5k/pcu.c
@@ -1003,7 +1003,7 @@ int ath5k_hw_reset_key(struct ath5k_hw *ah, u16 entry)
 	 * Note2: Windows driver (ndiswrapper) sets this to
 	 *        0x00000714 instead of 0x00000007
 	 */
-	if (ah->ah_version > AR5K_AR5211) {
+	if (ah->ah_version >= AR5K_AR5211) {
 		ath5k_hw_reg_write(ah, AR5K_KEYTABLE_TYPE_NULL,
 				AR5K_KEYTABLE_TYPE(entry));
 
-- 
1.6.2.4

