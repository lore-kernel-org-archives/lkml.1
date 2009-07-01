Return-Path: <linux-kernel-owner+w=401wt.eu-S1759368AbZGABGZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759368AbZGABGZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 21:06:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761527AbZGAAfR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 20:35:17 -0400
Received: from kroah.org ([198.145.64.141]:60524 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761496AbZGAAfL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 20:35:11 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Tue Jun 30 17:24:35 2009
Message-Id: <20090701002434.723163004@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Tue, 30 Jun 2009 17:23:58 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Sujith <Sujith.Manoharan@atheros.com>,
       "John W. Linville" <linville@tuxdriver.com>
Subject: [patch 069/108] ath9k: Fix bug in determining calibration support
References: <20090701002249.937782934@mini.kroah.org>
Content-Disposition: inline; filename=ath9k-fix-bug-in-determining-calibration-support.patch
In-Reply-To: <20090701002838.GA7100@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.30-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Sujith <Sujith.Manoharan@atheros.com>

commit a451aa66dcb14efcb7addf1d8edcac8df76a97b6 upstream.

ADC gain calibration has to be done for all non 2GHZ-HT20 channels.
Regression from "ath9k: use ieee80211_conf on ath9k_hw_iscal_supported()"

Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/wireless/ath9k/calib.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/net/wireless/ath9k/calib.c
+++ b/drivers/net/wireless/ath9k/calib.c
@@ -284,8 +284,8 @@ static bool ath9k_hw_iscal_supported(str
 		return true;
 	case ADC_GAIN_CAL:
 	case ADC_DC_CAL:
-		if (conf->channel->band == IEEE80211_BAND_5GHZ &&
-		  conf_is_ht20(conf))
+		if (!(conf->channel->band == IEEE80211_BAND_2GHZ &&
+		      conf_is_ht20(conf)))
 			return true;
 		break;
 	}


