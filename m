Return-Path: <linux-kernel-owner+w=401wt.eu-S1759687AbZBLRii@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759687AbZBLRii (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Feb 2009 12:38:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757076AbZBLRi1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Feb 2009 12:38:27 -0500
Received: from rcsinet11.oracle.com ([148.87.113.123]:56039 "EHLO
	rgminet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751899AbZBLRi0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Feb 2009 12:38:26 -0500
Message-ID: <49945E98.70002@oracle.com>
Date: Thu, 12 Feb 2009 09:38:32 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
       "linville@tuxdriver.com" <linville@tuxdriver.com>
Subject: [PATCH] wireless: fix for CONFIG_NL80211=n
References: <20090212194408.ff7489c1.sfr@canb.auug.org.au>
In-Reply-To: <20090212194408.ff7489c1.sfr@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt704.oracle.com [141.146.40.82]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090208.49945E7E.02B2:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Add empty function for case of CONFIG_NL80211=n:

net/wireless/scan.c:35: error: implicit declaration of function 'nl80211_send_scan_aborted'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 net/wireless/nl80211.h |    4 ++++
 1 file changed, 4 insertions(+)

--- linux-next-20090212.orig/net/wireless/nl80211.h
+++ linux-next-20090212/net/wireless/nl80211.h
@@ -27,6 +27,10 @@ static inline void
 nl80211_send_scan_done(struct cfg80211_registered_device *rdev,
 		       struct net_device *netdev)
 {}
+static inline void nl80211_send_scan_aborted(
+					struct cfg80211_registered_device *rdev,
+					struct net_device *netdev)
+{}
 #endif /* CONFIG_NL80211 */
 
 #endif /* __NET_WIRELESS_NL80211_H */
