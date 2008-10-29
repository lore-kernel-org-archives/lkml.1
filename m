Return-Path: <linux-kernel-owner+w=401wt.eu-S1757900AbYJ2Wy6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757900AbYJ2Wy6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2008 18:54:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756172AbYJ2Wpn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Oct 2008 18:45:43 -0400
Received: from kroah.org ([198.145.64.141]:56244 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755355AbYJ2Wpc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2008 18:45:32 -0400
From: Greg KH <greg@kroah.com>
To: linux-kernel@vger.kernel.org
Cc: Solomon Peachy <pizza@shaftnet.org>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 30/49] Staging: wlan-ng: Get rid of the MTU tests in the rx conversion path.
Date: Wed, 29 Oct 2008 15:39:57 -0700
Message-Id: <1225320016-21803-30-git-send-email-greg@kroah.com>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <20081029223832.GC21657@kroah.com>
References: <20081029223832.GC21657@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Solomon Peachy <pizza@shaftnet.org>

They are not needed.

Signed-off-by: Solomon Peachy <pizza@shaftnet.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/staging/wlan-ng/p80211conv.c |   29 -----------------------------
 1 files changed, 0 insertions(+), 29 deletions(-)

diff --git a/drivers/staging/wlan-ng/p80211conv.c b/drivers/staging/wlan-ng/p80211conv.c
index 68121b9..d58f10f 100644
--- a/drivers/staging/wlan-ng/p80211conv.c
+++ b/drivers/staging/wlan-ng/p80211conv.c
@@ -381,14 +381,6 @@ int skb_p80211_to_ether( wlandevice_t *wlandev, UINT32 ethconv, struct sk_buff *
 	     (memcmp(saddr, e_hdr->saddr, WLAN_ETHADDR_LEN) == 0))) {
 		WLAN_LOG_DEBUG(3, "802.3 ENCAP len: %d\n", payload_length);
 		/* 802.3 Encapsulated */
-		/* Test for an overlength frame */
-		if ( payload_length > (netdev->mtu + WLAN_ETHHDR_LEN)) {
-			/* A bogus length ethfrm has been encap'd. */
-			/* Is someone trying an oflow attack? */
-			WLAN_LOG_ERROR("ENCAP frame too large (%d > %d)\n",
-				payload_length, netdev->mtu + WLAN_ETHHDR_LEN);
-			return 1;
-		}
 
 		/* Chop off the 802.11 header.  it's already sane. */
 		skb_pull(skb, payload_offset);
@@ -408,15 +400,6 @@ int skb_p80211_to_ether( wlandevice_t *wlandev, UINT32 ethconv, struct sk_buff *
 		/* it's a SNAP + RFC1042 frame && protocol is in STT */
 		/* build 802.3 + RFC1042 */
 
-		/* Test for an overlength frame */
-		if ( payload_length > netdev->mtu ) {
-			/* A bogus length ethfrm has been sent. */
-			/* Is someone trying an oflow attack? */
-			WLAN_LOG_ERROR("SNAP frame too large (%d > %d)\n",
-				payload_length, netdev->mtu);
-			return 1;
-		}
-
 		/* chop 802.11 header from skb. */
 		skb_pull(skb, payload_offset);
 
@@ -437,18 +420,6 @@ int skb_p80211_to_ether( wlandevice_t *wlandev, UINT32 ethconv, struct sk_buff *
 		/* it's an 802.1h frame || (an RFC1042 && protocol is not in STT) */
 		/* build a DIXII + RFC894 */
 
-		/* Test for an overlength frame */
-		if ((payload_length - sizeof(wlan_llc_t) - sizeof(wlan_snap_t))
-		    > netdev->mtu) {
-			/* A bogus length ethfrm has been sent. */
-			/* Is someone trying an oflow attack? */
-			WLAN_LOG_ERROR("DIXII frame too large (%ld > %d)\n",
-					(long int) (payload_length - sizeof(wlan_llc_t) -
-						    sizeof(wlan_snap_t)),
-					netdev->mtu);
-			return 1;
-		}
-
 		/* chop 802.11 header from skb. */
 		skb_pull(skb, payload_offset);
 
-- 
1.6.0.2

