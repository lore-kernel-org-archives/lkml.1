Return-Path: <linux-kernel-owner+w=401wt.eu-S1756603AbYJVPYe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756603AbYJVPYe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 11:24:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755998AbYJVPXn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 11:23:43 -0400
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:37073 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755966AbYJVPXm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 11:23:42 -0400
Message-Id: <20081022152144.944690300@theryb.frec.bull.fr>
References: <20081022152144.351965414@theryb.frec.bull.fr>
User-Agent: quilt/0.46-1
Date: Wed, 22 Oct 2008 17:22:14 +0200
From: Benjamin Thery <benjamin.thery@bull.net>
To: netdev <netdev@vger.kernel.org>, Dave Miller <davem@davemloft.net>
Cc: Eric Biederman <ebiederm@xmission.com>,
       Greg Kroah-Hartman <gregkh@suse.de>, Al Viro <viro@ftp.linux.org.uk>,
       Serge Hallyn <serue@us.ibm.com>, Daniel Lezcano <dlezcano@fr.ibm.com>,
       linux-kernel@vger.kernel.org, Tejun Heo <htejun@gmail.com>,
       Denis Lunev <den@openvz.org>,
       Linux Containers <containers@lists.linux-foundation.org>,
       Benjamin Thery <benjamin.thery@bull.net>
Subject: [PATCH 3/4] net: cleanup some vars names to be more consistant with
 the network code
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This small patch renames a couple of net_device variables from 
'net' to 'netdev' to avoid confusion with 'struct net' variables
that will be introduced in the next patch. 
'net' is commonly used to designate 'struct net' in the rest of 
the network code.

Signed-off-by: Benjamin Thery <benjamin.thery@bull.net>
Acked-by: Serge Hallyn <serue@us.ibm.com>
---
 net/core/net-sysfs.c |   17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

Index: net-next-2.6/net/core/net-sysfs.c
===================================================================
--- net-next-2.6.orig/net/core/net-sysfs.c
+++ net-next-2.6/net/core/net-sysfs.c
@@ -471,32 +471,33 @@ static struct class net_class = {
 /* Delete sysfs entries but hold kobject reference until after all
  * netdev references are gone.
  */
-void netdev_unregister_kobject(struct net_device * net)
+void netdev_unregister_kobject(struct net_device *netdev)
 {
-	struct device *dev = &(net->dev);
+	struct device *dev = &(netdev->dev);
 
 	kobject_get(&dev->kobj);
 	device_del(dev);
 }
 
 /* Create sysfs entries for network device. */
-int netdev_register_kobject(struct net_device *net)
+int netdev_register_kobject(struct net_device *netdev)
 {
-	struct device *dev = &(net->dev);
-	struct attribute_group **groups = net->sysfs_groups;
+	struct device *dev = &(netdev->dev);
+	struct attribute_group **groups = netdev->sysfs_groups;
 
 	dev->class = &net_class;
-	dev->platform_data = net;
+	dev->platform_data = netdev;
 	dev->groups = groups;
 
 	BUILD_BUG_ON(BUS_ID_SIZE < IFNAMSIZ);
-	strlcpy(dev->bus_id, net->name, BUS_ID_SIZE);
+	strlcpy(dev->bus_id, netdev->name, BUS_ID_SIZE);
 
 #ifdef CONFIG_SYSFS
 	*groups++ = &netstat_group;
 
 #ifdef CONFIG_WIRELESS_EXT_SYSFS
-	if (net->wireless_handlers && net->wireless_handlers->get_wireless_stats)
+	if (netdev->wireless_handlers &&
+	    netdev->wireless_handlers->get_wireless_stats)
 		*groups++ = &wireless_group;
 #endif
 #endif /* CONFIG_SYSFS */

-- 
