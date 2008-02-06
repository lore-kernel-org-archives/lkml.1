Return-Path: <linux-kernel-owner+w=401wt.eu-S1761086AbYBFWrM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761086AbYBFWrM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2008 17:47:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757709AbYBFWq4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Feb 2008 17:46:56 -0500
Received: from mk-filter-1-a-1.mail.uk.tiscali.com ([212.74.100.52]:8886 "EHLO
	mk-filter-1-a-1.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757300AbYBFWqw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2008 17:46:52 -0500
X-Trace: 660075038/mk-filter-1.mail.uk.tiscali.com/B2C/$THROTTLED-DYNAMIC/CUSTOMER-DYNAMIC-IP/81.1.89.66
X-SBRS: None
X-RemoteIP: 81.1.89.66
X-IP-MAIL-FROM: adrian@newgolddream.dyndns.info
X-IP-BHB: Once
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ah4FAO/HqUdRAVlC/2dsb2JhbACBWatSgXY
Subject: [PATCH 1/2] - SH/Dreamcast - fix maple bus bugs
From: Adrian McMenamin <adrian@newgolddream.dyndns.info>
To: Paul Mundt <lethal@linux-sh.org>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-sh <linux-sh@vger.kernel.org>,
       Greg KH <greg@kroah.com>
Content-Type: text/plain
Date: Wed, 06 Feb 2008 22:46:21 +0000
Message-Id: <1202337981.6162.8.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch is fundamentally about fixing up the whitespace problems introduced by my previous patch (that brought the code into mainline). A second patch will follow that will fix memory leaks. The two need to be applied sequentially.

Signed-off by: Adrian McMenamin <adrian@mcmen.demon.co.uk>

---

diff --git a/drivers/sh/maple/maple.c b/drivers/sh/maple/maple.c
index 37c0bf7..3f341dc 100644
--- a/drivers/sh/maple/maple.c
+++ b/drivers/sh/maple/maple.c
@@ -56,8 +56,8 @@ static int started, scanning, liststatus;
 static struct kmem_cache *maple_queue_cache;
 
 struct maple_device_specify {
-       int port;
-       int unit;
+	int port;
+	int unit;
 };
 
 /**
@@ -67,22 +67,23 @@ struct maple_device_specify {
  */
 int maple_driver_register(struct device_driver *drv)
 {
-       if (!drv)
-               return -EINVAL;
-       drv->bus = &maple_bus_type;
-       return driver_register(drv);
+	if (!drv)
+		return -EINVAL;
+	drv->bus = &maple_bus_type;
+	return driver_register(drv);
 }
+
 EXPORT_SYMBOL_GPL(maple_driver_register);
 
 /* set hardware registers to enable next round of dma */
 static void maplebus_dma_reset(void)
 {
-       ctrl_outl(MAPLE_MAGIC, MAPLE_RESET);
-       /* set trig type to 0 for software trigger, 1 for hardware (VBLANK) */
-       ctrl_outl(1, MAPLE_TRIGTYPE);
-       ctrl_outl(MAPLE_2MBPS | MAPLE_TIMEOUT(50000), MAPLE_SPEED);
-       ctrl_outl(PHYSADDR(maple_sendbuf), MAPLE_DMAADDR);
-       ctrl_outl(1, MAPLE_ENABLE);
+	ctrl_outl(MAPLE_MAGIC, MAPLE_RESET);
+	/* set trig type to 0 for software trigger, 1 for hardware (VBLANK) */
+	ctrl_outl(1, MAPLE_TRIGTYPE);
+	ctrl_outl(MAPLE_2MBPS | MAPLE_TIMEOUT(50000), MAPLE_SPEED);
+	ctrl_outl(PHYSADDR(maple_sendbuf), MAPLE_DMAADDR);
+	ctrl_outl(1, MAPLE_ENABLE);
 }
 
 /**
@@ -93,27 +94,28 @@ static void maplebus_dma_reset(void)
  * @function: the function code for the device
  */
 void maple_getcond_callback(struct maple_device *dev,
-                           void (*callback) (struct mapleq * mq),
-                           unsigned long interval, unsigned long function)
+			    void (*callback) (struct mapleq * mq),
+			    unsigned long interval, unsigned long function)
 {
-       dev->callback = callback;
-       dev->interval = interval;
-       dev->function = cpu_to_be32(function);
-       dev->when = jiffies;
+	dev->callback = callback;
+	dev->interval = interval;
+	dev->function = cpu_to_be32(function);
+	dev->when = jiffies;
 }
+
 EXPORT_SYMBOL_GPL(maple_getcond_callback);
 
 static int maple_dma_done(void)
 {
-       return (ctrl_inl(MAPLE_STATE) & 1) == 0;
+	return (ctrl_inl(MAPLE_STATE) & 1) == 0;
 }
 
 static void maple_release_device(struct device *dev)
 {
-       if (dev->type) {
-               kfree(dev->type->name);
-               kfree(dev->type);
-       }
+	if (dev->type) {
+		kfree(dev->type->name);
+		kfree(dev->type);
+	}
 }
 
 /**
@@ -122,60 +124,61 @@ static void maple_release_device(struct device *dev)
  */
 void maple_add_packet(struct mapleq *mq)
 {
-       mutex_lock(&maple_list_lock);
-       list_add(&mq->list, &maple_waitq);
-       mutex_unlock(&maple_list_lock);
+	mutex_lock(&maple_list_lock);
+	list_add(&mq->list, &maple_waitq);
+	mutex_unlock(&maple_list_lock);
 }
