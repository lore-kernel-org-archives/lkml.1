Return-Path: <linux-kernel-owner+w=401wt.eu-S1758359AbYCUNxO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758359AbYCUNxO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2008 09:53:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756141AbYCUNw6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Mar 2008 09:52:58 -0400
Received: from styx.suse.cz ([82.119.242.94]:37868 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753753AbYCUNw5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2008 09:52:57 -0400
From: Libor Pechacek <lpechacek@suse.cz>
To: fubar@us.ibm.com
Subject: [PATCH] bonding: Fix sysfs attribute handling
Date: Fri, 21 Mar 2008 14:52:55 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: bonding-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <200803211452.55982.lpechacek@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

bonding: Fix sysfs attribute handling

For bonding interfaces any attempt to read the sysfs directory contents after
module removal results in an oops.  The fix is to release sysfs attributes
for the interfaces upon module unload.

Signed-off-by: Libor Pechacek <lpechacek@suse.cz>
--
 drivers/net/bonding/bond_main.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index 0942d82..33767d4 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -4528,8 +4528,7 @@ static void bond_free_all(void)
 		netif_tx_unlock_bh(bond_dev);
 		/* Release the bonded slaves */
 		bond_release_all(bond_dev);
-		bond_deinit(bond_dev);
-		unregister_netdevice(bond_dev);
+		bond_destroy(bond);
 	}
 
 #ifdef CONFIG_PROC_FS
