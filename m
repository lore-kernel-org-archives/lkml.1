Return-Path: <linux-kernel-owner+w=401wt.eu-S1762701AbYJJR5j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762701AbYJJR5j (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2008 13:57:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759763AbYJJR52
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Oct 2008 13:57:28 -0400
Received: from smtp.wellnetcz.com ([212.24.148.102]:50183 "EHLO
	smtp.wellnetcz.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759233AbYJJR51 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2008 13:57:27 -0400
From: Jiri Slaby <jirislaby@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
       Jiri Slaby <jirislaby@gmail.com>,
       "Luis R. Rodriguez" <lrodriguez@atheros.com>,
       Jouni Malinen <jmalinen@atheros.com>
Subject: [PATCH 1/1] Ath9k: fix uninitialized value in ath9k_hw_reset
Date: Fri, 10 Oct 2008 19:56:43 +0200
Message-Id: <1223661403-21803-1-git-send-email-jirislaby@gmail.com>
X-Mailer: git-send-email 1.6.0.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

status ath9k_hw_reset() parameter should be set in every case, since
it is used in callers to find out an error code.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Cc: Luis R. Rodriguez <lrodriguez@atheros.com>
Cc: Jouni Malinen <jmalinen@atheros.com>
---
 drivers/net/wireless/ath9k/hw.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath9k/hw.c b/drivers/net/wireless/ath9k/hw.c
index 62e44a0..fb6727b 100644
--- a/drivers/net/wireless/ath9k/hw.c
+++ b/drivers/net/wireless/ath9k/hw.c
@@ -5893,7 +5893,7 @@ bool ath9k_hw_reset(struct ath_hal *ah,
 	}
 
 	if (!ath9k_hw_setpower(ah, ATH9K_PM_AWAKE))
-		return false;
+		FAIL(-EIO);
 
 	if (curchan)
 		ath9k_hw_getnf(ah, curchan);
-- 
1.6.0.2