+
 EXPORT_SYMBOL_GPL(maple_add_packet);
 
 static struct mapleq *maple_allocq(struct maple_device *dev)
 {
-       struct mapleq *mq;
+	struct mapleq *mq;
 
-       mq = kmalloc(sizeof(*mq), GFP_KERNEL);
-       if (!mq)
-               return NULL;
+	mq = kmalloc(sizeof(*mq), GFP_KERNEL);
+	if (!mq)
+		return NULL;
 
-       mq->dev = dev;
-       mq->recvbufdcsp = kmem_cache_zalloc(maple_queue_cache, GFP_KERNEL);
-       mq->recvbuf = (void *) P2SEGADDR(mq->recvbufdcsp);
-       if (!mq->recvbuf) {
-               kfree(mq);
-               return NULL;
-       }
+	mq->dev = dev;
+	mq->recvbufdcsp = kmem_cache_zalloc(maple_queue_cache, GFP_KERNEL);
+	mq->recvbuf = (void *) P2SEGADDR(mq->recvbufdcsp);
+	if (!mq->recvbuf) {
+		kfree(mq);
+		return NULL;
+	}
 
-       return mq;
+	return mq;
 }
 
 static struct maple_device *maple_alloc_dev(int port, int unit)
 {
-       struct maple_device *dev;
+	struct maple_device *dev;
 
-       dev = kzalloc(sizeof(*dev), GFP_KERNEL);
-       if (!dev)
-               return NULL;
+	dev = kzalloc(sizeof(*dev), GFP_KERNEL);
+	if (!dev)
+		return NULL;
 
-       dev->port = port;
-       dev->unit = unit;
-       dev->mq = maple_allocq(dev);
+	dev->port = port;
+	dev->unit = unit;
+	dev->mq = maple_allocq(dev);
 
-       if (!dev->mq) {
-               kfree(dev);
-               return NULL;
-       }
+	if (!dev->mq) {
+		kfree(dev);
+		return NULL;
+	}
 
-       return dev;
+	return dev;
 }
 
 static void maple_free_dev(struct maple_device *mdev)
 {
-       if (!mdev)
-               return;
-       if (mdev->mq) {
-               kmem_cache_free(maple_queue_cache, mdev->mq->recvbufdcsp);
-               kfree(mdev->mq);
-       }
-       kfree(mdev);
+	if (!mdev)
+		return;
+	if (mdev->mq) {
+		kmem_cache_free(maple_queue_cache, mdev->mq->recvbufdcsp);
+		kfree(mdev->mq);
+	}
+	kfree(mdev);
 }
 
 /* process the command queue into a maple command block
@@ -183,153 +186,153 @@ static void maple_free_dev(struct maple_device *mdev)
  */
 static void maple_build_block(struct mapleq *mq)
 {
-       int port, unit, from, to, len;
-       unsigned long *lsendbuf = mq->sendbuf;
+	int port, unit, from, to, len;
+	unsigned long *lsendbuf = mq->sendbuf;
 
-       port = mq->dev->port & 3;
-       unit = mq->dev->unit;
-       len = mq->length;
-       from = port << 6;
-       to = (port << 6) | (unit > 0 ? (1 << (unit - 1)) & 0x1f : 0x20);
+	port = mq->dev->port & 3;
+	unit = mq->dev->unit;
+	len = mq->length;
+	from = port << 6;
+	to = (port << 6) | (unit > 0 ? (1 << (unit - 1)) & 0x1f : 0x20);
 
-       *maple_lastptr &= 0x7fffffff;
-       maple_lastptr = maple_sendptr;
+	*maple_lastptr &= 0x7fffffff;
+	maple_lastptr = maple_sendptr;
 
-       *maple_sendptr++ = (port << 16) | len | 0x80000000;
-       *maple_sendptr++ = PHYSADDR(mq->recvbuf);
-       *maple_sendptr++ =
-           mq->command | (to << 8) | (from << 16) | (len << 24);
+	*maple_sendptr++ = (port << 16) | len | 0x80000000;
+	*maple_sendptr++ = PHYSADDR(mq->recvbuf);
+	*maple_sendptr++ =
+	    mq->command | (to << 8) | (from << 16) | (len << 24);
 
-       while (len-- > 0)
-               *maple_sendptr++ = *lsendbuf++;
+	while (len-- > 0)
+		*maple_sendptr++ = *lsendbuf++;
 }
 
 /* build up command queue */
 static void maple_send(void)
 {
-       int i;
-       int maple_packets;
-       struct mapleq *mq, *nmq;
-
-       if (!list_empty(&maple_sentq))
-               return;
-       if (list_empty(&maple_waitq) || !maple_dma_done())
-               return;
-       maple_packets = 0;
-       maple_sendptr = maple_lastptr = maple_sendbuf;
-       list_for_each_entry_safe(mq, nmq, &maple_waitq, list) {
-               maple_build_block(mq);
-               list_move(&mq->list, &maple_sentq);
-               if (maple_packets++ > MAPLE_MAXPACKETS)
-                       break;
-       }
-       if (maple_packets > 0) {
-               for (i = 0; i < (1 << MAPLE_DMA_PAGES); i++)
-                       dma_cache_sync(0, maple_sendbuf + i * PAGE_SIZE,
-                                      PAGE_SIZE, DMA_BIDIRECTIONAL);
-       }
+	int i;
+	int maple_packets;
+	struct mapleq *mq, *nmq;
+
+	if (!list_empty(&maple_sentq))
+		return;
+	if (list_empty(&maple_waitq) || !maple_dma_done())
+		return;
+	maple_packets = 0;
+	maple_sendptr = maple_lastptr = maple_sendbuf;
+	list_for_each_entry_safe(mq, nmq, &maple_waitq, list) {
+		maple_build_block(mq);
+		list_move(&mq->list, &maple_sentq);
+		if (maple_packets++ > MAPLE_MAXPACKETS)
+			break;
+	}
+	if (maple_packets > 0) {
+		for (i = 0; i < (1 << MAPLE_DMA_PAGES); i++)
+			dma_cache_sync(0, maple_sendbuf + i * PAGE_SIZE,
+				       PAGE_SIZE, DMA_BIDIRECTIONAL);
+	}
 }
 
 static int attach_matching_maple_driver(struct device_driver *driver,
-                                       void *devptr)
+					void *devptr)
 {
-       struct maple_driver *maple_drv;
-       struct maple_device *mdev;
-
-       mdev = devptr;
-       maple_drv = to_maple_driver(driver);
-       if (mdev->devinfo.function & be32_to_cpu(maple_drv->function)) {
-               if (maple_drv->connect(mdev) == 0) {
-                       mdev->driver = maple_drv;
-                       return 1;
-               }
-       }
-       return 0;
+	struct maple_driver *maple_drv;
+	struct maple_device *mdev;
+
+	mdev = devptr;
+	maple_drv = to_maple_driver(driver);
+	if (mdev->devinfo.function & be32_to_cpu(maple_drv->function)) {
+		if (maple_drv->connect(mdev) == 0) {
+			mdev->driver = maple_drv;
+			return 1;
+		}
+	}
+	return 0;
 }
 
 static void maple_detach_driver(struct maple_device *mdev)
 {
-       if (!mdev)
-               return;
-       if (mdev->driver) {
-               if (mdev->driver->disconnect)
-                       mdev->driver->disconnect(mdev);
-       }
-       mdev->driver = NULL;
-       if (mdev->registered) {
-               maple_release_device(&mdev->dev);
-               device_unregister(&mdev->dev);
-       }
-       mdev->registered = 0;
-       maple_free_dev(mdev);
+	if (!mdev)
+		return;
+	if (mdev->driver) {
+		if (mdev->driver->disconnect)
+			mdev->driver->disconnect(mdev);
+	}
+	mdev->driver = NULL;
+	if (mdev->registered) {
+		maple_release_device(&mdev->dev);
+		device_unregister(&mdev->dev);
+	}
+	mdev->registered = 0;
+	maple_free_dev(mdev);
 }
 
 /* process initial MAPLE_COMMAND_DEVINFO for each device or port */
 static void maple_attach_driver(struct maple_device *dev)
 {
-       char *p;
-
-       char *recvbuf;
-       unsigned long function;
-       int matched, retval;
-
-       recvbuf = dev->mq->recvbuf;
-       memcpy(&dev->devinfo, recvbuf + 4, sizeof(dev->devinfo));
-       memcpy(dev->product_name, dev->devinfo.product_name, 30);
-       memcpy(dev->product_licence, dev->devinfo.product_licence, 60);
-       dev->product_name[30] = '\0';
-       dev->product_licence[60] = '\0';
-
-       for (p = dev->product_name + 29; dev->product_name <= p; p--)
-               if (*p == ' ')
-                       *p = '\0';
-               else
-                       break;
-
-       for (p = dev->product_licence + 59; dev->product_licence <= p; p--)
-               if (*p == ' ')
-                       *p = '\0';
-               else
-                       break;
-
-       function = be32_to_cpu(dev->devinfo.function);
-
-       if (function > 0x200) {
-               /* Do this silently - as not a real device */
-               function = 0;
-               dev->driver = &maple_dummy_driver;
-               sprintf(dev->dev.bus_id, "%d:0.port", dev->port);
-       } else {
-               printk(KERN_INFO
-                      "Maple bus at (%d, %d): Connected function 0x%lX\n",
-                      dev->port, dev->unit, function);
-
-               matched =
-                   bus_for_each_drv(&maple_bus_type, NULL, dev,
-                                    attach_matching_maple_driver);
-
-               if (matched == 0) {
-                       /* Driver does not exist yet */
-                       printk(KERN_INFO
-                              "No maple driver found for this device\n");
-                       dev->driver = &maple_dummy_driver;
-               }
-
-               sprintf(dev->dev.bus_id, "%d:0%d.%lX", dev->port,
-                       dev->unit, function);
-       }
-       dev->function = function;
-       dev->dev.bus = &maple_bus_type;
-       dev->dev.parent = &maple_bus;
-       dev->dev.release = &maple_release_device;
-       retval = device_register(&dev->dev);
-       if (retval) {
-               printk(KERN_INFO
-                      "Maple bus: Attempt to register device (%x, %x) failed.\n",
-                      dev->port, dev->unit);
-               maple_free_dev(dev);
-       }
-       dev->registered = 1;
+	char *p;
+
+	char *recvbuf;
+	unsigned long function;
+	int matched, retval;
+
+	recvbuf = dev->mq->recvbuf;
+	memcpy(&dev->devinfo, recvbuf + 4, sizeof(dev->devinfo));
+	memcpy(dev->product_name, dev->devinfo.product_name, 30);
+	memcpy(dev->product_licence, dev->devinfo.product_licence, 60);
+	dev->product_name[30] = '\0';
+	dev->product_licence[60] = '\0';
+
+	for (p = dev->product_name + 29; dev->product_name <= p; p--)
+		if (*p == ' ')
+			*p = '\0';
+		else
+			break;
+
+	for (p = dev->product_licence + 59; dev->product_licence <= p; p--)
+		if (*p == ' ')
+			*p = '\0';
+		else
+			break;
+
+	function = be32_to_cpu(dev->devinfo.function);
+
+	if (function > 0x200) {
+		/* Do this silently - as not a real device */
+		function = 0;
+		dev->driver = &maple_dummy_driver;
+		sprintf(dev->dev.bus_id, "%d:0.port", dev->port);
+	} else {
+		printk(KERN_INFO
+		       "Maple bus at (%d, %d): Connected function 0x%lX\n",
+		       dev->port, dev->unit, function);
+
+		matched =
+		    bus_for_each_drv(&maple_bus_type, NULL, dev,
+				     attach_matching_maple_driver);
+
+		if (matched == 0) {
+			/* Driver does not exist yet */
+			printk(KERN_INFO
+			       "No maple driver found for this device\n");
+			dev->driver = &maple_dummy_driver;
+		}
+
+		sprintf(dev->dev.bus_id, "%d:0%d.%lX", dev->port,
+			dev->unit, function);
+	}
+	dev->function = function;
+	dev->dev.bus = &maple_bus_type;
+	dev->dev.parent = &maple_bus;
+	dev->dev.release = &maple_release_device;
+	retval = device_register(&dev->dev);
+	if (retval) {
+		printk(KERN_INFO
+		       "Maple bus: Attempt to register device (%x, %x) failed.\n",
+		       dev->port, dev->unit);
+		maple_free_dev(dev);
+	}
+	dev->registered = 1;
 }
 
 /*
@@ -339,270 +342,271 @@ static void maple_attach_driver(struct maple_device *dev)
  */
 static int detach_maple_device(struct device *device, void *portptr)
 {
-       struct maple_device_specify *ds;
-       struct maple_device *mdev;
-
-       ds = portptr;
-       mdev = to_maple_dev(device);
-       if (mdev->port == ds->port && mdev->unit == ds->unit)
-               return 1;
-       return 0;
+	struct maple_device_specify *ds;
+	struct maple_device *mdev;
+
+	ds = portptr;
+	mdev = to_maple_dev(device);
+	if (mdev->port == ds->port && mdev->unit == ds->unit)
+		return 1;
+	return 0;
 }
 
 static int setup_maple_commands(struct device *device, void *ignored)
 {
-       struct maple_device *maple_dev = to_maple_dev(device);
-
-       if ((maple_dev->interval > 0)
-           && time_after(jiffies, maple_dev->when)) {
-               maple_dev->when = jiffies + maple_dev->interval;
-               maple_dev->mq->command = MAPLE_COMMAND_GETCOND;
-               maple_dev->mq->sendbuf = &maple_dev->function;
-               maple_dev->mq->length = 1;
-               maple_add_packet(maple_dev->mq);
-               liststatus++;
-       } else {
-               if (time_after(jiffies, maple_pnp_time)) {
-                       maple_dev->mq->command = MAPLE_COMMAND_DEVINFO;
-                       maple_dev->mq->length = 0;
-                       maple_add_packet(maple_dev->mq);
-                       liststatus++;
-               }
-       }
-
-       return 0;
+	struct maple_device *maple_dev = to_maple_dev(device);
+
+	if ((maple_dev->interval > 0)
+	    && time_after(jiffies, maple_dev->when)) {
+		maple_dev->when = jiffies + maple_dev->interval;
+		maple_dev->mq->command = MAPLE_COMMAND_GETCOND;
+		maple_dev->mq->sendbuf = &maple_dev->function;
+		maple_dev->mq->length = 1;
+		maple_add_packet(maple_dev->mq);
+		liststatus++;
+	} else {
+		if (time_after(jiffies, maple_pnp_time)) {
+			maple_dev->mq->command = MAPLE_COMMAND_DEVINFO;
+			maple_dev->mq->length = 0;
+			maple_add_packet(maple_dev->mq);
+			liststatus++;
+		}
+	}
+
+	return 0;
 }
 
 /* VBLANK bottom half - implemented via workqueue */
 static void maple_vblank_handler(struct work_struct *work)
 {
-       if (!maple_dma_done())
-               return;
-       if (!list_empty(&maple_sentq))
-               return;
-       ctrl_outl(0, MAPLE_ENABLE);
-       liststatus = 0;
-       bus_for_each_dev(&maple_bus_type, NULL, NULL,
-                        setup_maple_commands);
-       if (time_after(jiffies, maple_pnp_time))
-               maple_pnp_time = jiffies + MAPLE_PNP_INTERVAL;
-       if (liststatus && list_empty(&maple_sentq)) {
-               INIT_LIST_HEAD(&maple_sentq);
-               maple_send();
-       }
-       maplebus_dma_reset();
+	if (!maple_dma_done())
+		return;
+	if (!list_empty(&maple_sentq))
+		return;
+	ctrl_outl(0, MAPLE_ENABLE);
+	liststatus = 0;
+	bus_for_each_dev(&maple_bus_type, NULL, NULL,
+			 setup_maple_commands);
+	if (time_after(jiffies, maple_pnp_time))
+		maple_pnp_time = jiffies + MAPLE_PNP_INTERVAL;
+	if (liststatus && list_empty(&maple_sentq)) {
+		INIT_LIST_HEAD(&maple_sentq);
+		maple_send();
+	}
+	maplebus_dma_reset();
 }
 
 /* handle devices added via hotplugs - placing them on queue for DEVINFO*/
 static void maple_map_subunits(struct maple_device *mdev, int submask)
 {
-       int retval, k, devcheck;
-       struct maple_device *mdev_add;
-       struct maple_device_specify ds;
-
-       for (k = 0; k < 5; k++) {
-               ds.port = mdev->port;
-               ds.unit = k + 1;
-               retval =
-                   bus_for_each_dev(&maple_bus_type, NULL, &ds,
-                                    detach_maple_device);
-               if (retval) {
-                       submask = submask >> 1;
-                       continue;
-               }
-               devcheck = submask & 0x01;
-               if (devcheck) {
-                       mdev_add = maple_alloc_dev(mdev->port, k + 1);
-                       if (!mdev_add)
-                               return;
-                       mdev_add->mq->command = MAPLE_COMMAND_DEVINFO;
-                       mdev_add->mq->length = 0;
-                       maple_add_packet(mdev_add->mq);
-                       scanning = 1;
-               }
-               submask = submask >> 1;
-       }
+	int retval, k, devcheck;
+	struct maple_device *mdev_add;
+	struct maple_device_specify ds;
+
+	for (k = 0; k < 5; k++) {
+		ds.port = mdev->port;
+		ds.unit = k + 1;
+		retval =
+		    bus_for_each_dev(&maple_bus_type, NULL, &ds,
+				     detach_maple_device);
+		if (retval) {
+			submask = submask >> 1;
+			continue;
+		}
+		devcheck = submask & 0x01;
+		if (devcheck) {
+			mdev_add = maple_alloc_dev(mdev->port, k + 1);
+			if (!mdev_add)
+				return;
+			mdev_add->mq->command = MAPLE_COMMAND_DEVINFO;
+			mdev_add->mq->length = 0;
+			maple_add_packet(mdev_add->mq);
+			scanning = 1;
+		}
+		submask = submask >> 1;
+	}
 }
 
 /* mark a device as removed */
 static void maple_clean_submap(struct maple_device *mdev)
 {
-       int killbit;
+	int killbit;
 
-       killbit = (mdev->unit > 0 ? (1 << (mdev->unit - 1)) & 0x1f : 0x20);
-       killbit = ~killbit;
-       killbit &= 0xFF;
-       subdevice_map[mdev->port] = subdevice_map[mdev->port] & killbit;
+	killbit = (mdev->unit > 0 ? (1 << (mdev->unit - 1)) & 0x1f : 0x20);
+	killbit = ~killbit;
+	killbit &= 0xFF;
+	subdevice_map[mdev->port] = subdevice_map[mdev->port] & killbit;
 }
 
 /* handle empty port or hotplug removal */
 static void maple_response_none(struct maple_device *mdev,
-                               struct mapleq *mq)
+				struct mapleq *mq)
 {
-       if (mdev->unit != 0) {
-               list_del(&mq->list);
-               maple_clean_submap(mdev);
-               printk(KERN_INFO
-                      "Maple bus device detaching at (%d, %d)\n",
-                      mdev->port, mdev->unit);
-               maple_detach_driver(mdev);
-               return;
-       }
-       if (!started) {
-               printk(KERN_INFO "No maple devices attached to port %d\n",
-                      mdev->port);
-               return;
-       }
-       maple_clean_submap(mdev);
+	if (mdev->unit != 0) {
+		list_del(&mq->list);
+		maple_clean_submap(mdev);
+		printk(KERN_INFO
+		       "Maple bus device detaching at (%d, %d)\n",
+		       mdev->port, mdev->unit);
+		maple_detach_driver(mdev);
+		return;
+	}
+	if (!started) {
+		printk(KERN_INFO "No maple devices attached to port %d\n",
+		       mdev->port);
+		return;
+	}
+	maple_clean_submap(mdev);
 }
 
 /* preprocess hotplugs or scans */
 static void maple_response_devinfo(struct maple_device *mdev,
-                                  char *recvbuf)
+				   char *recvbuf)
 {
-       char submask;
-       if ((!started) || (scanning == 2)) {
-               maple_attach_driver(mdev);
-               return;
-       }
-       if (mdev->unit == 0) {
-               submask = recvbuf[2] & 0x1F;
-               if (submask ^ subdevice_map[mdev->port]) {
-                       maple_map_subunits(mdev, submask);
-                       subdevice_map[mdev->port] = submask;
-               }
-       }
+	char submask;
+	if ((!started) || (scanning == 2)) {
+		maple_attach_driver(mdev);
+		return;
+	}
+	if (mdev->unit == 0) {
+		submask = recvbuf[2] & 0x1F;
+		if (submask ^ subdevice_map[mdev->port]) {
+			maple_map_subunits(mdev, submask);
+			subdevice_map[mdev->port] = submask;
+		}
+	}
 }
 
 /* maple dma end bottom half - implemented via workqueue */
 static void maple_dma_handler(struct work_struct *work)
 {
-       struct mapleq *mq, *nmq;
-       struct maple_device *dev;
-       char *recvbuf;
-       enum maple_code code;
-
-       if (!maple_dma_done())
-               return;
-       ctrl_outl(0, MAPLE_ENABLE);
-       if (!list_empty(&maple_sentq)) {
-               list_for_each_entry_safe(mq, nmq, &maple_sentq, list) {
-                       recvbuf = mq->recvbuf;
-                       code = recvbuf[0];
-                       dev = mq->dev;
-                       switch (code) {
-                       case MAPLE_RESPONSE_NONE:
-                               maple_response_none(dev, mq);
-                               break;
-
-                       case MAPLE_RESPONSE_DEVINFO:
-                               maple_response_devinfo(dev, recvbuf);
-                               break;
-
-                       case MAPLE_RESPONSE_DATATRF:
-                               if (dev->callback)
-                                       dev->callback(mq);
-                               break;
-
-                       case MAPLE_RESPONSE_FILEERR:
-                       case MAPLE_RESPONSE_AGAIN:
-                       case MAPLE_RESPONSE_BADCMD:
-                       case MAPLE_RESPONSE_BADFUNC:
-                               printk(KERN_DEBUG
-                                      "Maple non-fatal error 0x%X\n",
-                                      code);
-                               break;
-
-                       case MAPLE_RESPONSE_ALLINFO:
-                               printk(KERN_DEBUG
-                                      "Maple - extended device information not supported\n");
-                               break;
-
-                       case MAPLE_RESPONSE_OK:
-                               break;
-
-                       default:
-                               break;
-                       }
-               }
-               INIT_LIST_HEAD(&maple_sentq);
-               if (scanning == 1) {
-                       maple_send();
-                       scanning = 2;
-               } else
-                       scanning = 0;
-
-               if (started == 0)
-                       started = 1;
-       }
-       maplebus_dma_reset();
+	struct mapleq *mq, *nmq;
+	struct maple_device *dev;
+	char *recvbuf;
+	enum maple_code code;
+
+	if (!maple_dma_done())
+		return;
+	ctrl_outl(0, MAPLE_ENABLE);
+	if (!list_empty(&maple_sentq)) {
+		list_for_each_entry_safe(mq, nmq, &maple_sentq, list) {
+			recvbuf = mq->recvbuf;
+			code = recvbuf[0];
+			dev = mq->dev;
+			switch (code) {
+			case MAPLE_RESPONSE_NONE:
+				maple_response_none(dev, mq);
+				break;
+
+			case MAPLE_RESPONSE_DEVINFO:
+				maple_response_devinfo(dev, recvbuf);
+				break;
+
+			case MAPLE_RESPONSE_DATATRF:
+				if (dev->callback)
+					dev->callback(mq);
+				break;
+
+			case MAPLE_RESPONSE_FILEERR:
+			case MAPLE_RESPONSE_AGAIN:
+			case MAPLE_RESPONSE_BADCMD:
+			case MAPLE_RESPONSE_BADFUNC:
+				printk(KERN_DEBUG
+				       "Maple non-fatal error 0x%X\n",
+				       code);
+				break;
+
+			case MAPLE_RESPONSE_ALLINFO:
+				printk(KERN_DEBUG
+				       "Maple - extended device information not supported\n");
+				break;
+
+			case MAPLE_RESPONSE_OK:
+				break;
+
+			default:
+				break;
+			}
+		}
+		INIT_LIST_HEAD(&maple_sentq);
+		if (scanning == 1) {
+			maple_send();
+			scanning = 2;
+		} else
+			scanning = 0;
+
+		if (started == 0)
+			started = 1;
+	}
+	maplebus_dma_reset();
 }
 
 static irqreturn_t maplebus_dma_interrupt(int irq, void *dev_id)
 {
-       /* Load everything into the bottom half */
-       schedule_work(&maple_dma_process);
-       return IRQ_HANDLED;
+	/* Load everything into the bottom half */
+	schedule_work(&maple_dma_process);
+	return IRQ_HANDLED;
 }
 
 static irqreturn_t maplebus_vblank_interrupt(int irq, void *dev_id)
 {
-       schedule_work(&maple_vblank_process);
-       return IRQ_HANDLED;
+	schedule_work(&maple_vblank_process);
+	return IRQ_HANDLED;
 }
 
 static struct irqaction maple_dma_irq = {
-       .name = "maple bus DMA handler",
-       .handler = maplebus_dma_interrupt,
-       .flags = IRQF_SHARED,
+	.name = "maple bus DMA handler",
+	.handler = maplebus_dma_interrupt,
+	.flags = IRQF_SHARED,
 };
 
 static struct irqaction maple_vblank_irq = {
-       .name = "maple bus VBLANK handler",
-       .handler = maplebus_vblank_interrupt,
-       .flags = IRQF_SHARED,
+	.name = "maple bus VBLANK handler",
+	.handler = maplebus_vblank_interrupt,
+	.flags = IRQF_SHARED,
 };
 
 static int maple_set_dma_interrupt_handler(void)
 {
-       return setup_irq(HW_EVENT_MAPLE_DMA, &maple_dma_irq);
+	return setup_irq(HW_EVENT_MAPLE_DMA, &maple_dma_irq);
 }
 
 static int maple_set_vblank_interrupt_handler(void)
 {
-       return setup_irq(HW_EVENT_VSYNC, &maple_vblank_irq);
+	return setup_irq(HW_EVENT_VSYNC, &maple_vblank_irq);
 }
 
 static int maple_get_dma_buffer(void)
 {
-       maple_sendbuf =
-           (void *) __get_free_pages(GFP_KERNEL | __GFP_ZERO,
-                                     MAPLE_DMA_PAGES);
-       if (!maple_sendbuf)
-               return -ENOMEM;
-       return 0;
+	maple_sendbuf =
+	    (void *) __get_free_pages(GFP_KERNEL | __GFP_ZERO,
+				      MAPLE_DMA_PAGES);
+	if (!maple_sendbuf)
+		return -ENOMEM;
+	return 0;
 }
 
 static int match_maple_bus_driver(struct device *devptr,
-                                 struct device_driver *drvptr)
+				  struct device_driver *drvptr)
 {
-       struct maple_driver *maple_drv;
-       struct maple_device *maple_dev;
-
-       maple_drv = container_of(drvptr, struct maple_driver, drv);
-       maple_dev = container_of(devptr, struct maple_device, dev);
-       /* Trap empty port case */
-       if (maple_dev->devinfo.function == 0xFFFFFFFF)
-               return 0;
-       else if (maple_dev->devinfo.function &
-                be32_to_cpu(maple_drv->function))
-               return 1;
-       return 0;
+	struct maple_driver *maple_drv;
+	struct maple_device *maple_dev;
+
+	maple_drv = container_of(drvptr, struct maple_driver, drv);
+	maple_dev = container_of(devptr, struct maple_device, dev);
+	/* Trap empty port case */
+	if (maple_dev->devinfo.function == 0xFFFFFFFF)
+		return 0;
+	else if (maple_dev->devinfo.function &
+		 be32_to_cpu(maple_drv->function))
+		return 1;
+	return 0;
 }
 
