Return-Path: <linux-kernel-owner+w=401wt.eu-S1763264AbZLQBuM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763264AbZLQBuM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 20:50:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936129AbZLQBtT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 20:49:19 -0500
Received: from kroah.org ([198.145.64.141]:47761 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763559AbZLQBTt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 20:19:49 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Wed Dec 16 17:15:58 2009
Message-Id: <20091217011558.748938366@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Wed, 16 Dec 2009 17:14:18 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       jirislaby@gmail.com, rjw@sisk.pl, me@bobcopeland.com,
       david.quan@atheros.com, "Luis R. Rodriguez" <lrodriguez@atheros.com>,
       "John W. Linville" <linville@tuxdriver.com>
Subject: [07/90] ath5k: enable EEPROM checksum check
In-Reply-To: <20091217011835.GA20434@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Luis R. Rodriguez <lrodriguez@atheros.com>

commit 512414b0bed0d376ac4d5ec1dd6f0b1a3551febc upstream.

Without this we have no gaurantee of the integrity of the
EEPROM and are likely to encounter a lot of bogus bug reports
due to actual issues on the EEPROM. With the EEPROM checksum
check in place we can easily rule those issues out.

If you run patch during a revert *you* have a card with a busted
EEPROM and only older kernel will support that concoction. This
patch is a trade off between not accepitng bogus EEPROMs and
avoiding bogus bug reports allowing developers to focus instead
on real concrete issues.

If stable keeps bogus bug reports because of a possibly busted EEPROM
feel free to apply this there too.

Tested on an AR5414

Cc: jirislaby@gmail.com
Cc: akpm@linux-foundation.org
Cc: rjw@sisk.pl
Cc: me@bobcopeland.com
Cc: david.quan@atheros.com
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/wireless/ath/ath5k/eeprom.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/net/wireless/ath/ath5k/eeprom.c
+++ b/drivers/net/wireless/ath/ath5k/eeprom.c
@@ -97,6 +97,7 @@ ath5k_eeprom_init_header(struct ath5k_hw
 	struct ath5k_eeprom_info *ee = &ah->ah_capabilities.cap_eeprom;
 	int ret;
 	u16 val;
+	u32 cksum, offset;
 
 	/*
 	 * Read values from EEPROM and store them in the capability structure
@@ -111,7 +112,6 @@ ath5k_eeprom_init_header(struct ath5k_hw
 	if (ah->ah_ee_version < AR5K_EEPROM_VERSION_3_0)
 		return 0;
 
-#ifdef notyet
 	/*
 	 * Validate the checksum of the EEPROM date. There are some
 	 * devices with invalid EEPROMs.
@@ -124,7 +124,6 @@ ath5k_eeprom_init_header(struct ath5k_hw
 		ATH5K_ERR(ah->ah_sc, "Invalid EEPROM checksum 0x%04x\n", cksum);
 		return -EIO;
 	}
-#endif
 
 	AR5K_EEPROM_READ_HDR(AR5K_EEPROM_ANT_GAIN(ah->ah_ee_version),
 	    ee_ant_gain);


