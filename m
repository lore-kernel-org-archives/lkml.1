Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935614Ab0CMAdJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Mar 2010 19:33:09 -0500
Received: from kroah.org ([198.145.64.141]:46914 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935418Ab0CMAbb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Mar 2010 19:31:31 -0500
X-Mailbox-Line: From gregkh@kvm.kroah.org Fri Mar 12 16:27:10 2010
Message-Id: <20100313002710.037693826@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Fri, 12 Mar 2010 16:26:28 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Jussi Kivilinna <jussi.kivilinna@mbnet.fi>,
       "John W. Linville" <linville@tuxdriver.com>
Subject: [055/145] rndis_wlan: handle NL80211_AUTHTYPE_AUTOMATIC
In-Reply-To: <20100313002816.GA18903@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let me know.

----------------
From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>

commit 634a555ce3ee5ea1fdcaee8b4ac9ce7b54f301ac upstream.

rndis_wlan didn't know about NL80211_AUTHTYPE_AUTOMATIC and simple
setup with 'iwconfig wlan essid no-encrypt' would fail (ENOSUPP).

v2: use NDIS_80211_AUTH_AUTO_SWITCH instead of _OPEN.
    This will make device try shared key auth first, then open.

Signed-off-by: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/wireless/rndis_wlan.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/net/wireless/rndis_wlan.c
+++ b/drivers/net/wireless/rndis_wlan.c
@@ -1072,6 +1072,8 @@ static int set_auth_mode(struct usbnet *
 		auth_mode = NDIS_80211_AUTH_SHARED;
 	else if (auth_type == NL80211_AUTHTYPE_OPEN_SYSTEM)
 		auth_mode = NDIS_80211_AUTH_OPEN;
+	else if (auth_type == NL80211_AUTHTYPE_AUTOMATIC)
+		auth_mode = NDIS_80211_AUTH_AUTO_SWITCH;
 	else
 		return -ENOTSUPP;
 


