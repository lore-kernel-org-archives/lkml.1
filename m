Return-Path: <linux-kernel-owner+w=401wt.eu-S1161413AbXDKXFb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161413AbXDKXFb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2007 19:05:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161357AbXDKWyb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Apr 2007 18:54:31 -0400
Received: from canuck.infradead.org ([209.217.80.40]:55541 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161346AbXDKWyR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2007 18:54:17 -0400
Date: Wed, 11 Apr 2007 15:51:36 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, netdev@vger.kernel.org,
       Stephen Hemminger <shemminger@linux-foundation.org>
Subject: [patch 07/31] sky2: phy workarounds for Yukon EC-U A1
Message-ID: <20070411225136.GH24814@kroah.com>
References: <20070411224329.866978349@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="sky2-ec-u-a1.patch"
In-Reply-To: <20070411225100.GA24814@kroah.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Stephen Hemminger <shemminger@linux-foundation.org>

The workaround Yukon EC-U wasn't comparing with correct
version and wasn't doing correct setup. Without it, 88e8056
throws all sorts of errors.

Signed-off-by: Stephen Hemminger <shemminger@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/sky2.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/net/sky2.c
+++ b/drivers/net/sky2.c
@@ -524,9 +524,9 @@ static void sky2_phy_init(struct sky2_hw
 		ledover &= ~PHY_M_LED_MO_RX;
 	}
 
-	if (hw->chip_id == CHIP_ID_YUKON_EC_U && hw->chip_rev == CHIP_REV_YU_EC_A1) {
+	if (hw->chip_id == CHIP_ID_YUKON_EC_U &&
+	    hw->chip_rev == CHIP_REV_YU_EC_U_A1) {
 		/* apply fixes in PHY AFE */
-		pg = gm_phy_read(hw, port, PHY_MARV_EXT_ADR);
 		gm_phy_write(hw, port, PHY_MARV_EXT_ADR, 255);
 
 		/* increase differential signal amplitude in 10BASE-T */
@@ -538,7 +538,7 @@ static void sky2_phy_init(struct sky2_hw
 		gm_phy_write(hw, port, 0x17, 0x2002);
 
 		/* set page register to 0 */
-		gm_phy_write(hw, port, PHY_MARV_EXT_ADR, pg);
+		gm_phy_write(hw, port, PHY_MARV_EXT_ADR, 0);
 	} else {
 		gm_phy_write(hw, port, PHY_MARV_LED_CTRL, ledctrl);
 

-- 
