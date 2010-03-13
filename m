Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935765Ab0CMBVm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Mar 2010 20:21:42 -0500
Received: from kroah.org ([198.145.64.141]:60897 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934945Ab0CMAUZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Mar 2010 19:20:25 -0500
X-Mailbox-Line: From gregkh@kvm.kroah.org Fri Mar 12 16:15:11 2010
Message-Id: <20100313001511.204283785@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Fri, 12 Mar 2010 16:12:47 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       "John W. Linville" <linville@tuxdriver.com>
Subject: [patch 069/123] netdevice.h: check for CONFIG_WLAN instead of CONFIG_WLAN_80211
In-Reply-To: <20100313001618.GA9811@kroah.com>
In-Reply-To: <20100313001618.GA9811@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-stable review patch.  If anyone has any objections, please let me know.

-----------------

From: John W. Linville <linville@tuxdriver.com>

commit caf66e581172dc5032bb84841a91bc7b77ad9876 upstream.

In "wireless: remove WLAN_80211 and WLAN_PRE80211 from Kconfig" I
inadvertantly missed a line in include/linux/netdevice.h.  I thereby
effectively reverted "net: Set LL_MAX_HEADER properly for wireless." by
accident. :-(  Now we should check there for CONFIG_WLAN instead.

Signed-off-by: John W. Linville <linville@tuxdriver.com>
Reported-by: Christoph Egger <siccegge@stud.informatik.uni-erlangen.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 include/linux/netdevice.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -136,7 +136,7 @@ static inline bool dev_xmit_complete(int
  *	used.
  */
 
-#if defined(CONFIG_WLAN_80211) || defined(CONFIG_AX25) || defined(CONFIG_AX25_MODULE)
+#if defined(CONFIG_WLAN) || defined(CONFIG_AX25) || defined(CONFIG_AX25_MODULE)
 # if defined(CONFIG_MAC80211_MESH)
 #  define LL_MAX_HEADER 128
 # else


