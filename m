Return-Path: <linux-kernel-owner+w=401wt.eu-S1752543AbZISTtZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752543AbZISTtZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Sep 2009 15:49:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752429AbZISTtY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Sep 2009 15:49:24 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:42338 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752073AbZISTtX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Sep 2009 15:49:23 -0400
Date: Sat, 19 Sep 2009 21:49:24 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: hal.rosenstock@gmail.com, Sean Hefty <sean.hefty@intel.com>,
       Roland Dreier <rolandd@cisco.com>,
       Chien Tung <chien.tin.tung@intel.com>,
       Faisal Latif <faisal.latif@intel.com>, linux-rdma@vger.kernel.org,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH 4/5] drivers/infiniband: remove duplicate structure field
 initialization
Message-ID: <Pine.LNX.4.64.0909192149040.27171@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

The definition of nes_netdev_ops has initializations of a local function
and eth_mac_addr for its ndo_set_mac_address field.  This change uses only
the local function.

The semantic match that finds this problem is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@r@
identifier I, s, fld;
position p0,p;
expression E;
@@

struct I s =@p0 { ... .fld@p = E, ...};

@s@
identifier I, s, r.fld;
position r.p0,p;
expression E;
@@

struct I s =@p0 { ... .fld@p = E, ...};

@script:python@
p0 << r.p0;
fld << r.fld;
ps << s.p;
pr << r.p;
@@

if int(ps[0].line)!=int(pr[0].line) or int(ps[0].column)!=int(pr[0].column):
  cocci.print_main(fld,p0)
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 drivers/infiniband/hw/nes/nes_nic.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/infiniband/hw/nes/nes_nic.c b/drivers/infiniband/hw/nes/nes_nic.c
index 538e409..e593af3 100644
--- a/drivers/infiniband/hw/nes/nes_nic.c
+++ b/drivers/infiniband/hw/nes/nes_nic.c
@@ -1566,7 +1566,6 @@ static const struct net_device_ops nes_netdev_ops = {
 	.ndo_set_mac_address	= nes_netdev_set_mac_address,
 	.ndo_set_multicast_list = nes_netdev_set_multicast_list,
 	.ndo_change_mtu		= nes_netdev_change_mtu,
-	.ndo_set_mac_address 	= eth_mac_addr,
 	.ndo_validate_addr	= eth_validate_addr,
 	.ndo_vlan_rx_register 	= nes_netdev_vlan_rx_register,
 };
