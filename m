Return-Path: <linux-kernel-owner+w=401wt.eu-S1761593AbYHOWR2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761593AbYHOWR2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2008 18:17:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753324AbYHOWRR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Aug 2008 18:17:17 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:49694
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751600AbYHOWRQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2008 18:17:16 -0400
Date: Fri, 15 Aug 2008 15:17:15 -0700 (PDT)
Message-Id: <20080815.151715.111675039.davem@davemloft.net>
To: randy.dunlap@oracle.com
Cc: sfr@canb.auug.org.au, mchan@broadcom.com, netdev@vger.kernel.org,
       linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: Tree for August 15 (bnx2) [resend/lost]
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080815084116.340ac526.randy.dunlap@oracle.com>
References: <20080815184032.3acd8032.sfr@canb.auug.org.au>
	<20080815084116.340ac526.randy.dunlap@oracle.com>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>
Date: Fri, 15 Aug 2008 08:41:16 -0700

> When VLAN is not enabled, bnx2 build fails with:
> 
> drivers/net/bnx2.c: In function 'bnx2_rx_int':
> drivers/net/bnx2.c:2959: error: dereferencing pointer to incomplete type
> drivers/net/bnx2.c:2960: error: dereferencing pointer to incomplete type
> make[2]: *** [drivers/net/bnx2.o] Error 1

Does this fix it for you?

diff --git a/drivers/net/bnx2.c b/drivers/net/bnx2.c
index d454810..2486a65 100644
--- a/drivers/net/bnx2.c
+++ b/drivers/net/bnx2.c
@@ -35,8 +35,8 @@
 #include <linux/time.h>
 #include <linux/ethtool.h>
 #include <linux/mii.h>
-#if defined(CONFIG_VLAN_8021Q) || defined(CONFIG_VLAN_8021Q_MODULE)
 #include <linux/if_vlan.h>
+#if defined(CONFIG_VLAN_8021Q) || defined(CONFIG_VLAN_8021Q_MODULE)
 #define BCM_VLAN 1
 #endif
 #include <net/ip.h>