-static int maple_bus_uevent(struct device *dev, struct kobj_uevent_env *env)
+static int maple_bus_uevent(struct device *dev,
+			    struct kobj_uevent_env *env)
 {
-       return 0;
+	return 0;
 }
 
 static void maple_bus_release(struct device *dev)
@@ -610,124 +614,126 @@ static void maple_bus_release(struct device *dev)
 }
 
 static struct maple_driver maple_dummy_driver = {
-       .drv = {
-               .name = "maple_dummy_driver",
-               .bus =  &maple_bus_type,
-       },
+	.drv = {
+		.name = "maple_dummy_driver",
+		.bus = &maple_bus_type,
+		},
 };
 
 struct bus_type maple_bus_type = {
-       .name =         "maple",
-       .match =        match_maple_bus_driver,
-       .uevent =       maple_bus_uevent,
+	.name = "maple",
+	.match = match_maple_bus_driver,
+	.uevent = maple_bus_uevent,
 };
+
 EXPORT_SYMBOL_GPL(maple_bus_type);
 
 static struct device maple_bus = {
-       .bus_id = "maple",
-       .release = maple_bus_release,
+	.bus_id = "maple",
+	.release = maple_bus_release,
 };
 
 static int __init maple_bus_init(void)
 {
-       int retval, i;
-       struct maple_device *mdev[MAPLE_PORTS];
-       ctrl_outl(0, MAPLE_STATE);
-
-       retval = device_register(&maple_bus);
-       if (retval)
-               goto cleanup;
-
-       retval = bus_register(&maple_bus_type);
-       if (retval)
-               goto cleanup_device;
-
-       retval = driver_register(&maple_dummy_driver.drv);
-
-       if (retval)
-               goto cleanup_bus;
-
-       /* allocate memory for maple bus dma */
-       retval = maple_get_dma_buffer();
-       if (retval) {
-               printk(KERN_INFO
-                      "Maple bus: Failed to allocate Maple DMA buffers\n");
-               goto cleanup_basic;
-       }
-
-       /* set up DMA interrupt handler */
-       retval = maple_set_dma_interrupt_handler();
-       if (retval) {
-               printk(KERN_INFO
-                      "Maple bus: Failed to grab maple DMA IRQ\n");
-               goto cleanup_dma;
-       }
-
-       /* set up VBLANK interrupt handler */
-       retval = maple_set_vblank_interrupt_handler();
-       if (retval) {
-               printk(KERN_INFO "Maple bus: Failed to grab VBLANK IRQ\n");
-               goto cleanup_irq;
-       }
-
-       maple_queue_cache =
-           kmem_cache_create("maple_queue_cache", 0x400, 0,
-                             SLAB_HWCACHE_ALIGN, NULL);
-
-       if (!maple_queue_cache)
-               goto cleanup_bothirqs;
-
-       /* setup maple ports */
-       for (i = 0; i < MAPLE_PORTS; i++) {
-               mdev[i] = maple_alloc_dev(i, 0);
-               if (!mdev[i]) {
-                       while (i-- > 0)
-                               maple_free_dev(mdev[i]);
-                       goto cleanup_cache;
-               }
-               mdev[i]->registered = 0;
-               mdev[i]->mq->command = MAPLE_COMMAND_DEVINFO;
-               mdev[i]->mq->length = 0;
-               maple_attach_driver(mdev[i]);
-               maple_add_packet(mdev[i]->mq);
-               subdevice_map[i] = 0;
-       }
-
-       /* setup maplebus hardware */
-       maplebus_dma_reset();
-
-       /* initial detection */
-       maple_send();
-
-       maple_pnp_time = jiffies;
-
-       printk(KERN_INFO "Maple bus core now registered.\n");
-
-       return 0;
-
-cleanup_cache:
-       kmem_cache_destroy(maple_queue_cache);
-
-cleanup_bothirqs:
-       free_irq(HW_EVENT_VSYNC, 0);
-
-cleanup_irq:
-       free_irq(HW_EVENT_MAPLE_DMA, 0);
-
-cleanup_dma:
-       free_pages((unsigned long) maple_sendbuf, MAPLE_DMA_PAGES);
-
-cleanup_basic:
-       driver_unregister(&maple_dummy_driver.drv);
-
-cleanup_bus:
-       bus_unregister(&maple_bus_type);
-
-cleanup_device:
-       device_unregister(&maple_bus);
-
-cleanup:
-       printk(KERN_INFO "Maple bus registration failed\n");
-       return retval;
+	int retval, i;
+	struct maple_device *mdev[MAPLE_PORTS];
+	ctrl_outl(0, MAPLE_STATE);
+
+	retval = device_register(&maple_bus);
+	if (retval)
+		goto cleanup;
+
+	retval = bus_register(&maple_bus_type);
+	if (retval)
+		goto cleanup_device;
+
+	retval = driver_register(&maple_dummy_driver.drv);
+
+	if (retval)
+		goto cleanup_bus;
+
+	/* allocate memory for maple bus dma */
+	retval = maple_get_dma_buffer();
+	if (retval) {
+		printk(KERN_INFO
+		       "Maple bus: Failed to allocate Maple DMA buffers\n");
+		goto cleanup_basic;
+	}
+
+	/* set up DMA interrupt handler */
+	retval = maple_set_dma_interrupt_handler();
+	if (retval) {
+		printk(KERN_INFO
+		       "Maple bus: Failed to grab maple DMA IRQ\n");
+		goto cleanup_dma;
+	}
+
+	/* set up VBLANK interrupt handler */
+	retval = maple_set_vblank_interrupt_handler();
+	if (retval) {
+		printk(KERN_INFO "Maple bus: Failed to grab VBLANK IRQ\n");
+		goto cleanup_irq;
+	}
+
+	maple_queue_cache =
+	    kmem_cache_create("maple_queue_cache", 0x400, 0,
+			      SLAB_HWCACHE_ALIGN, NULL);
+
+	if (!maple_queue_cache)
+		goto cleanup_bothirqs;
+
+	/* setup maple ports */
+	for (i = 0; i < MAPLE_PORTS; i++) {
+		mdev[i] = maple_alloc_dev(i, 0);
+		if (!mdev[i]) {
+			while (i-- > 0)
+				maple_free_dev(mdev[i]);
+			goto cleanup_cache;
+		}
+		mdev[i]->registered = 0;
+		mdev[i]->mq->command = MAPLE_COMMAND_DEVINFO;
+		mdev[i]->mq->length = 0;
+		maple_attach_driver(mdev[i]);
+		maple_add_packet(mdev[i]->mq);
+		subdevice_map[i] = 0;
+	}
+
+	/* setup maplebus hardware */
+	maplebus_dma_reset();
+
+	/* initial detection */
+	maple_send();
+
+	maple_pnp_time = jiffies;
+
+	printk(KERN_INFO "Maple bus core now registered.\n");
+
+	return 0;
+
+      cleanup_cache:
+	kmem_cache_destroy(maple_queue_cache);
+
+      cleanup_bothirqs:
+	free_irq(HW_EVENT_VSYNC, 0);
+
+      cleanup_irq:
+	free_irq(HW_EVENT_MAPLE_DMA, 0);
+
+      cleanup_dma:
+	free_pages((unsigned long) maple_sendbuf, MAPLE_DMA_PAGES);
+
+      cleanup_basic:
+	driver_unregister(&maple_dummy_driver.drv);
+
+      cleanup_bus:
+	bus_unregister(&maple_bus_type);
+
+      cleanup_device:
+	device_unregister(&maple_bus);
+
+      cleanup:
+	printk(KERN_INFO "Maple bus registration failed\n");
+	return retval;
 }
