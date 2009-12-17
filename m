Return-Path: <linux-kernel-owner+w=401wt.eu-S936744AbZLQEpv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936744AbZLQEpv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 23:45:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936713AbZLQEo5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 23:44:57 -0500
Received: from kroah.org ([198.145.64.141]:55324 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763311AbZLQEDu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 23:03:50 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Wed Dec 16 19:56:46 2009
Message-Id: <20091217035646.060484400@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Wed, 16 Dec 2009 19:55:21 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Bob Copeland <me@bobcopeland.com>,
       "John W. Linville" <linville@tuxdriver.com>
Subject: [024/151] ath5k: allow setting txpower to 0
In-Reply-To: <20091217040208.GA26571@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Bob Copeland <me@bobcopeland.com>

commit 2eb2fa67e5462a36e98172fb92c78bc405b3035f upstream.

As a holdover from earlier code when we used to set
the power limit to '0' after a reset to configure the
default transmit power, ath5k interprets txpower=0 as
12.5 dBm.  Fix that by just passing 0 through.

This fixes http://bugzilla.kernel.org/show_bug.cgi?id=14567

Reported-by: Daniel Folkers <daniel.folkers@task24.nl>
Tested-by: Daniel Folkers <daniel.folkers@task24.nl>
Signed-off-by: Bob Copeland <me@bobcopeland.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/wireless/ath/ath5k/phy.c |    2 --
 1 file changed, 2 deletions(-)

--- a/drivers/net/wireless/ath/ath5k/phy.c
+++ b/drivers/net/wireless/ath/ath5k/phy.c
@@ -2954,8 +2954,6 @@ ath5k_hw_txpower(struct ath5k_hw *ah, st
 		ATH5K_ERR(ah->ah_sc, "invalid tx power: %u\n", txpower);
 		return -EINVAL;
 	}
-	if (txpower == 0)
-		txpower = AR5K_TUNE_DEFAULT_TXPOWER;
 
 	/* Reset TX power values */
 	memset(&ah->ah_txpower, 0, sizeof(ah->ah_txpower));


