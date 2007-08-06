Return-Path: <linux-kernel-owner+w=401wt.eu-S933605AbXHFVoX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933605AbXHFVoX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2007 17:44:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754184AbXHFVoJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Aug 2007 17:44:09 -0400
Received: from xdsl-664.zgora.dialog.net.pl ([81.168.226.152]:1735 "EHLO
	tuxland.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753055AbXHFVoH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2007 17:44:07 -0400
From: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
To: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: [PATCH] drivers/net/ibmveth.c: memset fix
Date: Mon, 6 Aug 2007 23:44:03 +0200
User-Agent: KMail/1.9.5
Cc: brking@linux.vnet.ibm.com, santil@us.ibm.com, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
References: <200708062217.04361.m.kozlowski@tuxland.pl> <46B78672.9090808@linux.vnet.ibm.com> <46B78814.50508@pobox.com>
In-Reply-To: <46B78814.50508@pobox.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708062344.03443.m.kozlowski@tuxland.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> >> 	Looks like memset() is zeroing wrong nr of bytes.
> > 
> > Good catch, however, I think we can just remove this memset altogether
> > since the memory gets allocated via kzalloc.
> 
> Correct, that memset() is superfluous.

Ok. Then this should do it.

Signed-off-by: Mariusz Kozlowski <m.kozlowski@tuxland.pl>

 drivers/net/ibmveth.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- linux-2.6.23-rc1-mm2-a/drivers/net/ibmveth.c	2007-08-01 08:43:46.000000000 +0200
+++ linux-2.6.23-rc1-mm2-b/drivers/net/ibmveth.c	2007-08-06 23:32:13.000000000 +0200
@@ -963,7 +963,7 @@ static int __devinit ibmveth_probe(struc
 {
 	int rc, i;
 	struct net_device *netdev;
-	struct ibmveth_adapter *adapter = NULL;
+	struct ibmveth_adapter *adapter;

 	unsigned char *mac_addr_p;
 	unsigned int *mcastFilterSize_p;
@@ -997,7 +997,6 @@ static int __devinit ibmveth_probe(struc
 	SET_MODULE_OWNER(netdev);

 	adapter = netdev->priv;
-	memset(adapter, 0, sizeof(adapter));
 	dev->dev.driver_data = netdev;

 	adapter->vdev = dev;
