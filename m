Return-Path: <linux-kernel-owner+w=401wt.eu-S1755799AbZCEJJm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755799AbZCEJJm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Mar 2009 04:09:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753102AbZCEJJX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Mar 2009 04:09:23 -0500
Received: from stinky.trash.net ([213.144.137.162]:62039 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751431AbZCEJJW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Mar 2009 04:09:22 -0500
Message-ID: <49AF96BE.1020302@trash.net>
Date: Thu, 05 Mar 2009 10:09:18 +0100
From: Patrick McHardy <kaber@trash.net>
User-Agent: Mozilla-Thunderbird 2.0.0.19 (X11/20090103)
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: blaschka@linux.vnet.ibm.com, bart@jukie.net, greearb@candelatech.com,
       shemminger@vyatta.com, dada1@cosmosbay.com, frank.blaschka@de.ibm.com,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [BUG] 2.6.29-rc* QinQ vlan trunking regression
References: <49AF87D6.5040104@linux.vnet.ibm.com>	<49AF8CE0.6030301@trash.net>	<20090305.005646.115456407.davem@davemloft.net> <20090305.005934.130220849.davem@davemloft.net> <49AF9672.50200@trash.net>
In-Reply-To: <49AF9672.50200@trash.net>
Content-Type: multipart/mixed;
 boundary="------------000208020303060800090401"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------000208020303060800090401
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Patrick McHardy wrote:
> Yes, but that patch introduced the requirement to pass the correct
> device down since now the handlers need it to get to the ops of the
> underlying device. Previously they all relied on the handlers not
> using their private data.
>
> Signed-off-by: Patrick McHardy <kaber@trash.net>
>   

Oops, the last patch was broken.



--------------000208020303060800090401
Content-Type: text/plain;
 name="x"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="x"

diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index 9fb3883..e0578fe 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -4113,7 +4113,7 @@ static int bond_neigh_setup(struct net_device *dev, struct neigh_parms *parms)
 		const struct net_device_ops *slave_ops
 			= slave->dev->netdev_ops;
 		if (slave_ops->ndo_neigh_setup)
-			return slave_ops->ndo_neigh_setup(dev, parms);
+			return slave_ops->ndo_neigh_setup(slave->dev, parms);
 	}
 	return 0;
 }

--------------000208020303060800090401--
