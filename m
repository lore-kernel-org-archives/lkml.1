Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752109Ab0CBRIa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Mar 2010 12:08:30 -0500
Received: from xenotime.net ([72.52.64.118]:45322 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751295Ab0CBRI2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Mar 2010 12:08:28 -0500
Message-ID: <4B8D4607.8070603@xenotime.net>
Date: Tue, 02 Mar 2010 09:08:23 -0800
From: Randy Dunlap <rdunlap@xenotime.net>
Organization: YPO4
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       Stephen Hemminger <shemminger@linux-foundation.org>,
       bridge@lists.linux-foundation.org
Subject: [PATCH -next] bridge: depends on INET
References: <20100302180915.1388d3f3.sfr@canb.auug.org.au>
In-Reply-To: <20100302180915.1388d3f3.sfr@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

br_multicast calls ip_send_check(), so it should depend on INET.

built-in:
br_multicast.c:(.text+0x88cf4): undefined reference to `ip_send_check'

or modular:
ERROR: "ip_send_check" [net/bridge/bridge.ko] undefined!

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Stephen Hemminger <shemminger@linux-foundation.org>
Cc: bridge@lists.linux-foundation.org
---
 net/bridge/Kconfig |    1 +
 1 file changed, 1 insertion(+)

--- linux-next-20100302.orig/net/bridge/Kconfig
+++ linux-next-20100302/net/bridge/Kconfig
@@ -35,6 +35,7 @@ config BRIDGE
 config BRIDGE_IGMP_SNOOPING
 	bool "IGMP snooping"
 	depends on BRIDGE
+	depends on INET
 	default y
 	---help---
 	  If you say Y here, then the Ethernet bridge will be able selectively
