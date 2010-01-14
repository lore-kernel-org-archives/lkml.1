Return-Path: <linux-kernel-owner+w=401wt.eu-S1756574Ab0ANWcM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756574Ab0ANWcM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jan 2010 17:32:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757227Ab0ANWcB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jan 2010 17:32:01 -0500
Received: from kroah.org ([198.145.64.141]:60651 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756791Ab0ANW2x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jan 2010 17:28:53 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
       "Luis R. Rodriguez" <lrodriguez@atheros.com>,
       David Quan <david.quan@atheros.com>,
       Stephen Beahm <stephenbeahm@comcast.net>,
       "John W. Linville" <linville@tuxdriver.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 40/52] ath5k: Fix eeprom checksum check for custom sized eeproms
Date: Thu, 14 Jan 2010 14:27:19 -0800
Message-Id: <1263508051-7868-40-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.6
In-Reply-To: <1263508051-7868-39-git-send-email-gregkh@suse.de>
References: <20100114222551.GA7839@suse.de>
 <1263508051-7868-1-git-send-email-gregkh@suse.de>
 <1263508051-7868-2-git-send-email-gregkh@suse.de>
 <1263508051-7868-3-git-send-email-gregkh@suse.de>
 <1263508051-7868-4-git-send-email-gregkh@suse.de>
 <1263508051-7868-5-git-send-email-gregkh@suse.de>
 <1263508051-7868-6-git-send-email-gregkh@suse.de>
 <1263508051-7868-7-git-send-email-gregkh@suse.de>
 <1263508051-7868-8-git-send-email-gregkh@suse.de>
 <1263508051-7868-9-git-send-email-gregkh@suse.de>
 <1263508051-7868-10-git-send-email-gregkh@suse.de>
 <1263508051-7868-11-git-send-email-gregkh@suse.de>
 <1263508051-7868-12-git-send-email-gregkh@suse.de>
 <1263508051-7868-13-git-send-email-gregkh@suse.de>
 <1263508051-7868-14-git-send-email-gregkh@suse.de>
 <1263508051-7868-15-git-send-email-gregkh@suse.de>
 <1263508051-7868-16-git-send-email-gregkh@suse.de>
 <1263508051-7868-17-git-send-email-gregkh@suse.de>
 <1263508051-7868-18-git-send-email-gregkh@suse.de>
 <1263508051-7868-19-git-send-email-gregkh@suse.de>
 <1263508051-7868-20-git-send-email-gregkh@suse.de>
 <1263508051-7868-21-git-send-email-gregkh@suse.de>
 <1263508051-7868-22-git-send-email-gregkh@suse.de>
 <1263508051-7868-23-git-send-email-gregkh@suse.de>
 <1263508051-7868-24-git-send-email-gregkh@suse.de>
 <1263508051-7868-25-git-send-email-gregkh@suse.de>
 <1263508051-7868-26-git-send-email-gregkh@suse.de>
 <1263508051-7868-27-git-send-email-gregkh@suse.de>
 <1263508051-7868-28-git-send-email-gregkh@suse.de>
 <1263508051-7868-29-git-send-email-gregkh@suse.de>
 <1263508051-7868-30-git-send-email-gregkh@suse.de>
 <1263508051-7868-31-git-send-email-gregkh@suse.de>
 <1263508051-7868-32-git-send-email-gregkh@suse.de>
 <1263508051-7868-33-git-send-email-gregkh@suse.de>
 <1263508051-7868-34-git-send-email-gregkh@suse.de>
 <1263508051-7868-35-git-send-email-gregkh@suse.de>
 <1263508051-7868-36-git-send-email-gregkh@suse.de>
 <1263508051-7868-37-git-send-email-gregkh@suse.de>
 <1263508051-7868-38-git-send-email-gregkh@suse.de>
 <1263508051-7868-39-git-send-email-gregkh@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Luis R. Rodriguez <lrodriguez@atheros.com>

commit 359207c687cc8f4f9845c8dadd0d6dabad44e584 upstream.

Commit 8bf3d79bc401ca417ccf9fc076d3295d1a71dbf5 enabled EEPROM
checksum checks to avoid bogus bug reports but failed to address
updating the code to consider devices with custom EEPROM sizes.
Devices with custom sized EEPROMs have the upper limit size stuffed
in the EEPROM. Use this as the upper limit instead of the static
default size. In case of a checksum error also provide back the
max size and whether or not this was the default size or a custom
one. If the EEPROM is busted we add a failsafe check to ensure
we don't loop forever or try to read bogus areas of hardware.

This closes bug 14874

http://bugzilla.kernel.org/show_bug.cgi?id=14874

