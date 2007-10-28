Return-Path: <linux-kernel-owner+w=401wt.eu-S1753567AbXJ1Kiu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753567AbXJ1Kiu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2007 06:38:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751004AbXJ1Kim
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Oct 2007 06:38:42 -0400
Received: from mail02a.mail.t-online.hu ([84.2.40.7]:63308 "EHLO
	mail02a.mail.t-online.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751131AbXJ1Kil (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2007 06:38:41 -0400
Message-ID: <472473D2.8040102@freemail.hu>
Date: Sun, 28 Oct 2007 12:34:42 +0100
From: =?ISO-8859-2?Q?N=E9meth_M=E1rton?= <nm127@freemail.hu>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.2) Gecko/20070221 SeaMonkey/1.1.1
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>, Joe Jezak <josejx@gentoo.org>,
       Daniel Drake <dsd@gentoo.org>
CC: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] mac80211: fix printk() format string
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Márton Németh <nm127@freemail.hu>

Get rid of the following compiler warning message:

net/mac80211/ieee80211_sta.c: In function 'ieee80211_rx_mgmt_assoc_resp':
net/mac80211/ieee80211_sta.c:1187: warning: format '%d' expects type 'int', but argument 7 has type 'long unsigned int'

Signed-off-by: Márton Németh <nm127@freemail.hu>
---
--- linux-2.6.24-rc1/net/mac80211/ieee80211_sta.c.orig	2007-10-24 05:50:57.000000000 +0200
+++ linux-2.6.24-rc1/net/mac80211/ieee80211_sta.c	2007-10-28 11:20:23.000000000 +0100
@@ -1182,7 +1182,7 @@ static void ieee80211_rx_mgmt_assoc_resp
 	aid = le16_to_cpu(mgmt->u.assoc_resp.aid);

 	printk(KERN_DEBUG "%s: RX %sssocResp from %s (capab=0x%x "
-	       "status=%d aid=%d)\n",
+	       "status=%d aid=%lu)\n",
 	       dev->name, reassoc ? "Rea" : "A", print_mac(mac, mgmt->sa),
 	       capab_info, status_code, aid & ~(BIT(15) | BIT(14)));

