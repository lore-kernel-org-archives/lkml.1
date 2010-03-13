Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935973Ab0CMVTL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Mar 2010 16:19:11 -0500
Received: from server78.greatnet.de ([83.133.96.102]:42762 "EHLO
	server78.greatnet.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935358Ab0CMVTG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Mar 2010 16:19:06 -0500
X-Greylist: delayed 506 seconds by postgrey-1.27 at vger.kernel.org; Sat, 13 Mar 2010 16:19:06 EST
From: Henrik Kretzschmar <henne@nachtwindheim.de>
To: herbert@gondor.apana.org.au
Cc: bridge@lists.linux-foundation.org, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org,
       Henrik Kretzschmar <henne@nachtwindheim.de>
Subject: [PATCH] [PATCH]: CONFIG_BRIDGE_IGMP_SNOOPING must depend on CONFIG_INET
Date: Sat, 13 Mar 2010 22:10:11 +0100
Message-Id: <1268514611-7930-1-git-send-email-henne@nachtwindheim.de>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <[PATCH]: CONFIG_BRIDGE_IGMP_SNOOPING must depend on CONFIG_INET>
References: <[PATCH]: CONFIG_BRIDGE_IGMP_SNOOPING must depend on CONFIG_INET>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linking the kernel fails with the the following error message,
if CONFIG_BRIDGE_IGMP_SNOOPING is set and CONFIG_INET is not set.

net/built-in.o: In function `br_multicast_alloc_query':
br_multicast.c:(.text+0x52045): undefined reference to `ip_send_check'

This patch is tested.

Signed-off-by: Henrik Kretzschmar <henne@nachtwindheim.de>

---
 net/bridge/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/bridge/Kconfig b/net/bridge/Kconfig
index 19a6b96..52ef2dc 100644
--- a/net/bridge/Kconfig
+++ b/net/bridge/Kconfig
@@ -34,7 +34,7 @@ config BRIDGE
 
 config BRIDGE_IGMP_SNOOPING
 	bool "IGMP snooping"
-	depends on BRIDGE
+	depends on BRIDGE && INET
 	default y
 	---help---
 	  If you say Y here, then the Ethernet bridge will be able selectively
-- 
1.6.3.3

