Return-Path: <linux-kernel-owner+w=401wt.eu-S1755018Ab0AZXob@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755018Ab0AZXob (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jan 2010 18:44:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754930Ab0AZXoV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jan 2010 18:44:21 -0500
Received: from kroah.org ([198.145.64.141]:35499 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754877Ab0AZXoQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jan 2010 18:44:16 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Tue Jan 26 15:39:31 2010
Message-Id: <20100126233931.894407917@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Tue, 26 Jan 2010 15:34:50 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Benoit Papillault <benoit.papillault@free.fr>,
       "John W. Linville" <linville@tuxdriver.com>
Subject: [84/98] mac80211: check that ieee80211_set_power_mgmt only handles STA interfaces.
In-Reply-To: <20100126233950.GA5372@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Benoit Papillault <benoit.papillault@free.fr>

commit e5de30c9bf4a39db9f54c4a373470ce65881ade0 upstream.

ieee80211_set_power_mgmt is meant for STA interfaces only. Moreover,
since sdata->u.mgd.mtx is only initialized for STA interfaces, using
this code for any other type of interface (like creating a monitor
interface) will result in a oops.

Signed-off-by: Benoit Papillault <benoit.papillault@free.fr>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/mac80211/cfg.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -1306,6 +1306,9 @@ static int ieee80211_set_power_mgmt(stru
 	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
 	struct ieee80211_conf *conf = &local->hw.conf;
 
+	if (sdata->vif.type != NL80211_IFTYPE_STATION)
+		return -EOPNOTSUPP;
+
 	if (!(local->hw.flags & IEEE80211_HW_SUPPORTS_PS))
 		return -EOPNOTSUPP;
 


