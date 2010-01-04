Return-Path: <linux-kernel-owner+w=401wt.eu-S1754022Ab0ADWhT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754022Ab0ADWhT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jan 2010 17:37:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753903Ab0ADWhJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jan 2010 17:37:09 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:39007
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753619Ab0ADWhE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jan 2010 17:37:04 -0500
Date: Mon, 04 Jan 2010 14:37:05 -0800 (PST)
Message-Id: <20100104.143705.179916049.davem@davemloft.net>
To: sfr@canb.auug.org.au
Cc: netdev@vger.kernel.org, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, rakesh@chelsio.com,
       James.Bottomley@HansenPartnership.com
Subject: Re: linux-next: manual merge of the net-current tree with the
 scsi-rc-fixes tree
From: David Miller <davem@davemloft.net>
In-Reply-To: <20100105085613.0a04d952.sfr@canb.auug.org.au>
References: <20100105085613.0a04d952.sfr@canb.auug.org.au>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Tue, 5 Jan 2010 08:56:13 +1100

> Today's linux-next merge of the net-current tree got a conflict in
> drivers/scsi/cxgb3i/cxgb3i_offload.c between commit
> 44214ab474671e1ab5a860954db413bce52f7e04 ("[SCSI] cxgb3i: Fix a login
> over vlan issue") from the scsi-rc-fixes tree and commit
> 52ee264bca378835decb827d18b1d90b709ca4c9 ("cxgb3i: Fix a login over vlan
> issue") from the net-current tree.
> 
> These seem to be different version of the same change.  The version in
> the net-current tree looks wrong - it contains
> 
> if (dev->priv_flags && IFF_802_1Q_VLAN)
> 
> but it presumably should be
> 
> if (dev->priv_flags & IFF_802_1Q_VLAN)
> 
> as in the scsi-rc-fixes version.

I checked the following into my tree so it should all work out.

commit d3af9dd04f8795dc2761ecfa56632e4d0df0dae2
Author: David S. Miller <davem@davemloft.net>
Date:   Mon Jan 4 14:36:40 2010 -0800

    cxgb3i: Fix flags test.
    
    As noticed by Stephen Rothwell.
    
    Signed-off-by: David S. Miller <davem@davemloft.net>

diff --git a/drivers/scsi/cxgb3i/cxgb3i_offload.c b/drivers/scsi/cxgb3i/cxgb3i_offload.c
index 4b8a513..7449d46 100644
--- a/drivers/scsi/cxgb3i/cxgb3i_offload.c
+++ b/drivers/scsi/cxgb3i/cxgb3i_offload.c
@@ -1442,7 +1442,7 @@ static int is_cxgb3_dev(struct net_device *dev)
 	struct cxgb3i_sdev_data *cdata;
 	struct net_device *ndev = dev;
 
-	if (dev->priv_flags && IFF_802_1Q_VLAN)
+	if (dev->priv_flags & IFF_802_1Q_VLAN)
 		ndev = vlan_dev_real_dev(dev);
 
 	write_lock(&cdata_rwlock);
