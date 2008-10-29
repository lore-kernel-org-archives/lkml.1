Return-Path: <linux-kernel-owner+w=401wt.eu-S1754674AbYJ2WzW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754674AbYJ2WzW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2008 18:55:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756270AbYJ2Wpo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Oct 2008 18:45:44 -0400
Received: from kroah.org ([198.145.64.141]:56247 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755623AbYJ2Wpd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2008 18:45:33 -0400
From: Greg KH <greg@kroah.com>
To: linux-kernel@vger.kernel.org
Cc: Solomon Peachy <pizza@shaftnet.org>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 31/49] Staging: wlan-ng: Eliminate one more rx mtu test.
Date: Wed, 29 Oct 2008 15:39:58 -0700
Message-Id: <1225320016-21803-31-git-send-email-greg@kroah.com>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <20081029223832.GC21657@kroah.com>
References: <20081029223832.GC21657@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Solomon Peachy <pizza@shaftnet.org>

It also isn't needed.

Signed-off-by: Solomon Peachy <pizza@shaftnet.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/staging/wlan-ng/p80211conv.c |   10 ----------
 1 files changed, 0 insertions(+), 10 deletions(-)

diff --git a/drivers/staging/wlan-ng/p80211conv.c b/drivers/staging/wlan-ng/p80211conv.c
index d58f10f..aaf1c9d 100644
--- a/drivers/staging/wlan-ng/p80211conv.c
+++ b/drivers/staging/wlan-ng/p80211conv.c
@@ -444,16 +444,6 @@ int skb_p80211_to_ether( wlandevice_t *wlandev, UINT32 ethconv, struct sk_buff *
 		/*  build an 802.3 frame */
 		/* allocate space and setup hostbuf */
 
-		/* Test for an overlength frame */
-		if ( payload_length > netdev->mtu ) {
-			/* A bogus length ethfrm has been sent. */
-			/* Is someone trying an oflow attack? */
-			WLAN_LOG_ERROR("OTHER frame too large (%d > %d)\n",
-				payload_length,
-				netdev->mtu);
-			return 1;
-		}
-
 		/* Chop off the 802.11 header. */
 		skb_pull(skb, payload_offset);
 
-- 
1.6.0.2

