Return-Path: <linux-kernel-owner+w=401wt.eu-S1765403AbYCUXGX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765403AbYCUXGX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2008 19:06:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763801AbYCUWvQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Mar 2008 18:51:16 -0400
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:59409 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763146AbYCUWvO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2008 18:51:14 -0400
Message-Id: <20080321224427.219166510@sous-sol.org>
References: <20080321224250.144333319@sous-sol.org>
User-Agent: quilt/0.46-1
Date: Fri, 21 Mar 2008 15:43:40 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Haavard Skinnemoen <hskinnemoen@atmel.com>, anemo@mba.ocn.ne.jp,
       jeff@garzik.org, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [patch 50/76] macb: Fix speed setting
Content-Disposition: inline; filename=macb-fix-speed-setting.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
---------------------

From: Atsushi Nemoto <anemo@mba.ocn.ne.jp>

Fix NCFGR.SPD setting on 10Mbps.  This bug was introduced by
conversion to generic PHY layer in kernel 2.6.23.

Signed-off-by: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
Signed-off-by: Jeff Garzik <jeff@garzik.org>
Signed-off-by: Haavard Skinnemoen <hskinnemoen@atmel.com>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---

 drivers/net/macb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/macb.c
+++ b/drivers/net/macb.c
@@ -148,7 +148,7 @@ static void macb_handle_link_change(stru
 
 			if (phydev->duplex)
 				reg |= MACB_BIT(FD);
-			if (phydev->speed)
+			if (phydev->speed == SPEED_100)
 				reg |= MACB_BIT(SPD);
 
 			macb_writel(bp, NCFGR, reg);

-- 
