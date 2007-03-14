Return-Path: <linux-kernel-owner+w=401wt.eu-S933901AbXCNJEY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933901AbXCNJEY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2007 05:04:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933904AbXCNJEY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Mar 2007 05:04:24 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:57593 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933901AbXCNJEX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2007 05:04:23 -0400
To: torvalds@linux-foundation.org
Subject: [PATCH 1/13] ibmtr probe is __devinit, not __init
Cc: linux-kernel@vger.kernel.org, ralf@linux-mips.org
Message-Id: <E1HRPPB-0001pF-NP@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Date: Wed, 14 Mar 2007 09:04:21 +0000
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


used by ->attach() in pcmcia analog

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 drivers/net/pcmcia/ibmtr_cs.c |    4 ++--
 drivers/net/tokenring/ibmtr.c |    4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/pcmcia/ibmtr_cs.c b/drivers/net/pcmcia/ibmtr_cs.c
index a956a51..1060154 100644
--- a/drivers/net/pcmcia/ibmtr_cs.c
+++ b/drivers/net/pcmcia/ibmtr_cs.c
@@ -138,7 +138,7 @@ static const struct ethtool_ops netdev_ethtool_ops = {
 
 ======================================================================*/
 
-static int ibmtr_attach(struct pcmcia_device *link)
+static int __devinit ibmtr_attach(struct pcmcia_device *link)
 {
     ibmtr_dev_t *info;
     struct net_device *dev;
@@ -217,7 +217,7 @@ static void ibmtr_detach(struct pcmcia_device *link)
 #define CS_CHECK(fn, ret) \
 do { last_fn = (fn); if ((last_ret = (ret)) != 0) goto cs_failed; } while (0)
 
-static int ibmtr_config(struct pcmcia_device *link)
+static int __devinit ibmtr_config(struct pcmcia_device *link)
 {
     ibmtr_dev_t *info = link->priv;
     struct net_device *dev = info->dev;
diff --git a/drivers/net/tokenring/ibmtr.c b/drivers/net/tokenring/ibmtr.c
index 36202e9..01d5531 100644
--- a/drivers/net/tokenring/ibmtr.c
+++ b/drivers/net/tokenring/ibmtr.c
@@ -346,7 +346,7 @@ static void ibmtr_cleanup_card(struct net_device *dev)
  *	which references it.
  ****************************************************************************/
 
-static int __init ibmtr_probe(struct net_device *dev)
+static int __devinit ibmtr_probe(struct net_device *dev)
 {
 	int i;
 	int base_addr = dev->base_addr;
@@ -366,7 +366,7 @@ static int __init ibmtr_probe(struct net_device *dev)
 	return -ENODEV;
 }
 
-int __init ibmtr_probe_card(struct net_device *dev)
+int __devinit ibmtr_probe_card(struct net_device *dev)
 {
 	int err = ibmtr_probe(dev);
 	if (!err) {
-- 
1.5.0-rc2.GIT