+
 subsys_initcall(maple_bus_init);
diff --git a/include/linux/maple.h b/include/linux/maple.h
index bad9a7b..f82c17b 100644
--- a/include/linux/maple.h
+++ b/include/linux/maple.h
@@ -7,74 +7,75 @@ extern struct bus_type maple_bus_type;
 
 /* Maple Bus command and response codes */
 enum maple_code {
-       MAPLE_RESPONSE_FILEERR = -5,
-       MAPLE_RESPONSE_AGAIN = -4,      /* request should be retransmitted */
-       MAPLE_RESPONSE_BADCMD = -3,
-       MAPLE_RESPONSE_BADFUNC = -2,
-       MAPLE_RESPONSE_NONE = -1,       /* unit didn't respond at all */
-       MAPLE_COMMAND_DEVINFO = 1,
-       MAPLE_COMMAND_ALLINFO = 2,
-       MAPLE_COMMAND_RESET = 3,
-       MAPLE_COMMAND_KILL = 4,
-       MAPLE_RESPONSE_DEVINFO = 5,
-       MAPLE_RESPONSE_ALLINFO = 6,
-       MAPLE_RESPONSE_OK = 7,
-       MAPLE_RESPONSE_DATATRF = 8,
-       MAPLE_COMMAND_GETCOND = 9,
-       MAPLE_COMMAND_GETMINFO = 10,
-       MAPLE_COMMAND_BREAD = 11,
-       MAPLE_COMMAND_BWRITE = 12,
-       MAPLE_COMMAND_SETCOND = 14
+	MAPLE_RESPONSE_FILEERR = -5,
+	MAPLE_RESPONSE_AGAIN = -4,	/* request should be retransmitted */
+	MAPLE_RESPONSE_BADCMD = -3,
+	MAPLE_RESPONSE_BADFUNC = -2,
+	MAPLE_RESPONSE_NONE = -1,	/* unit didn't respond at all */
+	MAPLE_COMMAND_DEVINFO = 1,
+	MAPLE_COMMAND_ALLINFO = 2,
+	MAPLE_COMMAND_RESET = 3,
+	MAPLE_COMMAND_KILL = 4,
+	MAPLE_RESPONSE_DEVINFO = 5,
+	MAPLE_RESPONSE_ALLINFO = 6,
+	MAPLE_RESPONSE_OK = 7,
+	MAPLE_RESPONSE_DATATRF = 8,
+	MAPLE_COMMAND_GETCOND = 9,
+	MAPLE_COMMAND_GETMINFO = 10,
+	MAPLE_COMMAND_BREAD = 11,
+	MAPLE_COMMAND_BWRITE = 12,
+	MAPLE_COMMAND_SETCOND = 14
 };
 
 struct mapleq {
-       struct list_head list;
-       struct maple_device *dev;
-       void *sendbuf, *recvbuf, *recvbufdcsp;
-       unsigned char length;
-       enum maple_code command;
+	struct list_head list;
+	struct maple_device *dev;
+	void *sendbuf, *recvbuf, *recvbufdcsp;
+	unsigned char length;
+	enum maple_code command;
 };
 
 struct maple_devinfo {
-       unsigned long function;
-       unsigned long function_data[3];
-       unsigned char area_code;
-       unsigned char connector_directon;
-       char product_name[31];
-       char product_licence[61];
-       unsigned short standby_power;
-       unsigned short max_power;
+	unsigned long function;
+	unsigned long function_data[3];
+	unsigned char area_code;
+	unsigned char connector_directon;
+	char product_name[31];
+	char product_licence[61];
+	unsigned short standby_power;
+	unsigned short max_power;
 };
 
 struct maple_device {
-       struct maple_driver *driver;
-       struct mapleq *mq;
-       void *private_data;
-       void (*callback) (struct mapleq * mq);
-       unsigned long when, interval, function;
-       struct maple_devinfo devinfo;
-       unsigned char port, unit;
-       char product_name[32];
-       char product_licence[64];
-       int registered;
-       struct device dev;
+	struct maple_driver *driver;
+	struct mapleq *mq;
+	void *private_data;
+	void (*callback) (struct mapleq * mq);
+	unsigned long when, interval, function;
+	struct maple_devinfo devinfo;
+	unsigned char port, unit;
+	char product_name[32];
+	char product_licence[64];
+	int registered;
+	struct device dev;
 };
 
 struct maple_driver {
-       unsigned long function;
-       int (*connect) (struct maple_device * dev);
-       void (*disconnect) (struct maple_device * dev);
-       struct device_driver drv;
+	unsigned long function;
+	int (*connect) (struct maple_device * dev);
+	void (*disconnect) (struct maple_device * dev);
+	struct device_driver drv;
+	int registered;
 };
 
 void maple_getcond_callback(struct maple_device *dev,
-                           void (*callback) (struct mapleq * mq),
-                           unsigned long interval,
-                           unsigned long function);
+			    void (*callback) (struct mapleq * mq),
+			    unsigned long interval,
+			    unsigned long function);
 int maple_driver_register(struct device_driver *drv);
 void maple_add_packet(struct mapleq *mq);
 
 #define to_maple_dev(n) container_of(n, struct maple_device, dev)
 #define to_maple_driver(n) container_of(n, struct maple_driver, drv)
 
-#endif /* __LINUX_MAPLE_H */
+#endif				/* __LINUX_MAPLE_H */

