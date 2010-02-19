Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755331Ab0BSRDq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Feb 2010 12:03:46 -0500
Received: from kroah.org ([198.145.64.141]:57853 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755101Ab0BSRBR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Feb 2010 12:01:17 -0500
X-Mailbox-Line: From gregkh@kvm.kroah.org Fri Feb 19 08:32:56 2010
Message-Id: <20100219163255.743772327@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Fri, 19 Feb 2010 08:30:22 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Benoit Papillault <benoit.papillault@free.fr>,
       "John W. Linville" <linville@tuxdriver.com>
Subject: [89/93] mac80211: Fix probe request filtering in IBSS mode
In-Reply-To: <20100219165717.GA15002@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Benoit Papillault <benoit.papillault@free.fr>

commit 0da780c269957783d341fc3559e6b4c9912af7b4 upstream.

We only reply to probe request if either the requested SSID is the
broadcast SSID or if the requested SSID matches our own SSID. This
latter case was not properly handled since we were replying to different
SSID with the same length as our own SSID.

Signed-off-by: Benoit Papillault <benoit.papillault@free.fr>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/mac80211/ibss.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/mac80211/ibss.c
+++ b/net/mac80211/ibss.c
@@ -643,7 +643,7 @@ static void ieee80211_rx_mgmt_probe_req(
 	}
 	if (pos[1] != 0 &&
 	    (pos[1] != ifibss->ssid_len ||
-	     !memcmp(pos + 2, ifibss->ssid, ifibss->ssid_len))) {
+	     memcmp(pos + 2, ifibss->ssid, ifibss->ssid_len))) {
 		/* Ignore ProbeReq for foreign SSID */
 		return;
 	}


