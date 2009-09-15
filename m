Return-Path: <linux-kernel-owner+w=401wt.eu-S1758456AbZIOTP2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758456AbZIOTP2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Sep 2009 15:15:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758563AbZIOTPV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Sep 2009 15:15:21 -0400
Received: from kroah.org ([198.145.64.141]:33042 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758524AbZIOTO5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Sep 2009 15:14:57 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: David Brownell <dbrownell@users.sourceforge.net>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 05/20] driver model: constify attribute groups
Date: Tue, 15 Sep 2009 12:12:41 -0700
Message-Id: <1253041976-1111-5-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <20090915181247.GA32167@kroah.com>
References: <20090915181247.GA32167@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Brownell <dbrownell@users.sourceforge.net>

Let attribute group vectors be declared "const".  We'd
like to let most attribute metadata live in read-only
sections... this is a start.

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 block/genhd.c                              |    2 +-
 drivers/base/core.c                        |    4 ++--
 drivers/base/driver.c                      |    4 ++--
 drivers/block/cciss.c                      |    2 +-
 drivers/firewire/core-device.c             |    2 +-
 drivers/firmware/dmi-id.c                  |    2 +-
 drivers/infiniband/hw/ehca/ehca_main.c     |    2 +-
 drivers/infiniband/hw/ipath/ipath_kernel.h |    2 +-
 drivers/infiniband/hw/ipath/ipath_sysfs.c  |    2 +-
 drivers/input/input.c                      |    2 +-
 drivers/misc/enclosure.c                   |    4 ++--
 drivers/mmc/core/mmc.c                     |    2 +-
 drivers/mmc/core/sd.c                      |    2 +-
 drivers/mtd/mtdcore.c                      |    2 +-
 drivers/s390/cio/css.c                     |    2 +-
 drivers/s390/cio/device.c                  |    2 +-
 drivers/s390/net/netiucv.c                 |    2 +-
 drivers/scsi/scsi_priv.h                   |    2 +-
 drivers/scsi/scsi_sysfs.c                  |    4 ++--
 drivers/usb/core/endpoint.c                |    2 +-
 drivers/usb/core/sysfs.c                   |    4 ++--
 drivers/usb/core/usb.h                     |    4 ++--
 drivers/uwb/lc-dev.c                       |    2 +-
 fs/partitions/check.c                      |    2 +-
 include/linux/attribute_container.h        |    2 +-
 include/linux/device.h                     |    6 +++---
 include/linux/netdevice.h                  |    2 +-
 include/linux/transport_class.h            |    2 +-
 net/bluetooth/hci_sysfs.c                  |    4 ++--
 net/core/net-sysfs.c                       |    2 +-
 30 files changed, 39 insertions(+), 39 deletions(-)

diff --git a/block/genhd.c b/block/genhd.c
index 5b76bf5..2ad91dd 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -903,7 +903,7 @@ static struct attribute_group disk_attr_group = {
 	.attrs = disk_attrs,
 };
 
