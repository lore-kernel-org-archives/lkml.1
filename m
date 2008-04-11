Return-Path: <linux-kernel-owner+w=401wt.eu-S1761082AbYDKUhk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761082AbYDKUhk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2008 16:37:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759550AbYDKUh3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Apr 2008 16:37:29 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:43079 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759211AbYDKUh2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2008 16:37:28 -0400
X-Sasl-enc: MEXalaVMBMon3XUfu+cy1Vjk//EB/Yj5mgIxDJsVAYJR 1207946247
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: linux-kernel@vger.kernel.org
Cc: Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
       Ivo van Doorn <IvDoorn@gmail.com>,
       "John W. Linville" <linville@tuxdriver.com>,
       Dmitry Torokhov <dtor@mail.ru>
Subject: [PATCH 1/8] rfkill: clarify meaning of rfkill states
Date: Fri, 11 Apr 2008 17:37:17 -0300
Message-Id: <1207946244-14525-2-git-send-email-hmh@hmh.eng.br>
X-Mailer: git-send-email 1.5.4.4
In-Reply-To: <1207946244-14525-1-git-send-email-hmh@hmh.eng.br>
References: <1207946244-14525-1-git-send-email-hmh@hmh.eng.br>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

rfkill really should have been named rfswitch.  As it is, one can get
confused whether RFKILL_STATE_ON means the KILL switch is on (and
therefore, the radio is being *blocked* from operating), or whether it
means the RADIO rf output is on.

Clearly state that RFKILL_STATE_ON means the radio is *unblocked* from
operating (i.e. there is no rf killing going on).

Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: Ivo van Doorn <IvDoorn@gmail.com>
Cc: John W. Linville <linville@tuxdriver.com>
Cc: Dmitry Torokhov <dtor@mail.ru>
---
 include/linux/rfkill.h |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/include/linux/rfkill.h b/include/linux/rfkill.h
index e3ab21d..ca89ae1 100644
--- a/include/linux/rfkill.h
+++ b/include/linux/rfkill.h
@@ -44,8 +44,8 @@ enum rfkill_type {
 };
 
 enum rfkill_state {
-	RFKILL_STATE_OFF	= 0,
-	RFKILL_STATE_ON		= 1,
+	RFKILL_STATE_OFF	= 0,	/* Radio output blocked */
+	RFKILL_STATE_ON		= 1,	/* Radio output active */
 };
 
 /**
@@ -53,7 +53,7 @@ enum rfkill_state {
  * @name: Name of the switch.
  * @type: Radio type which the button controls, the value stored
  *	here should be a value from enum rfkill_type.
- * @state: State of the switch (on/off).
+ * @state: State of the switch, "ON" means radio can operate.
  * @user_claim_unsupported: Whether the hardware supports exclusive
  *	RF-kill control by userspace. Set this before registering.
  * @user_claim: Set when the switch is controlled exlusively by userspace.
-- 
1.5.4.4

