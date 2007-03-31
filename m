Return-Path: <linux-kernel-owner+w=401wt.eu-S1751744AbXCaUzi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751744AbXCaUzi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Mar 2007 16:55:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751894AbXCaUzg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 Mar 2007 16:55:36 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:39482 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751024AbXCaUzf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Mar 2007 16:55:35 -0400
Date: Sat, 31 Mar 2007 22:55:35 +0200
From: Adrian Bunk <bunk@stusta.de>
To: ctindel@users.sourceforge.net, fubar@us.ibm.com
Cc: bonding-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Subject: [2.6 patch] bonding/bond_main.c: make 2 functions static
Message-ID: <20070331205535.GA14134@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch makes two needleesly global functions static.

Signed-off-by: Adrian Bunk <bunk@stusta.de>

---

 drivers/net/bonding/bond_main.c |    5 +++--
 drivers/net/bonding/bonding.h   |    2 --
 2 files changed, 3 insertions(+), 4 deletions(-)

--- linux-2.6.21-rc5-mm3/drivers/net/bonding/bonding.h.old	2007-03-31 21:12:31.000000000 +0200
+++ linux-2.6.21-rc5-mm3/drivers/net/bonding/bonding.h	2007-03-31 21:12:42.000000000 +0200
@@ -301,13 +301,11 @@
 void bond_destroy_slave_symlinks(struct net_device *master, struct net_device *slave);
 int bond_enslave(struct net_device *bond_dev, struct net_device *slave_dev);
 int bond_release(struct net_device *bond_dev, struct net_device *slave_dev);
-int bond_sethwaddr(struct net_device *bond_dev, struct net_device *slave_dev);
 void bond_mii_monitor(struct net_device *bond_dev);
 void bond_loadbalance_arp_mon(struct net_device *bond_dev);
 void bond_activebackup_arp_mon(struct net_device *bond_dev);
 void bond_set_mode_ops(struct bonding *bond, int mode);
 int bond_parse_parm(char *mode_arg, struct bond_parm_tbl *tbl);
-const char *bond_mode_name(int mode);
 void bond_select_active_slave(struct bonding *bond);
 void bond_change_active_slave(struct bonding *bond, struct slave *new_active);
 void bond_register_arp(struct bonding *);
--- linux-2.6.21-rc5-mm3/drivers/net/bonding/bond_main.c.old	2007-03-31 21:12:50.000000000 +0200
+++ linux-2.6.21-rc5-mm3/drivers/net/bonding/bond_main.c	2007-03-31 21:13:16.000000000 +0200
@@ -187,7 +187,7 @@
 
 /*---------------------------- General routines -----------------------------*/
 
-const char *bond_mode_name(int mode)
+static const char *bond_mode_name(int mode)
 {
 	switch (mode) {
 	case BOND_MODE_ROUNDROBIN :
@@ -1224,7 +1224,8 @@
 
 /*---------------------------------- IOCTL ----------------------------------*/
 
-int bond_sethwaddr(struct net_device *bond_dev, struct net_device *slave_dev)
+static int bond_sethwaddr(struct net_device *bond_dev,
+			  struct net_device *slave_dev)
 {
 	dprintk("bond_dev=%p\n", bond_dev);
 	dprintk("slave_dev=%p\n", slave_dev);

