Return-Path: <linux-kernel-owner+w=401wt.eu-S1762545AbZFLXEl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762545AbZFLXEl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 19:04:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751315AbZFLXEa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 19:04:30 -0400
Received: from rcsinet12.oracle.com ([148.87.113.124]:38807 "EHLO
	rgminet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751232AbZFLXE3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 19:04:29 -0400
Message-ID: <4A32DDC8.7060605@oracle.com>
Date: Fri, 12 Jun 2009 15:59:20 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, dbaryshkov@gmail.com,
       slapin@ossfans.org, linux-zigbee-devel@lists.sourceforge.net,
       Netdev <netdev@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH -next] ieee802154: fix kconfig bool/tristate muckup
References: <20090611191420.1f4d5e4f.sfr@canb.auug.org.au> <4A31869B.3050901@oracle.com>
In-Reply-To: <4A31869B.3050901@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: abhmt003.oracle.com [141.146.116.12]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A010204.4A32DE9D.0133:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

menuconfig IEEE802154_DRIVERS is a bool that depends on tristate IEEE802154.
If the IEEE802154 symbol is 'm', the bool becomes 'y'.
This allows tristate symbols under IEEE802154_DRIVERS to be configured as
'y' and cause build problems.
Changing the menuconfig bool to a tristate fixes this.

drivers/built-in.o: In function `fake_scan_req':
fakehard.c:(.text+0x46d625): undefined reference to `ieee802154_nl_scan_confirm'
drivers/built-in.o: In function `fake_disassoc_req':
fakehard.c:(.text+0x46d66f): undefined reference to `ieee802154_nl_disassoc_confirm'
drivers/built-in.o: In function `fake_assoc_req':
fakehard.c:(.text+0x46d6be): undefined reference to `ieee802154_nl_assoc_confirm'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: linux-zigbee-devel@lists.sourceforge.net
Cc: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
Cc: Sergey Lapin <slapin@ossfans.org>
---
 drivers/ieee802154/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-next-20090612.orig/drivers/ieee802154/Kconfig
+++ linux-next-20090612/drivers/ieee802154/Kconfig
@@ -1,5 +1,5 @@
 menuconfig IEEE802154_DRIVERS
-	bool "IEEE 802.15.4 drivers"
+	tristate "IEEE 802.15.4 drivers"
 	depends on NETDEVICES && IEEE802154
 	default y
 	---help---


-- 
~Randy
LPC 2009, Sept. 23-25, Portland, Oregon
http://linuxplumbersconf.org/2009/