-static struct attribute_group *disk_attr_groups[] = {
+static const struct attribute_group *disk_attr_groups[] = {
 	&disk_attr_group,
 	NULL
 };
diff --git a/drivers/base/core.c b/drivers/base/core.c
index 99dfe96..a992985 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -341,7 +341,7 @@ static void device_remove_attributes(struct device *dev,
 }
 
 static int device_add_groups(struct device *dev,
-			     struct attribute_group **groups)
+			     const struct attribute_group **groups)
 {
 	int error = 0;
 	int i;
@@ -361,7 +361,7 @@ static int device_add_groups(struct device *dev,
 }
 
 static void device_remove_groups(struct device *dev,
-				 struct attribute_group **groups)
+				 const struct attribute_group **groups)
 {
 	int i;
 
diff --git a/drivers/base/driver.c b/drivers/base/driver.c
index 8ae0f63..ed2ebd3 100644
--- a/drivers/base/driver.c
+++ b/drivers/base/driver.c
@@ -181,7 +181,7 @@ void put_driver(struct device_driver *drv)
 EXPORT_SYMBOL_GPL(put_driver);
 
 static int driver_add_groups(struct device_driver *drv,
-			     struct attribute_group **groups)
+			     const struct attribute_group **groups)
 {
 	int error = 0;
 	int i;
@@ -201,7 +201,7 @@ static int driver_add_groups(struct device_driver *drv,
 }
 
 static void driver_remove_groups(struct device_driver *drv,
-				 struct attribute_group **groups)
+				 const struct attribute_group **groups)
 {
 	int i;
 
diff --git a/drivers/block/cciss.c b/drivers/block/cciss.c
index 0589dfb..d8372b4 100644
--- a/drivers/block/cciss.c
+++ b/drivers/block/cciss.c
@@ -572,7 +572,7 @@ static struct attribute_group cciss_dev_attr_group = {
 	.attrs = cciss_dev_attrs,
 };
 
-static struct attribute_group *cciss_dev_attr_groups[] = {
+static const struct attribute_group *cciss_dev_attr_groups[] = {
 	&cciss_dev_attr_group,
 	NULL
 };
diff --git a/drivers/firewire/core-device.c b/drivers/firewire/core-device.c
index 97e656a..9d0dfcb 100644
--- a/drivers/firewire/core-device.c
+++ b/drivers/firewire/core-device.c
@@ -312,7 +312,7 @@ static void init_fw_attribute_group(struct device *dev,
 	group->groups[0] = &group->group;
 	group->groups[1] = NULL;
 	group->group.attrs = group->attrs;
-	dev->groups = group->groups;
+	dev->groups = (const struct attribute_group **) group->groups;
 }
 
 static ssize_t modalias_show(struct device *dev,
diff --git a/drivers/firmware/dmi-id.c b/drivers/firmware/dmi-id.c
index 5a76d05..dbdf6fa 100644
--- a/drivers/firmware/dmi-id.c
+++ b/drivers/firmware/dmi-id.c
@@ -139,7 +139,7 @@ static struct attribute_group sys_dmi_attribute_group = {
 	.attrs = sys_dmi_attributes,
 };
 
-static struct attribute_group* sys_dmi_attribute_groups[] = {
+static const struct attribute_group* sys_dmi_attribute_groups[] = {
 	&sys_dmi_attribute_group,
 	NULL
 };
diff --git a/drivers/infiniband/hw/ehca/ehca_main.c b/drivers/infiniband/hw/ehca/ehca_main.c
index 5b635aa..fb2d83c 100644
--- a/drivers/infiniband/hw/ehca/ehca_main.c
+++ b/drivers/infiniband/hw/ehca/ehca_main.c
@@ -623,7 +623,7 @@ static struct attribute_group ehca_drv_attr_grp = {
 	.attrs = ehca_drv_attrs
 };
 
-static struct attribute_group *ehca_drv_attr_groups[] = {
+static const struct attribute_group *ehca_drv_attr_groups[] = {
 	&ehca_drv_attr_grp,
 	NULL,
 };
diff --git a/drivers/infiniband/hw/ipath/ipath_kernel.h b/drivers/infiniband/hw/ipath/ipath_kernel.h
index 6ba4861..b3d7efc 100644
--- a/drivers/infiniband/hw/ipath/ipath_kernel.h
+++ b/drivers/infiniband/hw/ipath/ipath_kernel.h
@@ -1286,7 +1286,7 @@ struct device_driver;
 
 extern const char ib_ipath_version[];
 
-extern struct attribute_group *ipath_driver_attr_groups[];
+extern const struct attribute_group *ipath_driver_attr_groups[];
 
 int ipath_device_create_group(struct device *, struct ipath_devdata *);
 void ipath_device_remove_group(struct device *, struct ipath_devdata *);
diff --git a/drivers/infiniband/hw/ipath/ipath_sysfs.c b/drivers/infiniband/hw/ipath/ipath_sysfs.c
index a6c8efb..b8cb2f1 100644
--- a/drivers/infiniband/hw/ipath/ipath_sysfs.c
+++ b/drivers/infiniband/hw/ipath/ipath_sysfs.c
@@ -1069,7 +1069,7 @@ static ssize_t show_tempsense(struct device *dev,
 	return ret;
 }
 
-struct attribute_group *ipath_driver_attr_groups[] = {
+const struct attribute_group *ipath_driver_attr_groups[] = {
 	&driver_attr_group,
 	NULL,
 };
diff --git a/drivers/input/input.c b/drivers/input/input.c
index 7c237e6..851791d 100644
--- a/drivers/input/input.c
+++ b/drivers/input/input.c
@@ -1144,7 +1144,7 @@ static struct attribute_group input_dev_caps_attr_group = {
 	.attrs	= input_dev_caps_attrs,
 };
 
-static struct attribute_group *input_dev_attr_groups[] = {
+static const struct attribute_group *input_dev_attr_groups[] = {
 	&input_dev_attr_group,
 	&input_dev_id_attr_group,
 	&input_dev_caps_attr_group,
diff --git a/drivers/misc/enclosure.c b/drivers/misc/enclosure.c
index 7b03930..e9eae4a 100644
--- a/drivers/misc/enclosure.c
+++ b/drivers/misc/enclosure.c
@@ -238,7 +238,7 @@ static void enclosure_component_release(struct device *dev)
 	put_device(dev->parent);
 }
 
-static struct attribute_group *enclosure_groups[];
+static const struct attribute_group *enclosure_groups[];
 
 /**
  * enclosure_component_register - add a particular component to an enclosure
@@ -536,7 +536,7 @@ static struct attribute_group enclosure_group = {
 	.attrs = enclosure_component_attrs,
 };
 
-static struct attribute_group *enclosure_groups[] = {
+static const struct attribute_group *enclosure_groups[] = {
 	&enclosure_group,
 	NULL
 };
diff --git a/drivers/mmc/core/mmc.c b/drivers/mmc/core/mmc.c
index 06084db..2fb9d5f 100644
--- a/drivers/mmc/core/mmc.c
+++ b/drivers/mmc/core/mmc.c
@@ -276,7 +276,7 @@ static struct attribute_group mmc_std_attr_group = {
 	.attrs = mmc_std_attrs,
 };
 
-static struct attribute_group *mmc_attr_groups[] = {
+static const struct attribute_group *mmc_attr_groups[] = {
 	&mmc_std_attr_group,
 	NULL,
 };
diff --git a/drivers/mmc/core/sd.c b/drivers/mmc/core/sd.c
index cd81c39..7ad646f 100644
--- a/drivers/mmc/core/sd.c
+++ b/drivers/mmc/core/sd.c
@@ -314,7 +314,7 @@ static struct attribute_group sd_std_attr_group = {
 	.attrs = sd_std_attrs,
 };
 
-static struct attribute_group *sd_attr_groups[] = {
+static const struct attribute_group *sd_attr_groups[] = {
 	&sd_std_attr_group,
 	NULL,
 };
diff --git a/drivers/mtd/mtdcore.c b/drivers/mtd/mtdcore.c
index 00ebf7a..69007a6 100644
--- a/drivers/mtd/mtdcore.c
+++ b/drivers/mtd/mtdcore.c
@@ -217,7 +217,7 @@ struct attribute_group mtd_group = {
 	.attrs		= mtd_attrs,
 };
 
-struct attribute_group *mtd_groups[] = {
+const struct attribute_group *mtd_groups[] = {
 	&mtd_group,
 	NULL,
 };
diff --git a/drivers/s390/cio/css.c b/drivers/s390/cio/css.c
index e995123..393c73c 100644
--- a/drivers/s390/cio/css.c
+++ b/drivers/s390/cio/css.c
@@ -266,7 +266,7 @@ static struct attribute_group subch_attr_group = {
 	.attrs = subch_attrs,
 };
 
-static struct attribute_group *default_subch_attr_groups[] = {
+static const struct attribute_group *default_subch_attr_groups[] = {
 	&subch_attr_group,
 	NULL,
 };
diff --git a/drivers/s390/cio/device.c b/drivers/s390/cio/device.c
index 0f95405..6527f3f 100644
--- a/drivers/s390/cio/device.c
+++ b/drivers/s390/cio/device.c
@@ -656,7 +656,7 @@ static struct attribute_group ccwdev_attr_group = {
 	.attrs = ccwdev_attrs,
 };
 
-static struct attribute_group *ccwdev_attr_groups[] = {
+static const struct attribute_group *ccwdev_attr_groups[] = {
 	&ccwdev_attr_group,
 	NULL,
 };
diff --git a/drivers/s390/net/netiucv.c b/drivers/s390/net/netiucv.c
index 9215fbb..a4b2c57 100644
--- a/drivers/s390/net/netiucv.c
+++ b/drivers/s390/net/netiucv.c
@@ -2159,7 +2159,7 @@ static struct attribute_group netiucv_drv_attr_group = {
 	.attrs = netiucv_drv_attrs,
 };
 
-static struct attribute_group *netiucv_drv_attr_groups[] = {
+static const struct attribute_group *netiucv_drv_attr_groups[] = {
 	&netiucv_drv_attr_group,
 	NULL,
 };
diff --git a/drivers/scsi/scsi_priv.h b/drivers/scsi/scsi_priv.h
index 021e503..1fbf7c7 100644
--- a/drivers/scsi/scsi_priv.h
+++ b/drivers/scsi/scsi_priv.h
@@ -132,7 +132,7 @@ extern struct scsi_transport_template blank_transport_template;
 extern void __scsi_remove_device(struct scsi_device *);
 
 extern struct bus_type scsi_bus_type;
-extern struct attribute_group *scsi_sysfs_shost_attr_groups[];
+extern const struct attribute_group *scsi_sysfs_shost_attr_groups[];
 
 /* scsi_netlink.c */
 #ifdef CONFIG_SCSI_NETLINK
diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index 91482f2..fde5453 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -275,7 +275,7 @@ struct attribute_group scsi_shost_attr_group = {
 	.attrs =	scsi_sysfs_shost_attrs,
 };
 
-struct attribute_group *scsi_sysfs_shost_attr_groups[] = {
+const struct attribute_group *scsi_sysfs_shost_attr_groups[] = {
 	&scsi_shost_attr_group,
 	NULL
 };
@@ -745,7 +745,7 @@ static struct attribute_group scsi_sdev_attr_group = {
 	.attrs =	scsi_sdev_attrs,
 };
 
-static struct attribute_group *scsi_sdev_attr_groups[] = {
+static const struct attribute_group *scsi_sdev_attr_groups[] = {
 	&scsi_sdev_attr_group,
 	NULL
 };
diff --git a/drivers/usb/core/endpoint.c b/drivers/usb/core/endpoint.c
index bc39fc4..fdfaa78 100644
--- a/drivers/usb/core/endpoint.c
+++ b/drivers/usb/core/endpoint.c
@@ -154,7 +154,7 @@ static struct attribute *ep_dev_attrs[] = {
 static struct attribute_group ep_dev_attr_grp = {
 	.attrs = ep_dev_attrs,
 };
-static struct attribute_group *ep_dev_groups[] = {
+static const struct attribute_group *ep_dev_groups[] = {
 	&ep_dev_attr_grp,
 	NULL
 };
diff --git a/drivers/usb/core/sysfs.c b/drivers/usb/core/sysfs.c
index b5c72e4..7ec3041 100644
--- a/drivers/usb/core/sysfs.c
+++ b/drivers/usb/core/sysfs.c
@@ -573,7 +573,7 @@ static struct attribute_group dev_string_attr_grp = {
 	.is_visible =	dev_string_attrs_are_visible,
 };
 
-struct attribute_group *usb_device_groups[] = {
+const struct attribute_group *usb_device_groups[] = {
 	&dev_attr_grp,
 	&dev_string_attr_grp,
 	NULL
@@ -799,7 +799,7 @@ static struct attribute_group intf_assoc_attr_grp = {
 	.is_visible =	intf_assoc_attrs_are_visible,
 };
 
-struct attribute_group *usb_interface_groups[] = {
+const struct attribute_group *usb_interface_groups[] = {
 	&intf_attr_grp,
 	&intf_assoc_attr_grp,
 	NULL
diff --git a/drivers/usb/core/usb.h b/drivers/usb/core/usb.h
index e2a8cfa..c0e0ae2 100644
--- a/drivers/usb/core/usb.h
+++ b/drivers/usb/core/usb.h
@@ -152,8 +152,8 @@ static inline int is_active(const struct usb_interface *f)
 extern const char *usbcore_name;
 
 /* sysfs stuff */
-extern struct attribute_group *usb_device_groups[];
-extern struct attribute_group *usb_interface_groups[];
+extern const struct attribute_group *usb_device_groups[];
+extern const struct attribute_group *usb_interface_groups[];
 
 /* usbfs stuff */
 extern struct mutex usbfs_mutex;
diff --git a/drivers/uwb/lc-dev.c b/drivers/uwb/lc-dev.c
index e9fe1bb..1097e81 100644
--- a/drivers/uwb/lc-dev.c
+++ b/drivers/uwb/lc-dev.c
@@ -255,7 +255,7 @@ static struct attribute_group dev_attr_group = {
 	.attrs = dev_attrs,
 };
 
-static struct attribute_group *groups[] = {
+static const struct attribute_group *groups[] = {
 	&dev_attr_group,
 	NULL,
 };
diff --git a/fs/partitions/check.c b/fs/partitions/check.c
index 619ba99..fbeaddf 100644
--- a/fs/partitions/check.c
+++ b/fs/partitions/check.c
@@ -312,7 +312,7 @@ static struct attribute_group part_attr_group = {
 	.attrs = part_attrs,
 };
 
-static struct attribute_group *part_attr_groups[] = {
+static const struct attribute_group *part_attr_groups[] = {
 	&part_attr_group,
 #ifdef CONFIG_BLK_DEV_IO_TRACE
 	&blk_trace_attr_group,
diff --git a/include/linux/attribute_container.h b/include/linux/attribute_container.h
index 794ad74..c3ab814 100644
--- a/include/linux/attribute_container.h
+++ b/include/linux/attribute_container.h
@@ -17,7 +17,7 @@ struct attribute_container {
 	struct list_head	node;
 	struct klist		containers;
 	struct class		*class;
-	struct attribute_group	*grp;
+	const struct attribute_group *grp;
 	struct device_attribute **attrs;
 	int (*match)(struct attribute_container *, struct device *);
 #define	ATTRIBUTE_CONTAINER_NO_CLASSDEVS	0x01
diff --git a/include/linux/device.h b/include/linux/device.h
index 3f33f17..e19e40a 100644
--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -131,7 +131,7 @@ struct device_driver {
 	void (*shutdown) (struct device *dev);
 	int (*suspend) (struct device *dev, pm_message_t state);
 	int (*resume) (struct device *dev);
-	struct attribute_group **groups;
+	const struct attribute_group **groups;
 
 	const struct dev_pm_ops *pm;
 
@@ -288,7 +288,7 @@ extern void class_destroy(struct class *cls);
  */
 struct device_type {
 	const char *name;
-	struct attribute_group **groups;
+	const struct attribute_group **groups;
 	int (*uevent)(struct device *dev, struct kobj_uevent_env *env);
 	char *(*nodename)(struct device *dev);
 	void (*release)(struct device *dev);
@@ -412,7 +412,7 @@ struct device {
 
 	struct klist_node	knode_class;
 	struct class		*class;
-	struct attribute_group	**groups;	/* optional groups */
+	const struct attribute_group **groups;	/* optional groups */
 
 	void	(*release)(struct device *dev);
 };
diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 65ee192..a9aa4b5 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -895,7 +895,7 @@ struct net_device
 	/* class/net/name entry */
 	struct device		dev;
 	/* space for optional statistics and wireless sysfs groups */
-	struct attribute_group  *sysfs_groups[3];
+	const struct attribute_group *sysfs_groups[3];
 
 	/* rtnetlink link ops */
 	const struct rtnl_link_ops *rtnl_link_ops;
diff --git a/include/linux/transport_class.h b/include/linux/transport_class.h
index eaec1ea..9ae8da3 100644
--- a/include/linux/transport_class.h
+++ b/include/linux/transport_class.h
@@ -55,7 +55,7 @@ struct anon_transport_class cls = {				\
 
 struct transport_container {
 	struct attribute_container ac;
-	struct attribute_group *statistics;
+	const struct attribute_group *statistics;
 };
 
 #define attribute_container_to_transport_container(x) \
diff --git a/net/bluetooth/hci_sysfs.c b/net/bluetooth/hci_sysfs.c
index 95f7a7a..7f939ce 100644
--- a/net/bluetooth/hci_sysfs.c
+++ b/net/bluetooth/hci_sysfs.c
@@ -68,7 +68,7 @@ static struct attribute_group bt_link_group = {
 	.attrs = bt_link_attrs,
 };
 
-static struct attribute_group *bt_link_groups[] = {
+static const struct attribute_group *bt_link_groups[] = {
 	&bt_link_group,
 	NULL
 };
@@ -392,7 +392,7 @@ static struct attribute_group bt_host_group = {
 	.attrs = bt_host_attrs,
 };
 
-static struct attribute_group *bt_host_groups[] = {
+static const struct attribute_group *bt_host_groups[] = {
 	&bt_host_group,
 	NULL
 };
diff --git a/net/core/net-sysfs.c b/net/core/net-sysfs.c
index ad91e9e..7d4c575 100644
--- a/net/core/net-sysfs.c
+++ b/net/core/net-sysfs.c
@@ -493,7 +493,7 @@ void netdev_unregister_kobject(struct net_device * net)
 int netdev_register_kobject(struct net_device *net)
 {
 	struct device *dev = &(net->dev);
-	struct attribute_group **groups = net->sysfs_groups;
+	const struct attribute_group **groups = net->sysfs_groups;
 
 	dev->class = &net_class;
 	dev->platform_data = net;
-- 
1.6.4.2

