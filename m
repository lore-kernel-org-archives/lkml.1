Return-Path: <linux-kernel-owner+w=401wt.eu-S1755536AbYKCLSz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755536AbYKCLSz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2008 06:18:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755083AbYKCLSq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Nov 2008 06:18:46 -0500
Received: from anchor-post-34.mail.demon.net ([194.217.242.92]:2539 "EHLO
	anchor-post-34.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755070AbYKCLSq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2008 06:18:46 -0500
Subject: [PATCH 4/8] p80211netdev.c correctly enable wext handlers
From: Richard Kennedy <richard@rsk.demon.co.uk>
To: gregkh <gregkh@suse.de>
Cc: lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <1225710353.3113.5.camel@castor.localdomain>
References: <1225710353.3113.5.camel@castor.localdomain>
Content-Type: text/plain
Date: Mon, 03 Nov 2008 11:18:23 +0000
Message-Id: <1225711103.3113.22.camel@castor.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

correctly enable wext handlers
CONFIG_NET_WIRELESS does not exist so wext_handlers did not get
defined. 

Signed-off-by: Richard Kennedy <richard@rsk.demon.co.uk>
---
 drivers/staging/wlan-ng/p80211netdev.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/wlan-ng/p80211netdev.c b/drivers/staging/wlan-ng/p80211netdev.c
index cc9cd4c..17b9321 100644
--- a/drivers/staging/wlan-ng/p80211netdev.c
+++ b/drivers/staging/wlan-ng/p80211netdev.c
@@ -864,12 +864,10 @@ int wlan_setup(wlandevice_t *wlandev)
 		dev->open =		p80211knetdev_open;
 		dev->stop =		p80211knetdev_stop;
 
-#ifdef CONFIG_NET_WIRELESS
 #if (WIRELESS_EXT < 21)
 		dev->get_wireless_stats = p80211wext_get_wireless_stats;
 #endif
 		dev->wireless_handlers = &p80211wext_handler_def;
-#endif
 
 		netif_stop_queue(dev);
 #ifdef HAVE_CHANGE_MTU
-- 
1.5.6.5



