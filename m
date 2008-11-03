Return-Path: <linux-kernel-owner+w=401wt.eu-S1755702AbYKCLOY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755702AbYKCLOY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2008 06:14:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755176AbYKCLNz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Nov 2008 06:13:55 -0500
Received: from anchor-post-31.mail.demon.net ([194.217.242.89]:2979 "EHLO
	anchor-post-31.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755149AbYKCLNz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2008 06:13:55 -0500
Subject: [PATCH 2/8] prism2_usb.c always enable the card in probe_usb
From: Richard Kennedy <richard@rsk.demon.co.uk>
To: gregkh <gregkh@suse.de>
Cc: lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <1225710353.3113.5.camel@castor.localdomain>
References: <1225710353.3113.5.camel@castor.localdomain>
Content-Type: text/plain
Date: Mon, 03 Nov 2008 11:13:48 +0000
Message-Id: <1225710828.3113.15.camel@castor.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

always enable card in probe_usb
& update register_wlandev to match latest wlan-ng-dev tree.

Signed-off-by: Richard Kennedy <richard@rsk.demon.co.uk>
---
 drivers/staging/wlan-ng/prism2_usb.c |   14 +++++++++-----
 1 files changed, 9 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/wlan-ng/prism2_usb.c b/drivers/staging/wlan-ng/prism2_usb.c
index f1ae371..34a36c1 100644
--- a/drivers/staging/wlan-ng/prism2_usb.c
+++ b/drivers/staging/wlan-ng/prism2_usb.c
@@ -110,11 +110,6 @@ static int prism2sta_probe_usb(
 	 * linux netdevice.
 	 */
 	SET_NETDEV_DEV(wlandev->netdev, &(interface->dev));
-        if ( register_wlandev(wlandev) != 0 ) {
-		WLAN_LOG_ERROR("%s: register_wlandev() failed.\n", dev_info);
-		result = -EIO;
-		goto failed;
-        }
 
 	/* Do a chip-level reset on the MAC */
 	if (prism2_doreset) {
@@ -138,6 +133,15 @@ static int prism2sta_probe_usb(
 
 	wlandev->msdstate = WLAN_MSD_HWPRESENT;
 
+        if ( register_wlandev(wlandev) != 0 ) {
+		WLAN_LOG_ERROR("%s: register_wlandev() failed.\n", dev_info);
+		result = -EIO;
+		goto failed;
+        }
+
+/* enable the card */
+	prism2sta_ifstate(wlandev, P80211ENUM_ifstate_enable);
+
 	goto done;
 
  failed:
-- 
1.5.6.5



