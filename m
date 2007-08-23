Return-Path: <linux-kernel-owner+w=401wt.eu-S1765335AbXHWW27@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765335AbXHWW27 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2007 18:28:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765943AbXHWW2E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Aug 2007 18:28:04 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:50631 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765662AbXHWW16 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2007 18:27:58 -0400
Date: Thu, 23 Aug 2007 15:26:00 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Stephen Hemminger <shemminger@linux-foundation.org>
Subject: [patch 03/28] sky2: dont clear phy power bits
Message-ID: <20070823222600.GD18559@kroah.com>
References: <20070823220656.101239233@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="sky2-don-t-clear-phy-power-bits.patch"
In-Reply-To: <20070823221811.GA18559@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.

------------------

There are special PHY settings available on Yukon EC-U chip that
should not get cleared. This should solve mysterious errors on some
motherboards (like Gigabyte DS-3).

Signed-off-by: Stephen Hemminger <shemminger@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>


---
 drivers/net/sky2.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/net/sky2.c
+++ b/drivers/net/sky2.c
@@ -657,8 +657,8 @@ static void sky2_mac_init(struct sky2_hw
 	int i;
 	const u8 *addr = hw->dev[port]->dev_addr;
 
-	sky2_write32(hw, SK_REG(port, GPHY_CTRL), GPC_RST_SET);
-	sky2_write32(hw, SK_REG(port, GPHY_CTRL), GPC_RST_CLR);
+	sky2_write8(hw, SK_REG(port, GPHY_CTRL), GPC_RST_SET);
+	sky2_write8(hw, SK_REG(port, GPHY_CTRL), GPC_RST_CLR);
 
 	sky2_write8(hw, SK_REG(port, GMAC_CTRL), GMC_RST_CLR);
 

-- 
