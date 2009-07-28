Return-Path: <linux-kernel-owner+w=401wt.eu-S1755468AbZG1S2P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755468AbZG1S2P (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 14:28:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755388AbZG1S2N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 14:28:13 -0400
Received: from avexch1.qlogic.com ([198.70.193.115]:42778 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755390AbZG1S2L convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 14:28:11 -0400
From: Dhananjay Phadke <dhananjay.phadke@qlogic.com>
To: Randy Dunlap <randy.dunlap@oracle.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       "davem@davemloft.net" <davem@davemloft.net>
CC: "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>, netdev <netdev@vger.kernel.org>
Date: Tue, 28 Jul 2009 11:25:19 -0700
Subject: RE: [PATCH -next] netxen: fix build when CONFIG_INET=n
Thread-Topic: [PATCH -next] netxen: fix build when CONFIG_INET=n
Thread-Index: AcoPsDrHBwFeH1ghTRyZCO98gWP9iAAAIf1c
Message-ID: <7608421F3572AB4292BB2532AE89D5658187610C1C@AVEXMB1.qlogic.org>
References: <20090728174224.647cc3ba.sfr@canb.auug.org.au>,<20090728112103.81f229d6.randy.dunlap@oracle.com>
In-Reply-To: <20090728112103.81f229d6.randy.dunlap@oracle.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginalArrivalTime: 28 Jul 2009 18:28:05.0073 (UTC) FILETIME=[25C44C10:01CA0FB1]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks Randy for catching, I didn't run  CONFIG_INET=n build.

I think, better option is to wrap code in netxen_nic_main.c with CONFIG_INET check,
since it's not a mandatory feature.

-Dhananjay
________________________________________
From: Randy Dunlap [randy.dunlap@oracle.com]
Sent: Tuesday, July 28, 2009 11:21 AM
To: Stephen Rothwell; davem@davemloft.net
Cc: linux-next@vger.kernel.org; LKML; netdev; Dhananjay Phadke
Subject: [PATCH -next] netxen: fix build when CONFIG_INET=n

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
-       depends on PCI
+       depends on PCI && INET
        help
          This enables the support for NetXen's Gigabit Ethernet card.




---
~Randy
LPC 2009, Sept. 23-25, Portland, Oregon
http://linuxplumbersconf.org/2009/
