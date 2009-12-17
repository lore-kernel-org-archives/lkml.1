Return-Path: <linux-kernel-owner+w=401wt.eu-S1763560AbZLQBud@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763560AbZLQBud (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 20:50:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936134AbZLQBtW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 20:49:22 -0500
Received: from kroah.org ([198.145.64.141]:47755 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763537AbZLQBTs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 20:19:48 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Wed Dec 16 17:15:58 2009
Message-Id: <20091217011558.635603496@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Wed, 16 Dec 2009 17:14:17 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Bob Copeland <me@bobcopeland.com>,
       "John W. Linville" <linville@tuxdriver.com>
Subject: [06/90] ath5k: allow setting txpower to 0
In-Reply-To: <20091217011835.GA20434@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

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
@@ -2931,8 +2931,6 @@ ath5k_hw_txpower(struct ath5k_hw *ah, st
 		ATH5K_ERR(ah->ah_sc, "invalid tx power: %u\n", txpower);
 		return -EINVAL;
 	}
-	if (txpower == 0)
-		txpower = AR5K_TUNE_DEFAULT_TXPOWER;
 
 	/* Reset TX power values */
 	memset(&ah->ah_txpower, 0, sizeof(ah->ah_txpower));


