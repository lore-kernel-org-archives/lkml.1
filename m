Return-Path: <linux-kernel-owner+w=401wt.eu-S1765607AbXKOG1L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765607AbXKOG1L (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 01:27:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764928AbXKOGWE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 01:22:04 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:45926 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764919AbXKOGWA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 01:22:00 -0500
Date: Wed, 14 Nov 2007 22:20:28 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org,
       "John W. Linville" <linville@tuxdriver.com>
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       linux-wireless <linux-wireless@vger.kernel.org>,
       Johannes Berg <johannes@sipsolutions.net>
Subject: [patch 08/23] softmac: fix wext MLME request reason code endianness
Message-ID: <20071115062028.GI8282@kroah.com>
References: <20071115055238.692814352@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="softmac-fix-wext-mlme-request-reason-code-endianness.patch"
In-Reply-To: <20071115061806.GA8282@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Johannes Berg <johannes@sipsolutions.net>

patch 94e10bfb8a7372df3ef2759c9ec2a37de2f24aca in mainline.

The MLME request reason code is host-endian and our passing
it to the low level functions is host-endian as well since
they do the swapping. I noticed that the reason code 768 was
sent (0x300) rather than 3 when wpa_supplicant terminates.
This removes the superfluous cpu_to_le16() call.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/ieee80211/softmac/ieee80211softmac_wx.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/ieee80211/softmac/ieee80211softmac_wx.c
+++ b/net/ieee80211/softmac/ieee80211softmac_wx.c
@@ -469,7 +469,7 @@ ieee80211softmac_wx_set_mlme(struct net_
 {
 	struct ieee80211softmac_device *mac = ieee80211_priv(dev);
 	struct iw_mlme *mlme = (struct iw_mlme *)extra;
-	u16 reason = cpu_to_le16(mlme->reason_code);
+	u16 reason = mlme->reason_code;
 	struct ieee80211softmac_network *net;
 	int err = -EINVAL;
 

-- 
