Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932978Ab0BYRPm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Feb 2010 12:15:42 -0500
Received: from charlotte.tuxdriver.com ([70.61.120.58]:42644 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932681Ab0BYRPk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Feb 2010 12:15:40 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-kernel@vger.kernel.org
Cc: linux-wireless@vger.kernel.org,
       "John W. Linville" <linville@tuxdriver.com>, stable@kernel.org
Subject: [PATCH] netdevice.h: check for CONFIG_WLAN instead of CONFIG_WLAN_80211
Date: Thu, 25 Feb 2010 12:02:45 -0500
Message-Id: <1267117365-16235-1-git-send-email-linville@tuxdriver.com>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <20100225150423.GA5101@faui49.informatik.uni-erlangen.de>
References: <20100225150423.GA5101@faui49.informatik.uni-erlangen.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In "wireless: remove WLAN_80211 and WLAN_PRE80211 from Kconfig" I
inadvertantly missed a line in include/linux/netdevice.h.  I thereby
effectively reverted "net: Set LL_MAX_HEADER properly for wireless." by
accident. :-(  Now we should check there for CONFIG_WLAN instead.

Signed-off-by: John W. Linville <linville@tuxdriver.com>
Reported-by: Christoph Egger <siccegge@stud.informatik.uni-erlangen.de>
Cc: stable@kernel.org
---
Unless there is objection, I'll push this up through my tree as normal.

(Apologies for the second copy, I munged the LKML address in the first
one...)

 include/linux/netdevice.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index a3fccc8..99914e6 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -136,7 +136,7 @@ static inline bool dev_xmit_complete(int rc)
  *	used.
  */
 
-#if defined(CONFIG_WLAN_80211) || defined(CONFIG_AX25) || defined(CONFIG_AX25_MODULE)
+#if defined(CONFIG_WLAN) || defined(CONFIG_AX25) || defined(CONFIG_AX25_MODULE)
 # if defined(CONFIG_MAC80211_MESH)
 #  define LL_MAX_HEADER 128
 # else
-- 
1.6.2.5

