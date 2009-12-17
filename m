Return-Path: <linux-kernel-owner+w=401wt.eu-S936420AbZLQESy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936420AbZLQESy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 23:18:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936132AbZLQEFW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 23:05:22 -0500
Received: from kroah.org ([198.145.64.141]:55885 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935547AbZLQEFS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 23:05:18 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Wed Dec 16 19:56:58 2009
Message-Id: <20091217035658.141592007@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Wed, 16 Dec 2009 19:56:54 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, greg@kroah.com
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       linux-wireless@vger.kernel.org, Sujith <Sujith.Manoharan@atheros.com>,
       "Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [117/151] ath9k: Fix TX hang poll routine
In-Reply-To: <20091217040208.GA26571@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------


From: Sujith <Sujith.Manoharan@atheros.com>

This is a backport of upstream commit: 332c556633b8c5fb4e890b1783122f2315526590

When TX is hung, the chip is reset. Ensure that
the chip is awake by using the PS wrappers.


Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/wireless/ath/ath9k/xmit.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -2065,7 +2065,9 @@ static void ath_tx_complete_poll_work(st
 
 	if (needreset) {
 		DPRINTF(sc, ATH_DBG_RESET, "tx hung, resetting the chip\n");
+		ath9k_ps_wakeup(sc);
 		ath_reset(sc, false);
+		ath9k_ps_restore(sc);
 	}
 
 	ieee80211_queue_delayed_work(sc->hw, &sc->tx_complete_work,


