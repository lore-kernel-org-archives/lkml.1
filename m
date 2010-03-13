Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935700Ab0CMBU2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Mar 2010 20:20:28 -0500
Received: from kroah.org ([198.145.64.141]:60897 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934955Ab0CMAUb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Mar 2010 19:20:31 -0500
X-Mailbox-Line: From gregkh@kvm.kroah.org Fri Mar 12 16:15:11 2010
Message-Id: <20100313001511.723976159@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Fri, 12 Mar 2010 16:12:53 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Larry Finger <Larry.Finger@lwfinger.net>,
       "John W. Linville" <linville@tuxdriver.com>
Subject: [patch 075/123] b43/b43legacy: Wake queues in wireless_core_start
In-Reply-To: <20100313001618.GA9811@kroah.com>
In-Reply-To: <20100313001618.GA9811@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-stable review patch.  If anyone has any objections, please let me know.

-----------------

From: Larry Finger <Larry.Finger@lwfinger.net>

commit 0866b03c7d7dee8a34ffa527ecda426c0f405518 upstream.

If b43 or b43legacy are deauthenticated or disconnected, there is a
possibility that a reconnection is tried with the queues stopped in
mac80211. To prevent this, start the queues before setting
STAT_INITIALIZED.

In b43, a similar change has been in place (twice) in the
wireless_core_init() routine. Remove the duplicate and add similar
code to b43legacy.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/wireless/b43/main.c       |    3 +--
 drivers/net/wireless/b43legacy/main.c |    2 ++
 2 files changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/net/wireless/b43/main.c
+++ b/drivers/net/wireless/b43/main.c
@@ -3970,6 +3970,7 @@ static int b43_wireless_core_start(struc
 	}
 
 	/* We are ready to run. */
+	ieee80211_wake_queues(dev->wl->hw);
 	b43_set_status(dev, B43_STAT_STARTED);
 
 	/* Start data flow (TX/RX). */
@@ -4379,8 +4380,6 @@ static int b43_wireless_core_init(struct
 
 	ieee80211_wake_queues(dev->wl->hw);
 
-	ieee80211_wake_queues(dev->wl->hw);
-
 	b43_set_status(dev, B43_STAT_INITIALIZED);
 
 out:
--- a/drivers/net/wireless/b43legacy/main.c
+++ b/drivers/net/wireless/b43legacy/main.c
@@ -2921,6 +2921,7 @@ static int b43legacy_wireless_core_start
 		goto out;
 	}
 	/* We are ready to run. */
+	ieee80211_wake_queues(dev->wl->hw);
 	b43legacy_set_status(dev, B43legacy_STAT_STARTED);
 
 	/* Start data flow (TX/RX) */
@@ -3341,6 +3342,7 @@ static int b43legacy_wireless_core_init(
 	b43legacy_security_init(dev);
 	b43legacy_rng_init(wl);
 
+	ieee80211_wake_queues(dev->wl->hw);
 	b43legacy_set_status(dev, B43legacy_STAT_INITIALIZED);
 
 	b43legacy_leds_init(dev);