Cc: David Quan <david.quan@atheros.com>
Cc: Stephen Beahm <stephenbeahm@comcast.net>
Reported-by: Joshua Covington <joshuacov@googlemail.com>
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/net/wireless/ath/ath5k/eeprom.c |   32 ++++++++++++++++++++++++++++--
 drivers/net/wireless/ath/ath5k/eeprom.h |    8 +++++++
 2 files changed, 37 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/eeprom.c b/drivers/net/wireless/ath/ath5k/eeprom.c
index 7918852..9a96550 100644
--- a/drivers/net/wireless/ath/ath5k/eeprom.c
+++ b/drivers/net/wireless/ath/ath5k/eeprom.c
@@ -97,7 +97,7 @@ ath5k_eeprom_init_header(struct ath5k_hw *ah)
 	struct ath5k_eeprom_info *ee = &ah->ah_capabilities.cap_eeprom;
 	int ret;
 	u16 val;
-	u32 cksum, offset;
+	u32 cksum, offset, eep_max = AR5K_EEPROM_INFO_MAX;
 
 	/*
 	 * Read values from EEPROM and store them in the capability structure
@@ -116,12 +116,38 @@ ath5k_eeprom_init_header(struct ath5k_hw *ah)
 	 * Validate the checksum of the EEPROM date. There are some
 	 * devices with invalid EEPROMs.
 	 */
-	for (cksum = 0, offset = 0; offset < AR5K_EEPROM_INFO_MAX; offset++) {
+	AR5K_EEPROM_READ(AR5K_EEPROM_SIZE_UPPER, val);
+	if (val) {
+		eep_max = (val & AR5K_EEPROM_SIZE_UPPER_MASK) <<
+			   AR5K_EEPROM_SIZE_ENDLOC_SHIFT;
+		AR5K_EEPROM_READ(AR5K_EEPROM_SIZE_LOWER, val);
+		eep_max = (eep_max | val) - AR5K_EEPROM_INFO_BASE;
+
+		/*
+		 * Fail safe check to prevent stupid loops due
+		 * to busted EEPROMs. XXX: This value is likely too
+		 * big still, waiting on a better value.
+		 */
+		if (eep_max > (3 * AR5K_EEPROM_INFO_MAX)) {
+			ATH5K_ERR(ah->ah_sc, "Invalid max custom EEPROM size: "
+				  "%d (0x%04x) max expected: %d (0x%04x)\n",
+				  eep_max, eep_max,
+				  3 * AR5K_EEPROM_INFO_MAX,
+				  3 * AR5K_EEPROM_INFO_MAX);
+			return -EIO;
+		}
+	}
+
+	for (cksum = 0, offset = 0; offset < eep_max; offset++) {
 		AR5K_EEPROM_READ(AR5K_EEPROM_INFO(offset), val);
 		cksum ^= val;
 	}
 	if (cksum != AR5K_EEPROM_INFO_CKSUM) {
-		ATH5K_ERR(ah->ah_sc, "Invalid EEPROM checksum 0x%04x\n", cksum);
+		ATH5K_ERR(ah->ah_sc, "Invalid EEPROM "
+			  "checksum: 0x%04x eep_max: 0x%04x (%s)\n",
+			  cksum, eep_max,
+			  eep_max == AR5K_EEPROM_INFO_MAX ?
+				"default size" : "custom size");
 		return -EIO;
 	}
 
diff --git a/drivers/net/wireless/ath/ath5k/eeprom.h b/drivers/net/wireless/ath/ath5k/eeprom.h
index 0123f35..473a483 100644
--- a/drivers/net/wireless/ath/ath5k/eeprom.h
+++ b/drivers/net/wireless/ath/ath5k/eeprom.h
@@ -37,6 +37,14 @@
 #define AR5K_EEPROM_RFKILL_POLARITY_S	1
 
 #define AR5K_EEPROM_REG_DOMAIN		0x00bf	/* EEPROM regdom */
+
+/* FLASH(EEPROM) Defines for AR531X chips */
+#define AR5K_EEPROM_SIZE_LOWER		0x1b /* size info -- lower */
+#define AR5K_EEPROM_SIZE_UPPER		0x1c /* size info -- upper */
+#define AR5K_EEPROM_SIZE_UPPER_MASK	0xfff0
+#define AR5K_EEPROM_SIZE_UPPER_SHIFT	4
+#define AR5K_EEPROM_SIZE_ENDLOC_SHIFT	12
+
 #define AR5K_EEPROM_CHECKSUM		0x00c0	/* EEPROM checksum */
 #define AR5K_EEPROM_INFO_BASE		0x00c0	/* EEPROM header */
 #define AR5K_EEPROM_INFO_MAX		(0x400 - AR5K_EEPROM_INFO_BASE)
-- 
1.6.6

