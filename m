Return-Path: <linux-kernel-owner+w=401wt.eu-S1753325AbYLBXGw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753325AbYLBXGw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2008 18:06:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753917AbYLBXGh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Dec 2008 18:06:37 -0500
Received: from ug-out-1314.google.com ([66.249.92.173]:42852 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752812AbYLBXGf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2008 18:06:35 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=oNIF3i6lr+wCGkNIMQZL8Hhqgovy2UCY5cRfd0fG5UJ5Pu+QnjgJ/kV16MzFzQeWfC
         R+13J/nSf8AFY0noFWa+4e7RA10lEp7DskNhUefNkGbGJyEcJzgLdnB6yHllyrpXurEt
         xblLS6Zv0IIexLhqo1zO29yBxkBISmHB9/K80=
Message-ID: <4935BF7F.4080109@gmail.com>
Date: Wed, 03 Dec 2008 00:06:39 +0100
From: Roel Kluin <roel.kluin@gmail.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080421)
MIME-Version: 1.0
To: Greg KH <gregkh@suse.de>, linux-wireless@vger.kernel.org,
       lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH] wlan: skb_p80211_to_ether() - payload_length is unsigned,
 check before subtraction
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

payload_length is unsigned, check before subtraction

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
diff --git a/drivers/staging/wlan-ng/p80211conv.c b/drivers/staging/wlan-ng/p80211conv.c
index 68121b9..9dd8b77 100644
--- a/drivers/staging/wlan-ng/p80211conv.c
+++ b/drivers/staging/wlan-ng/p80211conv.c
@@ -333,11 +333,11 @@ int skb_p80211_to_ether( wlandevice_t *wlandev, UINT32 ethconv, struct sk_buff *
 		memcpy(saddr, w_hdr->a3.a2, WLAN_ETHADDR_LEN);
 	} else {
 		payload_offset = WLAN_HDR_A4_LEN;
-		payload_length -= ( WLAN_HDR_A4_LEN - WLAN_HDR_A3_LEN );
-		if (payload_length < 0 ) {
+		if (payload_length < WLAN_HDR_A4_LEN - WLAN_HDR_A3_LEN) {
 			WLAN_LOG_ERROR("A4 frame too short!\n");
 			return 1;
 		}
+		payload_length -= (WLAN_HDR_A4_LEN - WLAN_HDR_A3_LEN);
 		memcpy(daddr, w_hdr->a4.a3, WLAN_ETHADDR_LEN);
 		memcpy(saddr, w_hdr->a4.a4, WLAN_ETHADDR_LEN);
 	}

