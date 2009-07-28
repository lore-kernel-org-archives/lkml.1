Return-Path: <linux-kernel-owner+w=401wt.eu-S1755418AbZG1SVh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755418AbZG1SVh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 14:21:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755341AbZG1SVg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 14:21:36 -0400
Received: from rcsinet11.oracle.com ([148.87.113.123]:26368 "EHLO
	rgminet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755284AbZG1SVf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 14:21:35 -0400
Date: Tue, 28 Jul 2009 11:21:03 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>, davem@davemloft.net
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       netdev <netdev@vger.kernel.org>,
       Dhananjay Phadke <dhananjay@netxen.com>
Subject: [PATCH -next] netxen: fix build when CONFIG_INET=n
Message-Id: <20090728112103.81f229d6.randy.dunlap@oracle.com>
In-Reply-To: <20090728174224.647cc3ba.sfr@canb.auug.org.au>
References: <20090728174224.647cc3ba.sfr@canb.auug.org.au>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.0 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: abhmt004.oracle.com [141.146.116.13]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A010201.4A6F41A5.005C:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix netxen build errors when CONFIG_INET=n:

netxen_nic_main.c:(.text+0x1abb8a): undefined reference to `in_dev_finish_destroy'
netxen_nic_main.c:(.init.text+0xd86e): undefined reference to `register_inetaddr_notifier'
netxen_nic_main.c:(.exit.text+0x1b70): undefined reference to `unregister_inetaddr_notifier'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Dhananjay Phadke <dhananjay@netxen.com>
---
 drivers/net/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-next-20090728.orig/drivers/net/Kconfig
+++ linux-next-20090728/drivers/net/Kconfig
@@ -2666,7 +2666,7 @@ config MYRI10GE_DCA
 
 config NETXEN_NIC
 	tristate "NetXen Multi port (1/10) Gigabit Ethernet NIC"
-	depends on PCI
+	depends on PCI && INET
 	help
 	  This enables the support for NetXen's Gigabit Ethernet card.
 



---
~Randy
LPC 2009, Sept. 23-25, Portland, Oregon
http://linuxplumbersconf.org/2009/
